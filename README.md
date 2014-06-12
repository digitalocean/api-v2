### API v2.0 Introduction

Welcome to the DigitalOcean API documentation.

The DigitalOcean API allows you to manage Droplets and resources within the DigitalOcean cloud in a simple, programmatic way using conventional HTTP requests.  The endpoints are intuitive and powerful, allowing you to easily make calls to retrieve information or to execute actions.

All of the functionality that you are familiar with in the DigitalOcean control panel is also available through the API, allowing you to script the complex actions that your situation requires.

The API documentation will start with a general overview about the design and technology that has been implemented, followed by reference information about specific endpoints.

### HTTP Requests

The DigitalOcean API is fully [RESTful]("http://en.wikipedia.org/wiki/Representational_state_transfer").  Users can access the resources provided by the API by using standard HTTP methods.

Any tool that is fluent in HTTP can communicate with the API simply by requesting the correct URI.  Requests should be made using the HTTPS protocol so that traffic is encrypted.  The interface responds to different methods depending on the action required.

<table class="pure-table pure-table-horizontal">
  <thead>
      <tr>
          <th>Method</th>
          <th>Usage</th>
      </tr>
  </thead>
  <tbody>
      <tr>
          <td>GET</td>
          <td>
              <p>For simple retrieval of information about your account, Droplets, or environment, you should use the <strong>GET</strong> method.  The information you request will be returned to you as a JSON object.</p>

              <p>The attributes defined by the JSON object can be used to form additional requests.  Any request using the GET method is read-only and will not affect any of the objects you are querying.</p>
          </td>
      </tr>
      <tr>
          <td>DELETE</td>
          <td>
              <p>To destroy a resource and remove it from your account and environment, the <strong>DELETE</strong> method should be used.  This will remove the specified object if it is found.  If it is not found, the operation will return a response indicating that the object was not found.</p>

              <p>This <a href="http://en.wikipedia.org/wiki/Idempotent#Computer_science_meaning">idempotency</a> means that you do not have to check for a resource's availability prior to issuing a delete command, the final state will be the same regardless of its existence.</p>
          </td>
      </tr>
      <tr>
          <td>PUT</td>
          <td>
              <p>To update the information about a resource in your account, the <strong>PUT</strong> method is available.</p>

              <p>Like the DELETE Method, the PUT method is idempotent.  It sets the state of the target using the provided values, regardless of their current values.  Requests using the PUT method do not need to check the current attributes of the object.</p>
          </td>
      </tr>
      <tr>
          <td>POST</td>
          <td>
              <p>To create a new object, your request should specify the <strong>POST</strong> method.</p>

              <p>The POST request includes all of the attributes necessary to create a new object.  When you wish to create a new object, send a POST request to the target endpoint.</p>
          </td>
      </tr>
      <tr>
          <td>HEAD</td>
          <td>
              <p>Finally, to retrieve metadata information, you should use the <strong>HEAD</strong> method to get the headers.  This returns only the header of what would be returned with an associated GET request.</p>

              <p>Response headers contain some useful information about your API access and the results that are available for your request.</p>

              <p>For instance, the headers contain your current rate-limit value and the amount of time available until the limit resets.  It also contains metrics about the total number of objects found, pagination information, and the total content length.</p>
          </td>
      </tr>
  </tbody>
</table>


### HTTP Statuses

Along with the HTTP methods that the API responds to, it will also return standard HTTP statuses, including error codes.

In the event of a problem, the status will contain the error code, while the body of the response will usually contain additional information about the problem that was encountered.

In general, if the status returned is in the 200 range, it indicates that the request was fulfilled successfully and that no error was encountered.

Return codes in the 400 range typically indicate that there was an issue with the request that was sent.  Among other things, this could mean that you did not authenticate correctly, that you are requesting an action that you do not have authorization for, that the object you are requesting does not exist, or that your request is malformed.

If you receive a status in the 500 range, this generally indicates a server-side problem.  This means that we are having an issue on our end and cannot fulfill your request currently.

#### EXAMPLE ERROR RESPONSE


    HTTP/1.1 403 Forbidden

    {
      "error":       "forbidden",
      "description": "You do not have access for the attempted action."
    }

### Responses

Upon a successful request, a response body will typically be sent back in the form of a JSON object.  An exception to this is when a DELETE request is processed, which will result in a successful HTTP 204 status and an empty response body.

Inside of this JSON object, the resource type that was the target of the request will be set as the key.  This will be the singular form of the word if the request operated on a single object, and the plural form of the word if a collection was processed.

For example, if you send a GET request to `/v2/droplets/$DROPLET_ID` you will get back an object with a key called "`droplet`".  However, if you send the GET request to the general collection at `/v2/droplets`, you will get back an object with a key called "`droplets`".

The value of these keys will generally be a JSON object for a request on a single object and an array of objects for a request on a collection of objects.

#### Example Responses

For a single object:

    {
        "droplet": {
            "name": "example.com"
            . . .
        }
    }

For an object collection:

    {
        "droplets": [
            {
                "name": "example.com"
                . . .
            },
            {
                "name": "second.com"
                . . .
            }
        ]
    }

### Pagination

In order to handle large numbers of objects, the returned response will be paginated.  By default, the pagination function is configured to return 25 objects at a time.

The pagination information is included in the headers of the response when more than one object is being returned.  The relevant pieces of information are:

* **Total**: The total number of results for the request.
* **Link**: This provides information about additional pages.  Check the [links] section for more information.

You can adjust the number of results per page by passing a `per_page` query parameter.  This can be used to specify the number of results returned per page.

To get the information from any of the additional pages, you should pass a `page` query parameter.  For instance, if you have 60 total results and are using the default pagination rules, you could get results 26-50 by adding `?page=2` to your request.

The [links] header will give you much better information about the relationship of the pages to one another and what the last of information will be.

#### Sample Pagination Header Information

    . . .
    Link: <https://api.digitalocean.com/v2/images?page=11&per_page=5>; rel="last", <https://api.digitalocean.com/v2/images?page=2&per_page=5>; rel="next"
    Total: 51
    . . .

### Rate Limit

The number of requests that can be made through the API is currently limited to 1200 per hour.

The rate limiting information is contained within the response headers of each request.  The relevant headers are:

* **X-RateLimit-Limit**: The number of requests that can be made per hour.
* **X-RateLimit-Remaining**: The number of requests that remain before you hit your request limit.  See the information below for how the request limits expire.
* **X-RateLimit-Reset**: This represents the time when the oldest request will expire.  The value is given in [UTC epoch seconds](http://en.wikipedia.org/wiki/Unix_time).  See below for more information about how request limits expire.

As long as the `X-RateLimit-Remaining` count is above zero, you will be able to make additional requests.

The way that a request expires and is removed from the current limit count is important to understand.  Rather than counting all of the requests for an hour and resetting the `X-RateLimit-Remaining` value at the end of the hour, each request instead has its own timer.

This means that each request contributes toward the `X-RateLimit-Remaining` count for one complete hour after the request is made.  When that request's timer runs out, it is no longer counted towards the request limit.

This has implications on the meaning of the `X-RateLimit-Reset` header as well.  Because the entire rate limit is not reset at one time, the value of this header is set to the time when the *oldest* request will expire.

Keep this in mind if you see your `X-RateLimit-Reset` value change, but not move an entire hour into the future.

If the `X-RateLimit-Remaining` reaches zero, subsequent requests will receive a 429 error code until the request reset has been reached.  You can see the format of the response in the examples.

#### Sample Rate Limit Headers

    . . .
    X-RateLimit-Limit: 1200
    X-RateLimit-Remaining: 1193
    X-RateLimit-Reset: 1402425459
    . . .

#### Sample Rate Exceeded Response

    429 Too Many Requests
    {
            id: "too_many_requests",
            message: "API Rate limit exceeded."
    }

### Link Headers

Link headers are used to provide information about the remaining paginated portions of the requested information.

For instance, if you request a listing of all available images at 5 results per page (as discussed in the last section), a link header will be set in the response that will contain the URIs of the related pages.

The related pages will be defined as a URI and a `rel` attribute, which defines the relationship of the URI to the response that is being sent back.  The `rel` attribute may be any of the following:

* **first**: The URI of the first page of results.
* **prev**: The URI of the previous sequential page of results.
* **next**: The URI of the next sequential page of results.
* **last**: The URI of the last page of results.

The link headers will only include the links that make sense.  So if the `Total` is less than the `per_page` value, then no link header will be set.  For the first page of results, no `first` or `prev` links will ever be set.  This convention holds true in other situations where a link would not make sense.

#### Link Header Example

    Link: <https://api.digitalocean.com/v2/images?page=1&per_page=5>; rel="first", <https://api.digitalocean.com/v2/images?page=1&per_page=5>; rel="prev", <https://api.digitalocean.com/v2/images?page=11&per_page=5>; rel="last", <https://api.digitalocean.com/v2/images?page=3&per_page=5>; rel="next"</code></pre>

### Curl Examples

Throughout this document, some example API requests will be given using the `curl` command.  This will allow us to demonstrate the various endpoints in a simple, textual format.

The names of account-specific references (like Droplet IDs, for instance) will be represented by variables.  For instance, a Droplet ID may be represented by a variable called `$DROPLET_ID`  You can set the associated variables in your environment if you wish to use the examples without modification.

The first variable that you should set to get started is your OAuth authorization token.  The next section will go over the details of this, but you can set an environmental variable for it now.

Generate a token by going to the [Apps & API](https://cloud.digitalocean.com/settings/applications) section of the DigitalOcean control panel.  Use an existing token if you have saved one, or generate a new token with the "Generate new token" button.  Copy the generated token and use it to set and export the TOKEN variable in your environment as the example shows.

You may also wish to set some other variables now or as you go along.  For example, you may wish to set the `DROPLET_ID` variable to one of your droplet IDs since this will be used frequently in the API.

If you are following along, make sure you use a Droplet ID that you control for so that your commands will execute correctly.

If you need access to the headers of a response through `curl`, you can pass the `-i` flag to display the header information along with the body.  If you are only interested in the header, you can instead pass the `-I` flag, which will exclude the response body entirely.

#### Set and Export your OAuth Token

    export TOKEN={your_token_here}

#### Set and Export a Variable

    export DROPLET_ID=1111111

### OAuth Authentication

In order to interact with the DigitalOcean API, you or your application must authenticate.

The DigitalOcean API handles this through OAuth, an open standard for authorization.  OAuth allows you to delegate access to your account in full or in read-only mode.

You can generate an OAuth token by visiting the [Apps & API]("https://cloud.digitalocean.com/settings/applications") section of the DigitalOcean control panel for your account.

An OAuth token functions as a complete authentication request.  In effect, it acts as a substitute for a username and password pair.

Because of this, it is absolutely **essential** that you keep your OAuth tokens secure.  In fact, upon generation, the web interface will only display each token a single time in order to prevent the token from being compromised.

#### How to Authenticate with OAuth

There are two separate ways to authenticate using OAuth.
      
The first option is to send a bearer authorization header with your request.  This is the preferred method of authenticating because it completes the authorization request in the header portion, away from the actual request.

You can also authenticate using basic authentication.  The normal way to do this with a tool like **curl** is to use the **-u** flag which is used for passing authentication information.
        
You then send the username and password combination delimited by a colon character.  We only have an OAuth token, so use the OAuth token as the username and leave the password field blank (make sure to include the colon character though).

This is effectively the same as embedding the authentication information within the URI itself.

#### Authenticate with a Bearer Authorization Header

    curl -X $HTTP_METHOD -H "Authorization: Bearer $ACCESS_TOKEN" "https://api.digitalocean.com/v2/$OBJECT"

#### Authenticate with Basic Authentication

    curl -X $HTTP_METHOD -u "$ACCESS_TOKEN:" "https://api.digitalocean.com/v2/$OBJECT"

### Parameters

There are two different ways to pass parameters in a request with the API.

The best way to pass parameters is as a JSON object containing the appropriate attribute names and values as key-value pairs.  When you use this format, you should specify that you are sending a JSON object in the header.

This is done by setting the `Content-Type` header to `application/json`.  This ensures that your request is interpreted correctly.

Another way of passing parameters is using standard query attributes.

Using this format, you would pass the attributes within the URI itself.  Tools like `curl` can take parameters and value as arguments to create the appropriate URI.

With `curl` this is done using the `-F` flag and then passing the key and value as an argument.  The argument should take the form of a quoted string with the attribute being set to a value with an equal sign.

You could also use a standard query string if that would be easier in our application.  In this case, the parameters would be embedded into the URI itself by appending a `?` to the end of the URI and then setting each attribute with an equal sign.  Attributes can be separated with a `&`.

#### Pass Parameters as a JSON Object

    curl -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"name": "example.com", "ip_address": "127.0.0.1"}' \
        -X POST "https://api.digitalocean.com/v2/domains"

#### Pass Parameters as URI Components

    curl -H "Authorization: Bearer $TOKEN" \
        -F "name=example.com" -F "ip_address=127.0.0.1" \
        -X POST "https://api.digitalocean.com/v2/domains"

#### Pass Parameters as a Query String

    curl -H "Authorization: Bearer $TOKEN" \
         -X POST \
         "https://api.digitalocean.com/v2/domains?name=example.com&ip_address=127.0.0.1"

### Cross Origin Resource Sharing

In order to make requests to the API from other domains, the API implements Cross Origin Resource Sharing (CORS) support.

CORS support is generally used to create AJAX requests outside of the domain that the request originated from.  This is necessary to implement projects like control panels utilizing the API.  This tells the browser that it can send requests to an outside domain.

The procedure that the browser initiates in order to perform these actions (other than GET requests) begins by sending a "preflight" request.  This sets the `Origin` header and uses the `OPTIONS` method.  The server will reply back with the methods it allows and some of the limits it imposes.  The client then sends the actual request if it falls within the allowed constraints.

This process is usually done in the background by the browser, but you can use curl to emulate this process using the example provided.  The headers that will be set to show the constraints are:

* **Access-Control-Allow-Origin**: This is the domain that is sent by the client or browser as the origin of the request.  It is set through an `Origin` header.
* **Access-Control-Allow-Methods**: This specifies the allowed options for requests from that domain.  This will generally be all available methods.
* **Access-Control-Expose-Headers**: This will contain the headers that will be available to requests from the origin domain.
* **Access-Control-Max-Age**: This is the length of time that the access is considered valid.  After this expires, a new preflight should be sent.
* **Access-Control-Allow-Credentials**: This will be set to `true`.  It basically allows you to send your OAuth token for authentication.

You should not need to be concerned with the details of these headers, because the browser will typically do all of the work for you.

#### Example Preflight Request

    curl -I -H "Origin: https://example.com" -X OPTIONS "https://api.digitalocean.com/v2/droplets"

#### Example Preflight Response

    . . .
    Access-Control-Allow-Origin: https://example.com
    Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS
    Access-Control-Expose-Headers: X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset, Total, Link
    Access-Control-Max-Age: 86400
    Access-Control-Allow-Credentials: true
    . . .
# Actions


<p>Actions are records of events that have occurred on the resources in your account.  These can be things like rebooting a Droplet, or transferring an image to a new region.</p>

<p>An action object is created every time one of these actions is initiated.  The action object contains information about the current status of the action, start and complete timestamps, and the associated resource type and ID.</p>

<p>Every action that creates an action object is available through this endpoint.  Completed actions are not removed from this list and are always available for querying.</p>


<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Type</th>
      <th>Description</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>id</strong></td>
      <td><em>integer</em></td>
      <td>A unique numeric ID that can be used to identify and reference an action.</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>status</strong></td>
      <td><em>string</em></td>
      <td>The current status of the action.  This can be "in-progress", "completed", or "errored".</td>
      <td><code>completed</code></td>
    </tr>
    <tr>
      <td><strong>type</strong></td>
      <td><em>string</em></td>
      <td>This is the type of action that the object represents.  For example, this could be "transfer" to represent the state of an image transfer action.</td>
      <td><code>image_transfer</code></td>
    </tr>
    <tr>
      <td><strong>started_at</strong></td>
      <td><em>integer</em></td>
      <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
      <td><code>1402421904</code></td>
    </tr>
    <tr>
      <td><strong>completed_at</strong></td>
      <td><em>integer</em></td>
      <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
      <td><code>1402421904</code></td>
    </tr>
    <tr>
      <td><strong>resource_id</strong></td>
      <td><em>integer</em></td>
      <td>A unique identifier for the resource that the action is associated with.</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>resource_type</strong></td>
      <td><em>string</em></td>
      <td>The type of resource that the action is associated with.</td>
      <td><code>droplet</code></td>
    </tr>
  </tbody>
</table>

## Actions Collection [/v2/actions]

### Actions List all Actions [GET]

<p>To list all of the actions that have been executed on the current account, send a GET request to <code>/v2/actions</code>.</p>

<p>This will be the entire list of actions taken on your account, so it will be quite large.  As with any large collection returned by the API, the results will be paginated with only 25 on each page by default.</p>

<p>The results will be returned as a JSON object with an <code>actions</code> key.  This will be set to an array filled with action objects containing the standard action attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique identifier that can be used to reference each unique action</td>
        </tr>
        <tr>
            <td>status</td>
            <td>string</td>
            <td>The current status of the action.  This can be "completed", "in-progress", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in <a href="http://en.wikipedia.org/wiki/Unix_time">UTC epoch seconds</a> that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in <a href="http://en.wikipedia.org/wiki/Unix_time">UTC epoch seconds</a> that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.  For example, a Droplet ID for a Droplet action.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/actions" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 08100f370a3e07d30e3318e1e51578bba544f899e60b0f1c331180330ee56255
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588871
Total: 1
Content-Length: 230
      ```

  
    - Body

      ```json
      {
  "actions": [
    {
      "id": 1,
      "status": "in-progress",
      "type": "test",
      "started_at": "2014-06-12T15:01:11Z",
      "completed_at": null,
      "resource_id": null,
      "resource_type": null
    }
  ]
}
      ```
  

## Actions Member [/v2/actions/{action_id}]

### Actions Retrieve an existing Action [GET]

<p>To retrieve a specific action object, send a GET request to <code>/v2/actions/$ACTION_ID</code>.</p>

<p>The result will be a JSON object with an <code>action</code> key.  This will be set to an action object containing the standard action attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique identifier that can be used to reference each unique action</td>
        </tr>
        <tr>
            <td>status</td>
            <td>string</td>
            <td>The current status of the action.  This can be "completed", "in-progress", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in <a href="http://en.wikipedia.org/wiki/Unix_time">UTC epoch seconds</a> that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in <a href="http://en.wikipedia.org/wiki/Unix_time">UTC epoch seconds</a> that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.  For example, a Droplet ID for a Droplet action.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/actions/2" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 87d3264f8e2067304b9475ef254d2ee5aba2c1af72eb433598bc3449bd58fe87
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588871
Content-Length: 203
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 2,
    "status": "in-progress",
    "type": "test",
    "started_at": "2014-06-12T15:01:11Z",
    "completed_at": null,
    "resource_id": null,
    "resource_type": null
  }
}
      ```
  
# Domain Records


<p>Domain record resources are used to set or retrieve information about the individual DNS records configured for a domain.  This allows you to build and manage DNS zone files by adding and modifying individual records for a domain.</p>

<p>The DigitalOcean DNS management interface allows you to configure the following DNS records:</p>

<ul class="nested">
    <li><strong>A</strong>
    <ul>
        <li><strong>Description</strong>: The address record is used to map a host to a specific IPv4 address.  This is used to define subdomain specifications so that hosts are mapped correctly and can receive requests in an intelligent way.</li>
        <li><strong>Required Fields</strong>:
        <ul>
            <li><strong>type</strong>: A</li>
            <li><strong>name</strong>: The host name, or subdomain, to configure.</li>
            <li><strong>data</strong>: The IPv4 IP address to route requests to.</li>
        </ul>
        </li>
        <li><strong>Successful Creation Example</strong>:
        <ul>
            <li><code>curl -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"type": "A", "name": "ipv4host", "data": "127.0.0.1"}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
        </ul>
        </li>
    </ul>
    </li>


    <li><strong>AAAA</strong>
    <ul>
        <li><strong>Description</strong>: The IPv6 address record is used to map a host name to a specific IPv6 address.  This is functionally equivalent to an "A" record, the only difference being its association with IPv6 addresses.</li>
        <li><strong>Required Fields</strong>:
        <ul>
            <li><strong>type</strong>: AAAA</li>
            <li><strong>name</strong>: The host name, or subdomain, to configure.</li>
            <li><strong>data</strong>: The IPv6 IP address to route requests to.</li>
        </ul>
        </li>
        <li><strong>Successful Creation Example</strong>:
        <ul>
            <li><code>curl -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"type": "AAAA", "name": "ipv6host", "data": "2001:db8::ff00:42:8329"}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
        </ul>
        </li>
    </ul>
    </li>


    <li><strong>CNAME</strong>
    <ul>
        <li><strong>Description</strong>: An alias record is used to point one host name to another.  This requires an additional DNS request to resolve the host name that is pointed to.</li>
        <li><strong>Required Fields</strong>:
        <ul>
            <li><strong>type</strong>: CNAME</li>
            <li><strong>name</strong>: The new alias name that you want to set up.</li>
            <li><strong>data</strong>: The host name that you would like to give to clients who request the alias.</li>
        </ul>
        </li>
        <li><strong>Successful Creation Example</strong>:
        <ul>
            <li><code>curl -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"type": "CNAME", "name": "newalias", "data": "hosttarget"}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
        </ul>
        </li>
    </ul>
    </li>


    <li><strong>MX</strong>
    <ul>
        <li><strong>Description</strong>: Mail records are used to route mail sent to the domain to the appropriate mail server.  Multiple MX records can be added to each domain and priority is assigned to each one.</li>
        <li><strong>Required Fields</strong>:
        <ul>
            <li><strong>type</strong>: MX</li>
            <li><strong>data</strong>: The data in this instance is the host name (as defined by an A or AAAA record) that mail should be routed to.</li>
            <li><strong>priority</strong>: The priority for this mail host.  Priority is assigned as a numeric value, with smaller numbers representing higher priority mail targets.  Valid priority values are integers between 0 and 65535.</li>
        </ul>
        </li>
        <li><strong>Successful Creation Example</strong>:
        <ul>
            <li><code>curl -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"type": "MX", "data": "127.0.0.1", "priority": 5}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
        </ul>
        </li>
    </ul>
    </li>


    <li><strong>TXT</strong>
    <ul>
        <li><strong>Description</strong>: A text record contains arbitrary human-readable messages.  It is also used for various validation and verification schemes like SPF and DKIM.</li>
        <li><strong>Required Fields</strong>:
        <ul>
            <li><strong>type</strong>: TXT</li>
            <li><strong>name</strong>: The name of the record, as a string.</li>
            <li><strong>data</strong>: The arbitrary text string contents.</li>
        </ul>
        </li>
        <li><strong>Successful Creation Example</strong>:
        <ul>
            <li><code>curl -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"type": "TXT", "name": "recordname", "data": "arbitrary data here"}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
        </ul>
        </li>
    </ul>
    </li>


    <li><strong>SRV</strong>
    <ul>
        <li><strong>Description</strong>: A service record is used for general purpose service declaration.  It specifies the service, the host and port where it can be reached, and the priority and weight.</li>
        <li><strong>Required Fields</strong>:
        <ul>
            <li><strong>type</strong>: SRV</li>
            <li><strong>name</strong>: The name for the service being configured.</li>
            <li><strong>data</strong>: The target host name to direct requests for the service to.</li>
            <li><strong>port</strong>: The port where the service is found on the target host.  A valid port is an integer between 1 and 65535.</li>
            <li><strong>priority</strong>: The priority of the target host.  Lower values have higher priority.  Valid priorities are integers between 0 and 65535.</li>
            <li><strong>weight</strong>: The relative weight of targets for this service that have the same priority.  A larger value has a higher priority.  Valid weights are between 0 and 65535.</li>
        </ul>
        </li>
        <li><strong>Successful Creation Example</strong>:
        <ul>
            <li><code>curl -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"type": "SRV", "name": "servicename", "data": "targethost", "priority": 0, "port": 1, "weight": 2}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
        </ul>
        </li>
    </ul>
    </li>


    <li><strong>NS</strong>
    <ul>
        <li><strong>Description</strong>: A name server record is used to define the zone's authoritative name servers.  Three NS records pointing to the DigitalOcean name servers will be automatically generated when the domain is added.</li>
        <li><strong>Required Fields</strong>:
        <ul>
            <li><strong>type</strong>: NS</li>
            <li><strong>data</strong>: The name of a name server that is authoritative for the domain.</li>
        </ul>
        </li>
        <li><strong>Successful Creation Example</strong>:
        <ul>
            <li><code>curl -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"type": "NS", "data": "ns1.digitalocean.com."}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
        </ul>
        </li>
    </ul>
    </li>
</ul>


<p>There is also an additional field called <code>id</code> that is auto-assigned for each record and used as a unique identifier for requests.  Each record contains all of these attribute types.  For record types that do not utilize all fields, a value of <code>null</code> will be set for that record.</p>


<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Type</th>
      <th>Description</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>id</strong></td>
      <td><em>integer</em></td>
      <td>A unique identifier for each domain record.</td>
      <td><code>32</code></td>
    </tr>
    <tr>
      <td><strong>type</strong></td>
      <td><em>string</em></td>
      <td>The type of the DNS record (ex: A, CNAME, TXT, ...).</td>
      <td><code>CNAME</code></td>
    </tr>
    <tr>
      <td><strong>name</strong></td>
      <td><em>string</em></td>
      <td>The name to use for the DNS record.</td>
      <td><code>subdomain</code></td>
    </tr>
    <tr>
      <td><strong>data</strong></td>
      <td><em>string</em></td>
      <td>The value to use for the DNS record.</td>
      <td><code>@</code></td>
    </tr>
    <tr>
      <td><strong>priority</strong></td>
      <td><em>nullable integer</em></td>
      <td>The priority for SRV and MX records.</td>
      <td><code>100</code></td>
    </tr>
    <tr>
      <td><strong>port</strong></td>
      <td><em>nullable integer</em></td>
      <td>The port for SRV records.</td>
      <td><code>12345</code></td>
    </tr>
    <tr>
      <td><strong>weight</strong></td>
      <td><em>nullable integer</em></td>
      <td>The weight for SRV records.</td>
      <td><code>100</code></td>
    </tr>
  </tbody>
</table>

## Domain Records Collection [/v2/domains/{domain_name}/records]

### Domain Records List all Domain Records [GET]

<p>To get a listing of all records configured for a domain, send a GET request to <code>/v2/domains/$DOMAIN_NAME/records</code>.</p>

<p>The response will be a JSON object with a key called <code>domain_records</code>.  The value of this will be an array of domain record objects, each of which contains the standard domain record attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>The unique id for the individual record.</td>
        </tr>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>The DNS record type (A, MX, CNAME, etc).</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The host name, alias, or service being defined by the record.  See the [domain record] object to find out more.</td>
        </tr>
        <tr>
            <td>data</td>
            <td>string</td>
            <td>Variable data depending on record type.  See the [domain record] object for more detail on each record type.</td>
        </tr>
        <tr>
            <td>priority</td>
            <td>nullable Integer</td>
            <td>The priority of the host (for SRV and MX records. <code>null</code> otherwise).</td>
        </tr>
        <tr>
            <td>port</td>
            <td>nullable Integer</td>
            <td>The port that the service is accessible on (for SRV records only. <code>null</code> otherwise).</td>
        </tr>
        <tr>
            <td>weight</td>
            <td>nullable Integer</td>
            <td>The weight of records with the same priority (for SRV records only.  <code>null</code> otherwise).</td>
        </tr>
    </tbody>
</table>


<p>For attributes that are not used by a specific record type, a value of <code>null</code> will be returned.  For instance, all records other than SRV will have <code>null</code> for the  <code>weight</code> and <code>port</code> attributes.</p>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/domains/example.com/records" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer e2b5181aea8653e9c2cb9d45627042c667b366e2d8a471bec96ccfdf3dec027d
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588871
Content-Length: 861
      ```

  
    - Body

      ```json
      {
  "domain_records": [
    {
      "id": 1,
      "type": "A",
      "name": "@",
      "data": "8.8.8.8",
      "priority": null,
      "port": null,
      "weight": null
    },
    {
      "id": 2,
      "type": "NS",
      "name": null,
      "data": "NS1.DIGITALOCEAN.COM.",
      "priority": null,
      "port": null,
      "weight": null
    },
    {
      "id": 3,
      "type": "NS",
      "name": null,
      "data": "NS2.DIGITALOCEAN.COM.",
      "priority": null,
      "port": null,
      "weight": null
    },
    {
      "id": 4,
      "type": "NS",
      "name": null,
      "data": "NS3.DIGITALOCEAN.COM.",
      "priority": null,
      "port": null,
      "weight": null
    },
    {
      "id": 5,
      "type": "CNAME",
      "name": "example",
      "data": "@",
      "priority": null,
      "port": null,
      "weight": null
    }
  ]
}
      ```
  

### Domain Records Create a new Domain Record [POST]

<p>To create a new record to a domain, send a POST request to <code>/v2/domains/$DOMAIN_NAME/records</code>. </p>

<p>The request must include all of the required fields for the [domain record type] being added:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required For</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>The record type (A, MX, CNAME, etc).</td>
            <td>All records</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The host name, alias, or service being defined by the record.</td>
            <td>A, AAAA, CNAME, TXT, SRV</td>
        </tr>
        <tr>
            <td>data</td>
            <td>string</td>
            <td>Variable data depending on record type.  See the [Domain Records]() section for more detail on each record type.</td>
            <td>A, AAAA, CNAME, MX, TXT, SRV, NS</td>
        </tr>
        <tr>
            <td>priority</td>
            <td>nullable integer</td>
            <td>The priority of the host (for SRV and MX records. <code>null</code> otherwise).</td>
            <td>MX, SRV</td>
        </tr>
        <tr>
            <td>port</td>
            <td>nullable integer</td>
            <td>The port that the service is accessible on (for SRV records only. <code>null</code> otherwise).</td>
            <td>SRV</td>
        </tr>
        <tr>
            <td>weight</td>
            <td>nullable integer</td>
            <td>The weight of records with the same priority (for SRV records only.  <code>null</code> otherwise).</td>
            <td>SRV</td>
        </tr>
    </tbody>
</table>

<p>The response body will be a JSON object with a key called <code>domain_record</code>.  The value of this will be an object representing the new record.  Attributes that are not applicable for the record type will be set to <code>null</code>.  An <code>id</code> attribute is generated for each record as part of the object.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>The unique id for the individual record.</td>
        </tr>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>The DNS record type (A, MX, CNAME, etc).</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The host name, alias, or service being defined by the record.  See the [domain record] object to find out more.</td>
        </tr>
        <tr>
            <td>data</td>
            <td>string</td>
            <td>Variable data depending on record type.  See the [domain record] object for more detail on each record type.</td>
        </tr>
        <tr>
            <td>priority</td>
            <td>nullable Integer</td>
            <td>The priority of the host (for SRV and MX records. <code>null</code> otherwise).</td>
        </tr>
        <tr>
            <td>port</td>
            <td>nullable Integer</td>
            <td>The port that the service is accessible on (for SRV records only. <code>null</code> otherwise).</td>
        </tr>
        <tr>
            <td>weight</td>
            <td>nullable Integer</td>
            <td>The weight of records with the same priority (for SRV records only.  <code>null</code> otherwise).</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>name</strong></td>
      <td>name of the DNS record</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>data</strong></td>
      <td>value of the DNS record</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>type</strong></td>
      <td>type of the DNS record (ex: A, CNAME, TXT, ...)</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>priority</strong></td>
      <td>priority for SRV records</td>
      <td>false</td>
    </tr>
  
    <tr>
      <td><strong>port</strong></td>
      <td>port for SRV records</td>
      <td>false</td>
    </tr>
  
    <tr>
      <td><strong>weight</strong></td>
      <td>weight for SRV records</td>
      <td>false</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/domains/example.com/records" \
	-d '{"name":"subdomain","data":"2001:db8::ff00:42:8329","type":"AAAA"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer ee8ccb0e05f82e11a822864170479d6190d3f6164bef7259a76f53eb240db885
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "name": "subdomain",
  "data": "2001:db8::ff00:42:8329",
  "type": "AAAA"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588872
Content-Length: 185
      ```

  
    - Body

      ```json
      {
  "domain_record": {
    "id": 16,
    "type": "AAAA",
    "name": "subdomain",
    "data": "2001:db8::ff00:42:8329",
    "priority": null,
    "port": null,
    "weight": null
  }
}
      ```
  

## Domain Records Member [/v2/domains/{domain_name}/records/{record_id}]

### Domain Records Retrieve an existing Domain Record [GET]

<p>To retrieve a specific domain record, send a GET request to <code>/v2/domains/$DOMAIN_NAME/records/$RECORD_ID</code>.</p>

The response will be a JSON object with a key called <code>domain_record</code>.  The value of this will be an object that contains all of the standard domain record attributes:

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>The unique id for the record.</td>
        </tr>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>The DNS record type (A, MX, CNAME, etc).</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The host name, alias, or service being defined by the record.  See the [domain record] object for more info.</td>
        </tr>
        <tr>
            <td>data</td>
            <td>string</td>
            <td>Variable data depending on record type.  See the [domain records] object for more detail on each record type.</td>
        </tr>
        <tr>
            <td>priority</td>
            <td>nullable integer</td>
            <td>The priority of the host (for SRV and MX records. <code>null</code> otherwise).</td>
        </tr>
        <tr>
            <td>port</td>
            <td>nullable integer</td>
            <td>The port that the service is accessible on (for SRV records only. <code>null</code> otherwise).</td>
        </tr>
        <tr>
            <td>weight</td>
            <td>nullable integer</td>
            <td>The weight of records with the same priority. (for SRV records only.  <code>null</code> otherwise).</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/domains/example.com/records/10" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 572e6198f1abb6f7963916c52bb8e69c556243031ae61da3701cf25f653d0117
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588871
Content-Length: 163
      ```

  
    - Body

      ```json
      {
  "domain_record": {
    "id": 10,
    "type": "CNAME",
    "name": "example",
    "data": "@",
    "priority": null,
    "port": null,
    "weight": null
  }
}
      ```
  

### Domain Records Delete a Domain Record [DELETE]

<p>To delete a record for a domain, send a DELETE request to <code>/v2/domains/$DOMAIN_NAME/records/$RECORD_ID</code>.</p>

<p>The record will be deleted and the response status will be a 204.  This indicates a successful request with no body returned.</p>


**Example:**

  - **cURL**

    ```bash
    curl -X DELETE "https://api.digitalocean.com/v2/domains/example.com/records/21" \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 06ab00ff2ca73e0d76186b88b4e0273838264038fcdf54cca501d70d4b124444
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588872
      ```

  

### Domain Records Update a Domain Record [PUT]

<p>To update an existing record, send a PUT request to <code>/v2/domains/$DOMAIN_NAME/records/$RECORD_ID</code>.  Set the "name" attribute to the new for the record.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>Set this to the new name you want for your record.</td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>domain_record</code>.  The value of this will be a domain record object which contains the standard domain record attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>The unique id for the record.</td>
        </tr>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>The DNS record type (A, MX, CNAME, etc).</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The host name, alias, or service being defined by the record.  See the [domain record] object for more info.</td>
        </tr>
        <tr>
            <td>data</td>
            <td>string</td>
            <td>Variable data depending on record type.  See the [domain records] object for more detail on each record type.</td>
        </tr>
        <tr>
            <td>priority</td>
            <td>nullable integer</td>
            <td>The priority of the host (for SRV and MX records. <code>null</code> otherwise).</td>
        </tr>
        <tr>
            <td>port</td>
            <td>nullable integer</td>
            <td>The port that the service is accessible on (for SRV records only. <code>null</code> otherwise).</td>
        </tr>
        <tr>
            <td>weight</td>
            <td>nullable integer</td>
            <td>The weight of records with the same priority (for SRV records only.  <code>null</code> otherwise).</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>name</strong></td>
      <td>New name</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X PUT "https://api.digitalocean.com/v2/domains/example.com/records/26" \
	-d '{"name":"new_name"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 9027a938286bf0c078d85f5c840bfd79829cc90b902ff62658ecc51aeda90dd1
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "name": "new_name"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588872
Content-Length: 164
      ```

  
    - Body

      ```json
      {
  "domain_record": {
    "id": 26,
    "type": "CNAME",
    "name": "new_name",
    "data": "@",
    "priority": null,
    "port": null,
    "weight": null
  }
}
      ```
  
# Domains


<p>Domain resources are domain names that you have purchased from a domain name registrar that you are managing through the DigitalOcean DNS interface.</p>

<p>This resource establishes top-level control over each domain.  Actions that affect individual domain records should be taken on the [Domain Records] resource.</p>


<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Type</th>
      <th>Description</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>name</strong></td>
      <td><em>string</em></td>
      <td>The name of the domain itself.  This should follow the standard domain format of `domain.TLD`.  For instance, `example.com` is a valid domain name.</td>
      <td><code>example.com</code></td>
    </tr>
    <tr>
      <td><strong>ttl</strong></td>
      <td><em>integer</em></td>
      <td>This value is the time to live for the records on this domain, in seconds.  This defines the time frame that clients can cache queried information before a refresh should be requested.</td>
      <td><code>1800</code></td>
    </tr>
    <tr>
      <td><strong>zone_file</strong></td>
      <td><em>string</em></td>
      <td>This attribute contains the complete contents of the zone file for the selected domain.  Individual domain record resources should be used to get more granular control over records.  However, this attribute can also be used to get information about the SOA record, which is created automatically and is not accessible as an individual record resource.</td>
      <td><code>$TTL\t600\n@\t\tIN\tSOA ...</code></td>
    </tr>
  </tbody>
</table>

## Domains Collection [/v2/domains]

### Domains List all Domains [GET]

<p>To retrieve a list of all of the domains in your account, send a GET request to <code>/v2/domains</code>.</p>

<p>The response will be a JSON object with a key called <code>domains</code>.  The value of this will be an array of Domain objects, each of which contain the standard domain attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The name of the domain name itself.  The string should be in the form of <code>domain.TLD</code>.  For instance, <code>example.com</code> is a valid domain value.</td>
        </tr>
        <tr>
            <td>ttl</td>
            <td>integer</td>
            <td>This value is the time to live for the records on this domain, in seconds.  This defines the time frame that clients can cache queried information before a refresh should be requested.</td>
        </tr>
        <tr>
            <td>zone_file</td>
            <td>string</td>
            <td>This attribute contains the complete contents of the zone file for the selected domain.  Most individual domain records can be accessed through the <code>/v2/domains/$DOMAIN_NAME/records</code> endpoint.  However, the SOA record for the domain is only available through the <code>zone_file</code>.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/domains" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 58b9519cfd1b6e4d87e519ede229d9d98b0b47cd12508d61f30b38f20628c43e
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588872
Total: 1
Content-Length: 130
      ```

  
    - Body

      ```json
      {
  "domains": [
    {
      "name": "example.com",
      "ttl": 1800,
      "zone_file": "Example zone file text..."
    }
  ]
}
      ```
  

### Domains Create a new Domain [POST]

<p>To create a new domain, send a POST request to <code>/v2/domains</code>.  Set the "name" attribute to the domain name you are adding.  Set the "ip_address" attribute to the IP address you want to point the domain to.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The domain name to add to the DigitalOcean DNS management interface.  The name must be unique in DigitalOcean's DNS system.  The request will fail if the name has already been taken.</td>
            <td>true</td>
        </tr>
        <tr>
            <td>ip_address</td>
            <td>string</td>
            <td>This attribute contains the IP address you want the domain to point to.</td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>domain</code>.  The value of this will be an object that contains the standard attributes associated with a domain:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The name of the domain name itself.  The string should be in the form of <code>domain.TLD</code>.  For instance, <code>example.com</code> is a valid domain value.</td>
        </tr>
        <tr>
            <td>ttl</td>
            <td>integer</td>
            <td>This value is the time to live for the records on this domain, in seconds.  This defines the time frame that clients can cache queried information before a refresh should be requested.</td>
        </tr>
        <tr>
            <td>zone_file</td>
            <td>string</td>
            <td>This attribute contains the complete contents of the zone file for the selected domain.  Most individual domain records can be accessed through the <code>/v2/domains/$DOMAIN_NAME/records</code> endpoint.  However, the SOA record for the domain is only available through the <code>zone_file</code>.</td>
        </tr>
    </tbody>
</table>


<p>Keep in mind that, upon creation, the <code>zone_file</code> field will have a value of <code>null</code> until a zone file is generated and propagated through an automatic process on the DigitalOcean servers.</p>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>name</strong></td>
      <td>Name of the domain</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>ip_address</strong></td>
      <td>IP Address for the www entry.</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/domains" \
	-d '{"name":"example.com","ip_address":"127.0.0.1"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer ac2bf0c51a2b8ed10a4a5eebecb550ffd1222e39f6181ebae167a1aa5a68d321
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "name": "example.com",
  "ip_address": "127.0.0.1"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588872
Content-Length: 88
      ```

  
    - Body

      ```json
      {
  "domain": {
    "name": "example.com",
    "ttl": 1800,
    "zone_file": null
  }
}
      ```
  

## Domains Member [/v2/domains/{domain_name}]

### Domains Retrieve an existing Domain [GET]

<p>To get details about a specific domain, send a GET request to <code>/v2/domains/$DOMAIN_NAME</code>. </p>

<p>The response will be a JSON object with a key called <code>domain</code>.  The value of this will be an object that contains the standard attributes defined for a domain:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The name of the domain name itself.  The string should be in the form of <code>domain.TLD</code>.  For instance, <code>example.com</code> is a valid domain value.</td>
        </tr>
        <tr>
            <td>ttl</td>
            <td>integer</td>
            <td>This value is the time to live for the records on this domain, in seconds.  This defines the time frame that clients can cache queried information before a refresh should be requested.</td>
        </tr>
        <tr>
            <td>zone_file</td>
            <td>string</td>
            <td>This attribute contains the complete contents of the zone file for the selected domain.  Most individual domain records can be accessed through the <code>/v2/domains/$DOMAIN_NAME/records</code> endpoint.  However, the SOA record for the domain is only available through the <code>zone_file</code>.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/domains/example.com" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 057f76073a446c2efda15b67bfd525d32371e6858fa105eff9e9c53c4edefc30
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588872
Content-Length: 111
      ```

  
    - Body

      ```json
      {
  "domain": {
    "name": "example.com",
    "ttl": 1800,
    "zone_file": "Example zone file text..."
  }
}
      ```
  

### Domains Delete a Domain [DELETE]

<p>To delete a domain, send a DELETE request to <code>/v2/domains/$DOMAIN_NAME</code>.</p>

<p>The domain will be removed from your account and a response status of 204 will be returned.  This indicates a successful request with no response body.</p>


**Example:**

  - **cURL**

    ```bash
    curl -X DELETE "https://api.digitalocean.com/v2/domains/example.com" \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 24514d1ede69b8349b5dfce2b0aa03b9ff8ad664be38946ce9f21d98ff0a7199
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588872
      ```

  
# Droplet Actions


<p>Droplet actions are tasks that can be executed on a Droplet.  These can be things like rebooting, resizing, snapshotting, etc.</p>

<p>Droplet action requests are generally targeted at the "actions" endpoint for a specific Droplet.  The specific actions are usually initiated by sending a POST request with the action and arguments as parameters.</p>

<p>Droplet actions themselves create a Droplet actions object.  These can be used to get information about the status of an action.</p>


<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Type</th>
      <th>Description</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>id</strong></td>
      <td><em>integer</em></td>
      <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>status</strong></td>
      <td><em>string</em></td>
      <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
      <td><code>in-progress</code></td>
    </tr>
    <tr>
      <td><strong>type</strong></td>
      <td><em>string</em></td>
      <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
      <td><code>reboot</code></td>
    </tr>
    <tr>
      <td><strong>started_at</strong></td>
      <td><em>integer</em></td>
      <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
      <td><code>2014-05-08T19:11:41Z</code></td>
    </tr>
    <tr>
      <td><strong>completed_at</strong></td>
      <td><em>integer</em></td>
      <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
      <td><code>2014-05-08T19:11:41Z</code></td>
    </tr>
    <tr>
      <td><strong>resource_id</strong></td>
      <td><em>integer</em></td>
      <td>A unique identifier for the resource that the action is associated with.</td>
      <td><code>2014-05-08T19:11:41Z</code></td>
    </tr>
    <tr>
      <td><strong>resource_type</strong></td>
      <td><em>string</em></td>
      <td>The type of resource that the action is associated with.</td>
      <td><code>2014-05-08T19:11:41Z</code></td>
    </tr>
  </tbody>
</table>

## Droplet Actions Collection [/v2/droplets/{droplet_id}/actions]

### Droplet Actions Reboot a Droplet [POST]

<p>To reboot a Droplet, send a POST request to <code>/v2/droplets/$DROPLET_ID/actions</code>.  Set the "type" attribute to <code>reboot</code>.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>Must be <code>reboot</code></td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>action</code>.  The value will be a Droplet actions object:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>Integer</td>
            <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>type</strong></td>
      <td>reboot</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/droplets/4/actions" \
	-d '{"type":"reboot"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer df2220945b7518b0b8f46c152b737961276e1c42d887dd435cd21e3f23ef8ff6
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "reboot"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588873
Content-Length: 207
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 4,
    "status": "in-progress",
    "type": "reboot",
    "started_at": "2014-06-12T15:01:13Z",
    "completed_at": null,
    "resource_id": 4,
    "resource_type": "droplet"
  }
}
      ```
  

### Droplet Actions Power Cycle a Droplet [POST]

<p>To power cycle a Droplet (power off and then back on), send a POST request to <code>/v2/droplets/$DROPLET_ID/actions</code>.  Set the "type" attribute to <code>power_cycle</code>.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>Must be <code>power_cycle</code></td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>action</code>.  The value will be a Droplet actions object:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>Integer</td>
            <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>type</strong></td>
      <td>power_cycle</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/droplets/5/actions" \
	-d '{"type":"power_cycle"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 68f699d138ea5ef61aa899305ea18396db99e26c80a7010d360f584378d6edcc
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "power_cycle"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588873
Content-Length: 212
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 5,
    "status": "in-progress",
    "type": "power_cycle",
    "started_at": "2014-06-12T15:01:13Z",
    "completed_at": null,
    "resource_id": 5,
    "resource_type": "droplet"
  }
}
      ```
  

### Droplet Actions Shutdown a Droplet [POST]

<p>To shutdown a Droplet, send a POST request to <code>/v2/droplets/$DROPLET_ID/actions</code>.  Set the "type" attribute to <code>shutdown</code>.</p>

<p>A shutdown action is an attempt to shutdown the Droplet in a graceful way, similar to using the <code>shutdown</code> command from the console.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>Must be <code>shutdown</code>.</td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>action</code>.  The value will be a Droplet actions object:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>Integer</td>
            <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>type</strong></td>
      <td>shutdown</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/droplets/6/actions" \
	-d '{"type":"shutdown"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 3804f496068f986ab77a7f6921fa6def8f16384dfd8b048bc2e51d9166e940ef
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "shutdown"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588873
Content-Length: 209
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 6,
    "status": "in-progress",
    "type": "shutdown",
    "started_at": "2014-06-12T15:01:13Z",
    "completed_at": null,
    "resource_id": 6,
    "resource_type": "droplet"
  }
}
      ```
  

### Droplet Actions Power Off a Droplet [POST]

<p>To power off a Droplet, send a POST request to <code>/v2/droplets/$DROPLET_ID/actions</code>.  Set the "type" attribute to <code>power_off</code>.</p>

<p>A <code>power_off</code> event is a hard shutdown and should only be used if the <code>shutdown</code> action is not successful.  It is similar to cutting the power on a server and could lead to complications.</p>

<p>The request should contain the following attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>Must be <code>powered_off</code></td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>action</code>.  The value will be a Droplet actions object:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>Integer</td>
            <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>type</strong></td>
      <td>power_off</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/droplets/7/actions" \
	-d '{"type":"power_off"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 7bff2fb273aac1812684e2604ea1e8dd88f304e67bd750fdf9015f4753ce029b
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "power_off"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588873
Content-Length: 210
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 7,
    "status": "in-progress",
    "type": "power_off",
    "started_at": "2014-06-12T15:01:13Z",
    "completed_at": null,
    "resource_id": 7,
    "resource_type": "droplet"
  }
}
      ```
  

### Droplet Actions Power On a Droplet [POST]

<p>To power on a Droplet, send a POST request to <code>/v2/droplets/$DROPLET_ID/actions</code>.  Set the "type" attribute to <code>power_on</code>.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>Must be <code>power_on</code></td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>action</code>.  The value will be a Droplet actions object:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>Integer</td>
            <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>type</strong></td>
      <td>power_on</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/droplets/8/actions" \
	-d '{"type":"power_on"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer d4844ddf8fe640872fb03a4b89e95c62a96ebcbeaac12c74878aaeaf6753d12f
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "power_on"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588873
Content-Length: 209
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 8,
    "status": "in-progress",
    "type": "power_on",
    "started_at": "2014-06-12T15:01:14Z",
    "completed_at": null,
    "resource_id": 8,
    "resource_type": "droplet"
  }
}
      ```
  

### Droplet Actions Password Reset a Droplet [POST]

<p>To reset the password for a Droplet, send a POST request to <code>/v2/droplets/$DROPLET_ID/actions</code>.  Set the "type" attribute to <code>password_reset</code>.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>Must be <code>password_reset</code></td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>action</code>.  The value will be a Droplet actions object:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>Integer</td>
            <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>type</strong></td>
      <td>password_reset</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/droplets/9/actions" \
	-d '{"type":"password_reset"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 708a706b1501f865e4a2006a6d4be0b3b9f22996093dad1936fa4aea7dae2058
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "password_reset"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588874
Content-Length: 215
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 9,
    "status": "in-progress",
    "type": "password_reset",
    "started_at": "2014-06-12T15:01:14Z",
    "completed_at": null,
    "resource_id": 9,
    "resource_type": "droplet"
  }
}
      ```
  

### Droplet Actions Resize a Droplet [POST]

<p>To resize a Droplet, send a POST request to <code>/v2/droplets/$DROPLET_ID/actions</code>.  Set the "type" attribute to <code>resize</code> and the "size" attribute to a sizes slug.</p>

<p>The Droplet must be powered off prior to resizing.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>Must be <code>resize</code>.</td>
            <td>true</td>
        </tr>
        <tr>
            <td>size</td>
            <td>string</td>
            <td>The size slug that you want to resize to.</td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>action</code>.  The value will be a Droplet actions object:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>Integer</td>
            <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>type</strong></td>
      <td>resize</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>size</strong></td>
      <td>the desired size slug</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/droplets/10/actions" \
	-d '{"type":"resize","size":"1024mb"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 817d270a2aa8187b2da1e17d621f176d5eff6a019d20fddf65347a9a143ff9c3
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "resize",
  "size": "1024mb"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588874
Content-Length: 209
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 10,
    "status": "in-progress",
    "type": "resize",
    "started_at": "2014-06-12T15:01:14Z",
    "completed_at": null,
    "resource_id": 10,
    "resource_type": "droplet"
  }
}
      ```
  

### Droplet Actions Restore a Droplet [POST]

<p>To restore a Droplet, send a POST request to <code>/v2/droplets/$DROPLET_ID/actions</code>.  Set the "type" attribute to <code>restore</code> and the "image" attribute to an image ID.</p>

<p>A Droplet restoration will rebuild an image using a backup image.  The image ID that is passed in must be a backup of the current Droplet instance.  The operation will leave any embedded SSH keys intact.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>Must be <code>restore</code>.</td>
            <td>true</td>
        </tr>
        <tr>
            <td>image</td>
            <td>integer</td>
            <td>The image ID of the backup image that you would like to restore.</td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>action</code>.  The value will be a Droplet actions object:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>Integer</td>
            <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>type</strong></td>
      <td>restore</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>image</strong></td>
      <td>the desired image identifier</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/droplets/11/actions" \
	-d '{"type":"restore","image":119192829}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 4de420ff885bf6c8fc093ae5350e0b0c67b94a2f2091f8aaf1e45f064d9e46ff
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "restore",
  "image": 119192829
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588874
Content-Length: 210
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 11,
    "status": "in-progress",
    "type": "restore",
    "started_at": "2014-06-12T15:01:14Z",
    "completed_at": null,
    "resource_id": 11,
    "resource_type": "droplet"
  }
}
      ```
  

### Droplet Actions Rebuild a Droplet [POST]

<p>To rebuild a Droplet, send a POST request to <code>/v2/droplets/$DROPLET_ID/actions</code>.  Set the "type" attribute to <code>rebuild</code> and the "image" attribute to an image ID or slug.</p>

<p>A rebuild action functions just like a new create.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>Must be <code>rebuild</code></td>
            <td>true</td>
        </tr>
        <tr>
            <td>image</td>
            <td>string if an image slug. integer if an image ID.</td>
            <td>An image slug or ID.  This represents the image that the Droplet will use as a base.</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>action</code>.  The value will be a Droplet actions object:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>Integer</td>
            <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>type</strong></td>
      <td>rebuild</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>image</strong></td>
      <td>the desired image identifier</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/droplets/12/actions" \
	-d '{"type":"rebuild","image":119192831}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer ea91ed4ce5569d8e4a352b509341487cd35a4005a2b46eaa6739109ae72ce065
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "rebuild",
  "image": 119192831
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588874
Content-Length: 210
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 12,
    "status": "in-progress",
    "type": "rebuild",
    "started_at": "2014-06-12T15:01:14Z",
    "completed_at": null,
    "resource_id": 12,
    "resource_type": "droplet"
  }
}
      ```
  

### Droplet Actions Rename a Droplet [POST]

<p>To rename a Droplet, send a POST request to <code>/v2/droplets/$DROPLET_ID/actions</code>.  Set the "type" attribute to <code>rename</code> and the "name" attribute to the new name for the droplet.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>Must be <code>rename</code></td>
            <td>true</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The new name for the Droplet.</td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>action</code>.  The value will be a Droplet actions object:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>Integer</td>
            <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>type</strong></td>
      <td>rename</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>name</strong></td>
      <td>the desired name</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/droplets/13/actions" \
	-d '{"type":"rename","name":"Droplet-Name"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 2dc446eaefe467bd0536e38e14b40abd1a05b2b352b5f68ac6cd2688ee556b07
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "rename",
  "name": "Droplet-Name"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588874
Content-Length: 209
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 13,
    "status": "in-progress",
    "type": "rename",
    "started_at": "2014-06-12T15:01:14Z",
    "completed_at": null,
    "resource_id": 13,
    "resource_type": "droplet"
  }
}
      ```
  

## Droplet Actions Member [/v2/droplets/{droplet_id}/actions/{droplet_action_id}]

### Droplet Actions Retrieve a Droplet Action [GET]

<p>To retrieve a Droplet action, send a GET request to <code>/v2/droplets/$DROPLET_ID/actions/$ACTION_ID</code>.</p>

<p>The response will be a JSON object with a key called <code>action</code>.  The value will be a Droplet actions object:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>Integer</td>
            <td>A unique identifier for each Droplet action event.  This is used to reference a specific action that was requested.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>The current status of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/droplets/3/actions/3" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer b8327ca47222f4995cc01377d551ae67f8610eedfdbf67485519971d6046daa2
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588873
Content-Length: 205
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 3,
    "status": "in-progress",
    "type": "create",
    "started_at": "2014-06-12T15:01:13Z",
    "completed_at": null,
    "resource_id": null,
    "resource_type": null
  }
}
      ```
  
# Droplets


<p>A Droplet is a DigitalOcean virtual machine.  By sending requests to the Droplet endpoint, you can list, create, or delete Droplets.</p>

<p>Some of the attributes will have an object value.  The <code>region</code>, <code>image</code>, and <code>size</code> objects will all contain the standard attributes of their associated types.  Find more information about each of these objects in their respective sections.</p>


<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Type</th>
      <th>Description</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>id</strong></td>
      <td><em>integer</em></td>
      <td>A unique identifier for each Droplet instance.  This is automatically generated upon Droplet creation.</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>name</strong></td>
      <td><em>string</em></td>
      <td>The human-readable name set for the Droplet instance.</td>
      <td><code>my-droplet</code></td>
    </tr>
    <tr>
      <td><strong>region</strong></td>
      <td><em>object</em></td>
      <td>The region that the Droplet instance is deployed in.  When setting a region, the value should be the slug identifier for the region.  When you query a Droplet, the entire region object will be returned.</td>
      <td><code>{"slug":"nyc1","name":"New York","sizes":["1024mb","512mb"],"available":true}</code></td>
    </tr>
    <tr>
      <td><strong>image</strong></td>
      <td><em>object</em></td>
      <td>The base image used to create the Droplet instance.  When setting an image, the value is set to the image id or slug.  When querying the Droplet, the entire image object will be returned.</td>
      <td><code>{"id":119192818,"name":"Ubuntu 13.04","distribution":"ubuntu","slug":null,"public":true,"regions":["nyc1"]}</code></td>
    </tr>
    <tr>
      <td><strong>size</strong></td>
      <td><em>object</em></td>
      <td>The size of the Droplet instance.  When setting a size, the value should be the slug identifier for a particular size.  When querying the Droplet, the entire size object will be returned.</td>
      <td><code>{"slug":"512mb","memory":512,"vcpus":1,"disk":20,"transfer":null,"price_monthly":"5.0","price_hourly":"0.00744","regions":["nyc1","sfo1","ams4"]}</code></td>
    </tr>
    <tr>
      <td><strong>locked</strong></td>
      <td><em>boolean</em></td>
      <td>A boolean value indicating whether the Droplet has been locked, preventing actions by users.</td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><strong>status</strong></td>
      <td><em>string</em></td>
      <td>A status string indicating the state of the Droplet instance.  This may be "new", "active", or "archive".</td>
      <td><code>online</code></td>
    </tr>
    <tr>
      <td><strong>networks</strong></td>
      <td><em>object</em></td>
      <td>The details of the network that are configured for the Droplet instance.  This is an object that contains keys for IPv4 and IPv6.  The value of each of these is an array that contains objects describing an individual IP resource allocated to the Droplet.  These will define attributes like the IP address, netmask, and gateway of the specific network depending on the type of network it is.</td>
      <td><code>{"v4":[{"ip_address":"127.0.0.2","netmask":"255.255.255.0","gateway":"127.0.0.1","type":"public"}],"v6":[]}</code></td>
    </tr>
    <tr>
      <td><strong>backups</strong></td>
      <td><em>array</em></td>
      <td>An array of backup IDs of any backups that have been taken of the Droplet instance.  Droplet backups are enabled at the time of the instance creation.</td>
      <td><code>[123, 456, 789]</code></td>
    </tr>
    <tr>
      <td><strong>snapshots</strong></td>
      <td><em>array</em></td>
      <td>An array of snapshot IDs of any snapshots created from the Droplet instance.</td>
      <td><code>[123, 456, 789]</code></td>
    </tr>
    <tr>
      <td><strong>action_ids</strong></td>
      <td><em>array</em></td>
      <td>An array of action IDs of any actions that have been taken on this Droplet.</td>
      <td><code>[123, 456, 789]</code></td>
    </tr>
  </tbody>
</table>

## Droplets Collection [/v2/droplets]

### Droplets List all Droplets [GET]

<p>To list all Droplets in your account, send a GET request to <code>/v2/droplets</code>.</p>


<p>The response body will be a JSON object with a key of <code>droplets</code>.  This will be set to an array containing objects representing each Droplet. These will contain the standard Droplet attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique identifier for each Droplet.  This is automatically generated upon Droplet creation.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>A human-readable name set for the Droplet instance.</td>
        </tr>
        <tr>
            <td>region</td>
            <td>object</td>
            <td>The region that the Droplet instance is deployed in.  The entire region object is returned.</td>
        </tr>
        <tr>
            <td>image</td>
            <td>object</td>
            <td>The base image used to create the Droplet instance.  The entire image object is returned.</td>
        </tr>
        <tr>
            <td>size</td>
            <td>object</td>
            <td>The size of the Droplet instance.  The entire size object is returned.</td>
        </tr>
        <tr>
            <td>locked</td>
            <td>boolean</td>
            <td>A boolean value indicating whether the Droplet has been locked, preventing actions by users.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>string</td>
            <td>A string indicating the state of the Droplet instance.  This may be "new", "active", or "archive".</td>
        </tr>
        <tr>
            <td>networks</td>
            <td>array</td>
            <td>The details of the networks configured for the Droplet.  This is an object containing arrays for each of the separate networks.  Each array defines the IP address and the network details (netmask, gateway, public or private, etc.) of the specific network.</td>
        </tr>
        <tr>
            <td>backups</td>
            <td>array</td>
            <td>An array of backup IDs of any backups that have been taken of the Droplet.</td>
        </tr>
        <tr>
            <td>snapshots</td>
            <td>array</td>
            <td>An array of snapshot IDs of any snapshots created from the Droplet.</td>
        </tr>
        <tr>
            <td>action_ids</td>
            <td>array</td>
            <td>An array of action IDs of any actions that have been taken on this Droplet.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/droplets" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 57e92a36fc88afe4c210416b394c4007672113fa190982c8a694b7a1c0f6aabc
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588875
Total: 1
Content-Length: 1431
      ```

  
    - Body

      ```json
      {
  "droplets": [
    {
      "id": 14,
      "name": "test.example.com",
      "region": {
        "slug": "nyc1",
        "name": "New York",
        "sizes": [
          "1024mb",
          "512mb"
        ],
        "available": true
      },
      "image": {
        "id": 119192817,
        "name": "Ubuntu 13.04",
        "distribution": "ubuntu",
        "slug": "ubuntu1304",
        "public": true,
        "regions": [
          "nyc1"
        ]
      },
      "size": {
        "slug": "512mb",
        "memory": 512,
        "vcpus": 1,
        "disk": 20,
        "transfer": null,
        "price_monthly": "5.0",
        "price_hourly": "0.00744",
        "regions": [
          "nyc1",
          "lon1",
          "sfo1",
          "ams1"
        ]
      },
      "locked": false,
      "status": "active",
      "networks": {
        "v4": [
          {
            "ip_address": "127.0.0.1",
            "netmask": "255.255.255.0",
            "gateway": "127.0.0.2",
            "type": "public"
          }

        ],
        "v6": [
          {
            "ip_address": "2400:6180:0000:00D0:0000:0000:0009:7001",
            "cidr": 124,
            "gateway": "2400:6180:0000:00D0:0000:0000:0009:7000",
            "type": "public"
          }

        ]
      },
      "backup_ids": [
        119192833
      ],
      "snapshot_ids": [
        119192834
      ],
      "action_ids": [

      ]
    }
  ]
}
      ```
  

### Droplets Retrieve snapshots for a Droplet [GET]

<p>To retrieve the snapshots that have been created from a Droplet, sent a GET request to <code>/v2/droplets/$DROPLET_ID/snapshots</code>.</p>

<p>You will get back a JSON object that has a <code>snapshots</code> key.  This will be set to an array of snapshot objects, each of which contain the standard image attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique integer used to identify and reference a specific image.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The display name of the image.  This is shown in the web UI and is generally a descriptive title for the image in question.</td>
        </tr>
        <tr>
            <td>distribution</td>
            <td>string</td>
            <td>The base distribution used for this image.</td>
        </tr>
        <tr>
            <td>slug</td>
            <td>nullable string</td>
            <td>A uniquely identifying string that is associated with each of the DigitalOcean-provided public images.  These can be used to reference a public image as an alternative to the numeric id.</td>
        </tr>
        <tr>
            <td>public</td>
            <td>boolean</td>
            <td>A boolean value that indicates whether the image in question is public.  An image that is public is available to all accounts.  A non-public image is only accessible from your account.</td>
        </tr>
        <tr>
            <td>regions</td>
            <td>array</td>
            <td>An array of the regions that the image is available in.  The regions are represented by their identifying slug values.</td>
        </tr>
        <tr>
            <td>action_ids</td>
            <td>array</td>
            <td>An array of action IDs of any actions that have been taken on this image.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/droplets/16/snapshots" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer d427cab5e4f8f030ca4287c0850f24cb061506ff6e1a6b22b1ad6aad92833e07
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588875
Total: 1
Content-Length: 207
      ```

  
    - Body

      ```json
      {
  "snapshots": [
    {
      "id": 119192837,
      "name": "Ubuntu 13.04",
      "distribution": "ubuntu",
      "slug": null,
      "public": false,
      "regions": [
        "nyc1"
      ]
    }
  ]
}
      ```
  

### Droplets Retrieve backups for a Droplet [GET]

<p>To retrieve any backups associated with a Droplet, sent a GET request to <code>/v2/droplets/$DROPLET_ID/backups</code>.</p>

<p>You will get back a JSON object that has a <code>backups</code> key.  This will be set to an array of backup objects, each of which contain the standard image attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique integer used to identify and reference a specific image.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The display name of the image.  This is shown in the web UI and is generally a descriptive title for the image in question.</td>
        </tr>
        <tr>
            <td>distribution</td>
            <td>string</td>
            <td>The base distribution used for this image.</td>
        </tr>
        <tr>
            <td>slug</td>
            <td>nullable string</td>
            <td>A uniquely identifying string that is associated with each of the DigitalOcean-provided public images.  These can be used to reference a public image as an alternative to the numeric id.</td>
        </tr>
        <tr>
            <td>public</td>
            <td>boolean</td>
            <td>A boolean value that indicates whether the image in question is public.  An image that is public is available to all accounts.  A non-public image is only accessible from your account.</td>
        </tr>
        <tr>
            <td>regions</td>
            <td>array</td>
            <td>An array of the regions that the image is available in.  The regions are represented by their identifying slug values.</td>
        </tr>
        <tr>
            <td>action_ids</td>
            <td>array</td>
            <td>An array of action IDs of any actions that have been taken on this image.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/droplets/17/backups" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 03eeef35edc6bcf2c43cb0e16b305c14216ce7b42f8883a14084f642171ae079
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588875
Total: 1
Content-Length: 205
      ```

  
    - Body

      ```json
      {
  "backups": [
    {
      "id": 119192838,
      "name": "Ubuntu 13.04",
      "distribution": "ubuntu",
      "slug": null,
      "public": false,
      "regions": [
        "nyc1"
      ]
    }
  ]
}
      ```
  

### Droplets Create a new Droplet [POST]

<p>To create a new Droplet, send a POST request to <code>/v2/droplets</code>.</p>

<p>The attribute values that must be set to successfully create a Droplet are:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>name</td>
            <td>String</td>
            <td>The human-readable string you wish to use when displaying the Droplet name.  The name, if set to a domain name managed in the DigitalOcean DNS management system, will configure a PTR record for the Droplet.  The name set during creation will also determine the hostname for the Droplet in its internal configuration.</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>region</td>
            <td>String</td>
            <td>The unique slug identifier for the region that you wish to deploy in.</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>size</td>
            <td>String</td>
            <td>The unique slug identifier for the size that you wish to select for this Droplet.</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>image</td>
            <td>Integer (if using an image ID), or String (if using a public image slug)</td>
            <td>The image ID of a public or private image, or the unique slug identifier for a public image.  This image will be the base image for your Droplet.</td>
            <td>Yes</td>
        </tr> <tr>
            <td>ssh_keys</td>
            <td>Array</td>
            <td>An array containing the IDs or fingerprints of the SSH keys that you wish to embed in the Droplet's root account upon creation.</td>
            <td>No</td>
        </tr>
        <tr>
            <td>backups</td>
            <td>Boolean</td>
            <td>A boolean indicating whether automated backups should be enabled for the Droplet.  Automated backups can only be enabled when the Droplet is created.</td>
            <td>No</td>
        </tr>
        <tr>
            <td>ipv6</td>
            <td>Boolean</td>
            <td>A boolean indicating whether IPv6 is enabled on the Droplet.</td>
            <td>No</td>
        </tr>
        <tr>
            <td>private_networking</td>
            <td>Boolean</td>
            <td>A boolean indicating whether private networking is enabled for the Droplet.  Private networking is currently only available in certain regions.</td>
            <td>No</td>
        </tr>
    </tbody>
</table>

<p>A Droplet will be created using the provided information.  The response body will contain a JSON object with a key called <code>droplet</code>.  The value will be an object containing the standard attributes for your new Droplet:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique identifier for each Droplet.  This is automatically generated upon Droplet creation.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>A human-readable name set for the Droplet instance.</td>
        </tr>
        <tr>
            <td>region</td>
            <td>object</td>
            <td>The region that the Droplet instance is deployed in.  The entire region object is returned.</td>
        </tr>
        <tr>
            <td>image</td>
            <td>object</td>
            <td>The base image used to create the Droplet instance.  The entire image object is returned.</td>
        </tr>
        <tr>
            <td>size</td>
            <td>object</td>
            <td>The size of the Droplet instance.  The entire size object is returned.</td>
        </tr>
        <tr>
            <td>locked</td>
            <td>boolean</td>
            <td>A boolean value indicating whether the Droplet has been locked, preventing actions by users.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>string</td>
            <td>A string indicating the state of the Droplet instance.  This may be "new", "active", or "archive".</td>
        </tr>
        <tr>
            <td>networks</td>
            <td>array</td>
            <td>The details of the networks configured for the Droplet.  This is an object containing arrays for each of the separate networks.  Each array defines the IP address and the network details (netmask, gateway, public or private, etc.) of the specific network.</td>
        </tr>
        <tr>
            <td>backups</td>
            <td>array</td>
            <td>An array of backup IDs of any backups that have been taken of the Droplet.</td>
        </tr>
        <tr>
            <td>snapshots</td>
            <td>array</td>
            <td>An array of snapshot IDs of any snapshots created from the Droplet.</td>
        </tr>
        <tr>
            <td>action_ids</td>
            <td>array</td>
            <td>An array of action IDs of any actions that have been taken on this Droplet.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>name</strong></td>
      <td>User assigned identifier</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>region</strong></td>
      <td>Slug of the desired Region</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>size</strong></td>
      <td>Slug of the desired Size</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>image</strong></td>
      <td>ID or Slug(public images only) of the desired Image</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>ssh_keys</strong></td>
      <td>An array of ssh key or fingerprints</td>
      <td>false</td>
    </tr>
  
    <tr>
      <td><strong>backups</strong></td>
      <td>Boolean field for enabling automatic backups</td>
      <td>false</td>
    </tr>
  
    <tr>
      <td><strong>ipv6</strong></td>
      <td>Boolean field for enabling ipv6 support</td>
      <td>false</td>
    </tr>
  
    <tr>
      <td><strong>private_networking</strong></td>
      <td>Boolean field for enabling private networking</td>
      <td>false</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/droplets" \
	-d '{"name":"My-Droplet","region":"nyc1","size":"512mb","image":119192839}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer f01a7956a9cbe5f73159866344e79db2e4057e61464fc37004b25e31baaef7a4
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "name": "My-Droplet",
  "region": "nyc1",
  "size": "512mb",
  "image": 119192839
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588875
Link: <http://example.org/v2/droplets/18/actions/14>; rel="monitor"
Content-Length: 847
      ```

  
    - Body

      ```json
      {
  "droplet": {
    "id": 18,
    "name": "My-Droplet",
    "region": {
      "slug": "nyc1",
      "name": "New York",
      "sizes": [
        "1024mb",
        "512mb"
      ],
      "available": true
    },
    "image": {
      "id": 119192839,
      "name": "Ubuntu 13.04",
      "distribution": "ubuntu",
      "slug": null,
      "public": true,
      "regions": [
        "nyc1"
      ]
    },
    "size": {
      "slug": "512mb",
      "memory": 512,
      "vcpus": 1,
      "disk": 20,
      "transfer": null,
      "price_monthly": "5.0",
      "price_hourly": "0.00744",
      "regions": [
        "nyc1",
        "ams1",
        "sfo1",
        "lon1"
      ]
    },
    "locked": false,
    "status": "new",
    "networks": {
    },
    "backup_ids": [

    ],
    "snapshot_ids": [

    ],
    "action_ids": [
      14
    ]
  }
}
      ```
  

## Droplets Member [/v2/droplets/{droplet_id}]

### Droplets Retrieve an existing Droplet by id [GET]

<p>To show an individual droplet, send a GET request to <code>/v2/droplets/$DROPLET_ID</code>.</p>

<p>The response will be a JSON object with a key called <code>droplet</code>.  This will be set to a JSON object that contains the Droplet's attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique identifier for each Droplet.  This is automatically generated upon Droplet creation.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>A human-readable name set for the Droplet instance.</td>
        </tr>
        <tr>
            <td>region</td>
            <td>object</td>
            <td>The region that the Droplet instance is deployed in.  The entire region object is returned.</td>
        </tr>
        <tr>
            <td>image</td>
            <td>object</td>
            <td>The base image used to create the Droplet instance.  The entire image object is returned.</td>
        </tr>
        <tr>
            <td>size</td>
            <td>object</td>
            <td>The size of the Droplet instance.  The entire size object is returned.</td>
        </tr>
        <tr>
            <td>locked</td>
            <td>boolean</td>
            <td>A boolean value indicating whether the Droplet has been locked, preventing actions by users.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>string</td>
            <td>A string indicating the state of the Droplet instance.  This may be "new", "active", or "archive".</td>
        </tr>
        <tr>
            <td>networks</td>
            <td>array</td>
            <td>The details of the networks configured for the Droplet.  This is an object containing arrays for each of the separate networks.  Each array defines the IP address and the network details (netmask, gateway, public or private, etc.) of the specific network.</td>
        </tr>
        <tr>
            <td>backups</td>
            <td>array</td>
            <td>An array of backup IDs of any backups that have been taken of the Droplet.</td>
        </tr>
        <tr>
            <td>snapshots</td>
            <td>array</td>
            <td>An array of snapshot IDs of any snapshots created from the Droplet.</td>
        </tr>
        <tr>
            <td>action_ids</td>
            <td>array</td>
            <td>An array of action IDs of any actions that have been taken on this Droplet.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/droplets/15" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 9854bb4c0e63212c0b82268e12d2bdd466e2ac1a7a73d3fb763acb7125665c63
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588875
Content-Length: 1290
      ```

  
    - Body

      ```json
      {
  "droplet": {
    "id": 15,
    "name": "test.example.com",
    "region": {
      "slug": "nyc1",
      "name": "New York",
      "sizes": [
        "1024mb",
        "512mb"
      ],
      "available": true
    },
    "image": {
      "id": 119192817,
      "name": "Ubuntu 13.04",
      "distribution": "ubuntu",
      "slug": "ubuntu1304",
      "public": true,
      "regions": [
        "nyc1"
      ]
    },
    "size": {
      "slug": "512mb",
      "memory": 512,
      "vcpus": 1,
      "disk": 20,
      "transfer": null,
      "price_monthly": "5.0",
      "price_hourly": "0.00744",
      "regions": [
        "nyc1",
        "lon1",
        "sfo1",
        "ams1"
      ]
    },
    "locked": false,
    "status": "active",
    "networks": {
      "v4": [
        {
          "ip_address": "127.0.0.2",
          "netmask": "255.255.255.0",
          "gateway": "127.0.0.3",
          "type": "public"
        }

      ],
      "v6": [
        {
          "ip_address": "2400:6180:0000:00D0:0000:0000:0009:7002",
          "cidr": 124,
          "gateway": "2400:6180:0000:00D0:0000:0000:0009:7000",
          "type": "public"
        }

      ]
    },
    "backup_ids": [
      119192835
    ],
    "snapshot_ids": [
      119192836
    ],
    "action_ids": [

    ]
  }
}
      ```
  

### Droplets Delete a Droplet [DELETE]

<p>To delete a Droplet, send a DELETE request to <code>/v2/droplets/$DROPLET_ID</code>.</p>

<p>No response body will be sent back, but the response code will indicate success.  Specifically, the response code will be a 204, which means that the action was successful with no returned body data.</p>


**Example:**

  - **cURL**

    ```bash
    curl -X DELETE "https://api.digitalocean.com/v2/droplets/19" \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer dc1f0ed2c5e84ae2dae6962f16f74a03242d04ddad7d8a48767012922fb576f6
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588876
      ```

  
# Image Actions


<p>Image actions are commands that can be given to a DigitalOcean image.  In general, these requests are made on the <code>actions</code> endpoint of a specific image.</p>

<p>An image action object is returned.  These objects hold the current status of the requested action.</p>


<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Type</th>
      <th>Description</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>id</strong></td>
      <td><em>integer</em></td>
      <td>A unique numeric ID that can be used to identify and reference an image action.</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>status</strong></td>
      <td><em>string</em></td>
      <td>The current status of the image action.  This will be either "in-progress", "completed", or "errored".</td>
      <td><code>in-progress</code></td>
    </tr>
    <tr>
      <td><strong>type</strong></td>
      <td><em>string</em></td>
      <td>This is the type of the image action that the JSON object represents.  For example, this could be "transfer" to represent the state of an image transfer action.</td>
      <td><code>image_transfer</code></td>
    </tr>
    <tr>
      <td><strong>started_at</strong></td>
      <td><em>integer</em></td>
      <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
      <td><code>2014-05-08T19:11:41Z</code></td>
    </tr>
    <tr>
      <td><strong>completed_at</strong></td>
      <td><em>integer</em></td>
      <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
      <td><code>2014-05-08T19:11:41Z</code></td>
    </tr>
    <tr>
      <td><strong>resource_id</strong></td>
      <td><em>integer</em></td>
      <td>A unique identifier for the resource that the action is associated with.</td>
      <td><code>2014-05-08T19:11:41Z</code></td>
    </tr>
    <tr>
      <td><strong>resource_type</strong></td>
      <td><em>string</em></td>
      <td>The type of resource that the action is associated with.</td>
      <td><code>2014-05-08T19:11:41Z</code></td>
    </tr>
  </tbody>
</table>

## Image Actions Collection [/v2/images/{image_id}/actions]

### Image Actions Transfer an Image [POST]

<p>To transfer an image to another region, send a POST request to <code>/v2/images/$IMAGE_ID/actions</code>.  Set the "type" attribute to "transfer" and set "region" attribute to the slug identifier of the region you wish to transfer to.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>Must be <code>resize</code></td>
            <td>true</td>
        </tr>
        <tr>
            <td>region</td>
            <td>string</td>
            <td>The region slug that represents the region target.</td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response will be a JSON object with a key called <code>action</code>.  The value of this will be an object containing the standard image action attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique numeric ID used to identify and reference an image action.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>string</td>
            <td>The current status of the image action.  This will be either "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>This is the type of the image action (transfer, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>type</strong></td>
      <td>transfer</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>region</strong></td>
      <td>the desired region slug</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/images/119192841/actions" \
	-d '{"type":"transfer","region":"sfo1"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 06ada2a47cbd8a2e1bac30703a58640e6a32e364821371929cfce95b2ad0e10f
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "transfer",
  "region": "sfo1"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588876
Content-Length: 213
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 17,
    "status": "in-progress",
    "type": "transfer",
    "started_at": "2014-06-12T15:01:16Z",
    "completed_at": null,
    "resource_id": null,
    "resource_type": "backend"
  }
}
      ```
  

## Image Actions Member [/v2/images/{image_id}/actions/{image_action_id}]

### Image Actions Retrieve an existing Image Action [GET]

<p>To retrieve the status of an image action, send a GET request to <code>/v2/images/$IMAGE_ID/actions/$IMAGE_ACTION_ID</code>.</p>

<p>The response will be an object with a key called <code>action</code>.  The value of this will be an object that contains the standard image action attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique numeric ID used to identify and reference an image action.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>string</td>
            <td>The current status of the image action.  This will be either "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>string</td>
            <td>This is the type of the image action (transfer, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was initiated.</td>
        </tr>
        <tr>
            <td>completed_at</td>
            <td>integer</td>
            <td>A time value given in UTC epoch seconds that represents when the action was completed.</td>
        </tr>
        <tr>
            <td>resource_id</td>
            <td>integer</td>
            <td>A unique identifier for the resource that the action is associated with.</td>
        </tr>
        <tr>
            <td>resource_type</td>
            <td>string</td>
            <td>The type of resource that the action is associated with.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/images/119192840/actions/16" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer e42f54cdc6177fdb40b64f43f1be257c85aeb234e24eb743d2145ad7b231e6fb
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588876
Content-Length: 208
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 16,
    "status": "in-progress",
    "type": "transfer",
    "started_at": "2014-06-12T15:01:16Z",
    "completed_at": null,
    "resource_id": null,
    "resource_type": null
  }
}
      ```
  
# Images


<p>Images in DigitalOcean may refer to one of a few different kinds of objects. </p>

<p>An image may refer to a snapshot that has been taken of a Droplet instance.  It may also mean an image representing an automatic backup of a Droplet.  The third category that it can represent is a public Linux distribution or application image that is used as a base to create Droplets.</p>

<p>To interact with images, you will generally send requests to the images endpoint at <code>/v2/images</code>.</p>


<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Type</th>
      <th>Description</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>id</strong></td>
      <td><em>integer</em></td>
      <td>A unique integer that can be used to identify and reference a specific image.</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>name</strong></td>
      <td><em>string</em></td>
      <td>The display name that has been given to an image.  This is what is shown in the control panel and is generally a descriptive title for the image in question.</td>
      <td><code>my image</code></td>
    </tr>
    <tr>
      <td><strong>distribution</strong></td>
      <td><em>string</em></td>
      <td>This attribute describes the base distribution used for this image.</td>
      <td><code>ubuntu</code></td>
    </tr>
    <tr>
      <td><strong>slug</strong></td>
      <td><em>nullable string</em></td>
      <td>A uniquely identifying string that is associated with each of the DigitalOcean-provided public images.  These can be used to reference a public image as an alternative to the numeric id.</td>
      <td><code>ubuntu12.04</code></td>
    </tr>
    <tr>
      <td><strong>public</strong></td>
      <td><em>boolean</em></td>
      <td>This is a boolean value that indicates whether the image in question is public or not.  An image that is public is available to all accounts.  A non-public image is only accessible from your account.</td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><strong>regions</strong></td>
      <td><em>array</em></td>
      <td>This attribute is an array of the regions that the image is available in.  The regions are represented by their identifying slug values.</td>
      <td><code>["nyc1", "sfo1"]</code></td>
    </tr>
    <tr>
      <td><strong>action_ids</strong></td>
      <td><em>array</em></td>
      <td>An array of action IDs of any actions that have been taken on this image.</td>
      <td><code>[123, 456, 789]</code></td>
    </tr>
  </tbody>
</table>

## Images Collection [/v2/images]

### Images List all Images [GET]

<p>To list all of the images available on your account, send a GET request to <code>/v2/images</code>.</p>

<p>The response will be a JSON object with a key called <code>images</code>.  This will be set to an array of image objects, each of which will contain the standard image attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique integer used to identify and reference a specific image.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The display name of the image.  This is shown in the web UI and is generally a descriptive title for the image in question.</td>
        </tr>
        <tr>
            <td>distribution</td>
            <td>string</td>
            <td>The base distribution used for this image.  This will not contain release information, but only a simple string like "Ubuntu".</td>
        </tr>
        <tr>
            <td>slug</td>
            <td>nullable string</td>
            <td>A uniquely identifying string that is associated with each of the DigitalOcean-provided public images.  These can be used to reference a public image as an alternative to the numeric id.</td>
        </tr>
        <tr>
            <td>public</td>
            <td>boolean</td>
            <td>A boolean value that indicates whether the image in question is public.  An image that is public is available to all accounts.  A non-public image is only accessible from your account.</td>
        </tr>
        <tr>
            <td>regions</td>
            <td>array</td>
            <td>An array of the regions that the image is available in.  The regions are represented by their identifying slug values.</td>
        </tr>
        <tr>
            <td>action_ids</td>
            <td>array</td>
            <td>An array of action IDs of any actions that have been taken on this image.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/images/" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer ff53e884be5a5563c7e6f41ff4e09c88134cc4fcad358b3f7fd58b824899993b
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588876
Total: 2
Content-Length: 390
      ```

  
    - Body

      ```json
      {
  "images": [
    {
      "id": 119192817,
      "name": "Ubuntu 13.04",
      "distribution": "ubuntu",
      "slug": "ubuntu1304",
      "public": true,
      "regions": [
        "nyc1"
      ]
    },
    {
      "id": 119192842,
      "name": "Ubuntu 13.04",
      "distribution": null,
      "slug": null,
      "public": false,
      "regions": [
        "nyc1"
      ]
    }
  ]
}
      ```
  

## Images Member [/v2/images/{image_id}]

### Images Retrieve an existing Image by id [GET]

<p>To retrieve information about an image (public or private), send a GET request to <code>/v2/images/$IMAGE_ID</code>.</p>

<p>The response will be a JSON object with a key called <code>image</code>.  The value of this will be an image object containing the standard image attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique integer used to identify and reference a specific image.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The display name of the image.  This is shown in the web UI and is generally a descriptive title for the image in question.</td>
        </tr>
        <tr>
            <td>distribution</td>
            <td>string</td>
            <td>The base distribution used for this image.  This will not contain release information, but only a simple string like "Ubuntu".</td>
        </tr>
        <tr>
            <td>slug</td>
            <td>nullable string</td>
            <td>A uniquely identifying string that is associated with each of the DigitalOcean-provided public images.  These can be used to reference a public image as an alternative to the numeric id.</td>
        </tr>
        <tr>
            <td>public</td>
            <td>boolean</td>
            <td>A boolean value that indicates whether the image in question is public.  An image that is public is available to all accounts.  A non-public image is only accessible from your account.</td>
        </tr>
        <tr>
            <td>regions</td>
            <td>array</td>
            <td>An array of the regions that the image is available in.  The regions are represented by their identifying slug values.</td>
        </tr>
        <tr>
            <td>action_ids</td>
            <td>array</td>
            <td>An array of action IDs of any actions that have been taken on this image.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/images/119192843" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer cac9785f98333deb79b5060b9dc7afee24fb89e801802f2f213a7b24c7a84f26
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588876
Content-Length: 171
      ```

  
    - Body

      ```json
      {
  "image": {
    "id": 119192843,
    "name": "Ubuntu 13.04",
    "distribution": null,
    "slug": null,
    "public": false,
    "regions": [
      "nyc1"
    ]
  }
}
      ```
  

### Images Retrieve an existing Image by slug [GET]

<p>To retrieve information about a public image, one option is to send a GET request to <code>/v2/images/$IMAGE_SLUG</code>.</p>

<p>The response will be a JSON object with a key called <code>image</code>.  The value of this will be an image object containing the standard image attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique integer used to identify and reference a specific image.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The display name of the image.  This is shown in the web UI and is generally a descriptive title for the image in question.</td>
        </tr>
        <tr>
            <td>distribution</td>
            <td>string</td>
            <td>The base distribution used for this image.  This will not contain release information, but only a simple string like "Ubuntu".</td>
        </tr>
        <tr>
            <td>slug</td>
            <td>nullable string</td>
            <td>A uniquely identifying string that is associated with each of the DigitalOcean-provided public images.  These can be used to reference a public image as an alternative to the numeric id.</td>
        </tr>
        <tr>
            <td>public</td>
            <td>boolean</td>
            <td>A boolean value that indicates whether the image in question is public.  An image that is public is available to all accounts.  A non-public image is only accessible from your account.</td>
        </tr>
        <tr>
            <td>regions</td>
            <td>array</td>
            <td>An array of the regions that the image is available in.  The regions are represented by their identifying slug values.</td>
        </tr>
        <tr>
            <td>action_ids</td>
            <td>array</td>
            <td>An array of action IDs of any actions that have been taken on this image.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/images/ubuntu1304" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 8e1ddedf8fd9c2db03d2d33ec82458e2c5b870576906b0b5376c99e6615a0717
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588876
Content-Length: 182
      ```

  
    - Body

      ```json
      {
  "image": {
    "id": 119192817,
    "name": "Ubuntu 13.04",
    "distribution": "ubuntu",
    "slug": "ubuntu1304",
    "public": true,
    "regions": [
      "nyc1"
    ]
  }
}
      ```
  

### Images Delete an Image [DELETE]

<p>To delete an image, send a DELETE request to <code>/v2/images/$IMAGE_ID</code>.</p>

<p>A status of 204 will be given.  This indicates that the request was processed successfully, but that no response body is needed.</p>


**Example:**

  - **cURL**

    ```bash
    curl -X DELETE "https://api.digitalocean.com/v2/images/119192845" \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer c56607aadd76697e117d3dfb5623491849666207d41508364a811f7e9aa41474
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588876
      ```

  

### Images Update an Image [PUT]

<p>To update an image, send a PUT request to <code>/v2/images/$IMAGE_ID</code>.  Set the "name" attribute to the new value you would like to use.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The new name that you would like to use for the image.</td>
            <td>true</td>
    </tbody>
</table>

<p>The response will be a JSON object with a key set to <code>image</code>.  The value of this will be an image object containing the standard image attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique integer used to identify and reference a specific image.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The display name of the image.  This is shown in the web UI and is generally a descriptive title for the image in question.</td>
        </tr>
        <tr>
            <td>distribution</td>
            <td>string</td>
            <td>The base distribution used for this image.  This will not contain release information, but only a simple string like "Ubuntu".</td>
        </tr>
        <tr>
            <td>slug</td>
            <td>nullable string</td>
            <td>A uniquely identifying string that is associated with each of the DigitalOcean-provided public images.  These can be used to reference a public image as an alternative to the numeric id.</td>
        </tr>
        <tr>
            <td>public</td>
            <td>boolean</td>
            <td>A boolean value that indicates whether the image in question is public.  An image that is public is available to all accounts.  A non-public image is only accessible from your account.</td>
        </tr>
        <tr>
            <td>regions</td>
            <td>array</td>
            <td>An array of the regions that the image is available in.  The regions are represented by their identifying slug values.</td>
        </tr>
        <tr>
            <td>action_ids</td>
            <td>array</td>
            <td>An array of action IDs of any actions that have been taken on this image.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>name</strong></td>
      <td>Image Name</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X PUT "https://api.digitalocean.com/v2/images/119192846" \
	-d '{"name":"New Image Name"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 88065935f4243ca8768df30625672c6ee8f79f0b90f6e6f9a86ac7f54b848422
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "name": "New Image Name"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588877
Content-Length: 173
      ```

  
    - Body

      ```json
      {
  "image": {
    "id": 119192846,
    "name": "New Image Name",
    "distribution": null,
    "slug": null,
    "public": false,
    "regions": [
      "nyc1"
    ]
  }
}
      ```
  
# Keys


<p>DigitalOcean allows you to add SSH public keys to the interface so that you can embed your public key into a Droplet at the time of creation.  Only the public key is required to take advantage of this functionality.</p>


<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Type</th>
      <th>Description</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>id</strong></td>
      <td><em>integer</em></td>
      <td>This is a unique identification number for the key.  This can be used to reference a specific SSH key when you wish to embed a key into a Droplet.</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>name</strong></td>
      <td><em>string</em></td>
      <td>This is the human-readable display name for the given SSH key.  This is used to easily identify the SSH keys when they are displayed.</td>
      <td><code>my key</code></td>
    </tr>
    <tr>
      <td><strong>fingerprint</strong></td>
      <td><em>string</em></td>
      <td>This attribute contains the fingerprint value that is generated from the public key.  This is a unique identifier that will differentiate it from other keys using a format that SSH recognizes.</td>
      <td><code>f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2</code></td>
    </tr>
    <tr>
      <td><strong>public_key</strong></td>
      <td><em>string</em></td>
      <td>This attribute contains the entire public key string that was uploaded.  This is what is embedded into the root user's `authorized_keys` file if you choose to include this SSH key during Droplet creation.</td>
      <td><code>ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com</code></td>
    </tr>
  </tbody>
</table>

## Keys Collection [/v2/account/keys]

### Keys List all Keys [GET]

<p>To list all of the keys in your account, send a GET request to <code>/v2/account/keys</code>.</p>

<p>The response will be a JSON object with a key set to <code>ssh_keys</code>.  The value of this will be an array of key objects, each of which contain the standard key attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique identification number for the key.  This is used to reference the specific SSH key.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The display name for the given SSH key.</td>
        </tr>
        <tr>
            <td>fingerprint</td>
            <td>string</td>
            <td>The fingerprint value generated from the public key.  This is a unique identifier that can be used to  differentiate it from other keys using a format that SSH recognizes.</td>
        </tr>
        <tr>
            <td>public_key</td>
            <td>string</td>
            <td>The entire public key string that was uploaded.  This is embedded into the root user's <code>authorized_keys</code> file if you choose to include the SSH key during Droplet creation.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/account/keys" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 8984cad53f2fc0a69adcd9be1b81272cd524fb05bcc68fbf3b0d1fd6c85b07a7
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588870
Content-Length: 572
      ```

  
    - Body

      ```json
      {
  "ssh_keys": [
    {
      "id": 1,
      "fingerprint": "f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2",
      "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com",
      "name": "Example Key"
    }
  ]
}
      ```
  

### Keys Create a new Key [POST]

<p>To add a new SSH public key to your DigitalOcean account, send a POST request to <code>/v2/account/keys</code>.  Set the "name" attribute to the name you wish to use and the "public_key" attribute to a string of the full public key you are adding.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The name to give the new SSH key in your account.</td>
            <td>true</td>
        </tr>
        <tr>
            <td>public_key</td>
            <td>string</td>
            <td>A string containing the entire public key.</td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response body will be a JSON object with a key set to <code>ssh_key</code>.  The value will be the complete generated key object. This will have the standard key attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique identification number for the key.  This is used to reference the specific SSH key.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The display name for the given SSH key.</td>
        </tr>
        <tr>
            <td>fingerprint</td>
            <td>string</td>
            <td>The fingerprint value generated from the public key.  This is a unique identifier that can be used to  differentiate it from other keys using a format that SSH recognizes.</td>
        </tr>
        <tr>
            <td>public_key</td>
            <td>string</td>
            <td>The entire public key string that was uploaded.  This is embedded into the root user's <code>authorized_keys</code> file if you choose to include the SSH key during Droplet creation.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>name</strong></td>
      <td>User assigned identifier</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>public_key</strong></td>
      <td>Public SSH Key</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X POST "https://api.digitalocean.com/v2/account/keys" \
	-d '{"name":"Example Key","public_key":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 3286d9cb2f2920a5051991054806ef7d2bdb0ae9912c0a5794ee7e9f2488e491
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "name": "Example Key",
  "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588870
Content-Length: 551
      ```

  
    - Body

      ```json
      {
  "ssh_key": {
    "id": 3,
    "fingerprint": "f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2",
    "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com",
    "name": "Example Key"
  }
}
      ```
  

## Keys Member [/v2/account/keys/{id_or_fingerprint}]

### Keys Retrieve an existing Key [GET]

<p>To show information about a key, send a GET request to <code>/v2/account/keys/$KEY_ID</code> or <code>/v2/account/keys/$KEY_FINGERPRINT</code>.</p>

<p>The response will be a JSON object with a key called <code>ssh_key</code>.  The value of this will be a key object which contains the standard key attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique identification number for the key.  This is used to reference the specific SSH key.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The display name for the given SSH key.</td>
        </tr>
        <tr>
            <td>fingerprint</td>
            <td>string</td>
            <td>The fingerprint value generated from the public key.  This is a unique identifier that can be used to  differentiate it from other keys using a format that SSH recognizes.</td>
        </tr>
        <tr>
            <td>public_key</td>
            <td>string</td>
            <td>The entire public key string that was uploaded.  This is embedded into the root user's <code>authorized_keys</code> file if you choose to include the SSH key during Droplet creation.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/account/keys/f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer a702cbc20cc4839df9876068b88b8c2ac82ba26a404c0eea8917d5d7be503d8b
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588870
Content-Length: 551
      ```

  
    - Body

      ```json
      {
  "ssh_key": {
    "id": 4,
    "fingerprint": "f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2",
    "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com",
    "name": "Example Key"
  }
}
      ```
  

### Keys Update a Key [PUT]

<p>To update the name of an SSH key, send a PUT request to either <code>/v2/account/keys/$SSH_KEY_ID</code> or <code>/v2/account/keys/$SSH_KEY_FINGERPRINT</code>.  Set the "name" attribute to the new name you want to use.</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required?</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The new name to give the SSH key.</td>
            <td>true</td>
        </tr>
    </tbody>
</table>

<p>The response body will be a JSON object with a key set to <code>ssh_key</code>.  The value will be an ojbect that contains the standard key attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>integer</td>
            <td>A unique identification number for the key.  This is used to reference the specific SSH key.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The display name for the given SSH key.</td>
        </tr>
        <tr>
            <td>fingerprint</td>
            <td>string</td>
            <td>The fingerprint value generated from the public key.  This is a unique identifier that can be used to  differentiate it from other keys using a format that SSH recognizes.</td>
        </tr>
        <tr>
            <td>public_key</td>
            <td>string</td>
            <td>The entire public key string that was uploaded.  This is embedded into the root user's <code>authorized_keys</code> file if you choose to include the SSH key during Droplet creation.</td>
        </tr>
    </tbody>
</table>

**Parameters:**
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <td><strong>name</strong></td>
      <td>User assigned identifier</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>

**Example:**

  - **cURL**

    ```bash
    curl -X PUT "https://api.digitalocean.com/v2/account/keys/f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2" \
	-d '{"name":"New Name"}' \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 4010e05bdf211eafbe418f15873fc522a5c63ef0db326c0c5de09e73973e3054
Content-Type: application/x-www-form-urlencoded
      ```

  
    - Body

      ```json
      {
  "name": "New Name"
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588870
Content-Length: 551
      ```

  
    - Body

      ```json
      {
  "ssh_key": {
    "id": 5,
    "fingerprint": "f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2",
    "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com",
    "name": "Example Key"
  }
}
      ```
  

### Keys Destroy a Key [DELETE]

<p>To destroy a public SSH key that you have in your account, send a DELETE request to <code>/v2/account/keys/$KEY_ID</code> or <code>/v2/account/keys/$KEY_FINGERPRINT</code>. </p>

<p>A 204 status will be returned, indicating that the action was successful and that the response body is empty.</p>


**Example:**

  - **cURL**

    ```bash
    curl -X DELETE "https://api.digitalocean.com/v2/account/keys/f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2" \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 55153943996964895b664f8a3365a6d047ea5c405c8fba82e0ebbf04b92dacf7
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588870
      ```

  
# Regions


<p>A region in DigitalOcean represents a datacenter where Droplets can be deployed and images can be transferred.</p>

<p>Each region represents a specific datacenter in a geographic location.  Some geographical locations may have multiple "regions" available.  This means that there are multiple datacenters available within that area.</p>


<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Type</th>
      <th>Description</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>slug</strong></td>
      <td><em>string</em></td>
      <td>A human-readable string that is used as a unique identifier for each region.</td>
      <td><code>nyc1</code></td>
    </tr>
    <tr>
      <td><strong>name</strong></td>
      <td><em>string</em></td>
      <td>The display name of the region.  This will be a full name that is used in the control panel and other interfaces.</td>
      <td><code>New York 1</code></td>
    </tr>
    <tr>
      <td><strong>sizes</strong></td>
      <td><em>array</em></td>
      <td>This attribute is set to an array which contains the identifying slugs for the sizes available in this region.</td>
      <td><code>["512mb", "1024mb"]</code></td>
    </tr>
    <tr>
      <td><strong>available</strong></td>
      <td><em>boolean</em></td>
      <td>This is a boolean value that represents whether new Droplets can be created in this region.</td>
      <td><code>true</code></td>
    </tr>
  </tbody>
</table>

## Regions Collection [/v2/regions]

### Regions List all Regions [GET]

<p>To list all of the regions that are available, send a GET request to <code>/v2/regions</code>.</p>

<p>The response will be a JSON object with a key called <code>regions</code>.  The value of this will be an array of region objects, each of which will contain the standard region attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>slug</td>
            <td>string</td>
            <td>A human-readable string that is used as a unique identifier for each region.  An example is "nyc2".</td>
        </tr>
        <tr>
            <td>name</td>
            <td>string</td>
            <td>The display name of the region.  This is the full name that is used in the web UI and other interfaces.</td>
        </tr>
        <tr>
            <td>sizes</td>
            <td>array</td>
            <td>An array which contains the sizes slugs that represent the sizes available for deployment in this region.</td>
        </tr>
        <tr>
            <td>available</td>
            <td>boolean</td>
            <td>A boolean that represents whether new Droplets can be created in this region.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/regions" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 37df160885e006bc23a92c8d053723b132ac94952b31e792481af72878301ec9
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588877
Content-Length: 431
      ```

  
    - Body

      ```json
      {
  "regions": [
    {
      "slug": "nyc1",
      "name": "New York",
      "sizes": [

      ],
      "available": false
    },
    {
      "slug": "sfo1",
      "name": "San Francisco",
      "sizes": [
        "1024mb",
        "512mb"
      ],
      "available": true
    },
    {
      "slug": "ams1",
      "name": "Amsterdam",
      "sizes": [
        "1024mb",
        "512mb"
      ],
      "available": true
    }
  ]
}
      ```
  

# Sizes


<p>The sizes objects represent different packages of hardware resources that can be used for Droplets.  When a Droplet is created, a size must be selected so that the correct resources can be allocated.</p>

<p>Each size represents a plan that bundles together specific sets of resources.  This includes the amount of RAM, the number of virtual CPUs, disk space, and transfer.  The size object also includes the pricing details and the regions that the size is available in.</p>


<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Type</th>
      <th>Description</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>slug</strong></td>
      <td><em>string</em></td>
      <td>A human-readable string that is used to uniquely identify each size.</td>
      <td><code>512mb</code></td>
    </tr>
    <tr>
      <td><strong>memory</strong></td>
      <td><em>integer</em></td>
      <td>The amount of RAM available to Droplets created with this size.  This value is given in megabytes.</td>
      <td><code>512</code></td>
    </tr>
    <tr>
      <td><strong>vcpus</strong></td>
      <td><em>integer</em></td>
      <td>The number of virtual CPUs that are allocated to Droplets with this size.</td>
      <td><code>1</code></td>
    </tr>
    <tr>
      <td><strong>disk</strong></td>
      <td><em>integer</em></td>
      <td>This is the amount of disk space set aside for Droplets created with this size.  The value is given in gigabytes.</td>
      <td><code>20</code></td>
    </tr>
    <tr>
      <td><strong>transfer</strong></td>
      <td><em>integer</em></td>
      <td>The amount of transfer bandwidth that is available for Droplets created in this size.  This only counts traffic on the public interface.  The value is given in terabytes.</td>
      <td><code>5</code></td>
    </tr>
    <tr>
      <td><strong>price_monthly</strong></td>
      <td><em>string</em></td>
      <td>This attribute describes the monthly cost of this Droplet size if the Droplet is kept for an entire month.  The value is measured in US dollars.</td>
      <td><code>5</code></td>
    </tr>
    <tr>
      <td><strong>price_hourly</strong></td>
      <td><em>string</em></td>
      <td>This describes the price of the Droplet size as measured hourly.  The value is measured in US dollars.</td>
      <td><code>.00744</code></td>
    </tr>
    <tr>
      <td><strong>regions</strong></td>
      <td><em>array</em></td>
      <td>An array that contains the region slugs where this size is available for Droplet creates.</td>
      <td><code>["nyc1", "sfo1"]</code></td>
    </tr>
  </tbody>
</table>

## Sizes Collection [/v2/sizes]

### Sizes List all Sizes [GET]

<p>To list all of the sizes, send a GET request to <code>/v2/sizes</code>.</p>

<p>The response will be a JSON object with a key called <code>sizes</code>.  The value of this will be an array of size objects each of which contain the standard sizes attributes:</p>

<table class="pure-table pure-table-horizontal">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>slug</td>
            <td>string</td>
            <td>A human-readable string that is used to uniquely identify each Droplet/image size.</td>
        </tr>
        <tr>
            <td>memory</td>
            <td>integer</td>
            <td>The amount of RAM allocated to Droplets created of this size.  The value is represented in megabytes.</td>
        </tr>
        <tr>
            <td>vcpus</td>
            <td>integer</td>
            <td>The number of virtual CPUs allocated to Droplets of this size.</td>
        </tr>
        <tr>
            <td>disk</td>
            <td>integer</td>
            <td>The amount of disk space set aside for Droplets of this size.  The value is represented in gigabytes.</td>
        </tr>
        <tr>
            <td>transfer</td>
            <td>integer</td>
            <td>The amount of transfer bandwidth available for Droplets of this size.  The value is represented in terabytes.</td>
        </tr>
        <tr>
            <td>price_monthly</td>
            <td>string</td>
            <td>The monthly cost of this Droplet size.  This is represented in US dollars.</td>
        </tr>
        <tr>
            <td>price_hourly</td>
            <td>string</td>
            <td>The price of this Droplet size as measured hourly.  The value is represented in US dollars.</td>
        </tr>
        <tr>
            <td>regions</td>
            <td>array</td>
            <td>An array containing the region slugs where this size is available for Droplet creates.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl -X GET "https://api.digitalocean.com/v2/sizes" \
	-H "Authorization: Bearer $TOKEN"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 14df952940c048a1efd7c5caa7f16713b6c250789dd1acfb7f0f05eabe333fe1
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402588877
Content-Length: 563
      ```

  
    - Body

      ```json
      {
  "sizes": [
    {
      "slug": "512mb",
      "memory": 512,
      "vcpus": 1,
      "disk": 20,
      "transfer": null,
      "price_monthly": "5.0",
      "price_hourly": "0.00744",
      "regions": [
        "nyc1",
        "lon1",
        "sfo1",
        "ams1"
      ]
    },
    {
      "slug": "1024mb",
      "memory": 1024,
      "vcpus": 2,
      "disk": 30,
      "transfer": null,
      "price_monthly": "10.0",
      "price_hourly": "0.01488",
      "regions": [
        "nyc1",
        "lon1",
        "sfo1",
        "ams1"
      ]
    }
  ]
}
      ```
  

