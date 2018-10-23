---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - javascript
  - shell

toc_footers:
  - <a href='https://app.flow.ai/signup'>Sign Up for a free account</a>
  - <a href='https://github.com/lord/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduction

The Flow.ai API is organized around [REST](http://en.wikipedia.org/wiki/Representational_State_Transfer). Our API has predictable, resource-oriented URLs, and uses HTTP response codes to indicate API errors. We use built-in HTTP features, like HTTP authentication and HTTP verbs, which are understood by off-the-shelf HTTP clients.


Our messaging API supports [cross-origin resource sharing](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing), allowing you to interact securely with our API from a client-side web application (though you should never expose your secret API key in any public client-side code). [JSON](http://www.json.org/) is returned by all API responses, including errors.

# Messaging API

## Authentication

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
```

> Make sure to replace `meowmeowmeow` with your API key.

Kittn uses API keys to allow access to the API. You can register a new Kittn API key at our [developer portal](http://example.com/developers).

Kittn expects for the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: meowmeowmeow`

<aside class="notice">
You must replace <code>meowmeowmeow</code> with your personal API key.
</aside>

# Management API

## Flows

### The Flow object

### Create a Flow

### Retrieve a Flow

### Update a Flow

### List all Flows

## Intents

### The Intent object

### Create an Intent

### Retrieve an Intent

### Update an Intent

### List all Intents

## Entity types

### The Entity type object

### Create an Entity type

### Retrieve an Entity type

### Update an Entity type

### List all Entity types

## Projects

### The Project object

### Create a Project

### Retrieve a Project

### Update a Project

### List all Projects

## Members

### The Member object

### List all Members
