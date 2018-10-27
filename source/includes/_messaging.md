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

Many types of unstructured content can be sent to the Flow.ai platform, including text, audio, images, video, and files. Our powerful AI engine will process any query and send back replies using the provided webhook.

Any message that is send requires a `threadId` that relates the message to a specific user, chat or thread. Optionally you can provide a `traceId` that will help keep track of the message when you receive delivery events.

### Endpoint

All the URLs referenced in the Messaging API have the following base:

`https://api.flow.ai/v1/messaging/`

### Authentication

Authenticate your API requests by providing a Messaging API key as a bearer token. All API requests expect this bearer token to be present.

You can register a new Messaging API key within your [organisation settings](https://app.flow.ai/settings/organisation).

<aside class="notice">
Treat API keys with care. Never share keys with other users or applications. Do not publish keys in public code repositories.
</aside>

### Text message

Sending a text message

> POST /v1/messaging/message

> Example Request:

```http
POST /v1/messaging/message HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
	"threadId": "6ecfd199-853a-448f-9f91-ef397588ff87",
	"type": "text",
	"text": "Hello"
}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/v1/messaging/query',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
    threadId: '6ecfd199-853a-448f-9f91-ef397588ff87',
		type: 'text',
    text: 'Hello'
  },
  json: true
})
```

> Example Response:

```
200 OK
```

```json
{
	"status": "ok"
}
```

#### Arguments

| | |
|----:|---|
| **threadId** *string* | Unique identifier for the target chat or user of the target channel |
| **traceId** *number* | Optional unique number that is passed along to identify the message. Use this to verify message delivery. |
| **type** *string* | Indicates the type of message. Should be `text` |
| **text** *string* | The text or speech message to process. The maximum length of a message is 255 characters. |
| **lang** *string* | Language code in [ISO format](https://en.wikipedia.org/wiki/ISO_639-1) (2 letters) |
| **timezone** *integer* | UTF timezone offset in hours |
| **params** *object* | Optional parameters |

### Event message

> POST /v1/messaging/message

> Example Request:

```http
POST /v1/messaging/message HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
	"threadId": "6ecfd199-853a-448f-9f91-ef397588ff87",
	"type": "event",
	"eventName": "MY_EVENT"
}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/v1/messaging/query',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
		threadId: '6ecfd199-853a-448f-9f91-ef397588ff87',
		type: 'event',
    eventName: "MY_EVENT"
  },
  json: true
})
```

> Example Response:

```
200 OK
```

```json
{
	"status": "ok"
}
```

Trigger events within Flow.ai by sending an event message.

#### Arguments

| | |
|----:|---|
| **threadId** *string* | Unique identifier for the target chat or user of the target channel |
| **traceId** *number* | Optional unique number that is passed along to identify the message. Use this to verify message delivery. |
| **type** *string* | Indicates the type of message. Should be `event` |
| **eventName** *string* | The name of the event to trigger |
| **lang** *string* | Language code in [ISO format](https://en.wikipedia.org/wiki/ISO_639-1) (2 letters) |
| **timezone** *integer* | UTF timezone offset in hours |
| **params** *object* | Optional parameters |

### Location message

> POST /v1/messaging/message

> Example Request:

```http
POST /v1/messaging/message HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
	"threadId": "6ecfd199-853a-448f-9f91-ef397588ff87",
	"type": "location",
	"lat": "1232122422",
	"lng": "2433343343"
}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/v1/messaging/query',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
		threadId: '6ecfd199-853a-448f-9f91-ef397588ff87',
		type: 'location',
		lat: "1232122422",
		lng: "2433343343"
  },
  json: true
})
```

> Example Response:

```
200 OK
```

```json
{
	"status": "ok"
}
```

Send coordinates

#### Arguments

| | |
|----:|---|
| **threadId** *string* | Unique identifier for the target chat or user of the target channel |
| **traceId** *number* | Optional unique number that is passed along to identify the message. Use this to verify message delivery. |
| **type** *string* | Indicates the type of message. Should be `location` |
| **lat** *string* | Latitude |
| **lng** *string* | Longitude |
| **lang** *string* | Language code in [ISO format](https://en.wikipedia.org/wiki/ISO_639-1) (2 letters) |
| **timezone** *integer* | UTF timezone offset in hours |
| **params** *object* | Optional parameters |


### Media message

> POST /v1/messaging/message

> Example Request:

```http
POST /v1/messaging/message HTTP/1.1
Host: api.flow.ai
------WebKitFormBoundaryDJX0xmK2m2F6Mvka
Content-Disposition: form-data; name="file"; filename="image.png"
Content-Type: image/png

------WebKitFormBoundaryDJX0xmK2m2F6Mvka
Content-Disposition: form-data; name="query"
{
	"threadId": "6ecfd199-853a-448f-9f91-ef397588ff87",
	"type": "location",
	"mediaType": "image",
	"mimetype": "image/png"
}
------WebKitFormBoundaryDJX0xmK2m2F6Mvka--
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

```javascript
import request from "async-request";
import { createReadStream } from 'fs';
import FormData from 'form-data';

// Stream the binary file
const stream = createReadStream('./test.png')

// Create a formData and append the file and query (JSON)
const formData = new FormData()
formData.append('file', stream)
formData.append('query', JSON.stringify(query: {
	threadId: '6ecfd199-853a-448f-9f91-ef397588ff87',
	type: 'media',
	mediaType: 'image',
	mimeType: "image/png"
}))

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/v1/messaging/query',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY'
  },
  body: formData
})
```

> Example Response:

```
200 OK
```

```json
{
	"status": "ok"
}
```

The API allows you to send images, files and other media files.

For media you'll need to make a `POST` call that is `multipart/form-data`. The maximum file size you can upload is 250MB.

#### Arguments

| | |
|----:|---|
| **threadId** *string* | Unique identifier for the target chat or user of the target channel |
| **traceId** *number* | Optional unique number that is passed along to identify the message. Use this to verify message delivery. |
| **type** *string* | Indicates the type of message. Should be `media` |
| **mediaType** *string* | Type of media, `image`, `file`, `audio`, or `video`  |
| **mimeType** *string* | Optionally specify the mime-type of the uploaded file |
| **lang** *string* | Language code in [ISO format](https://en.wikipedia.org/wiki/ISO_639-1) (2 letters) |
| **timezone** *integer* | UTF timezone offset in hours |
| **params** *object* | Optional parameters |

##  Webhooks

Webhooks are the way Flow.ai will deliver replies and notify your app of other type of events.

### Receiving a notification

Creating a webhook endpoint on your server is no different from creating any page on your website.

Webhook data is sent as [JSON](https://www.json.org/) in the `POST` request body. The full event details are included and can be used directly, after parsing the JSON into an Event object.

Your webhook must meet with the following requirements:

- HTTPS support
- A valid SSL certificate
- An open port that accepts `GET` and `POST` requests

### Responding to a webhook

To acknowledge receipt of a webhook, your endpoint should return a 2xx HTTP status code. All response codes outside this range, including 3xx codes, will indicate to Flow.ai that you did not receive the webhook. This does mean that a URL redirection or a "Not Modified" response will be treated as a failure. Flow.ai will ignore any other information returned in the request headers or request body.

We will attempt to deliver your webhooks for up to two 4 hours with an exponential back off. Webhooks cannot be manually retried after this time.

### Type of Events

This is a list of all the types of events we currently send. We may add more at any time, so in developing and maintaining your code, you should not assume that only these types exist.

#### message.reply

| | |
|----:|---|
| `message.reply` | Called whenever Flow.ai is sending a reply message |
| `message.delivered` | Called when your message that you send has been successfully received |
| `control.handover` | Called when the AI engine is handing off to your solution and pausing operations |

### The Webhook object

> Example Response:

```json
{
	"webhookId": "9f91853a-448f-ef397588ff87-6ecfd199",
	"organisationId": "853a-448f-9f91-ef397588ff87-6ecfd199",
	"url": "https://myawesomeapp.com/webhook",
	"verifyKey": "1234567",
	"events": [
		"message.delivered",
		"message.reply",
		"control.handover"
	]
}
```

Each webhook object represents a webhook subscription Flow.ai will attempt to call whenever a subscribed event takes place.

#### Attributes

| | |
|----:|---|
| **webhookId** *string* | Unique ID of the webhook |
| **organisationId** *string* | ID of the organisation this webhook will receive calls from |
| **url** *string* | The url your app lives that Flow.ai shall call |
| **verifyKey** *string* | Along with each call Flow.ai will send you this verify key. It enables you to verify that the call was made by Flow.ai |
| **events** *array* | The list of events to subscribe to. You'll need to have at least one subscribed event |

### Create a webhook

> POST /v1/messaging/webhooks

> Example Request:

```http
POST /messages/v1/webhooks HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
	"url": "https://myawesomeapp.com/webhook",
	"verifyKey": "1234567",
	"events": [
		"message.delivered",
		"message.reply",
		"control.handover"
	]
}
```

> Example Response:

```
201 Created
Location: /messages/v1/webhooks/9f91853a-448f-ef397588ff87-6ecfd199
```

```json
{
	"webhookId": "9f91853a-448f-ef397588ff87-6ecfd199",
	"organisationId": "853a-448f-9f91-ef397588ff87-6ecfd199",
	"url": "https://myawesomeapp.com/webhook",
	"verifyKey": "1234567",
	"events": [
		"message.delivered",
		"message.reply",
		"control.handover"
	]
}
```

Creates a new webhook subscription.

Whenever you add a webhook we'll make a `GET` request to verify the endpoint. This call should receive a `2xx` response code of your server.

#### Arguments

| | |
|----:|---|
| **url** **required** | The url your app lives that Flow.ai shall call |
| **verifyKey** **required** | Along with each call Flow.ai will send you this verify key. It enables you to verify that the call was made by Flow.ai |
| **events** **required** | A list of events to subscribe to. You'll need to have at least one subscribed event |


### Retrieve a Webhook

> GET /v1/messaging/webhooks/{WEBHOOK_ID}

> Example Request:

```http
GET /messages/v1/webhooks/9f91853a-448f-ef397588ff87-6ecfd199 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
```

> Example Response:

```
200 OK
```

```json
{
	"webhookId": "9f91853a-448f-ef397588ff87-6ecfd199",
	"organisationId": "853a-448f-9f91-ef397588ff87-6ecfd199",
	"url": "https://myawesomeapp.com/webhook",
	"verifyKey": "1234567",
	"events": [
		"message.delivered",
		"message.reply",
		"control.handover"
	]
}
```

Retrieves the details of an existing webhook subscription. Supply the unique webhook ID from either a webhook creation request or the webhook list, and Flow.ai will return the corresponding webhook information.

### Update a Webhook

> POST /v1/messaging/webhooks/{WEBHOOK_ID}

> Example Request:

```http
PUT /messages/v1/webhooks/9f91853a-448f-ef397588ff87-6ecfd199 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
	"organisationId": "853a-448f-9f91-ef397588ff87-6ecfd199",
	"url": "https://myawesomeapp.com/webhook",
	"verifyKey": "1234567",
	"events": [
		"message.reply",
		"control.handover"
	]
}
```

> Example Response:

```
200 OK
```

```json
{
	"webhookId": "9f91853a-448f-ef397588ff87-6ecfd199",
	"organisationId": "853a-448f-9f91-ef397588ff87-6ecfd199",
	"url": "https://myawesomeapp.com/webhook",
	"verifyKey": "1234567",
	"events": [
		"message.delivered",
		"message.reply",
		"control.handover"
	]
}
```

Updates the specified webhook by setting the values of the parameters passed. Any parameters not provided will be left unchanged.

#### Arguments

| | |
|----:|---|
| **url** *optional* | The url your app lives that Flow.ai shall call |
| **verifyKey** *optional* | Along with each call Flow.ai will send you this verify key. It enables you to verify that the call was made by Flow.ai |
| **events** *optional* | The list of events to subscribe to. You'll need to have at least one subscribed event |


### List all Webhooks

> GET /v1/messaging/webhooks

> Example Request:

```http
GET /messages/v1/webhooks/9f91853a-448f-ef397588ff87-6ecfd199 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
```

> Example Response:

```
200 OK
```

```json
{
	"items": [{
		"webhookId": "9f91853a-448f-ef397588ff87-6ecfd199",
		"organisationId": "853a-448f-9f91-ef397588ff87-6ecfd199",
		"url": "https://myawesomeapp.com/webhook",
		"verifyKey": "1234567",
		"events": [
			"message.delivered",
			"message.reply",
			"control.handover"
		]
	}, {
		"webhookId": "448f-9f91853a-6ecfd199-ef397588ff87",
		"organisationId": "853a-448f-9f91-ef397588ff87-6ecfd199",
		"url": "https://otherawesomeapp.com/webhook",
		"verifyKey": "7654321",
		"events": [
			"message.reply"
		]
	}]
}
```

Returns a list of your webhook subscriptions. The webhooks are returned sorted by creation date, with the most recently created webhooks appearing first.

### Delete a Webhook

> DELETE /v1/messaging/webhooks/{WEBHOOK_ID}

> Example Request:

```http
DELETE /messages/v1/webhooks/9f91853a-448f-ef397588ff87-6ecfd199 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
```

```
204 No Content
```

> Example Response:

```json
{
	"webhookId": "9f91853a-448f-ef397588ff87-6ecfd199",
	"organisationId": "853a-448f-9f91-ef397588ff87-6ecfd199",
	"url": "https://myawesomeapp.com/webhook",
	"verifyKey": "1234567",
	"events": [
		"message.delivered",
		"message.reply",
		"control.handover"
	]
}
```

Permanently deletes a webhook subscription. It cannot be undone.
