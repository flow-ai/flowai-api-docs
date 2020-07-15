# REST API

An API to automate messaging (e.g., chatbots, voice-powered apps and devices)

<aside class="notice">
  <strong>Need some inspiration?</strong>
  <p>There are different ways to leverage the Flow.ai platform:</p>
  <ul>
    <li><a href="https://www.tracebuzz.com/">Tracebuzz</a> connects their social media chat and messaging platform</li>
    <li><a href="https://www.shopctrl.com/">ShopCtrl</a> automates online retailers</li>
    <li><a href="https://www.teleperformance.com/en-us/solutions/digital-platforms">Telepeformance</a> deflects phone calls and automates contact centers</li>
  </ul>
</aside>

This API is organized around [REST](http://en.wikipedia.org/wiki/Representational_State_Transfer). It has predictable, resource-oriented URLs, and uses HTTP response codes to indicate API errors. We use built-in HTTP features, like HTTP authentication and HTTP verbs, which are understood by off-the-shelf HTTP clients.

Our REST API supports [cross-origin resource sharing](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing), allowing you to interact securely with our API from a client-side web application (though you should never expose your secret API key in any public client-side code). [JSON](http://www.json.org/) is returned by all API responses, including errors.

## Audience

The API is specifically intended for developers that want to use the Flow.ai platform within their own technology stack or solution.

Some example use cases are:

- Automating a customer service solution
- Integrating a bot with a custom backend service
- Hardware or other server-side integrations

For use cases that connect with client interfaces, like mobile apps and websites, we offer a real-time [websocket API](#socket-api)

## You call us, we'll call you

The REST API works asynchronous. Unlike other NLP APIs, it will not always returns a direct reply to a [Send](#sending-messages) call.

![Send messages using REST API](/images/sending.svg "Sending messages to Flow.ai")

Instead, the API will send a POST request to your configured [webhook](#webhooks) whenever an event takes place.

### Sync mode 

To make life easier, some calls do support an optional synchronous reply mode. If enabled, you'll get a direct reply with your request instead of having to wait for your webhook to be called.

To enable this sync mode add a `sync=true` flag to the called endpoint.

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

### Text message

Sending a text message

> POST rest/v1/messages/:threadId

> Example Request:

```http
POST rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
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
    'Authorization': 'MY_MESSAGING_API_KEY',
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

With each message you need to provide some information regarding the sender, user or as we call it, the originator of the message.

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
| **country** *string* | Lowercase, two letter country code (https://en.wikipedia.org/wiki/ISO_639-1) |
| **email** *string* | Email address |
| **picture** *string* | URL to profile picture |

### Event message

> POST rest/v1/messages/:threadId

> Example Request:

```http
POST rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
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
    'Authorization': 'MY_MESSAGING_API_KEY',
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
Authorization: MY_MESSAGING_API_KEY
{
	"payload": {
		"type": "location",
		"lat": "1232122422",
		"long": "2433343343",
    "title": "Example title",
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
    'Authorization': 'MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
		payload: {
			type: 'location',
			lat: '1232122422',
      long: '2433343343',
      title: 'Example title',
			originator: {
				name: 'John Doe',
				role: 'external'
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
| **title** *string* | Optional title of location |
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
    "title": "Example title",
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

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
    payload: {
      type: 'media',
      mediaType: 'image',
      mimeType: 'image/png',
      title: 'Example title',
      url: 'https://source.unsplash.com/random/880x400',
      originator: {
        name: 'John Doe',
        role: 'external'
        }
	  }
  }
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
| **title** *string* | Optional title of location |
| **mimeType** *string* | Optionally specify the mime-type of the uploaded file, supported media formats are channel specific |
| **lang** *string* | Optional language code in [ISO format](https://en.wikipedia.org/wiki/ISO_639-1) (2 letters) |
| **timezone** *integer* | Optional UTF timezone offset in hours |
| **params** *object* | Optional parameters |

## Thread messages

We provide a way to request the messaging history of a specific `threadId`. Each request is limited to 20 entries and supports pagination to retrieve more entries by specifying a `page` parameter.

> GET rest/v1/messages/:threadId

> Example Request

```http
GET rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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

> GET rest/v1/messages/:threadId?sync=true&page=3

> Example Request

```http
GET rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87?sync=true&page=3 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/messages/6ecfd199-853a-448f-9f91-ef397588ff87?sync=true&page=3',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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

## Get threads

This API call provides a way to load *threads*. A thread represents a conversation and each request is limited to 20 entries. If you need to retrieve more entries we provide pagination using an optional `page` parameter.

> GET rest/v1/threads

> Example Request

```http
GET rest/v1/threads HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/threads',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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

#### Query parameters

| | |
|----:|---|
| **sync** *string* | Optional parameter for enabling sync mode |
| **page** *number* | Required parameter for pagination |

> GET rest/v1/threads?sync=true

> Example Request

```http
GET rest/v1/threads?sync=true&page=1 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/threads?sync=true&page=1',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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
        "threads": [
            "14ee0879-afa7-45ed-a3db-42c4b538d42c|o_4f4f442c-cd6c-44f1-8f3d-28d9668ab72c",
            "2a1b5693-133b-4d92-84e8-005d5350ca2e|o_4f4f442c-cd6c-44f1-8f3d-28d9668ab72c",
            "98e1c5a8-1647-42db-bbb5-9d835f53ee95|o_4f4f442c-cd6c-44f1-8f3d-28d9668ab72c",
            ...
        ],
        "page": "1",
        "pages": 100
    }
}
```

## Send takeover action (deprecated)

Send takeover action for specific thread

#### Parameters

| | |
|----:|---|
| **threadId** *string* | Unique identifier of the thread |

> POST rest/v1/takeover/:threadId

> Example Request

```http
POST rest/v1/takeover/6ecfd199-853a-448f-9f91-ef397588ff87 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
{}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/takeover/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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
## Send resolve action

> POST rest/v1/resolve/:threadId

> Example Request:

```http
POST rest/v1/resolve/a4ad8a025763451da6f15f2b50991651|o_21361542-a262-4aaa-8edb-0f8f88e07d89 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/resolve/a4ad8a025763451da6f15f2b50991651|o_21361542-a262-4aaa-8edb-0f8f88e07d89',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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

Send resolve action for a specific threadId. Resolve will remove `takeover` and `pause` from the bot and set `control_state` tag with value `resolved`.

#### Parameters

| | |
|----:|---|
| **threadId** *string* | Unique threadId | [//]: <> (THREAD_ID|o_CHANNEL_ID)


## Send handover action

> POST rest/v1/handover/:threadId

> Example Request:

```http
POST rest/v1/handover/a4ad8a025763451da6f15f2b50991651|o_21361542-a262-4aaa-8edb-0f8f88e07d89 HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
{
	{
	  "secondsToPause": 600
  }
}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/handover/a4ad8a025763451da6f15f2b50991651|o_21361542-a262-4aaa-8edb-0f8f88e07d89',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
		{
	    "secondsToPause": 600
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

Send handover action for a specific thread. If `secondsToPause` specified, bot will pause for this number of seconds. 

#### Parameters

| | |
|----:|---|
| **threadId** *string* | Unique threadId | [//]: <> (THREAD_ID|o_CHANNEL_ID)

#### Arguments

| | |
|----:|---|
| **secondsToPause** *number* | Optional. Number of seconds to pause bot. |

## Triggering events

We provide a way to trigger events for specific threads. An example use case can be a customer service agent doing a hand back and triggering a bot flow for a customer.

### Get a list of events

This API provides a way to retrieve a list of events that are allowed to be triggered. Be sure that you have events with the `ENABLE MANUAL TRIGGER` checkbox checked. You can find this checkbox in the sidebar on the right when you select an event inside the flow designer.

> GET rest/v1/trigger/event

> Example Request

```http
GET rest/v1/trigger/event HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/trigger/event',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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

#### Query parameters

| | |
|----:|---|
| **sync** *string* | Optional parameter for enabling sync mode |

> GET rest/v1/trigger/event?sync=true

> Example Request

```http
GET rest/v1/trigger/event?sync=true HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/trigger/event?sync=true',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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
        "items": [
            "EVENT 1",
            "EVENT 2",
            "EVENT 3"
        ]
    }
}
```

### Trigger an event

Use this API to trigger an event for a specific thread. If you are interested to trigger events for multiple customers at once, please have a look at our instant [broadcast](#broadcast) API.

> POST rest/v1/trigger/event/:threadId

> Example Request

```http
POST rest/v1/trigger/event/6ecfd199-853a-448f-9f91-ef397588ff87?eventName=MY_EVENT HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
{}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/trigger/event/6ecfd199-853a-448f-9f91-ef397588ff87?eventName=MY_EVENT',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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
| **eventName** *string* | Required parameter |

## Business hours

Retrieve a list of configured business hours for your project.

> GET rest/v1/businesshours

> Example Request

```http
GET rest/v1/businesshours HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/businesshours',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/businesshours?sync=true',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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
Authorization: MY_MESSAGING_API_KEY
{}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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
Authorization: MY_MESSAGING_API_KEY
{}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'DELETE',
  url: 'https://api.flow.ai/rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/pause/6ecfd199-853a-448f-9f91-ef397588ff87?sync=true',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
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

## Get audience segments

This API call provides a way to load a list of [segments](https://flow.ai/docs/guides/audience#segments) created in Flow.ai. Segment is a list of your bot's contacts that are grouped by one or multiple conditions.

> GET rest/v1/broadcast/segments?sync=true

> Example Request

```http
GET rest/v1/broadcast/segments?sync=true HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
```

```javascript
import request from "async-request";

const result = await request({
  method: 'GET',
  url: 'https://api.flow.ai/rest/v1/broadcast/segments?sync=true',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  json: true
})
```

> Example Response

```
200 OK
```

```json
{
  "status": "ok",
  "segments":     [{
                      "_id": "5f0f2445e11c9f0032bb0772",
                      "agentId": "ea6e8bde-8bf3-4bf2-abc1-e4d2865bae10",
                      "audienceId": "befce22b-7a3e-40fb-8b44-4de3688509f8",
                      "__v": 0,
                      "channels": [
                          "eazy"
                      ],
                      "conditions": [],
                      "contact": "all",
                      "createdAfterCondition": "2020-07-14T21:00:00.000Z",
                      "createdAt": "2020-07-15T15:44:05.831Z",
                      "createdBeforeCondition": "2020-07-15T21:00:00.000Z",
                      "importCondition": "all_contacts",
                      "title": "Created on 15th of July (Eazy)",
                      "type": "segment",
                      "updatedAt": "2020-07-15T15:44:05.828Z"
                  },
                  {
                      "_id": "5f0f2465e11c9f0032bb0773",
                      "agentId": "ea6e8bde-8bf3-4bf2-abc1-e4d2865bae10",
                      "audienceId": "164b9fa3-db65-4aaf-9b07-9eab3b4ff459",
                      "__v": 0,
                      "channels": [
                          "messenger"
                      ],
                      "conditions": [
                          {
                              "condition": "has_tag_name",
                              "conditionValue": "OPTIN"
                          }
                      ],
                      "contact": "messenger",
                      "createdAfterCondition": null,
                      "createdAt": "2020-07-15T15:44:37.013Z",
                      "createdBeforeCondition": null,
                      "importCondition": "all_contacts",
                      "title": "OPTIN tag (Messenger)",
                      "type": "segment",
                      "updatedAt": "2020-07-15T15:44:37.012Z"
                  }
              ]
}
```

#### Query parameters

| | |
|----:|---|
| **sync** *string* | Optional parameter for enabling sync mode |

## Broadcast to MSISDN

The broadcast API provides a way to send bulk messages. You can use this API to re-engage or engage with customers without them starting an initial conversation. For example, sending a WhatsApp templated message or SMS (text) message to a phone number (MSISDN).

> POST rest/v1/broadcast/instant

> Example Request

```http
POST rest/v1/broadcast/instant HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
{
	"audience": [{
		"name": "John Doe",
		"phoneNumber": "+12345678901",
		"profile": {}
	}],
	"channel": {
		"channelName": "whatsapp",
		"externalId": "+10987654321"
	},
	"payload": {
		"type": "event",
		"eventName": "Send template"
	}
}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/broadcast/instant',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
    audience: [{
      name: 'John Doe',
      phoneNumber: "+12345678901",
      profile: {
      }
    }],
    channel: {
      channelName: "whatsapp",
      externalId: "+10987654321"
    },
    payload: {
      type: 'event',
      eventName: "Send template",
      metadata: {
        language: "fr",
        timezone: "-2",
        params: {
          customerId: [{
            value: "1234223422232"
          }]
        }
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
| **audience** *array* | A list of originator objects. See [audience](#rest-api-broadcast-to-msisdn-parameters-audience) below |
| **channel** *object* | See [channel](#rest-api-broadcast-to-msisdn-parameters-channel) below |
| **payload** *object* | See [payload](#rest-api-broadcast-to-msisdn-parameters-payload) below |

##### Audience

The intended audience to send a message to. Please see the [originator](#originator) format for more details

| | |
|----:|---|
| **name** *string* | Mandatory name, for example `Anonymous` |
| **phoneNumber** *string* | Mandatory^1^ MSISDN (phone number in [E164](https://en.wikipedia.org/wiki/E.164) format)  |
| **identifier** *string* | Mandatory^1^ identifier  |
| **profile** *string* | Optional [profile](#profile) data |

1: Either the `phoneNumber` or `identifier` needs to be provided

##### Channel

Information about the Flow.ai integration used to send a message from.

| | |
|----:|---|
| **channelName** *string* | Type of channel to send the message, see the reference table below |
| **externalId** *string* | Identifier of the channel to send the message, see the table below where to find this |

**channelName**

Use the reference table below to determine the `channel.channelName` to copy and paste:

| Channel | channelName |
|------------|--------------|
| Google RBM | `rbm` |
| MessageMedia | `messagemedia` |
| Telekom RBM | `telekom` |
| Twilio | `twilio` |
| WhatsApp | `whatsapp` |
| Khoros | `khoros` |
| Messenger^1^ | `messenger` |

1: Facebook Messenger requires a user scoped page ID. We do not support phone numbers at this time

**externalId**

Within the Flow.ai dashboard, open the messaging channel you'd like to use to send a message. Use the reference table below to find the value to use within your API call.

| Channel | externalId |
|------------|--------------|
| Google RBM | Project ID |
| MessageMedia | Phone Number |
| Telekom RBM | Telekom bot ID |
| Twilio | Phone Number |
| WhatsApp | Production phone number |
| Khoros | Phone number |
| Messenger | Page ID |

###### Payload

| | |
|----:|---|
| **type** *string* | Should be `event`|
| **eventName** *string* | Name of the Flow.ai [event](/docs/triggers/event) to trigger |
| **metadata** *object* | See metadata below |

###### Metadata

| | |
|----:|---|
| **language** *object* | Optional language to use |
| **timezone** *object* | Optional UTC timezone offset to use |
| **params** *object* | Optional params to use |

## Broadcast to segments

This broadcast API call provides a way to trigger one or multiple events for specified segments. You can specify either name of segment or it's id taken from [Segments list](#rest-api-get-audience-segments)

> POST rest/v1/broadcast/instant/segment

> Example Request

```http
POST rest/v1/broadcast/instant/segment HTTP/1.1
Host: api.flow.ai
Content-Type: application/json
Authorization: MY_MESSAGING_API_KEY
{
    "audience": [{
        "name": "MY_SEGMENT_1"
    }, {
        "id": "ID_OF_MY_SEGMENT_2"
    }, {
        "name": "MY_SEGMENT_3",
        "id": "ID_OF_MY_SEGMENT_3"
    }],
    "events": [{
        "name": "MY_EVENT_1"
    }, {
        "name": "MY_EVENT_2"
    }]
}
```

```javascript
import request from "async-request";

const result = await request({
  method: 'POST',
  url: 'https://api.flow.ai/rest/v1/broadcast/instant/segment',
  headers: {
    'Authorization': 'MY_MESSAGING_API_KEY',
    'Content-Type': 'application/json'
  },
  body: {
    audience: [{
      name: 'MY_SEGMENT_1',
    }, {
      id: 'ID_OF_MY_SEGMENT_2'
    }, {
      name: 'MY_SEGMENT_3',
      id: 'ID_OF_MY_SEGMENT_3'
    }],
    events: [{
      name: 'MY_EVENT_1'
    }, {
      name: 'MY_EVENT_2'
    }]
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
| **audience** *array* | A list of segment objects. See [audience](#rest-api-broadcast-to-segments-parameters-audience) below |
| **events** *array* | A list of event objects. See [events](#rest-api-broadcast-to-segments-parameters-events) below |

##### Audience

The segment to trigger event for.

| | |
|----:|---|
| **name** *string* | Name of your segment, for example `MY_SEGMENT_1` |
| **id** *string* | ID of your segment. Can be obtained [here](#rest-api-get-audience-segments)  |

1: Either the `name` or `id` needs to be provided.

##### Events

| | |
|----:|---|
| **name** *string* | Name of the [event](/docs/triggers/event) to trigger. For example `MY_EVENT_1`|

## Webhooks

Webhooks are the way we deliver replies and notify your app of other type of events.

### Receiving calls

Creating a webhook endpoint on your server is no different from creating any page on your website.

Webhook data is sent as [JSON](https://www.json.org/) in the `POST` request body. The full event details are included and can be used directly, after parsing the JSON into an Event object.

Your webhook must meet with the following requirements:

- HTTPS support
- A valid SSL certificate
- An open port that accepts `GET` and `POST` requests

### Responding to a call

To acknowledge receiving successful webhook call, your endpoint should return a 2xx HTTP status code. All response codes outside this range, including 3xx codes, will indicate to us that you did not receive the webhook call. 

This does mean that a URL redirection or a "Not Modified" response will be treated as a failure. we will ignore any other information returned in the request headers or request body.

We will attempt to deliver your webhook calls for up to two 4 hours with an exponential back off. Webhooks cannot be manually retried after this time.

### Type of Events

This is a list of all the types of events we currently send. We may add more at any time, so in developing and maintaining your code, you should not assume that only these types exist.

| | |
|----:|---|
| `message` | Called whenever Flow.ai is sending reply message for a specific threadId |
| `history` | Called whenever Flow.ai is sending messaging history for a specific threadId |
| `threads` | Called whenever Flow.ai is sending list of threads in user's project |
| `trigger.events` | Called whenever Flow.ai is sending list of events that can be triggered manually |
| `businessHours` | Called whenever Flow.ai is sending business hours information |
| `paused` | Called when the AI engine has paused operation for a specific threadId |
| `resumed` | Called when the AI engine has resumed operation for a specific threadId |
| `isPaused` | Called whenever Flow.ai is sending bot status for a specific threadId |
| `inbound` | Called whenever user sends message to Flow.ai from non-rest channel |
| `outbound` | Called whenever AI engine sends message to user from non-rest channel |
| `takeover` | Called when the takeover action is executed |

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

      // Can be found within the 'Outbound' section of your REST integration inside the Flow.ai dashboard
      var token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZ2VudElkIjoiODkxZjBiZjQtNmYwYi00NWEyLThiYjUtMDk5MTI3MDdhZjQ0IiwiY2hhbm5lbElkIjoiOWUxYzZhOWUtMjE4ZC00NGFkLTg3OWYtNzEwMjFmMTgyYWU3IiwiaWF0IjoxNTYxMzk1MjM2fQ.sBzBBCplIPMzoOxBkQgkZtm7jN2TIrz_PWcI-bUjiOI'

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
