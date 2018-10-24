# Web socket API
A real time messaging API that allows you to send and receive messages from Flow.ai in real-time.

## Audience
This API is specifically intended for developers looking to interate Flow.ai in a client facing ap. For example:

- Building a custom web chat widget
- Integrating Flow.ai inside a mobile app

<aside class="notice">
 We provide a <a href="https://github.com/flow-ai/flowai-js">JavaScript SDK</a>, and for iOS a <a href="https://github.com/flow-ai/flowai-swift">Swift SDK</a>.
</aside>

For server or backend integrations we advice you to take a look at our Messaging API.

## Getting started

An overview how the API works:

1. Request \(GET\) a WebSocket endpoint
2. Open a WebSocket connection \(WSS\)
3. Send and receive messages
4. [Keep the connection alive](/api/keep-alive.md)

## Request an endpoint

> Example calls

```shell
curl -X GET -H "Content-Type: application/json" "https://api.flow.ai/socket.info?clientId=YOUR_CLIENT_ID&sessionId=123432"
```

```js
var request = require("request");

var options = { method: 'GET', url: 'https://api.flow.ai/socket.info/?clientId=YOUR_CLIENT_ID&sessionId=1234' };

request(options, function (error, response, body) {
  if (error) throw new Error(error);

  console.log(body);
});
```

```csharp
var client = new RestClient("https://api.flow.ai/socket.info?clientId=YOUR_CLIENT_ID&sessionId=1234");
var request = new RestRequest(Method.GET);
IRestResponse response = client.Execute(request);
```

```swift
var request = NSMutableURLRequest(URL: NSURL(string: "https://api.flow.ai/socket.info/?clientId=YOUR_CLIENT_ID&sessionId=1234")!,
                                        cachePolicy: .UseProtocolCachePolicy,
                                    timeoutInterval: 10.0)
```

> Example response

```json
{
  "status": "ok",
  "payload": {
    "endpoint": "wss://api.flow.ai/ws/8c3b7d7ea9400..."
  }
}
```

To start a connection you'll need to make a `GET` call to the `socket.info` API method to the API endpoint at `https://api.flow.ai`. This provides a temporary WebSocket URL.

The `socket.info` method requires a `sessionId` and a `clientId`.

| **Query param** | Description |
| :--- | :--- |
| **sessionId** | The sessionId is something unique you need to create for every call. This can be something like a [UIUID](https://en.wikipedia.org/wiki/Universally_unique_identifier). Each connection is partly identified on our end using this key |
| **clientId** | Check the [Channels](https://app.flow.ai/channels) app of the [dashboard](https://app.flow.ai) to find your unique clientId. |


## Open a connection

The Websocket URL provided by `socket.info` are single-use and are only valid for 60 seconds, so make sure to connect directly.

## Common format

Any message or other kind of event you send or receive has the same JSON format.

```json
{
  "type": "...",
  "payload": {
    ...
  }
}
```

**Fields**

| **Property** | Description |
| --- | --- |
| **type** *string* | The message type for example: `message.send` |
| **payload** *object* | The body of the message |

## Keep alive

> Send a ping to keep the connection alive

```json
{
  "type": "ping"
}
```

> We will respond with a pong

```json
{
  "type": "pong"
}
```

When a connection is made we will automatically disconnect if we do not receive any messages within 50 seconds.

In order to keep the connection live we support a ping message.


## Sending Messages

> The following example shows sending a simple text message

```json
{
  "type": "message.send",
  "payload": {
    "threadId": "58ca9e327348ed3bd1439e7b",
    "traceId": 1519091841664,
    "speech": "Hi there!"
  }
}
```

### Payload

| **Property** | Description |
| --- | --- |
| **threadId** *string* | Required. Unique key identifying a user or channel |
| **traceId** *integer* | Optional number used to track message delivery |
| **speech** *string* | Required. Text of message |

### Message Attachment

> Event example

```json
{
  "type": "message.send",
  "payload": {
    "threadId": "58ca9e327348ed3bd1439e7b",
    "traceId": 1519091841665,
    "speech": "event attachment",
    "attachment": {
      "type": "event",
      "payload": {
        "name": "INTRO"
      }
    }
  }
}
```

Instead of text we also support sending attachments.

<aside class="notice">
Note: we currently only support sending event attachments. Image and file attachments will follow soon.
</aside>

##### Attachment fields

| Property | Description |
| :--- | :--- |
| **type** *string* | Attachment type. Currently this has to be `event` |
| **payload** *attachment* | Attachment |

##### Attachment fields

| Property | Description | Type |
| :--- | :--- | :--- |
| name | Name of the event to trigger | string |

### Originator

> Sending originator info

```json
{
  "type": "message.send",
  "payload": {
    "threadId": "58ca9e327348ed3bd1439e7b",
    "traceId": 1519091841666,
    "speech": "Turn off the lights in the Living room",
    "originator": {
      "name": "John Doe",
      "role": "external"
    },
  }
}
```

> Sending additional profile information

```json
{
  "type": "message.send",
  "payload": {
    "threadId": "58ca9e327348ed3bd1439e7b",
    "traceId": 1519091841667,
    "speech": "has my milk expired?",
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

> Sending originator with metadata

```json
{
  "type": "message.send",
  "payload": {
    "threadId": "58ca9e327348ed3bd1439e7b",
    "speech": "I want to book a flight between Amsterdam and Toronto",
    "originator": {
      "name": "John Doe",
      "role": "external",
      "metadata": {
        "clientNumber": "asddaasq333ee332",
        "preference": "A,B,G"
      }
    }
  }
}
```

With each message you can customise information regarding the sender, user or as we call it the originator of the message.

#### Originator fields

| Property | Description |
| :--- | :--- |
| **name** | Name representing the originator |
| **role** *string* | Either `external`, or `moderator` |
| **profile** *profile* | Additional profile information |
| **metadata** *object* | Key value pairs with additional info |

#### Profile fields

| Property | Description |
| :--- | :--- |
| **fullName** | Complete name |
| **firstName** *string* | First name |
| **lastName** *string* | Family name |
| **gender** *string* | Gender, M, F or U |
| **locale** *string* | Locale code \(ISO\)
| **timezone** *number* | Number of hours of UTC |
| **country** *string* | Two letter country code |
| **email** *string* | Email address |
| **picture** *string* | URL to profile picture |



### Message Metadata

Along with every message you can send additional metadata. Some of this metadata is also used by the AI engine to determine the response.

```json
{
  "type": "message.send",
  "payload": {
    "threadId": "58ca9e327348ed3bd1439e7b",
    "speech": "I want to book a flight between Amsterdam and Toronto",
    "originator": {
      "name": "John Doe",
      "role": "external"
    },
    "metadata": {
      "language": "en-US",
      "timezone": -6,
      "params": {
        "seats": [{
          "value": "Business class"
        }]
      }
    }
  }
}
```

##### Metadata fields

| Property | Description | Type |
| :--- | :--- | :--- |
| language | Language code \(ISO\) of the message, not the user | string |
| timezone | Timezone of the message \(where it was sent\). Number of hours from UTC | number |
| params | Bag of parameters to use within the AI | object |

### Responses

> A reply is sent \(almost\) instantly. The following is replied if the message is successfully delivered.

```json
{
  "type": "message.delivered",
  "payload": {
    "traceId": 1,
    "threadId": "31ea9df73ca74dfe9329bf68c09b61ce",
    "traceId": 1489399519321,
    "speech": "hi"
  }
}
```

> If there is an error processing a message the server will reply with an error. For example:

```json
{
  "type": "error",
  "message": "Invalid message format ..."
}
```

## Receiving Messages

Messages that are replied are in almost the same format as the ones that are sent.


> Example or reply

```json
{
  "type": "message.received",
  "payload": {
    "threadId": "57a8a2a8917250d54bcbb596",
    "messages": [
      {
        "fallback": "hallo",
        "responses": [
          {
            "type": "text",
            "payload": {
              "text": "hallo"
            }
          }
        ]
      }
    ],
    "originator": {
      "userId": "7250d54bcbb59657a8a2a891",
      "name": "Gijs van de Nieuwegiessen",
      "role": "user",
      "profile": {
        "fullName": "Gijs van de Nieuwegiessen",
        "firstName": "Gijs",
        "lastName": "van de Nieuwegiessen",
        "locale": "nl",
        "gender": "M",
        "picture": "https://flowai.s3.eu-central-1.amazonaws.com/identities/profile/5959ca45-318a-4d58-b5e1-b430934b8e23"
      }
    }
  }
}
```

> Example of advanced reply  

```json
{
  "type": "message.received",
  "payload": {
    "threadId": "58ca9e327348ed3bd1439e7b",
    "messages": [
      {
        "fallback": "Hi, how can we help?",
        "silent": false,
        "replyTo": "event attachment",
        "originator": {
          "userId": "flowai|system",
          "name": "system",
          "role": "bot",
          "profile": {
            "picture": "https://flow.ai/img/brains/flowai.svg"
          }
        },
        "actions": [],
        "responses": [
          {
            "type": "text",
            "payload": {
              "text": "Hi, how can we help?",
              "quickReplies": [
                {
                  "label": "Chat with flow.ai",
                  "value": "Chat with someone from flow.ai",
                  "type": "text"
                },
                {
                  "label": "Call flow.ai",
                  "value": "What is your phone number?",
                  "type": "text"
                },
                {
                  "label": "Ask a question",
                  "value": "I want to ask a question",
                  "type": "text"
                }
              ]
            },
            "delay": 0
          }
        ],
        "flow": {
          "flowId": "2afcb930-9335-4e74-abb3-5745d26707f7",
          "title": "Intro"
        },
        "step": {
          "stepId": "d3d46698-e526-4252-b70c-e6e5af3338e0",
          "title": "INTRO",
          "type": "EVENT"
        },
        "params": {
          "event": [
            {
              "type": "custom",
              "value": {
                "name": "INTRO"
              }
            }
          ]
        }
      }
    ],
    "originator": {
      "userId": "flowai|system",
      "name": "system",
      "role": "bot",
      "profile": {
        "picture": "https://flow.ai/img/brains/flowai.svg"
      }
    }
  }
}
```

##### Payload fields

| Property | Description | Type |
| :--- | :--- | :--- |
| threadId | Required. Unique key identifying a user or channel | string |
| messages | List of Message templates | array |
| originator | Similar to the originator when sending messages | object |

##### Message fields

| Property | Description | Type |
| :--- | :--- | :--- |
| fallback | Speech representation of the message | string |
| silent | True if message does not have any output for a user | bool |
| replyTo | Optionally contains the text the message is a direct reply to | string |
| originator | Originator specific to this message | object |
| actions | Optional action names being called | array |
| responses | Collection of Response templates | array |
| flow | Information about the flow being matched | object |
| step | Information about the step being matched | object |
| params | Hash table with Parameters | object |

##### Response fields

We have a complete[ reference of the JSON responses](https://github.com/flow-ai/flowai-js-templates/blob/master/JSON.md) available


## Example

We provide a [JavaScript SDK](https://github.com/flow-ai/flowai-js), but the following example demonstrates opening a connection and sending a test message using vanilla JavaScript in the browser.

```html
<html>
  <body>
    <script>

    (function () {
      // Vanilla JS example
      // When executing this script. Check your development console for any messages

      // This identifies the channel we want to connect with
      var clientId = 'YOUR CLIENTID'

      // Global references to our WebSocket and interval
      var ws
      var keepalive

      // This methos is where we send test messages
      function runTestMessages() {

        console.info('runTestMessages')
        var message = {
          "type": "message.send",
          "payload": {
            "threadId": "jane.doe",
            "speech": "event attachment",
            "attachment": {
              "type": "event",
              "payload": {
                "name": "MY EVENT"
              }
            },
            "originator": {
              "name": "Jane Doe",
              "role": "external",
              "profile": {
                "fullName": "Jane Doe",
                "firstName": "Jane",
                "lastName": "Doe",
                "gender": "F",
                "locale": "en-US",
                "timezone": -5,
                "country": "us",
                "email": "janedoe@gmail.com",
                "picture": "https://en.wikipedia.org/wiki/File:YellowLabradorLooking_new.jpg"
              },
              "metadata": {
                "clientNumber": "12345",
                "preference": "A,B,G"
              }
            }
          }
        }

        wsSendMessage(message)
      }

      // Get a new wss endpoint
      function getWsEndpoint() {
        console.info('Request endpoint')
        // socket.info endpoint
        var socketInfoUrl = 'https://api.flow.ai/socket.info?clientId=' + clientId + '&sessionId=' + Date.now();

        // Create a GET request
        var req = new XMLHttpRequest();
        req.onload = wsEndpointResponse
        req.responseType = 'json';
        req.open('GET', socketInfoUrl, true);
        req.send();
      }

      // Called when we get a response from socket.info
      // validate the response and open a websocket connection
      function wsEndpointResponse(e) {
        console.info('Received endpoint')

        var xhr = e.target;

        if(xhr.response.status !== 'ok') {
          // This is not OK..
          console.error('Error while fetching wss url', xhr.response)
          return
        }

        // Get the endpoint from the response
        var endpoint = xhr.response.payload.endpoint

        startWebsocket(endpoint)
      }

      // Open a new websocket connection
      function startWebsocket(endpoint) {
        console.info('Websocket start connection with endpoint', endpoint)
        // Create a new socket
        ws = new WebSocket(endpoint);
        ws.onopen = wsOnOpen;
        ws.onmessage = wsOnMessage;
      }

      // Handler called when the socket makes a connection
      function wsOnOpen(e) {
        console.info('Websocket connection open')

        // Start the keepalive
        wsStartKeepalive()

        // Run our test messages
        runTestMessages()
      }

      // Handler called when the socket receives a message
      function wsOnMessage(e) {
        var json = JSON.parse(e.data)
        console.info('Websocket received json', json)
      }

      // Simple keep alive method (sending pings)
      function wsStartKeepalive() {
        clearInterval(keepalive)

        // Send a ping 30 seconds
        keepalive = setInterval(function() {
          wsSendMessage({
            "type": "ping"
          })
        }, 30 * 1000)
      }

      // Helper method for sending messages
      function wsSendMessage(message) {
        ws.send(JSON.stringify(message))
      }

      // Start with sending a GET request for a WSS endpoint
      getWsEndpoint()
    }());
    </script>
  </body>
</html>
```
