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

> Request:

```http
POST /messaging/v1/query HTTP/1.1
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

> Response:

```json
{
	"status": "ok"
}
```

#### Attributes

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

> Request:

```http
POST /messaging/v1/query HTTP/1.1
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

> Response:

```json
{
	"status": "ok"
}
```

Trigger events within Flow.ai by sending an event message.

#### Attributes

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

> Request:

```http
POST /messaging/v1/query HTTP/1.1
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

> Response:

```json
{
	"status": "ok"
}
```

Send coordinates

#### Attributes

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

> Request:

```http
POST /messaging/v1/query HTTP/1.1
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

> Response:

```json
{
	"status": "ok"
}
```

The API allows you to send images, files and other media files.

For media you'll need to make a `POST` call that is `multipart/form-data`. The maximum file size you can upload is 250MB.

#### Attributes

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
