# REST API

An API to built conversational interfaces (e.g., chatbots, voice-powered apps and devices). Warning. It's a Beta version of our API

## Audience

The API is specifically made for developers that want to use the Flow.ai engine within their own technology stack or solution.

Some example use cases:

- Combine Flow.ai with a customer service solution
- Use Flow.ai with any other backend service
- Hardware or other integrations

## You call us, we'll call you

The REST API works asynchronous. Unlike other NLP APIs, Flow.ai will not return any direct reply to a [Send](#sending-messages) call.

![Send messages using REST API](/images/sending.svg "Sending messages to Flow.ai")

Instead, the API will send a POST request to your configured [webhook](#webhooks) whenever a reply is being sent.

For some queries we added an optional sync support. To enable sync mode add sync=true flag to supported query.

![Receive replies using Webhooks](/images/receiving.svg "Receiving replies from Flow.ai")

<aside class="notice">
To make life easier, some APIs can be called with a <em>sync</em> parameter. This will cause them to send a direct reply instead of having to rely on a webhook event.
</aside>

## Sending messages

Many types of unstructured content can be sent to the Flow.ai platform, including text, audio, images, video, and files. Our powerful AI engine will process any query and send back replies using the provided [webhook](#webhooks).

Any message that is sent requires a `threadId` that relates the message to a specific user, chat or thread. Optionally you can provide a `traceId` that will help keep track of the message when you receive delivery events.

### Endpoint

All the URLs referenced in the REST API have the following base:

`https://api.flow.ai/rest/v1/`

### Authentication

Authenticate your API requests by providing an API key as a value of `Authorization` header. All API requests expect this header to be present.

You can get a new API key within the `Organisation settings` section by selecting `API Keys` tab and pressing `Create a new API Token` button. After that you need to select this API key in `Outbound` section of your REST API integration in [integrations](https://api.flow.ai/default/integrations) section and press `Save` button.

<aside class="notice">
Treat API keys with care. Never share keys with other users or applications. Do not publish keys in public code repositories.
</aside>

### Originator

> Example Message:

```json
{
	"payload": {
		"type": "text",
		"speech": "hello",
		"originator": {
			"name": "John Doe",
			"role": "external"
		}
	}
}
```

> Example Message:

```json
{
	"payload": {
		"type": "text",
		"speech": "hello",
		"originator": {
			"name": "John Doe",
			"role": "external",
			"profile": {
				"fullName": "John Doe",
				"firstName": "John",
				"lastName": "Doe",
				"gender": "M",
				"locale": "en-US",
				"timezone": -5,
				"country": "us",
				"email": "johndoe@dmail.com",
				"picture": "https://..."
			}	
		}
	}
}
```

> Example Message:

```json
{
	...
	"originator": {
		"name": "John Doe",
		"role": "external",
		"metadata": {
			"clientNumber": "asddaasq333ee332",
			"preference": "A,B,G"
		}
	}
	...
}
```

With each message you need to provide some information regarding the sender, user or as Flow.ai calls it, the originator of the message.

#### Attributes

| **Property** | Description |
| :--- | :--- |
| **name** *string*| Name representing the originator |
| **role** *string* | Either `external`, or `moderator` |
| **profile** *Profile object* | Optional Profile object |
| **metadata** *object* | Key value pairs with additional info |

#### Profile object

An originator can contain additional profile information using the profile object

| **Property** | Description |
| :--- | :--- |
| **fullName** *string* | Complete name |
| **firstName** *string* | First name |
| **lastName** *string* | Family name |
| **gender** *string* | Gender, M, F or U |
| **locale** *string* | Locale code \(ISO\)
| **timezone** *number* | Number of hours of UTC |
| **country** *string* | Two letter country code |
| **email** *string* | Email address |
| **picture** *string* | URL to profile picture |

### Text message

Sending a text message

> POST rest/v1/messages/:threadId

> Example Request:

```http
POST rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
	"payload": {
		"type": "text",
		"speech": "Hello",
		"originator": {
			"name": "John Doe",
			"role": "external"
		}
	}
}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
		payload: {
			type: 'text',
			speech: 'Hello',
			originator: {
				name: "John Doe",
				role: "external"
		}
		}
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

#### Parameters

| | |
|----:|---|
| **threadId** *string* | Unique identifier of the thread |

#### Arguments

| | |
|----:|---|
| **traceId** *number* | Optional unique number that is passed along to identify the message. Use this to verify message delivery. |
| **type** *string* | Indicates the type of message. Should be `text` |
| **text** *string* | The text or speech message to process. The maximum length of a message is 255 characters. |
| **lang** *string* | Optional language code in [ISO format](https://en.wikipedia.org/wiki/ISO_639-1) (2 letters) |
| **timezone** *integer* | Optional UTF timezone offset in hours |
| **params** *object* | Optional parameters |

### Event message

> POST rest/v1/messages/:threadId

> Example Request:

```http
POST rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
	"payload": {
		"type": "event",
		"eventName": "MY_EVENT",
		"originator": {
			"name": "John Doe",
			"role": "external"
		}
	}
}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
		payload: {
			type: 'event',
			eventName: "MY_EVENT",
			originator: {
				name: "John Doe",
				role: "external"
		}
		}
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

#### Parameters

| | |
|----:|---|
| **threadId** *string* | Unique identifier of the thread |

#### Arguments

| | |
|----:|---|
| **traceId** *number* | Optional unique number that is passed along to identify the message. Use this to verify message delivery. |
| **type** *string* | Indicates the type of message. Should be `event` |
| **eventName** *string* | The name of the event to trigger |
| **lang** *string* | Optional language code in [ISO format](https://en.wikipedia.org/wiki/ISO_639-1) (2 letters) |
| **timezone** *integer* | Optional UTF timezone offset in hours |
| **params** *object* | Optional parameters |

### Location message

> POST rest/v1/messages/:threadId

> Example Request:

```http
POST rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{
	"payload": {
		"type": "location",
		"lat": "1232122422",
		"long": "2433343343",
		"originator": {
			"name": "John Doe",
			"role": "external"
		}
	}
}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
		payload: {
			type: 'location',
			lat: "1232122422",
			long: "2433343343",
			originator: {
				name: "John Doe",
				role: "external"
		}
		}
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

#### Parameters

| | |
|----:|---|
| **threadId** *string* | Unique identifier of the thread |

#### Arguments

| | |
|----:|---|
| **traceId** *number* | Optional unique number that is passed along to identify the message. Use this to verify message delivery. |
| **type** *string* | Indicates the type of message. Should be `location` |
| **lat** *string* | Latitude |
| **long** *string* | Longitude |
| **lang** *string* | Optional language code in [ISO format](https://en.wikipedia.org/wiki/ISO_639-1) (2 letters) |
| **timezone** *integer* | Optional UTF timezone offset in hours |
| **params** *object* | Optional parameters |


### Media message

> POST rest/v1/messages/:threadId

> Example Request:

```http
POST rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
{
	"payload": {
		"type": "media",
		"mediaType": "image",
		"mimetype": "image/png",
		"url": "https://source.unsplash.com/random/880x400",
		"originator": {
			"name": "John Doe",
			"role": "external"
		}
	}
}
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
	payload: {
		type: 'media',
		mediaType: 'image',
		mimeType: 'image/png;,
		url: 'https://source.unsplash.com/random/880x400'
		originator: {
			name: 'John Doe,
			role: external
		}
	}
}))

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87',
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

#### Parameters

| | |
|----:|---|
| **threadId** *string* | Unique identifier of the thread |

#### Arguments

| | |
|----:|---|
| **traceId** *number* | Optional unique number that is passed along to identify the message. Use this to verify message delivery. |
| **type** *string* | Indicates the type of message. Should be `media` |
| **mediaType** *string* | Type of media, `image`, `file`, `audio`, or `video`  |
| **url** *string* | URL of media attachment  |
| **mimeType** *string* | Optionally specify the mime-type of the uploaded file, supported media formats are channel specific |
| **lang** *string* | Optional language code in [ISO format](https://en.wikipedia.org/wiki/ISO_639-1) (2 letters) |
| **timezone** *integer* | Optional UTF timezone offset in hours |
| **params** *object* | Optional parameters |

## Thread messages

Flow.ai allows you to request messaging history for specific `threadId`. One history request is limited with 20 entries, if you need to retrieve more entries you should use optional parameter `page`.

> GET rest/v1/messages/:threadId

> Example Request

```http
GET rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
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

#### Parameters

| | |
|----:|---|
| **threadId** *string* | Unique identifier of the thread |

#### Query parameters

| | |
|----:|---|
| **sync** *string* | Optional parameter for enabling sync mode |
| **page** *number* | Optional parameter for pagination |

> GET rest/v1/messages/:threadId?sync=true

> Example Request

```http
GET rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87?sync=true HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87?sync=true&page=3',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
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
	"status": "ok",
	"result": {
		"history": [
			{
				"originator": {
					"name": "visitor_abc",
					"role": "user",
					"profile": {}
				},
				"messages": [
					{
						"fallback": "test",
						"replyTo": null,
						"contexts": [],
						"params": {},
						"intents": [],
						"createdAt": "2019-06-25T12:45:11.857Z",
						"responses": [
								{
										"type": "text",
										"payload": {
												"text": "test"
										}
								}
						]
					},
					...
				]
			},
			...
		],
    "threadId": "6ecfd199-853a-448f-9f91-ef397588ff87",
    "page": 3,
    "pages": 10
	}
}
```

## Business hours

Retrieve a list of configured business hours for your project.

> GET rest/v1/businesshours

> Example Request

```http
GET rest/v1/businesshours HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/businesshours',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
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
	"status": "ok",
}
```

#### Query parameters
| | |
|----:|---|
| **sync** *string* | Optional parameter for enabling sync mode |

> GET rest/v1/businesshours?sync=true

> Example Request

```http
GET rest/v1/businesshours?sync=true HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/businesshours?sync=true',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
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
	"status": "ok",
	"businessHours": [
		{
			"weekdays": [
				{
					"weekday": "Monday",
					"content": [
						{
							"from": "0:20",
							"to": "4:19"
						},
						{
							"from": "10:00",
							"to": "22:22"
						},
						...
					]
				},
				...
			],
			"holidays": [
				{
					"holiday": "New Year",
					"date": "2019-12-31T00:00:00.000Z"
				},
				...
			],
			"label": "test BH",
			"timezone": "(UTC+03:00) Minsk"
		},
		...
	]
}
```

## Webhooks

Webhooks are the way Flow.ai will deliver replies and notify your app of other type of events.

### Receiving calls

Creating a webhook endpoint on your server is no different from creating any page on your website.

Webhook data is sent as [JSON](https://www.json.org/) in the `POST` request body. The full event details are included and can be used directly, after parsing the JSON into an Event object.

Your webhook must meet with the following requirements:

- HTTPS support
- A valid SSL certificate
- An open port that accepts `GET` and `POST` requests

### Responding to a call

To acknowledge receipt of a webhook call, your endpoint should return a 2xx HTTP status code. All response codes outside this range, including 3xx codes, will indicate to Flow.ai that you did not receive the webhook. This does mean that a URL redirection or a "Not Modified" response will be treated as a failure. Flow.ai will ignore any other information returned in the request headers or request body.

We will attempt to deliver your webhooks for up to two 4 hours with an exponential back off. Webhooks cannot be manually retried after this time.

### Type of Events

This is a list of all the types of events we currently send. We may add more at any time, so in developing and maintaining your code, you should not assume that only these types exist.

| | |
|----:|---|
| `message.reply` | Called whenever Flow.ai is sending a reply message |
| `message.delivered` | Called when your message that you sent has been successfully received |
| `control.handover` | Called when the AI engine is handing off a specific threadId to your solution |
| `control.pause` | Called when the AI engine has paused operation for a specific threadId |
| `control.resume` | Called when the AI engine has resumed operation for a specific threadId |

## Bot control

We provide the ability to pause and resume bots for specific threads.

### Pause

Pause a bot for specific thread

> POST rest/v1/pause/:threadId

> Example Request

```http
POST rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {},
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

#### Parameters

| | |
|----:|---|
| **threadId** *string* | Unique identifier of the thread |

### Resume

Resume a bot for a specific thread

> DELETE rest/v1/pause/:threadId

> Example Request

```http
DELETE rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
{}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'DELETE',
  url: 'https://api.flow.ai/rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {},
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

#### Parameters

| | |
|----:|---|
| **threadId** *string* | Unique identifier of the thread |

### Bot status

Retrieve the status of a bot (if it's paused or active) for a specific `threadId`

> GET rest/v1/pause/:threadId

> Example Request

```http
GET rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {},
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

#### Parameters
| | |
|----:|---|
| **threadId** *string* | Unique identifier of the thread |

#### Query parameters
| | |
|----:|---|
| **sync** *string* | Optional parameter for enabling sync mode |

> GET rest/v1/pause/:threadId?sync=true

> Example Request

```http
GET rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87?sync=true HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: Bearer MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87?sync=true',
  headers: {
    'Authorization': 'Bearer MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {},
  json: true
})
```

> Example Response:

```
200 OK
```

```json
{
	"status": "ok",
	"isPaued": false,
	"threadId": "6ecfd199-853a-448f-9f91-ef397588ff87"
}
```

## Example

The following example demonstrates opening a connection and sending a test message using vanilla JavaScript in the browser.

```html
<html>
	<script>
		(function () {
      // Vanilla JS example
      // When executing this script. Check your development console for any messages

      // This identifies specific user's message
      var threadId = 'USER_THREAD_ID'

      // Can be found in 'Outbound' section of your REST integration in Flow.ai dashboard
      var token = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZ2VudElkIjoiODkxZjBiZjQtNmYwYi00NWEyLThiYjUtMDk5MTI3MDdhZjQ0IiwiY2hhbm5lbElkIjoiOWUxYzZhOWUtMjE4ZC00NGFkLTg3OWYtNzEwMjFmMTgyYWU3IiwiaWF0IjoxNTYxMzk1MjM2fQ.sBzBBCplIPMzoOxBkQgkZtm7jN2TIrz_PWcI-bUjiOI'

      var url = 'https://api.flow.ai/rest/v1/'

      function sendTextMessage() {
        console.info('sendTextMessage')

        var message = {
          "payload": {
            "type": "text",
            "speech": "test",
            "originator": {
              "name": "John Doe",
              "role": "external",
              "profile": {
                "fullName": "John Doe",
                "firstName": "John",
                "lastName": "Doe",
                "gender": "M",
                "locale": "en-US",
                "timezone": -5,
                "country": "us",
                "email": "notloving@spam.com",
                "picture": "https://randompicture.org"
              }
            }
          }
        }

        // Messaging/history endpoint
        var messageUrl = url + 'messages/' + threadId

        // Create a POST request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponse
        req.responseType = 'json'
        req.open('POST', messageUrl, true)
        req.setRequestHeader('Authorization', token)
        req.setRequestHeader("Content-type", "application/json")
        req.send(JSON.stringify(message))
      }

      function sendEventMessage() {
        console.info('sendEventMessage')

        var event = {
          "payload": {
            "type": "event",
            "eventName": "test_event",
            "originator": {
              "name": "John Doe",
              "role": "external",
              "profile": {
                "fullName": "John Doe",
                "firstName": "John",
                "lastName": "Doe",
                "gender": "M",
                "locale": "en-US",
                "timezone": -5,
                "country": "us",
                "email": "notloving@spam.com",
                "picture": "https://randompicture.org"
              }
            }
          }
        }

        // Messaging/history endpoint
        var messageUrl = url + 'messages/' + threadId

        // Create a POST request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponse
        req.responseType = 'json'
        req.open('POST', messageUrl, true)
        req.setRequestHeader('Authorization', token)
        req.setRequestHeader("Content-type", "application/json")
        req.send(JSON.stringify(event))
      }

      function sendLocationMessage() {
        console.info('sendLocationMessage')

        var location = {
          "payload": {
            "type": "location",
            "lat": "12.3",
            "long": "3.21",
            "originator": {
              "name": "John Doe",
              "role": "external",
              "profile": {
                "fullName": "John Doe",
                "firstName": "John",
                "lastName": "Doe",
                "gender": "M",
                "locale": "en-US",
                "timezone": -5,
                "country": "us",
                "email": "notloving@spam.com",
                "picture": "https://randompicture.org"
              }
            }
          }
        }

        // Messaging/history endpoint
        var messageUrl = url + 'messages/' + threadId

        // Create a POST request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponse
        req.responseType = 'json'
        req.open('POST', messageUrl, true)
        req.setRequestHeader('Authorization', token)
        req.setRequestHeader("Content-type", "application/json")
        req.send(JSON.stringify(location))
      }

      function sendMediaMessage() {
        console.info('sendMediaMessage')

        var media = {
          "payload": {
            "type": "media",
            "mediaType": "image",
            "url": "https://source.unsplash.com/random/880x400",
            "originator": {
              "name": "John Doe",
              "role": "external",
              "profile": {
                "fullName": "John Doe",
                "firstName": "John",
                "lastName": "Doe",
                "gender": "M",
                "locale": "en-US",
                "timezone": -5,
                "country": "us",
                "email": "notloving@spam.com",
                "picture": "https://randompicture.org"
              }
            }
          }
        }

        // Messaging/history endpoint
        var messageUrl = url + 'messages/' + threadId

        // Create a POST request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponse
        req.responseType = 'json'
        req.open('POST', messageUrl, true)
        req.setRequestHeader('Authorization', token)
        req.setRequestHeader("Content-type", "application/json")
        req.send(JSON.stringify(media))
      }

      function getMessagingHistory() {
        console.info('getMessagingHistory')

        // Messaging/history endpoint        
        var historyUrl = url + 'messages/' + threadId

        //Create a GET request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponse
        req.responseType = 'json'
        req.open('GET', historyUrl, true)
        req.setRequestHeader('Authorization', token)
        req.send()
      }

      function getMessagingHistorySync() {
        console.info('getMessagingHistorySync')

        // Messaging/history endpoint        
        var historyUrl = url + 'messages/' + threadId + '?sync=true'

        //Create a GET request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponseSync
        req.responseType = 'json'
        req.open('GET', historyUrl, true)
        req.setRequestHeader('Authorization', token)
        req.setRequestHeader("Content-type", "application/json")
        req.send()
      }

      function getBusinessHours() {
        console.info('getBusinessHours')

        // Messaging/history endpoint        
        var businessHoursUrl = url + 'businesshours'

        //Create a GET request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponse
        req.responseType = 'json'
        req.open('GET', businessHoursUrl, true)
        req.setRequestHeader('Authorization', token)
        req.setRequestHeader("Content-type", "application/json")
        req.send()
      }

      function getBusinessHoursSync() {
        console.info('getBusinessHoursSync')

        // Messaging/history endpoint        
        var businessHoursUrl = url + 'businesshours?sync=true'

        //Create a GET request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponseSync
        req.responseType = 'json'
        req.open('GET', businessHoursUrl, true)
        req.setRequestHeader('Authorization', token)
        req.setRequestHeader("Content-type", "application/json")
        req.send()
      }

      function pauseBotForUser() {
        console.info('pauseBotForUser')

        // Pause/resume endpoint
        var pauseUrl = url + 'pause/' + threadId

        // Create a POST request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponse
        req.responseType = 'json'
        req.open('POST', pauseUrl, true)
        req.setRequestHeader('Authorization', token)
        req.setRequestHeader("Content-type", "application/json")
        req.send()
      }

      function resumeBotForUser() {
        console.info('pauseBotForUser')

        // Pause/resume endpoint
        var resumeUrl = url + 'pause/' + threadId

        // Create a DELETE request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponse
        req.responseType = 'json'
        req.open('DELETE', resumeUrl, true)
        req.setRequestHeader('Authorization', token)
        req.setRequestHeader("Content-type", "application/json")
        req.send()
      }

      function getBotStatus() {
        console.info('getBotStatus')

        // Messaging/history endpoint        
        var businessHoursUrl = url + 'pause/' + threadId

        //Create a GET request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponse
        req.responseType = 'json'
        req.open('GET', businessHoursUrl, true)
        req.setRequestHeader('Authorization', token)
        req.setRequestHeader("Content-type", "application/json")
        req.send()
      }

      function getBotStatusSync() {
        console.info('getBotStatusSync')

        // Messaging/history endpoint        
        var businessHoursUrl = url + 'pause/' + threadId + '?sync=true'

        //Create a GET request
        var req = new XMLHttpRequest()
        req.onload = restEndpointResponseSync
        req.responseType = 'json'
        req.open('GET', businessHoursUrl, true)
        req.setRequestHeader('Authorization', token)
        req.setRequestHeader("Content-type", "application/json")
        req.send()
      }

      function restEndpointResponse(e) {
        console.info('Received response')

        var xhr = e.target

        if (xhr.status !== 200) {
          // This is not OK..
          console.error('Error while sending text message', xhr.response)
          return
        }
        // In other case check your webhook url to see the response from Flow.ai
      }

      function restEndpointResponseSync(e) {
        console.info('Received response')

        var xhr = e.target

        if (xhr.status !== 200) {
          // This is not OK..
          console.error('Error while sending text message', xhr.response)
          return
        } else {
          console.log(xhr.response)
        }
      }

      // Sending text message
      sendTextMessage()

      // Sending event message
      sendEventMessage()

      // Sending location message
      sendLocationMessage()

      // Sending media message
      sendMediaMessage()

      // Getting business hours for project
      getBusinessHours()
      getBusinessHoursSync()

      // Getting messaging history
      setTimeout(function () {
        getMessagingHistory()
        getMessagingHistorySync()
      }, 1000)

      // Pausing bot
      setTimeout(function () {
        pauseBotForUser()
        getBotStatus()
        getBotStatusSync()
      }, 2000)

      // Resuming bot
      setTimeout(function () {
        resumeBotForUser()
      }, 3000)
    }())
	</script>
</html>
```