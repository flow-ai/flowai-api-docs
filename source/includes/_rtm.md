# Flow Socket API

A real time messaging API that allows you to send and receive messages from Flow using web sockets.

## Audience

The Socket API is specifically intended for developers looking to integrate Flow in a client facing app. For example:

- Building a custom web chat widget
- Integrating Flow inside a mobile app

<aside class="notice">
 We provide a <a href="https://github.com/flow-ai/flowai-js">JavaScript SDK</a>, and for iOS a <a href="https://github.com/flow-ai/flowai-swift">Swift SDK</a>.
</aside>

For server integrations we advice you to take a look at our [Messaging API](#messaging-api).

## Getting started

An overview how the API works:

1. [Request](#web-socket-api-request-an-endpoint) \(GET\) a WebSocket endpoint
2. [Open](#web-socket-api-open-a-connection) a WebSocket connection \(WSS\)
3. [Send](#web-socket-api-sending-messages) and [receive](#web-socket-api-receiving-messages) messages
4. [Keep the connection alive](#web-socket-api-keep-alive)

## Nonce overview

The nonce (or secret) is created to provide more security for websocket interactions. To enable it, go to your project
and choose the Flow widget integration, select the advanced section, scroll down and check the box `ENABLE CLIENT NONCE`

How it works:

- If you call us for the first time for a specific `threadId` you don't need to provide a `nonce` (secret)
in response you will receive the `nonce` (secret) and you need to store it for this specific `threadId`
- A nonce is linked to a `threadId`, that means if you change the `threadId`, you will receive new `nonce` in the response
- If you have a `nonce` for a specific `threadId` you'll need to provide it in the headers `x-flowai-secret` for any `REST` request
- If you send a websocket message of the type `message.send` you'll need to send the `nonce` in the message `payload` with a key named `nonce`
## Requesting an endpoint

> Example Request:

```shell
curl 'https://sdk.flow.ai/socket.info' \
  -H 'x-flowai-secret: SECRET' \
  -H 'x-flowai-threadid: THREAD_ID' \
  -H 'x-flowai-clientid: CLIENT_ID' \
  -H 'x-flowai-sessionid: SESSION_ID' \
  -H 'content-type: application/json' \
  -H 'accept: */*' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  --compressed
```

```js
var request = require("request");

var options = {
  method: 'GET',
  url: 'https://sdk.flow.ai/socket.info',
  headers: {
    'x-flowai-secret': 'SECRET',
    'x-flowai-threadid': 'THREAD_ID',
    'x-flowai-clientid': 'CLIENT_ID',
    'x-flowai-sessionid': 'SESSION_ID'
  }
};

request(options, function (error, response, body) {
  if (error) throw new Error(error);

  console.log(body);
});
```

```csharp
var client = new RestClient("https://sdk.flow.ai/socket.info");
var request = new RestRequest(Method.GET);

request.AddHeader("x-flowai-secret", "SECRET");
request.AddHeader("x-flowai-threadid", "THREAD_ID");
request.AddHeader("x-flowai-clientid", "CLIENT_ID");
request.AddHeader("x-flowai-sessionid", "SESSION_ID");

IRestResponse response = client.Execute(request);
```

```swift
var request = NSMutableURLRequest(URL: NSURL(string: "https://sdk.flow.ai/socket.info/?clientId=YOUR_CLIENT_ID&sessionId=1234")!,
                                        cachePolicy: .UseProtocolCachePolicy,
                                    timeoutInterval: 10.0)
request.addValue("SECRET", forHTTPHeaderField: "x-flowai-secret")
request.addValue("THREAD_ID", forHTTPHeaderField: "x-flowai-threadid")
request.addValue("CLIENT_ID", forHTTPHeaderField: "x-flowai-clientid")
request.addValue("SESSION_ID", forHTTPHeaderField: "x-flowai-sessionid")
```

> Example response:

```
200 OK
```

```json
{
  "status": "ok",
  "payload": {
    "endpoint": "wss://sdk.flow.ai/ws/8c3b7d7ea9400..."
  },
  "secret": "SECRET"
}
```

To start a connection you'll need to make a `GET` call to the `socket.info` API method to the API endpoint at `https://sdk.flow.ai`. This provides a temporary WebSocket URL.

The `socket.info` method requires a `secret`, `sessionId`, `clientId`, and a `threadId`.

| **Headers** | Description |
| :--- | :--- |
| **x-flowai-secret** | The [secret](#socket-api-nonce-overview) is used for more security |
| **x-flowai-threadid** | The thread ID of the conversation |
| **x-flowai-sessionid** | The sessionId is something unique you need to create for every call. This can be something like a [UIUID](https://en.wikipedia.org/wiki/Universally_unique_identifier). Each connection is partly identified on our end using this key |
| **x-flowai-clientid** | Check the [Channels](https://app.flow.ai/channels) app of the [dashboard](https://app.flow.ai) to find your unique clientId. |

## Open a connection

The socket URL provided by `socket.info` are single-use and are only valid for 60 seconds, so make sure to connect directly.

## Common format

```json
{
  "type": "...",
  "payload": {
    ...
  }
}
```

Any message or other kind of event you send or receive has the same JSON format.

#### Attributes

| **Property** | Description |
| --- | --- |
| **type** **required** | The message type for example: `message.send` |
| **payload** **required** | The body of the message |

## Keep alive

> Example Message:

```json
{
  "type": "ping"
}
```

> Example Reply:

```json
{
  "type": "pong"
}
```

When a connection is made we will automatically disconnect if we do not receive any messages within 50 seconds.

In order to keep the connection live we support a ping message.


## Sending Messages

> Example Message:

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

The easiest way to send a simple text message in real time

#### Attributes

| **Property** | Description |
| --- | --- |
| **threadId** **required** | Unique key identifying a user or channel |
| **traceId** *optional* | Optional number used to track message delivery |
| **nonce** *optional* | The [secret](#socket-api-nonce-overview) is used for more security |
| **speech** **required** | Text of message |

### Originator object

> Example Message:

```json
{
  "type": "message.send",
  "payload": {
    "threadId": "58ca9e327348ed3bd1439e7b",
    "traceId": 1519091841666,
    "nonce": "SECRET",
    "speech": "Turn off the lights in the Living room",
    "originator": {
      "name": "John Doe",
      "role": "external"
    },
  }
}
```

> Example Message:

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
```

> Example Message:

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

With each message you can customize information regarding the sender, user or as Flow calls it, the originator of the message.

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


### Metadata

> Example Message:

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

Along with every message you can send additional metadata. Some of this metadata is also used by the AI engine to determine the response.

##### Attributes

| **Property** | Description |
| :--- | :--- |
| **language** *string* | Language code \(ISO\) of the message, not the user |
| **timezone** *number* | Timezone of the message \(where it was sent\). Number of hours from UTC |
| **params** *Params object* | Bag of parameters to use within the AI |

#### Params object

> Example Params

```json
{
  "passengerCount": [{
    "value": "2"
  }]
}
```

```json
{
  "food": [{
    "value": "food-item-22332",
    "match": "Pizza Hawaii"
  }, {
    "value": "food-item-44525",
    "match": "Pizza Calzone"
  }]
}
```

The params object resembles the matched result created by the AI engine using entity classification. Each param itself is a list of `[{ value }]` objects.

| **Property** | Description |
| :--- | :--- |
| **value** **required** | The value of the param |
| **match** *optional* | Represents a human value |

### Attachment

> Example Message:

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

Instead of simple text messages, Flow also supports sending attachments like files or events.

<aside class="notice">
Note: we currently only support sending event attachments. Image and file attachments will follow soon.
</aside>

##### Attachment attributes

| Property | Description |
| :--- | :--- |
| **type** **required** | Attachment type. Currently this has to be `event` |
| **payload** **required** | Attachment object |

##### Attachment object

| Property | Description | Type |
| :--- | :--- | :--- |
| **name** **required** | Name of the event to trigger |

### Responses

> Example Reply:

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

A reply is sent \(almost\) instantly. The following is replied if the message is successfully delivered.

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
        var socketInfoUrl = 'https://sdk.flow.ai/socket.info?clientId=' + clientId + '&sessionId=' + Date.now();

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
