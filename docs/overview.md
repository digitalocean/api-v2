# DigitalOcean API Reference

	This is a work-in-progress document representing the current "spec" for the DigitalOcean v2 API.

## Table of Contents

1. [Overview](#overview)
1. [Droplets](#droplet)
  * [Droplet Actions](#droplet-action)
  * [Droplet Self](#droplet-self)
1. [Images](#image)
  * [Image Actions](#image-action)
1. [Domains](#domain)
  * [Domain Records](#domain-record)
1. [Keys](#key)
1. [Regions](#region)
1. [Sizes](#size)

## Overview

### Authentication

OAuth is used to authorize and revoke access to your account to yourself and third parties. *Full
OAuth documentation will be available in a separate document.* There are three ways to use an OAuth
access token once you have one.

##### OAuth Token in Basic Authentication

	$ curl -u "$ACCESS_TOKEN:x" https://api.digitalocean.com

##### OAuth Token in Bearer Auth Header

	$ curl -H "Authorization: Bearer $ACCESS_TOKEN" https://api.digitalocean.com

##### OAuth Token in Query Parameter

	$ curl "https://api.digitalocean.com/?access_token=$ACCESS_TOKEN"

For personal and development purposes, you can create a personal access token in the API control
panel and use it like a regular OAuth token.

### Schema

The API has a machine-readable JSON schema that describes what resources are available via the API,
what their URLs are, how they are represented and what operations they support. You can access the
schema using curl:

	$ curl https://api.digialocean.com/v2/schema

The schema format is based on the same JSON schema used by [Heroku for their API](https://blog.heroku.com/archives/2014/1/8/json_schema_for_heroku_platform_api).

### Errors

Failing responses will have an appropriate [HTTP status](https://github.com/for-GET/know-your-http-well/blob/master/status-codes.md) and a JSON body containing more details about the error.

##### Example Error Response

```
HTTP/1.1 403 Forbidden
```
```javascript
{
  "id":       "forbidden",
  "message":  "Request not authorized, provided credentials do not provide access to specified resource"
}
```

### Methods

<table>
<thead><tr>
<th>Method</th>
<th>Usage</th>
</tr></thead>
<tbody>
<tr>
<td>DELETE</td>
<td>used for destroying existing objects</td>
</tr>
<tr>
<td>GET</td>
<td>used for retrieving lists and individual objects</td>
</tr>
<tr>
<td>HEAD</td>
<td>used for retrieving metadata about existing objects</td>
</tr>
<tr>
<td>PATCH</td>
<td>used for updating existing objects</td>
</tr>
<tr>
<td>POST</td>
<td>used for creating new objects</td>
</tr>
</tbody>
</table>

### Method Override

When using a client that does not support all of the [methods](#methods), you can override by using a `POST` and
setting the `X-Http-Method-Override` header to the desired methed. For instance, to do a `PATCH`
request, do a `POST` with header `X-Http-Method-Override: PATCH`.

### Parameters

Values that can be provided for an action are divided between optional and required values. The expected type for each value is specified. Parameters should be JSON encoded and passed in the request body, however, in many cases you can use regular query parameters or `application/x-www-form-urlencoded` or `multipart/form-data` parameters. For example, these two requests are equivalent:

```
$ curl -n -X PATCH https://api.digitalocean.com/v2/domains/$DOMAIN_ID/records/$DOMAIN_RECORD_ID \
-H "Content-Type: application/json" \
-d '{"type":"A","name":"www","data":"127.0.0.1"}'
```
```
$ curl -n -X PATCH https://api.digitalocean.com/v2/domains/$DOMAIN_ID/records/$DOMAIN_RECORD_ID \
-F "type=A"
-F "name=www"
-F "data=127.0.0.1"
```

### Ranges

List requests will return a `Content-Range` header indicating the range of values returned. Large lists may require additional requests to retrieve. If a list response has been truncated you will receive a `206 Partial Content` status and one or both of `Next-Range` and `Prev-Range` headers if there are next and previous ranges respectively. To retrieve the next or previous range, repeat the request with the `Range` header set to either the `Next-Range` or `Prev-Range` value from the previous request.

The number of values returned in a range can be controlled using a `max` key in the `Range` header. For example, to get only the first 10 values, set this header: `Range: id ..; max=10;`. `max` can also be passed when iterating over `Next-Range` and `Prev-Range`. The default page size is 200 and maximum page size is 1000.

### Versioning

Major versions of the API are backwards incompatible and are available at different path endpoints. A major version may change
in backwards compatible ways, such as adding new parameters, or if changing a parameter, the old parameter will still work.



