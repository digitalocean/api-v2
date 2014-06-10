### API v2.0 Introduction

Welcome to the DigitalOcean API documentation.

The DigitalOcean API allows you to manage Droplets and resources within the DigitalOcean cloud in a simple, programmatic way using conventional HTTP requests.  The endpoints are intuitive and powerful, allowing you to easily make calls to retrieve information or to execute actions.

All of the functionality that you are familiar with in the DigitalOcean control panel is also available through the API, allowing you to script the complex actions that your situation requires.

The API documentation will start with a general overview about the design and technology that has been implemented, followed by reference information about specific endpoints.

### HTML Requests

The DigitalOcean API is fully [RESTful]("http://en.wikipedia.org/wiki/Representational_state_transfer").  Users can access the resources provided by the API by using standard HTML methods.

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


### HTML Statuses

Along with the HTML methods that the API responds to, it will also return standard HTML statuses, including error codes.

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

### Curl Examples

Throughout this document, some example API requests will be given using the `curl` command.  This will allow us to demonstrate the various endpoints in a simple, textual format.

The names of account-specific resources (like Droplet IDs, for instance) will be represented by variables.  For instance, a Droplet ID may be represented by a variable called `$DROPLET_ID`  You can set the associated variables in your environment if you wish to use the examples without modification.

If you are working from the command line, the previously mentioned environmental variable could be set by setting and exporting the variables, as we show in the example.

If you are following along, make sure you use a Droplet ID that you control for so that your commands will execute correctly.

#### Set and Export a Variable</h4>

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
        
You then send the username and password combination delimited by a colon character.  We only have an OAuth token, so use the OAuth token as the username and leave the password slot blank.

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

Using this format, you would pass the attributes within the URI itself.  Tools like `curl` can take parameters and value as arguments and create the appropriate URI.

With `curl` this is done using the `-F` flag and then passing the key and value as an argument.  The argument should take the form of a quoted string with the attribute being set to a value with an equal sign.

You could also use a standard query string if that would be easier in our application.  In this case, the parameters would be embedded into the URI itself by appending a `?` to the end of the URI and then setting each attribute with an equal sign.  Attributes can be separated with a `&`.

#### Pass Parameters as a JSON Object

    curl -H "Authorization: Bearer $AUTH_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"name": "example.com", "ip_address": "127.0.0.1"}' \
        -X POST "https://api.digitalocean.com/v2/domains"

#### Pass Parameters as URI Components

    curl -H "Authorization: Bearer $AUTH_TOKEN" \
        -F "name=example.com" -F "ip_address=127.0.0.1" \
        -X POST "https://api.digitalocean.com/v2/domains"

#### Pass Parameters as a Query String

    curl -H "Authorization: Bearer $AUTH_TOKEN" \
         -X POST \
         "https://api.digitalocean.com/v2/domains?name=example.com&ip_address=127.0.0.1"
# Actions


Actions are a user's way of interacting with our cloud, from renaming a droplet to transferring an image from region to region.

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
      <td>This is a unique identification number for the aciton.</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>status</strong></td>
      <td><em>string</em></td>
      <td>The current status of the action.</td>
      <td><code>completed</code></td>
    </tr>
    <tr>
      <td><strong>started_at</strong></td>
      <td><em>integer</em></td>
      <td>unix timestamp of when the action started</td>
      <td><code>1402421904</code></td>
    </tr>
    <tr>
      <td><strong>completed_at</strong></td>
      <td><em>integer</em></td>
      <td>unix timestamp of when the action completed</td>
      <td><code>1402421904</code></td>
    </tr>
    <tr>
      <td><strong>resource_id</strong></td>
      <td><em>integer</em></td>
      <td>Unique identifier for the resource this action is associated with</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>resource_type</strong></td>
      <td><em>string</em></td>
      <td>Resource name of the type this action is associate with</td>
      <td><code>droplet</code></td>
    </tr>
  </tbody>
</table>

## Actions Collection [/v2/actions]

### Actions List all Actions [GET]

Lists all Actions for the currently authenticated user.

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/actions" -X GET \
	-H "Authorization: Bearer 7e28ca12e029cb9fc24c67da6c39595c3d0cf569b7c3adb04498c046a5f2b38e"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 7e28ca12e029cb9fc24c67da6c39595c3d0cf569b7c3adb04498c046a5f2b38e
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429604
Total: 1
Content-Length: 231
      ```

  
    - Body

      ```json
      {
  "actions": [
    {
      "id": 17,
      "status": "in-progress",
      "type": "test",
      "started_at": "2014-06-10T18:46:44Z",
      "completed_at": null,
      "resource_id": null,
      "resource_type": null
    }
  ]
}
      ```
  

## Actions Member [/v2/actions/{action_id}]

### Actions Retrieve an existing Action [GET]

Shows the details for a single Action

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/actions/18" -X GET \
	-H "Authorization: Bearer b31e04f6544c4746531572d22d5e79dfd7a6eea012800fbf3ce9e8bb2be3c906"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer b31e04f6544c4746531572d22d5e79dfd7a6eea012800fbf3ce9e8bb2be3c906
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429605
Content-Length: 204
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 18,
    "status": "in-progress",
    "type": "test",
    "started_at": "2014-06-10T18:46:45Z",
    "completed_at": null,
    "resource_id": null,
    "resource_type": null
  }
}
      ```
  
# Domain Records


<p>Domain record resources are used to set or retrieve information about the individual DNS records configured for a domain.  This allows you to build and manage DNS zone files by adding and modifying individual records for a domain.</p>

<p>The DigitalOcean DNS management interface allows you to configure the following DNS records:</p>

<ul>
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
            <li><code>curl -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -d '{"type": "A", "name": "ipv4host", "data": "127.0.0.1"}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
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
            <li><code>curl -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -d '{"type": "AAAA", "name": "ipv6host", "data": "2001:db8::ff00:42:8329"}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
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
            <li><code>curl -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -d '{"type": "CNAME", "name": "newalias", "data": "hosttarget"}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
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
            <li><code>curl -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -d '{"type": "MX", "data": "127.0.0.1", "priority": 5}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
        </ul>
        </li>
    </ul>
    </li>


    <li><strong>TXT</strong>
    <ul>
        <li><strong>Description</strong>: A text record contains arbitrary data that contains human-readable messages.  It is also used for various validation and verification schemes like SPF and DKIM.</li>
        <li><strong>Required Fields</strong>:
        <ul>
            <li><strong>type</strong>: TXT</li>
            <li><strong>name</strong>: The name of the record, as a string.</li>
            <li><strong>data</strong>: The arbitrary text string contents.</li>
        </ul>
        </li>
        <li><strong>Successful Creation Example</strong>:
        <ul>
            <li><code>curl -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -d '{"type": "TXT", "name": "recordname", "data": "arbitrary data here"}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
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
            <li><code>curl -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -d '{"type": "SRV", "name": "servicename", "data": "targethost", "priority": 0, "port": 1, "weight": 2}' -X POST "https://api.digitalocean.com/v2/domains/$DOMAIN/records"</code></li>
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
            <li><code>curl -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -d '{"type": "NS", "data": "ns1.digitalocean.com."}' -X POST "https://api.digitalocean.com/v2/domains/justinellingwood.com/records"</code></li>
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

<p>The response will be an array of domain record objects, each of which contains the standard domain record attributes:</p>

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


<p>For attributes that are not used by a specific record type, the value of <code>null</code> will be returned.  For instance, all records other than SRV will have <code>null</code> for the <code>priority</code>, <code>weight</code>, and <code>port</code> attributes.</p>


**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com/records" -X GET \
	-H "Authorization: Bearer 2b9da5d90efb036bd13e81f07b0c8045275bc37ec4561c15eb5b3a224adc3e37"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 2b9da5d90efb036bd13e81f07b0c8045275bc37ec4561c15eb5b3a224adc3e37
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429598
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

<p>The response body will be an object of the new record.  Attributes that are not applicable for the record type will be set to <code>null</code>.  An <code>id</code> attribute is generated for each record as part of the object.</p>

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
    curl "https://api.digitalocean.com/v2/domains/example.com/records" -d '{
  "name": "subdomain",
  "data": "2001:db8::ff00:42:8329",
  "type": "AAAA"
}' -X POST \
	-H "Authorization: Bearer fd28dec61d8f833ddb8406431d5b7381e22141f0965ab1faa8dde9ba584960cb" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer fd28dec61d8f833ddb8406431d5b7381e22141f0965ab1faa8dde9ba584960cb
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
X-RateLimit-Reset: 1402429598
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

The request will be an object that contains all of the standard domain record attributes:

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
    curl "https://api.digitalocean.com/v2/domains/example.com/records/10" -X GET \
	-H "Authorization: Bearer 87f43bb4af27c01bd6e1b8b93f1a370ba57912a4b0c37b68064ca85f4d235c92"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 87f43bb4af27c01bd6e1b8b93f1a370ba57912a4b0c37b68064ca85f4d235c92
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429598
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

<p>The response will be a domain record object which contains the standard domain record attributes:</p>

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
    curl "https://api.digitalocean.com/v2/domains/example.com/records/21" -d '{
  "name": "new_name"
}' -X PUT \
	-H "Authorization: Bearer d536fea19bb31944524fbada125390da56cbe4bfd1ec0f96134160acfa344408" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer d536fea19bb31944524fbada125390da56cbe4bfd1ec0f96134160acfa344408
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
X-RateLimit-Reset: 1402429599
Content-Length: 164
      ```

  
    - Body

      ```json
      {
  "domain_record": {
    "id": 21,
    "type": "CNAME",
    "name": "new_name",
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
    curl "https://api.digitalocean.com/v2/domains/example.com/records/26" -d '' -X DELETE \
	-H "Authorization: Bearer 54cd2687b8a23d8f7f54328fa6b6f78574573c797a616b1c59ed50f4fcb06e64" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 54cd2687b8a23d8f7f54328fa6b6f78574573c797a616b1c59ed50f4fcb06e64
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429599
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

An array of Domain objects will be returned, each of which contain the standard domain attributes:

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
    curl "https://api.digitalocean.com/v2/domains" -X GET \
	-H "Authorization: Bearer d0afd1d657928ed795bda59dafd8494b11739c4fbe76e191723cb315e2689d75"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer d0afd1d657928ed795bda59dafd8494b11739c4fbe76e191723cb315e2689d75
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429599
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

<p>The response will contain the standard attributes associated with a domain:</p>

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
    curl "https://api.digitalocean.com/v2/domains" -d '{"name":"example.com","ip_address":"127.0.0.1"}' -X POST \
	-H "Authorization: Bearer ee7d74a01bd16a8f1b209155549d6f32929e756bee784cbcbe8aaab70529b67c" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer ee7d74a01bd16a8f1b209155549d6f32929e756bee784cbcbe8aaab70529b67c
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
X-RateLimit-Reset: 1402429599
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

### Domains Delete a Domain [DELETE]

<p>To delete a domain, send a DELETE request to <code>/v2/domains/$DOMAIN_NAME</code>.</p>

<p>The domain will be removed from your account and a response status of 204 will be returned.  This indicates a successful request with no response body.</p>


**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com" -d '' -X DELETE \
	-H "Authorization: Bearer 8e3ffd053ba62229cfd12f429336f9bdd070fb7812e6847bb3e4236910eaa374" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 8e3ffd053ba62229cfd12f429336f9bdd070fb7812e6847bb3e4236910eaa374
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429600
      ```

  

### Domains Show [GET]

<p>To get details about a specific domain, send a GET request to <code>/v2/domains/$DOMAIN_NAME</code>. </p>

The response received will contain the standard attributes defined for a domain:

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
    curl "https://api.digitalocean.com/v2/domains/example.com" -X GET \
	-H "Authorization: Bearer 259cc8c252070d12b85ca5444b87b9e8ba27b0a9772c8c29c5e996fe5e6c1f94"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 259cc8c252070d12b85ca5444b87b9e8ba27b0a9772c8c29c5e996fe5e6c1f94
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429600
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
  
# Droplet


<p>A Droplet is a DigitalOcean virtual machine.  By sending requests to the Droplet endpoint, you can list, create or delete Droplets.</p>

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
      <td>The region that the Droplet instance is deployed in.  WHen setting a region, the value should be the slug identifier for the region.  When you query a Droplet, teh entire region object will be returned.</td>
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
      <td><strong>networks</strong></td>
      <td><em>object</em></td>
      <td>The details of the network that are configured for the Droplet instance.  This is an object that contains keys for IPv4 and IPv6.  The value of each of these is an array that contains objects describing an individual IP resource allocated to the Droplet.  These will define attributes like the IP address, netmask, and gateway of the specific network depending on the type of network it is.</td>
      <td><code>{"v4":[{"ip_address":"127.0.0.2","netmask":"255.255.255.0","gateway":"127.0.0.1","type":"public"}],"v6":[]}</code></td>
    </tr>
    <tr>
      <td><strong>backups</strong></td>
      <td><em>array</em></td>
      <td>An array of any backups that have been taken of the Droplet instance.  Droplet backups are enabled at the time of the instance creation.  The array contains image objects representing each backup.</td>
      <td><code>[123, 456, 789]</code></td>
    </tr>
    <tr>
      <td><strong>snapshots</strong></td>
      <td><em>array</em></td>
      <td>An array of any snapshots created from the Droplet instance.  The array contains objects that represent each snapshot.  This will be in the form of an image object.</td>
      <td><code>[123, 456, 789]</code></td>
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
  </tbody>
</table>

## Droplet Collection [/v2/droplets]

### Droplet List all Droplets [GET]

<p>To list all Droplets in your account, send a GET request to <code>/v2/droplets</code>.</p>


<p>The response body will be an array containing objects representing each Droplet. These will have the standard Droplet attributes:</p>

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
            <td>A unique identifier for each Droplet.  This is automatically generated upon Droplet creation.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>String</td>
            <td>A human-readable name set for the Droplet instance.</td>
        </tr>
        <tr>
            <td>region</td>
            <td>Object</td>
            <td>The region that the Droplet instance is deployed in.  The entire region object is returned.</td>
        </tr>
        <tr>
            <td>image</td>
            <td>Object</td>
            <td>The base image used to create the Droplet instance.  The entire image object is returned.</td>
        </tr>
        <tr>
            <td>size</td>
            <td>Object</td>
            <td>The size of the Droplet instance.  The entire size object is returned.</td>
        </tr>
        <tr>
            <td>networks</td>
            <td>Array</td>
            <td>The details of the networks configured for the Droplet.  This is an object containing arrays for each of the separate networks.  Each array defines the IP address and the network details (netmask, gateway, public or private, etc.) of the specific network.</td>
        </tr>
        <tr>
            <td>backups</td>
            <td>Array</td>
            <td>An array of any backups that have been taken of the Droplet.  The array contain backup objects.  These follow the conventions of an image object.</td>
        </tr>
        <tr>
            <td>snapshots</td>
            <td>Array</td>
            <td>An array of any snapshots created from the Droplet.  The array contains snapshot objects.  These follow the conventions of an image object.</td>
        </tr>
        <tr>
            <td>locked</td>
            <td>Boolean</td>
            <td>A boolean value indicating whether the Droplet has been locked, preventing actions by users.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>A string indicating the state of the Droplet instance.  This may be "new", "active", or "archive".</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/droplets" -X GET \
	-H "Authorization: Bearer 1271e769f329d6b9f2d90cd938a503cf1a52f65b584277a0454701aee6a78b51"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 1271e769f329d6b9f2d90cd938a503cf1a52f65b584277a0454701aee6a78b51
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429601
Total: 1
Content-Length: 1531
      ```

  
    - Body

      ```json
      {
  "droplets": [
    {
      "id": 1,
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
          "br1",
          "sfo1",
          "ams4"
        ]
      },
      "locked": false,
      "status": "active",
      "networks": {
        "v4": [
          {
            "ip_address": {
              "ip_address": "127.0.0.1",
              "netmask": "255.255.255.0",
              "gateway": "127.0.0.2",
              "type": "public"
            }
          }

        ],
        "v6": [
          {
            "ipv6_address": {
              "ip_address": "2400:6180:0000:00D0:0000:0000:0009:7001",
              "cidr": 124,
              "gateway": "2400:6180:0000:00D0:0000:0000:0009:7000",
              "type": "public"
            }
          }

        ]
      },
      "backup_ids": [
        119192825
      ],
      "snapshot_ids": [
        119192826
      ],
      "action_ids": [

      ]
    }
  ]
}
      ```
  

### Droplet Retrieve snapshots for a Droplet [GET]

Lists all of the droplet's snapshots

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/droplets/3/snapshots" -X GET \
	-H "Authorization: Bearer d5775ff79904cf4424d863177c3b111b5975d9560fa0458fb2bd7ef031a31ae6"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer d5775ff79904cf4424d863177c3b111b5975d9560fa0458fb2bd7ef031a31ae6
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429602
Total: 1
Content-Length: 207
      ```

  
    - Body

      ```json
      {
  "snapshots": [
    {
      "id": 119192829,
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
  

### Droplet Create a new Droplet [POST]

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

<p>A Droplet will be created using the provided information.  The response body will contain the standard attributes for your new Droplet:</p>

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
            <td>A unique identifier for each Droplet.  This is automatically generated upon Droplet creation.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>String</td>
            <td>A human-readable name set for the Droplet instance.</td>
        </tr>
        <tr>
            <td>region</td>
            <td>Object</td>
            <td>The region that the Droplet instance is deployed in.  The entire region object is returned.</td>
        </tr>
        <tr>
            <td>image</td>
            <td>Object</td>
            <td>The base image used to create the Droplet instance.  The entire image object is returned.</td>
        </tr>
        <tr>
            <td>size</td>
            <td>Object</td>
            <td>The size of the Droplet instance.  The entire size object is returned.</td>
        </tr>
        <tr>
            <td>networks</td>
            <td>Array</td>
            <td>The details of the networks configured for the Droplet.  This is an object containing arrays for each of the separate networks.  Each array defines the IP address and the network details (netmask, gateway, public or private, etc.) of the specific network.</td>
        </tr>
        <tr>
            <td>backups</td>
            <td>Array</td>
            <td>An array of any backups that have been taken of the Droplet.  The array contain backup objects.  These follow the conventions of an image object.</td>
        </tr>
        <tr>
            <td>snapshots</td>
            <td>Array</td>
            <td>An array of any snapshots created from the Droplet.  The array contains snapshot objects.  These follow the conventions of an image object.</td>
        </tr>
        <tr>
            <td>locked</td>
            <td>Boolean</td>
            <td>A boolean value indicating whether the Droplet has been locked, preventing actions by users.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>A string indicating the state of the Droplet instance.  This may be "new", "active", or "archive".</td>
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
    curl "https://api.digitalocean.com/v2/droplets" -d '{
  "name": "My-Droplet",
  "region": "nyc1",
  "size": "512mb",
  "image": 119192830
}' -X POST \
	-H "Authorization: Bearer 6ec329a0f8d73133fc4870c9b055c9c61c74b7576e82f5255393d56d2b6792f4" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 6ec329a0f8d73133fc4870c9b055c9c61c74b7576e82f5255393d56d2b6792f4
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "name": "My-Droplet",
  "region": "nyc1",
  "size": "512mb",
  "image": 119192830
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429602
Link: <http://example.org/v2/droplets/4/actions/4>; rel="monitor"
Content-Length: 844
      ```

  
    - Body

      ```json
      {
  "droplet": {
    "id": 4,
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
      "id": 119192830,
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
        "br1",
        "sfo1",
        "ams4"
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
      4
    ]
  }
}
      ```
  

### Droplet Retrieve backups for a Droplet [GET]

Lists all of the droplet's backups

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/droplets/5/backups" -X GET \
	-H "Authorization: Bearer 9018e55b6294f46742471dc68e77b4ea54ec558dbb8f84204d605128c529c6a1"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 9018e55b6294f46742471dc68e77b4ea54ec558dbb8f84204d605128c529c6a1
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429602
Total: 1
Content-Length: 205
      ```

  
    - Body

      ```json
      {
  "backups": [
    {
      "id": 119192831,
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
  

## Droplet Member [/v2/droplets/{droplet_id}]

### Droplet Retrieve an existing Droplet by id [GET]

<p>To show an individual droplet, send a GET request to <code>/v2/droplets/$DROPLET_ID</code>.</p>

<p>The response will contain the Droplet's attributes:</p>

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
            <td>A unique identifier for each Droplet.  This is automatically generated upon Droplet creation.</td>
        </tr>
        <tr>
            <td>name</td>
            <td>String</td>
            <td>A human-readable name set for the Droplet instance.</td>
        </tr>
        <tr>
            <td>region</td>
            <td>Object</td>
            <td>The region that the Droplet instance is deployed in.  The entire region object is returned.</td>
        </tr>
        <tr>
            <td>image</td>
            <td>Object</td>
            <td>The base image used to create the Droplet instance.  The entire image object is returned.</td>
        </tr>
        <tr>
            <td>size</td>
            <td>Object</td>
            <td>The size of the Droplet instance.  The entire size object is returned.</td>
        </tr>
        <tr>
            <td>networks</td>
            <td>Array</td>
            <td>The details of the networks configured for the Droplet.  This is an object containing arrays for each of the separate networks.  Each array defines the IP address and the network details (netmask, gateway, public or private, etc.) of the specific network.</td>
        </tr>
        <tr>
            <td>backups</td>
            <td>Array</td>
            <td>An array of any backups that have been taken of the Droplet.  The array contain backup objects.  These follow the conventions of image objects. </td>
        </tr>
        <tr>
            <td>snapshots</td>
            <td>Array</td>
            <td>An array of any snapshots created from the Droplet.  The array contains snapshot objects.  These follow the conventions of image objects.</td>
        </tr>
        <tr>
            <td>locked</td>
            <td>Boolean</td>
            <td>A boolean value indicating whether the Droplet has been locked, preventing actions by users.</td>
        </tr>
        <tr>
            <td>status</td>
            <td>String</td>
            <td>A string indicating the state of the Droplet instance.  This may be "new", "active", or "archive".</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/droplets/2" -X GET \
	-H "Authorization: Bearer 672c408f6c5e23ed7553e053915e1bf3a21dc4eed7aa4e4d67b4468d728a43f5"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 672c408f6c5e23ed7553e053915e1bf3a21dc4eed7aa4e4d67b4468d728a43f5
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429602
Content-Length: 1382
      ```

  
    - Body

      ```json
      {
  "droplet": {
    "id": 2,
    "name": "test.example.com",
    "region": {
      "slug": "nyc1",
      "name": "New York",
      "sizes": [
        "512mb",
        "1024mb"
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
        "ams4",
        "sfo1",
        "br1"
      ]
    },
    "locked": false,
    "status": "active",
    "networks": {
      "v4": [
        {
          "ip_address": {
            "ip_address": "127.0.0.2",
            "netmask": "255.255.255.0",
            "gateway": "127.0.0.3",
            "type": "public"
          }
        }

      ],
      "v6": [
        {
          "ipv6_address": {
            "ip_address": "2400:6180:0000:00D0:0000:0000:0009:7002",
            "cidr": 124,
            "gateway": "2400:6180:0000:00D0:0000:0000:0009:7000",
            "type": "public"
          }
        }

      ]
    },
    "backup_ids": [
      119192827
    ],
    "snapshot_ids": [
      119192828
    ],
    "action_ids": [

    ]
  }
}
      ```
  

### Droplet Delete a Droplet [DELETE]

<p>To delete a Droplet, send a DELETE request to <code>/v2/droplets/$DROPLET_ID</code>.</p>

<p>No response body will be sent back, but the response code will indicate success.  Specifically, the response code will be a 204, which means that the action was successful with no returned body data.</p>


**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/droplets/6" -d '' -X DELETE \
	-H "Authorization: Bearer 91dac362560bccc43c38347a2785bb626b3d54b47e06212fda7c4fb88980c953" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 91dac362560bccc43c38347a2785bb626b3d54b47e06212fda7c4fb88980c953
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429602
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
      <td><strong>progress</strong></td>
      <td><em>string</em></td>
      <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
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
      <td><em>datetime</em></td>
      <td>The datetime containing the time that the action was initiated.</td>
      <td><code>2014-05-08T19:11:41Z</code></td>
    </tr>
  </tbody>
</table>

## Droplet Actions Collection [/v2/droplets/{droplet_id}/actions]

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

<p>The response will contain all of the standard Droplet action attributes:</p>

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
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>The datetime containing the time that the action was initiated.</td>
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
    curl "https://api.digitalocean.com/v2/droplets/7/actions" -d '{"type":"restore","image":119192833}' -X POST \
	-H "Authorization: Bearer c38e683b44b250ed0d8a4bec9970ce2098732c63445c9c41c222b0b12767350c" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer c38e683b44b250ed0d8a4bec9970ce2098732c63445c9c41c222b0b12767350c
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "restore",
  "image": 119192833
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429603
Content-Length: 208
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 6,
    "status": "in-progress",
    "type": "restore",
    "started_at": "2014-06-10T18:46:43Z",
    "completed_at": null,
    "resource_id": 7,
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

<p>The response will be a Droplet actions object:</p>

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
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>The datetime containing the time that the action was initiated.</td>
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
    curl "https://api.digitalocean.com/v2/droplets/8/actions" -d '{"type":"power_cycle"}' -X POST \
	-H "Authorization: Bearer 25f38dd41080bc39b096347bdd73a9fb34b201399dbbe1a096186e777b5d208e" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 25f38dd41080bc39b096347bdd73a9fb34b201399dbbe1a096186e777b5d208e
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
X-RateLimit-Reset: 1402429603
Content-Length: 212
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 7,
    "status": "in-progress",
    "type": "power_cycle",
    "started_at": "2014-06-10T18:46:43Z",
    "completed_at": null,
    "resource_id": 8,
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

<p>The response will be a standard Droplet action:</p>

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
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>The datetime containing the time that the action was initiated.</td>
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
    curl "https://api.digitalocean.com/v2/droplets/9/actions" -d '{"type":"rebuild","image":119192836}' -X POST \
	-H "Authorization: Bearer 79283f5df3ecb71807f94eecaffc2fa1495e0d9bf4194d26e2ce318e0d21425f" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 79283f5df3ecb71807f94eecaffc2fa1495e0d9bf4194d26e2ce318e0d21425f
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "rebuild",
  "image": 119192836
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429603
Content-Length: 208
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 8,
    "status": "in-progress",
    "type": "rebuild",
    "started_at": "2014-06-10T18:46:43Z",
    "completed_at": null,
    "resource_id": 9,
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

<p>The response will be a standard Droplet action:</p>

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
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>The datetime containing the time that the action was initiated.</td>
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
    curl "https://api.digitalocean.com/v2/droplets/10/actions" -d '{"type":"rename","name":"Droplet-Name"}' -X POST \
	-H "Authorization: Bearer 852e47297731297ad2bdeaa8ba143a03542660df14bc022e7f82c960fd4d231e" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 852e47297731297ad2bdeaa8ba143a03542660df14bc022e7f82c960fd4d231e
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
X-RateLimit-Reset: 1402429603
Content-Length: 208
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 9,
    "status": "in-progress",
    "type": "rename",
    "started_at": "2014-06-10T18:46:43Z",
    "completed_at": null,
    "resource_id": 10,
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

<p>The response will be a standard Droplet action:</p>

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
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>The datetime containing the time that the action was initiated.</td>
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
    curl "https://api.digitalocean.com/v2/droplets/11/actions" -d '{"type":"shutdown"}' -X POST \
	-H "Authorization: Bearer 0419b4ef8d30a3c2c0dc3aea3e8694c670bf10047e1dda53a8be59101658a3b3" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 0419b4ef8d30a3c2c0dc3aea3e8694c670bf10047e1dda53a8be59101658a3b3
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
X-RateLimit-Reset: 1402429603
Content-Length: 211
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 10,
    "status": "in-progress",
    "type": "shutdown",
    "started_at": "2014-06-10T18:46:43Z",
    "completed_at": null,
    "resource_id": 11,
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

<p>The response will be a standard Droplet action:</p>

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
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>The datetime containing the time that the action was initiated.</td>
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
    curl "https://api.digitalocean.com/v2/droplets/12/actions" -d '{"type":"password_reset"}' -X POST \
	-H "Authorization: Bearer 563b06c8f7356e9a6144ea39c3135348564cb5a3b7ccc15be6e37b4f922b1c96" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 563b06c8f7356e9a6144ea39c3135348564cb5a3b7ccc15be6e37b4f922b1c96
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
X-RateLimit-Reset: 1402429603
Content-Length: 217
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 11,
    "status": "in-progress",
    "type": "password_reset",
    "started_at": "2014-06-10T18:46:43Z",
    "completed_at": null,
    "resource_id": 12,
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

<p>The response will be a standard Droplet action:</p>

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
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>The datetime containing the time that the action was initiated.</td>
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
    curl "https://api.digitalocean.com/v2/droplets/13/actions" -d '{"type":"resize","size":"1024mb"}' -X POST \
	-H "Authorization: Bearer 0ed810f505c4326f525fba46e2ba213f7438f1d4a81746a05d70c93f4eedd8ad" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 0ed810f505c4326f525fba46e2ba213f7438f1d4a81746a05d70c93f4eedd8ad
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
X-RateLimit-Reset: 1402429604
Content-Length: 209
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 12,
    "status": "in-progress",
    "type": "resize",
    "started_at": "2014-06-10T18:46:44Z",
    "completed_at": null,
    "resource_id": 13,
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

<p>The response should be a standard Droplet action:</p>

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
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>The datetime containing the time that the action was initiated.</td>
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
    curl "https://api.digitalocean.com/v2/droplets/14/actions" -d '{"type":"power_on"}' -X POST \
	-H "Authorization: Bearer 9f6cf35ecacf1858ee841116ba334fd2f3419d94530c984d6f2dfe8c87e9336a" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 9f6cf35ecacf1858ee841116ba334fd2f3419d94530c984d6f2dfe8c87e9336a
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
X-RateLimit-Reset: 1402429604
Content-Length: 211
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 13,
    "status": "in-progress",
    "type": "power_on",
    "started_at": "2014-06-10T18:46:44Z",
    "completed_at": null,
    "resource_id": 14,
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

<p>The response should be a standard Droplet action:</p>

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
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>The datetime containing the time that the action was initiated.</td>
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
    curl "https://api.digitalocean.com/v2/droplets/15/actions" -d '{"type":"power_off"}' -X POST \
	-H "Authorization: Bearer 7b4fc135fbd73a260aecdbcc2472a7d41ce7607c3b780d92fc4241a0bd6ed3c7" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 7b4fc135fbd73a260aecdbcc2472a7d41ce7607c3b780d92fc4241a0bd6ed3c7
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
X-RateLimit-Reset: 1402429604
Content-Length: 212
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 14,
    "status": "in-progress",
    "type": "power_off",
    "started_at": "2014-06-10T18:46:44Z",
    "completed_at": null,
    "resource_id": 15,
    "resource_type": "droplet"
  }
}
      ```
  

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

<p>The response will be a standard Droplet action:</p>

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
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>The datetime containing the time that the action was initiated.</td>
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
    curl "https://api.digitalocean.com/v2/droplets/16/actions" -d '{"type":"reboot"}' -X POST \
	-H "Authorization: Bearer cd81b26b5da0b276c942246041cbf1e241c5fd69ea4e1fc4149508b2bc68b70e" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer cd81b26b5da0b276c942246041cbf1e241c5fd69ea4e1fc4149508b2bc68b70e
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
X-RateLimit-Reset: 1402429604
Content-Length: 209
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 15,
    "status": "in-progress",
    "type": "reboot",
    "started_at": "2014-06-10T18:46:44Z",
    "completed_at": null,
    "resource_id": 16,
    "resource_type": "droplet"
  }
}
      ```
  

## Droplet Actions Member [/v2/droplets/{droplet_id}/actions/{droplet_action_id}]

### Droplet Actions Retrieve a Droplet Action [GET]

<p>To retrieve a Droplet action, send a GET request to <code>/v2/droplets/$DROPLET_ID/actions/$ACTION_ID</code>.</p>

<p>A Droplet action object is an object containing the id, progress, type, and started_at attributes.  It can be used to track the completion of actions that were requested.</p>

<p>The response will be a standard Droplet action:</p>

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
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the action.  The value of this attribute will be "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>The type of action that the event is executing (reboot, power_off, etc.).</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>The datetime containing the time that the action was initiated.</td>
        </tr>
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/droplets/17/actions/16" -X GET \
	-H "Authorization: Bearer c5c45094bb9abb542277d5c3d8f6265db81fe02e94a6ee64321faaa908262b93"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer c5c45094bb9abb542277d5c3d8f6265db81fe02e94a6ee64321faaa908262b93
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429604
Content-Length: 206
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 16,
    "status": "in-progress",
    "type": "create",
    "started_at": "2014-06-10T18:46:44Z",
    "completed_at": null,
    "resource_id": null,
    "resource_type": null
  }
}
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
      <td><strong>progress</strong></td>
      <td><em>string</em></td>
      <td>The current progress of the image action.  This will be either "in-progress", "completed", or "errored".</td>
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
      <td><em>datetime</em></td>
      <td>This represents the time that the image action was initiated.</td>
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
            <td>The sizes slug that represents the resize target.</td>
            <td>true</td>
        </tr>
    </tbody>
</table>

The response will contain the image action:

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
            <td>A unique numeric ID that can be used to identify and reference an image action event.</td>
        </tr>
        <tr>
            <td>progress</td>
            <td>String</td>
            <td>The current progress of the image action.  This will be either "in-progress", "completed", or "errored".</td>
        </tr>
        <tr>
            <td>type</td>
            <td>String</td>
            <td>This is the type of the image action that the JSON object represents.</td>
        </tr>
        <tr>
            <td>started_at</td>
            <td>Datetime</td>
            <td>This represents the time that the image action was initiated.</td>
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
    curl "https://api.digitalocean.com/v2/images/119192819/actions" -d '{"type":"transfer","region":"sfo1"}' -X POST \
	-H "Authorization: Bearer 93d482b57a2aa692adb0cbba50df28133fb3777c2349b8eefb2a1f9262c7430c" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 93d482b57a2aa692adb0cbba50df28133fb3777c2349b8eefb2a1f9262c7430c
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
X-RateLimit-Reset: 1402429600
Content-Length: 212
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 2,
    "status": "in-progress",
    "type": "transfer",
    "started_at": "2014-06-10T18:46:40Z",
    "completed_at": null,
    "resource_id": null,
    "resource_type": "backend"
  }
}
      ```
  

## Image Actions Member [/v2/images/{image_id}/actions/{image_action_id}]

### Image Actions Retrieve an existing Image Action [GET]



**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/images/119192818/actions/1" -X GET \
	-H "Authorization: Bearer 8592d2a9eaf03bf5720ad4b540a1a3d220574a5882ecd73881bdc130c98e33f2"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 8592d2a9eaf03bf5720ad4b540a1a3d220574a5882ecd73881bdc130c98e33f2
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429600
Content-Length: 207
      ```

  
    - Body

      ```json
      {
  "action": {
    "id": 1,
    "status": "in-progress",
    "type": "transfer",
    "started_at": "2014-06-10T18:46:40Z",
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
      <td>This attribute describes the base distribution used for this image.  This will not contain release information, but only a simple string like "Ubuntu".</td>
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
  </tbody>
</table>

## Images Collection [/v2/images]

### Images List a
    ll Images [GET]

<p>To list all of the images available on your account, send a GET request to <code>/v2/images</code>.</p>

<p>The response will be an array of image objects.  The objects will each contain the standard image attributes:</p>

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
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/images/" -X GET \
	-H "Authorization: Bearer 2722e05df7b1e09d6bd27f895f8895bd76caebeeac2daf65b2e53880238c6c88"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 2722e05df7b1e09d6bd27f895f8895bd76caebeeac2daf65b2e53880238c6c88
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429600
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
      "id": 119192820,
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

<p>The response will be an image object containing the standard image attributes:</p>

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
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/images/119192821" -X GET \
	-H "Authorization: Bearer ad6768b9beea9cdbaf6553b1afd62a2c34a2baa198a1e56effd41203b78b44b6"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer ad6768b9beea9cdbaf6553b1afd62a2c34a2baa198a1e56effd41203b78b44b6
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429601
Content-Length: 171
      ```

  
    - Body

      ```json
      {
  "image": {
    "id": 119192821,
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

<p>The response will be an image object containing the standard image attributes:</p>

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
    </tbody>
</table>


**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/images/ubuntu1304" -X GET \
	-H "Authorization: Bearer fac69fb31340e856f9d803ff19c39a7b14efb869824ed725c36064e6259b529b"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer fac69fb31340e856f9d803ff19c39a7b14efb869824ed725c36064e6259b529b
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429601
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

<p>The response will be an image object containing the standard image attributes:</p>

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
    curl "https://api.digitalocean.com/v2/images/119192823" -d '{"name":"New Image Name"}' -X PUT \
	-H "Authorization: Bearer a1eeb49c2210d8faf6b046b40f350475b5ab55067af699ebd830c68d99dbab7c" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer a1eeb49c2210d8faf6b046b40f350475b5ab55067af699ebd830c68d99dbab7c
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
X-RateLimit-Reset: 1402429601
Content-Length: 173
      ```

  
    - Body

      ```json
      {
  "image": {
    "id": 119192823,
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
  

### Images Delete an Image [DELETE]

<p>To delete an image, send a DELETE request to <code>/v2/images/$IMAGE_ID</code>.</p>

<p>A status of 204 will be given.  This indicates that the request was processed successfully, but that no response body is needed.</p>


**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/images/119192824" -d '' -X DELETE \
	-H "Authorization: Bearer ac369f1ff107a08085e8d1a913e2d8d7af5247c30a8ee4def2cf2c37af6d5171" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer ac369f1ff107a08085e8d1a913e2d8d7af5247c30a8ee4def2cf2c37af6d5171
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429601
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

<p>To retrieve a list of all of the domains in your account, send a GET request to <code>/v2/domains</code>.</p>

An array of Domain objects will be returned, each of which contain the standard domain attributes:

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
    curl "https://api.digitalocean.com/v2/account/keys" -X GET \
	-H "Authorization: Bearer b11803326e3ed7a92f11f077e407bb734fd759ad7551eb88ba0c4dfba601fab0"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer b11803326e3ed7a92f11f077e407bb734fd759ad7551eb88ba0c4dfba601fab0
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429605
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

<p>The response will contain the standard attributes associated with a domain:</p>

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
    curl "https://api.digitalocean.com/v2/account/keys" -d '{
  "name": "Example Key",
  "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com"
}' -X POST \
	-H "Authorization: Bearer 49c730607201b00df1435678388e85acfa3dfb1c11495dc5cc161028a15ea9cc" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 49c730607201b00df1435678388e85acfa3dfb1c11495dc5cc161028a15ea9cc
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
X-RateLimit-Reset: 1402429605
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

### Keys Show [GET]

<p>To get details about a specific domain, send a GET request to <code>/v2/domains/$DOMAIN_NAME</code>. </p>

The response received will contain the standard attributes defined for a domain:

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
    curl "https://api.digitalocean.com/v2/account/keys/f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2" -X GET \
	-H "Authorization: Bearer 3070ce74ef5e19062a92880b6b662bf8c2e2f37849b389ab1f3e3f9d5df1b910"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 3070ce74ef5e19062a92880b6b662bf8c2e2f37849b389ab1f3e3f9d5df1b910
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429605
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
  

### Keys Destroy [DELETE]

<p>To delete a domain, send a DELETE request to <code>/v2/domains/$DOMAIN_NAME</code>.</p>

<p>The domain will be removed from your account and a response status of 204 will be returned.  This indicates a successful request with no response body.</p>


**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/account/keys/f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2" -d '' -X DELETE \
	-H "Authorization: Bearer db0b8102d87db3da926251b621b6f4d5babd049570f462ade887e25e0360c2f5" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer db0b8102d87db3da926251b621b6f4d5babd049570f462ade887e25e0360c2f5
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429605
      ```

  

### Keys Update [PUT]

Update a Key
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
    curl "https://api.digitalocean.com/v2/account/keys/f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2" -d '{
  "name": "New Name"
}' -X PUT \
	-H "Authorization: Bearer d4b75b82770961c873bca4700b67d2836bff20331d889b6eb1677ff3ac87623d" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer d4b75b82770961c873bca4700b67d2836bff20331d889b6eb1677ff3ac87623d
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
X-RateLimit-Reset: 1402429605
Content-Length: 551
      ```

  
    - Body

      ```json
      {
  "ssh_key": {
    "id": 6,
    "fingerprint": "f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2",
    "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com",
    "name": "Example Key"
  }
}
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

The response will be an array of region objects, each of which will contain the standard region attributes:

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
    curl "https://api.digitalocean.com/v2/regions" -X GET \
	-H "Authorization: Bearer 71273ab1bb6f30e329c823e60afd7577fdc59117ea1eaa35ddcb9fd0f6d5c36e"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 71273ab1bb6f30e329c823e60afd7577fdc59117ea1eaa35ddcb9fd0f6d5c36e
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429599
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
      "slug": "ams4",
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

<p>The response will be an array of size objects each of which contain the standard sizes attributes:</p>

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
    curl "https://api.digitalocean.com/v2/sizes" -X GET \
	-H "Authorization: Bearer 665928be91e83243214549541e47c86a123ca911794cc1482b4d59c3c2c993a6"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 665928be91e83243214549541e47c86a123ca911794cc1482b4d59c3c2c993a6
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1402429599
Content-Length: 561
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
        "br1",
        "sfo1",
        "ams4"
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
        "br1",
        "sfo1",
        "ams4"
      ]
    }
  ]
}
      ```
  

