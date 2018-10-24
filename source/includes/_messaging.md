
# Messaging API

An API to built conversational interfaces (e.g., chatbots, voice-powered apps and devices).

## Audience

The API is specifically made for developers that want to use the Flow.ai engine within their own technology stack or solution.

Some example use cases:

- Combine Flow.ai with a customer service solution
- Use Flow.ai with any other backend service
- Hardware or other integrations

## You call us, we'll call you

The Messaging API works asynchronous. Unlike other NLP APIs, Flow.ai will not return any direct reply to a [Send](#sending-messages) call.

![Send messages using REST API](/images/sending.svg "Sending messages to Flow.ai")

Instead, the API will call your configured [webhook](#webhooks) whenever a reply is being sent.

![Receive replies using Webhooks](/images/receiving.svg "Receiving replies from Flow.ai")


## Sending messages

> Sending text or speech

```http
POST /messaging/v1/query HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
	"query": {
		"text": "Hello"
	}
}
```

> Triggering an event

```http
POST /messaging/v1/query HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
  "query": {
    "event": "MY_EVENT"
  }
}
```

> Sending a location

```http
POST /messaging/v1/query HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
  "query": {
    "location": {
      "lat": "1232122422",
      "lng": "2433343343"
    }
  }
}
```

> Sending an image

```http
POST /messaging/v1/query HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
  "query": {
    "image": "https://awesome.corp/nice_image.jpg"
  }
}
```

```javascript
const request = require("request");

const options = {
  method: 'POST',
  url: 'https://api.flow.ai/messaging/v1/query',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
    query: {
      text: 'Hello'
    }
  },
  json: true
};

request(options, function (error, response, body) {
  if (error) throw new Error(error);

  console.log(body);
});
```

Many types of unstructured content can be sent to the Flow.ai platform, including text, audio, images, video, and files. Our powerful AI engine will process any query and send back replies using the provided webhook.

### Endpoint

All the URLs referenced in the Messaging API have the following base:

`https://api.flow.ai/messaging/v1/`

### Authentication

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H 'Authorization: Bearer MY_MESSAGING_API_KEY'
```

> Make sure to replace `MY_MANAGEMENT_API_KEY` with your API key.

Authenticate your API requests by providing a Messaging API key as a bearer token. All API requests expect this bearer token to be present.

You can register a new Messaging API key within your [organisation settings](https://app.flow.ai/settings/organisation).

<aside class="notice">
Treat API keys with care. Never share keys with other users or applications. Do not publish keys in public code repositories.
</aside>

### Post body

**Property** | Description
--------- | -----------
**threadId** *string* | Identifies thread of the user
**query** *object* | Object with query request
**lang** *object* | Language
**timezone** *integer* | UTF timezone offset in hours


#### Query object

The Query object represents the interaction that should be processed. Flow.ai can handle different types of information.

**Property** | Description
--------- | -----------
**text** *string* | Classify text using natural language processing
**event** *string* | Trigger a named event
**location** *object* | Latitude and longitude coordinates
**image** *string* | URL to an image resource
**file** *string* | Group name
**audio** *string* | Date the flow was created
**video** *string* | Indicates if it should be ignored
**params** *object* | Optional parameters


##  Webhooks

Webhooks are the way Flow.ai will deliver replies.

```HTTP
POST /management/v1/webhooks HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MANAGEMENT_API_KEY
{
	"events": [
    "thread.reply",
    "thread.handover"
  ]
}
```

### Setting Up Your Webhook

You can add a webhook subscription using the Management API

#### Requirements

- HTTPS support
- A valid SSL certificate
- An open port that accepts `GET` and `POST` requests

### Webhook Events

### Event Format

### Required 200 OK Response

### Performance Requirements

### Validating Webhook Events

### Templates
