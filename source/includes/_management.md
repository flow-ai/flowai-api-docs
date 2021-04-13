
# Flow Management API

## Authentication

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
curl "https://api.flow.ai/v1/projects/:projectId/flows"
  -H 'Authorization: Bearer MY_MANAGEMENT_API_KEY'
```

> Make sure to replace `MY_MANAGEMENT_API_KEY` with your API key.

Authenticate your API requests by providing a Management API key as a bearer token. All API requests expect this bearer token to be present.

You can register a new Management API key within your [organisation settings](https://app.flow.ai/settings/organisation).

<aside class="notice">
Treat API keys with care. Never share keys with other users or applications. Do not publish keys in public code repositories.
</aside>

## Flows

> Example Flow object:

```json
{
	"flowId": "c48b0a06-9727-4735-8886-49286fae78e3",
	"projectId": "db3e3895-fe06-4dcc-a7a0-35b0c0ec55c3",
	"brainId": "86bc0fa0-25f7-4d3d-9dcf-eaa2a6f810b1",
	"title": "Hello World",
	"group": "Demo",
	"createdAt": "2018-10-24T06:45:19.541Z",
	"disabled": false,
	"steps": [{
		"stepId": "31aef3cf-8c96-442b-9871-7fc9be322da1",
		"title": "Hello!",
		"type": "INTENT",
		"contexts": [],
		"intent": {
			"intentId": "67841005-31b1-45b3-b939-3879dfd377de",
			"title": "Hello_World_Greeting",
			"createdAt": "2018-10-24T06:45:19.484Z",
			"examples": [{
				"entities": [],
				"query": "Hello"
			}, {
				"entities": [],
				"query": "Good day"
			}, {
				"entities": [],
				"query": "Good afternoon"
			}, {
				"entities": [],
				"query": "good morning"
			}, {
				"entities": [],
				"query": "hi"
			}, {
				"entities": [],
				"query": "Hey"
			}]
		},
		"actions": [{
			"type": "TEXT",
			"payload": {
				"texts": [
					"Hi there! This is a customer service demo bot! ",
					"Hello! I am a customer service demo bot!"
				],
				"quickReplies": [],
				"delay": 0
			}
		}]
	}]
}
```

A Flow represents a [conversation topic](https://flow.ai/docs/thinking-in-flows.html). It's combines a series of [Step objects](#the-step-object) that the AI engine uses to determine what actions to perform.

### The Flow object

Property | Description
--------- | -----------
**flowId** *string* | Unique ID of the Flow
**projectId** *string* | Project ID the Flow belongs to
**brainId** *string* | ID of the AI brain the Flow belongs to
**title** *string* | Name of the Flow
**group** *string* | Group name
**createdAt** *date string* | Date the flow was created
**disabled** *boolean* | Indicates if it should be ignored
**steps** *array* | Collection of Step objects


### The Step object

> Example `INTENT` Step:

```json
{
	"stepId": "31aef3cf-8c96-442b-9871-7fc9be322da1",
	"title": "Hello!",
	"type": "INTENT",
	"contexts": [],
	"actions": [{
		"type": "TEXT",
		"payload": {
			"texts": [
				"Simple reply"
			],
			"quickReplies": [],
			"tags": []
		}
	}],
	"intent": {
		"intentId": "67841005-31b1-45b3-b939-3879dfd377de",
		"title": "Hello_World_Greeting",
		"createdAt": "2018-10-24T06:45:19.484Z",
		"examples": [{
			"entities": [],
			"query": "Hello"
		}, {
			"entities": [],
			"query": "hi"
		}, {
			"entities": [],
			"query": "Hey"
		}]
	}
}
```

> Example `EVENT` Step:

```json
{
	"stepId": "c7512efe-9c2e-4cd4-9fdc-11fc1d31dfb8",
	"type": "EVENT",
	"title": "EVENT NAME",
	"contexts": ["31aef3cf-8c96-442b-9871-7fc9be322da1"],
	"actions": [{
		"type": "TEXT",
		"payload": {
			"texts": [
				"Simple reply"
			],
			"quickReplies": [],
			"tags": []
		}
	}]
}
```

Each Step is part of a Flow. Steps are used by the AI engine to determine what reply action to send when for example an intent is matched.

Steps can be related to other steps and configure complex tree like dialog structures,

Property | Description
--------- | -----------
**stepId** *string* | Unique ID of the Step
**title** *string* | Name of the Step
**type** *string* | Type of step. Should be a value of `INTENT`, `EVENT`, `UNKNOWN`, `IMAGE`, `FILE`, `AUDIO`, `VIDEO`, `LOCATION`, `NOTHING`, `ANYTHING`
**contexts** *array* | Collection of stepIds that precede the step
**intent** *object* | Intent object, required if type is `INTENT`
**actions** *array* | Collection of Reply actions

### List all Flows

This endpoint retrieves all Flows.

> GET /flows/list

```javascript
var request = require("request");
var options = { method: 'GET',
  url: 'https://api.flow.ai/v1/projects/:projectId/flows',
  qs: { limit: '5', skip: '0' },
  headers: 
   { 
     Authorization: 'MY_MANAGEMENT_API_KEY',
   } };

request(options, function (error, response, body) {
  if (error) throw new Error(error);

  console.log(body);
});
```

```shell
curl "https://api.flow.ai/v1/projects/:projectId/flows"
  -H 'Authorization: Bearer MY_MANAGEMENT_API_KEY'
```

Property | Description
--------- | -----------
**projectId** *required* | Project ID the Flow belongs to
**limit** *optional* | Pagination option. Number of items per response
**skip** *optional* | Pagination option. Number of items to skip

```json
[{
	"flowId": "53ced89e-08e4-40bc-89b8-f7ea02ba6cd5",
	"projectId": "db3e3895-fe06-4dcc-a7a0-35b0c0ec55c3",
	"brainId": "86bc0fa0-25f7-4d3d-9dcf-eaa2a6f810b1",
	"title": "Get started",
  "group": "Weather",
	"createdAt": "2018-10-24T06:45:03.828Z",
	"disabled": false,
	"steps": [{
		"stepId": "4237653c-ad8d-4bf8-8ff5-da9dd7cb5636",
		"type": "INTENT",
		"title": "Get started",
		"contexts": [],
		"actions": ["5bd014ef0838670032b1aa11"],
		"intent": "5bd014ef0838670032b1aa16"
	}]
}, {
	"flowId": "f1a4c7fd-fa2b-4f67-a391-15b9e98d47ea",
	"projectId": "db3e3895-fe06-4dcc-a7a0-35b0c0ec55c3",
	"brainId": "86bc0fa0-25f7-4d3d-9dcf-eaa2a6f810b1",
	"title": "Weather",
  "group": "Weather",
	"createdAt": "2018-10-24T06:45:03.820Z",
	"disabled": false,
	"steps": [{
		"stepId": "ea8b18e6-eb07-4ad6-8df2-518c43c180e3",
		"type": "INTENT",
		"title": "What is the weather like",
		"contexts": [],
		"actions": ["5bd014ef0838670032b1aa13"]
	}, {
		"stepId": "e010bb48-a51b-48f3-ab46-81ce10f05454",
		"type": "SLOT",
		"title": "SLOT",
		"contexts": ["ea8b18e6-eb07-4ad6-8df2-518c43c180e3"],
		"actions": ["5bd014ef0838670032b1aa12"],
		"slot": {
			"validation": "REQUIRED",
			"entityId": "system.query",
			"label": "city"
		}
	}]
}]
```
