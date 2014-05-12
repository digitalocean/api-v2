---
title: DigitalOcean API v2
layout: api_v2
---

### Authentication

OAuth is used to authorize and revoke access to resources managed by the API. *Full
OAuth documentation will be available in a separate document.* There are two ways to use an OAuth
access token once you have one.

#### Bearer Authorization Header

    $ curl -H "Authorization: Bearer $ACCESS_TOKEN" https://api.digitalocean.com

#### Basic Authentication

    $ curl -u "$ACCESS_TOKEN:" https://api.digitalocean.com

For personal and development purposes, you can create a personal access token in the API control
panel and use it like a regular OAuth token.

### Curl Examples

Curl examples used in this documentation are provided to facilitate experimentation. Variable values are represented as `$SOMETHING` so that you can manipulate them using environment variables. Examples use the `-n` option to fetch credentials from a `~/.netrc` file, which should include an entry for api.digitalocean.com similar to the following:

    machine api.digitalocean.com
      login {your-oauth-token}
      password x

### Errors

Failing responses will have an appropriate [HTTP status](https://github.com/for-GET/know-your-http-well/blob/master/status-codes.md) and a JSON body containing more details about the error.

#### Example Error Response


    HTTP/1.1 403 Forbidden

    {
      "error":       "forbidden",
      "description": "You do not have access for the attempted action."
    }

### Methods

<table>
  <thead>
    <tr>
      <th>Method</th>
      <th>Usage</th>
    </tr>
  </thead>
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
      <td>PUT</td>
      <td>used for updating existing objects</td>
    </tr>
    <tr>
      <td>POST</td>
      <td>used for creating new objects</td>
    </tr>
  </tbody>
</table>

### Parameters

Values that can be provided for an action are divided between optional and required values. The expected type for each value is specified. Parameters should be JSON encoded and passed in the request body, however, in many cases you can use regular query parameters or form parameters. For example, these two requests are equivalent:

    $ curl -n -X PATCH https://api.digitalocean.com/v2/domains/$DOMAIN_NAME/records/$DOMAIN_RECORD_ID \
          -H "Content-Type: application/json" \
          -d '{"type":"A","name":"www","data":"127.0.0.1"}'


    $ curl -n -X PATCH https://api.digitalocean.com/v2/domains/$DOMAIN_NAME/records/$DOMAIN_RECORD_ID \
          -F "type=A" \
          -F "name=www" \
          -F "data=127.0.0.1"

# Domain Records

Domain records are the DNS records for a domain.

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
      <td>unique identifier for domain records</td>
      <td><code>32</code></td>
    </tr>
    <tr>
      <td><strong>type</strong></td>
      <td><em>string</em></td>
      <td>type of the DNS record (ex: A, CNAME, TXT, ...)</td>
      <td><code>CNAME</code></td>
    </tr>
    <tr>
      <td><strong>name</strong></td>
      <td><em>string</em></td>
      <td>name to use for the DNS record</td>
      <td><code>subdomain</code></td>
    </tr>
    <tr>
      <td><strong>data</strong></td>
      <td><em>string</em></td>
      <td>value to use for the DNS record</td>
      <td><code>@</code></td>
    </tr>
    <tr>
      <td><strong>priority</strong></td>
      <td><em>nullable integer</em></td>
      <td>priority for SRV records</td>
      <td><code>100</code></td>
    </tr>
    <tr>
      <td><strong>port</strong></td>
      <td><em>nullable integer</em></td>
      <td>port for SRV records</td>
      <td><code>12345</code></td>
    </tr>
    <tr>
      <td><strong>weight</strong></td>
      <td><em>nullable integer</em></td>
      <td>weight for SRV records</td>
      <td><code>100</code></td>
    </tr>
  </tbody>
</table>

## Domain Records Collection [/v2/domains/{domain_name}/records]


### Domain Records List [GET]

Lists all Domain Records for a Domain



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com/records" -X GET \
    	-H "Authorization: Bearer e0e45f8e01d2b8bc59825c9ac4691c2c6760d65ccdf69bfce0ef379c98e214b9"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer e0e45f8e01d2b8bc59825c9ac4691c2c6760d65ccdf69bfce0ef379c98e214b9
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927300
      Content-Length: 508
      ```
  
    - Body

      ```json
      [
        {
          "id": 21,
          "type": "A",
          "name": "@",
          "data": "8.8.8.8",
          "priority": null,
          "port": null,
          "weight": null
        },
        {
          "id": 22,
          "type": "NS",
          "name": null,
          "data": "NS1.DIGITALOCEAN.COM.",
          "priority": null,
          "port": null,
          "weight": null
        },
        {
          "id": 23,
          "type": "NS",
          "name": null,
          "data": "NS2.DIGITALOCEAN.COM.",
          "priority": null,
          "port": null,
          "weight": null
        },
        {
          "id": 24,
          "type": "NS",
          "name": null,
          "data": "NS3.DIGITALOCEAN.COM.",
          "priority": null,
          "port": null,
          "weight": null
        },
        {
          "id": 25,
          "type": "CNAME",
          "name": "example",
          "data": "@",
          "priority": null,
          "port": null,
          "weight": null
        }
      ]
      ```
  

## Domain Records Member [/v2/domains/{domain_name}/records/{record_id}]


### Domain Records Show [GET]

Shows a Domain Record



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com/records/5" -X GET \
    	-H "Authorization: Bearer 1a8b514507445fb1ac319ed54f1858f3b51758051b93f46c11da93dc366b341f"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 1a8b514507445fb1ac319ed54f1858f3b51758051b93f46c11da93dc366b341f
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927299
      Content-Length: 93
      ```
  
    - Body

      ```json
      {
        "id": 5,
        "type": "CNAME",
        "name": "example",
        "data": "@",
        "priority": null,
        "port": null,
        "weight": null
      }
      ```
  


### Domain Records Update [PUT]

Updating a Domain Record


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
    curl "https://api.digitalocean.com/v2/domains/example.com/records/10" -d '{
      "name": "new_name"
    }' -X PUT \
    	-H "Authorization: Bearer 9f41fddd1bfe2602afbf83d3c79ca1b5c99002b34fd78ff167ef9b2ba3f149a8" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 9f41fddd1bfe2602afbf83d3c79ca1b5c99002b34fd78ff167ef9b2ba3f149a8
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
      X-RateLimit-Reset: 1399927299
      Content-Length: 95
      ```
  
    - Body

      ```json
      {
        "id": 10,
        "type": "CNAME",
        "name": "new_name",
        "data": "@",
        "priority": null,
        "port": null,
        "weight": null
      }
      ```
  


### Domain Records Create [POST]

Creating a Domain Record for a Domain


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
    curl "https://api.digitalocean.com/v2/domains/example.com/records/15" -d '{
      "name": "subdomain",
      "data": "2001:db8::ff00:42:8329",
      "type": "AAAA"
    }' -X POST \
    	-H "Authorization: Bearer de17dfb014270e7e67f4ea657649176f3a9ae9398968be8678d4c606de720f59" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer de17dfb014270e7e67f4ea657649176f3a9ae9398968be8678d4c606de720f59
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
      X-RateLimit-Reset: 1399927300
      Content-Length: 82
      ```
  
    - Body

      ```json
      {
        "id": "not_found",
        "message": "The resource you were accessing could not be found."
      }
      ```
  


### Domain Records Destroy [DELETE]

Destroying a Domain Record



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com/records/20" -d '' -X DELETE \
    	-H "Authorization: Bearer 50faa3183c4b99a823a16b23bd9c25d65196140c3a113b4ad9823e2e9d0481a3" \
    	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 50faa3183c4b99a823a16b23bd9c25d65196140c3a113b4ad9823e2e9d0481a3
      Content-Type: application/x-www-form-urlencoded
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927300
      Content-Length: 94
      ```
  
    - Body

      ```json
      {
        "id": 20,
        "type": "CNAME",
        "name": "example",
        "data": "@",
        "priority": null,
        "port": null,
        "weight": null
      }
      ```
  
# Droplet

Droplets are VMs in the DigitalOcean cloud.

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
      <td>unique identifier for droplets</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>name</strong></td>
      <td><em>string</em></td>
      <td>name used to identify a droplet</td>
      <td><code>my-droplet</code></td>
    </tr>
    <tr>
      <td><strong>region</strong></td>
      <td><em>object</em></td>
      <td>region the droplet is present in</td>
      <td><code>{"slug":"nyc1","name":"New York","sizes":["1024mb","512mb"],"available":true}</code></td>
    </tr>
    <tr>
      <td><strong>image</strong></td>
      <td><em>object</em></td>
      <td>image used for droplet</td>
      <td><code>{"id":119192818,"name":"Ubuntu 13.04","distribution":"ubuntu","slug":null,"public":true,"regions":["nyc1"]}</code></td>
    </tr>
    <tr>
      <td><strong>size</strong></td>
      <td><em>object</em></td>
      <td>size of the droplet</td>
      <td><code>{"slug":"512mb","memory":512,"vcpus":1,"disk":20,"transfer":null,"price_monthly":"5.0","price_hourly":"0.00744","regions":["nyc1","sfo1","ams4"]}</code></td>
    </tr>
    <tr>
      <td><strong>networks</strong></td>
      <td><em>array</em></td>
      <td>networks of the droplet</td>
      <td><code>[{"ip_address":"192.168.1.2", "netmask":"192.168.1.1", "gateway":"255.255.255.0"}]</code></td>
    </tr>
    <tr>
      <td><strong>backups</strong></td>
      <td><em>array</em></td>
      <td>backup images of the droplet</td>
      <td><code>[{"slug":"512mb","memory":512,"vcpus":1,"disk":20,"transfer":null,"price_monthly":"5.0","price_hourly":"0.00744","regions":["nyc1","sfo1","ams4"]}]</code></td>
    </tr>
    <tr>
      <td><strong>snapshots</strong></td>
      <td><em>array</em></td>
      <td>snapshot images of the droplet</td>
      <td><code>[{"slug":"512mb","memory":512,"vcpus":1,"disk":20,"transfer":null,"price_monthly":"5.0","price_hourly":"0.00744","regions":["nyc1","sfo1","ams4"]}]</code></td>
    </tr>
    <tr>
      <td><strong>locked</strong></td>
      <td><em>boolean</em></td>
      <td>whether operations are currently permitted</td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><strong>status</strong></td>
      <td><em>string</em></td>
      <td>current status of the droplet</td>
      <td><code>online</code></td>
    </tr>
  </tbody>
</table>

## Droplet Collection [/v2/droplets]


### Droplet Create [POST]

Creates a Droplet


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
  
  </tbody>
</table>


**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets" -d '{
      "name": "My-Droplet",
      "region": "nyc1",
      "size": "512mb",
      "image": 119192818
    }' -X POST \
    	-H "Authorization: Bearer a84b351c9945260b789343fa3ba3b4da102fee72081fbbefebf4858dbdff72d2" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer a84b351c9945260b789343fa3ba3b4da102fee72081fbbefebf4858dbdff72d2
      Content-Type: application/json
      ```
  
    - Body

      ```json
      {
        "name": "My-Droplet",
        "region": "nyc1",
        "size": "512mb",
        "image": 119192818
      }
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927300
      Link: <http://example.org/v2/droplets/1/actions/1>; rel="monitor"
      Content-Length: 456
      ```
  
    - Body

      ```json
      {
        "id": 1,
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
          "id": 119192818,
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
            "sfo1",
            "ams4"
          ]
        },
        "backups": [
      
        ],
        "snapshots": [
      
        ],
        "locked": false,
        "status": "new",
        "networks": [
      
        ]
      }
      ```
  


### Droplet List [GET]

Lists all Droplets



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets" -X GET \
    	-H "Authorization: Bearer 8229535986103aba5f220f779a7b7e36b25cda1157acd70db15d949efb04c62c"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 8229535986103aba5f220f779a7b7e36b25cda1157acd70db15d949efb04c62c
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927300
      Total: 1
      Content-Length: 475
      ```
  
    - Body

      ```json
      [
        {
          "id": 2,
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
              "sfo1",
              "ams4"
            ]
          },
          "backups": [
      
          ],
          "snapshots": [
      
          ],
          "locked": false,
          "status": "active",
          "networks": [
      
          ]
        }
      ]
      ```
  

## Droplet Member [/v2/droplets/{droplet_id}]


### Droplet Destroy [DELETE]

Destroys a given Droplet



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/3" -d '' -X DELETE \
    	-H "Authorization: Bearer e1c9e0fd39202bda8ab2af3abb04e4c9fe2867eae90671c94e206da4d83034d2" \
    	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer e1c9e0fd39202bda8ab2af3abb04e4c9fe2867eae90671c94e206da4d83034d2
      Content-Type: application/x-www-form-urlencoded
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: text/html; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927301
      Content-Length: 1
      ```
  
# Keys

Keys are your public SSH keys that you can use to access Droplets.

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
      <td>unique identifier of keys</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>name</strong></td>
      <td><em>string</em></td>
      <td>display name of the key</td>
      <td><code>my key</code></td>
    </tr>
    <tr>
      <td><strong>fingerprint</strong></td>
      <td><em>string</em></td>
      <td>fingerprint generated from the key</td>
      <td><code>f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2</code></td>
    </tr>
    <tr>
      <td><strong>public_key</strong></td>
      <td><em>string</em></td>
      <td>full public key string </td>
      <td><code>ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com</code></td>
    </tr>
  </tbody>
</table>

## Keys Collection [/v2/account/keys]


### Keys List [GET]

Lists all Keys



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/account/keys" -X GET \
    	-H "Authorization: Bearer d70f9ede460f17c5ab058fe35d8b406d096e3941d6a666af91a88dab4ecc7c5b"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer d70f9ede460f17c5ab058fe35d8b406d096e3941d6a666af91a88dab4ecc7c5b
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927301
      Content-Length: 508
      ```
  
    - Body

      ```json
      [
        {
          "id": 2,
          "fingerprint": "f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2",
          "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com",
          "name": "Example Key"
        }
      ]
      ```
  


### Keys Create [POST]

Creates a Key


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
    	-H "Authorization: Bearer 1fc555df694876faf25391f7fbbbff32cefe313e3ecccb46cd17be7cc84650e6" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 1fc555df694876faf25391f7fbbbff32cefe313e3ecccb46cd17be7cc84650e6
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
      X-RateLimit-Reset: 1399927301
      Content-Length: 506
      ```
  
    - Body

      ```json
      {
        "id": 4,
        "fingerprint": "f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2",
        "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com",
        "name": "Example Key"
      }
      ```
  

## Keys Member [/v2/account/keys/{id_or_fingerprint}]


### Keys Show [GET]

Shows a Key



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/account/keys/f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2" -X GET \
    	-H "Authorization: Bearer 5e01408df76467e169c3770ca9a1e844e890cebcc817f371e915b8b04e851fb8"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 5e01408df76467e169c3770ca9a1e844e890cebcc817f371e915b8b04e851fb8
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927301
      Content-Length: 506
      ```
  
    - Body

      ```json
      {
        "id": 1,
        "fingerprint": "f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2",
        "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com",
        "name": "Example Key"
      }
      ```
  


### Keys Destroy [DELETE]

Permanently destroys a Key



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/account/keys/f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2" -d '' -X DELETE \
    	-H "Authorization: Bearer 61b201aba729a90482b363fc283cae3670e4c9b4ed4dabe3cf35e250c0068d1e" \
    	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 61b201aba729a90482b363fc283cae3670e4c9b4ed4dabe3cf35e250c0068d1e
      Content-Type: application/x-www-form-urlencoded
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927301
      Content-Length: 506
      ```
  
    - Body

      ```json
      {
        "id": 5,
        "fingerprint": "f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2",
        "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com",
        "name": "Example Key"
      }
      ```
  
# Domains

Domains are managed domain names that DigitalOcean provides DNS for.

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
      <td>name of the domain</td>
      <td><code>example.com</code></td>
    </tr>
    <tr>
      <td><strong>ttl</strong></td>
      <td><em>integer</em></td>
      <td>time to live for records on this domain</td>
      <td><code>1800</code></td>
    </tr>
    <tr>
      <td><strong>zone_file</strong></td>
      <td><em>string</em></td>
      <td>contents of the zone file used by the DNS server</td>
      <td><code>$TTL\t600\n@\t\tIN\tSOA ...</code></td>
    </tr>
  </tbody>
</table>

## Domains Collection [/v2/domains]


### Domains List [GET]

Lists all Domains



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/domains" -X GET \
    	-H "Authorization: Bearer 564f523d380b03a485b78b3985601b71c8e180ed7cb40e2f74d6e98c9f8a6530"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 564f523d380b03a485b78b3985601b71c8e180ed7cb40e2f74d6e98c9f8a6530
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927302
      Total: 1
      Content-Length: 75
      ```
  
    - Body

      ```json
      [
        {
          "name": "example.com",
          "ttl": 1800,
          "zone_file": "Example zone file text..."
        }
      ]
      ```
  


### Domains Create [POST]

Creates a Domain


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
    	-H "Authorization: Bearer 2070bfcccf5c47a126f88f808cdc0a51a696e3b1babc781476d549fdd759a34c" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 2070bfcccf5c47a126f88f808cdc0a51a696e3b1babc781476d549fdd759a34c
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
      X-RateLimit-Reset: 1399927302
      Content-Length: 50
      ```
  
    - Body

      ```json
      {
        "name": "example.com",
        "ttl": 1800,
        "zone_file": null
      }
      ```
  

## Domains Member [/v2/domains/{domain_name}]


### Domains Show [GET]

Shows the Domain



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com" -X GET \
    	-H "Authorization: Bearer 0b3fa718d15d87d377305d0e516e8f6e285db132003b75bb071501a6a5371652"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 0b3fa718d15d87d377305d0e516e8f6e285db132003b75bb071501a6a5371652
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927301
      Content-Length: 73
      ```
  
    - Body

      ```json
      {
        "name": "example.com",
        "ttl": 1800,
        "zone_file": "Example zone file text..."
      }
      ```
  


### Domains Delete [DELETE]

Permanently deletes the Domain



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com" -d '' -X DELETE \
    	-H "Authorization: Bearer a1177aef153e537500a6b478f17618af5c7d6ceb2ffcc3d301a59513d15ce4e7" \
    	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer a1177aef153e537500a6b478f17618af5c7d6ceb2ffcc3d301a59513d15ce4e7
      Content-Type: application/x-www-form-urlencoded
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927302
      Content-Length: 73
      ```
  
    - Body

      ```json
      {
        "name": "example.com",
        "ttl": 1800,
        "zone_file": "Example zone file text..."
      }
      ```
  
# Images

Images are either snapshots or backups you've made, or public images of applications or base systems.

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
      <td>unique identifier of image</td>
      <td><code>1234</code></td>
    </tr>
    <tr>
      <td><strong>name</strong></td>
      <td><em>string</em></td>
      <td>display name of the image</td>
      <td><code>my image</code></td>
    </tr>
    <tr>
      <td><strong>distribution</strong></td>
      <td><em>string</em></td>
      <td>name of the linux distribution this image is based on</td>
      <td><code>ubuntu</code></td>
    </tr>
    <tr>
      <td><strong>slug</strong></td>
      <td><em>nullable string</em></td>
      <td>slug of the image</td>
      <td><code>ubuntu12.04</code></td>
    </tr>
    <tr>
      <td><strong>public</strong></td>
      <td><em>boolean</em></td>
      <td>whether accessible by all accounts or just your account</td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><strong>regions</strong></td>
      <td><em>array</em></td>
      <td>region slugs the image is available in</td>
      <td><code>["nyc1", "sfo1"]</code></td>
    </tr>
  </tbody>
</table>

## Images Collection [/v2/images]


### Images List [GET]

Lists all images a user has access to.



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/images/" -X GET \
    	-H "Authorization: Bearer 806691a47bcea850522cc78b0293a01ff7e126a492dac45c34c8705b3b4fd6eb"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 806691a47bcea850522cc78b0293a01ff7e126a492dac45c34c8705b3b4fd6eb
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927303
      Total: 2
      Content-Length: 222
      ```
  
    - Body

      ```json
      [
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
          "id": 119192823,
          "name": "Ubuntu 13.04",
          "distribution": null,
          "slug": null,
          "public": false,
          "regions": [
            "nyc1"
          ]
        }
      ]
      ```
  

## Images Member [/v2/images/{image_id}]


### Images Show with ID [GET]

Shows all of the info for a given image.



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/images/119192819" -X GET \
    	-H "Authorization: Bearer a7552611e90f9884921515543dfcbd1adffb17f19ef91adfa8e0e5f9067bb373"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer a7552611e90f9884921515543dfcbd1adffb17f19ef91adfa8e0e5f9067bb373
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927302
      Content-Length: 104
      ```
  
    - Body

      ```json
      {
        "id": 119192819,
        "name": "Ubuntu 13.04",
        "distribution": null,
        "slug": null,
        "public": false,
        "regions": [
          "nyc1"
        ]
      }
      ```
  


### Images Update [PUT]

Updates an image with the provided parameters.


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
    curl "https://api.digitalocean.com/v2/images/119192820" -d '{"name":"New Image Name"}' -X PUT \
    	-H "Authorization: Bearer 550962b4f9e6fbc5e82e8ebf0860744c6f358f896f6c8c0f052007e74e9c56e1" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 550962b4f9e6fbc5e82e8ebf0860744c6f358f896f6c8c0f052007e74e9c56e1
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
      X-RateLimit-Reset: 1399927302
      Content-Length: 106
      ```
  
    - Body

      ```json
      {
        "id": 119192820,
        "name": "New Image Name",
        "distribution": null,
        "slug": null,
        "public": false,
        "regions": [
          "nyc1"
        ]
      }
      ```
  


### Images Show with Slug [GET]

Shows all of the info for a given public image.



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/images/ubuntu1304" -X GET \
    	-H "Authorization: Bearer f893f62493e3f0b47310153bbf5253cd7d16da17b1d05072587dade778e18467"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer f893f62493e3f0b47310153bbf5253cd7d16da17b1d05072587dade778e18467
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927302
      Content-Length: 115
      ```
  
    - Body

      ```json
      {
        "id": 119192817,
        "name": "Ubuntu 13.04",
        "distribution": "ubuntu",
        "slug": "ubuntu1304",
        "public": true,
        "regions": [
          "nyc1"
        ]
      }
      ```
  


### Images Delete [DELETE]

Permanently deletes an image.



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/images/119192822" -d '' -X DELETE \
    	-H "Authorization: Bearer 8b91adeee3dfecf6ad67edc0bb7744a9f621c0ba908245ff8b0359a8fd794100" \
    	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 8b91adeee3dfecf6ad67edc0bb7744a9f621c0ba908245ff8b0359a8fd794100
      Content-Type: application/x-www-form-urlencoded
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927302
      Content-Length: 104
      ```
  
    - Body

      ```json
      {
        "id": 119192822,
        "name": "Ubuntu 13.04",
        "distribution": null,
        "slug": null,
        "public": false,
        "regions": [
          "nyc1"
        ]
      }
      ```
  
# Image Actions

Image actions are actions that can be executed on an image.

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
      <td><strong>progress</strong></td>
      <td><em>string</em></td>
      <td>current progress of the action (in-progress or completed)</td>
      <td><code>in-progress</code></td>
    </tr>
    <tr>
      <td><strong>type</strong></td>
      <td><em>string</em></td>
      <td>action type (EX: image_transfer)</td>
      <td><code>image_transfer</code></td>
    </tr>
    <tr>
      <td><strong>started_at</strong></td>
      <td><em>datetime</em></td>
      <td>date time of when the action started</td>
      <td><code>2014-05-08T19:11:41Z</code></td>
    </tr>
  </tbody>
</table>

## Image Actions Collection [/v2/images/{image_id}/actions]


### Image Actions Image Transfer [POST]





**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/images/119192825/actions" -d '{"type":"transfer","params":{"region":"sfo1"}}' -X POST \
    	-H "Authorization: Bearer 70571fd4a632073ba0ea86090a26fe8385eaa83ac108d34cc48f6f3511deceef" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 70571fd4a632073ba0ea86090a26fe8385eaa83ac108d34cc48f6f3511deceef
      Content-Type: application/json
      ```
  
    - Body

      ```json
      {
        "type": "transfer",
        "params": {
          "region": "sfo1"
        }
      }
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927303
      Content-Length: 80
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "transfer",
        "started_at": "2014-05-12T19:41:43Z"
      }
      ```
  

## Image Actions Member [/v2/images/{image_id}/actions/{image_action_id}]


### Image Actions Show Image Action [GET]





**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/images/119192824/actions/4" -X GET \
    	-H "Authorization: Bearer ac4d647d9814b2a3ef67e8877941d1b931aa4d1d6941b95c358611346b01c57d"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer ac4d647d9814b2a3ef67e8877941d1b931aa4d1d6941b95c358611346b01c57d
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927303
      Content-Length: 80
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "transfer",
        "started_at": "2014-05-12T19:41:43Z"
      }
      ```
  
# Sizes

Sizes represent possible Droplet resources.

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
      <td>unique identifier of sizes</td>
      <td><code>512mb</code></td>
    </tr>
    <tr>
      <td><strong>memory</strong></td>
      <td><em>integer</em></td>
      <td>RAM in MB</td>
      <td><code>512</code></td>
    </tr>
    <tr>
      <td><strong>vcpus</strong></td>
      <td><em>integer</em></td>
      <td>number of vcpus this size has access to</td>
      <td><code>1</code></td>
    </tr>
    <tr>
      <td><strong>disk</strong></td>
      <td><em>integer</em></td>
      <td>disk space in GB</td>
      <td><code>20</code></td>
    </tr>
    <tr>
      <td><strong>transfer</strong></td>
      <td><em>integer</em></td>
      <td>transfer bandwidth available to this size in TB</td>
      <td><code>5</code></td>
    </tr>
    <tr>
      <td><strong>price_monthly</strong></td>
      <td><em>string</em></td>
      <td>price of this size per month in USD</td>
      <td><code>5</code></td>
    </tr>
    <tr>
      <td><strong>price_hourly</strong></td>
      <td><em>string</em></td>
      <td>price of this size per hour in USD</td>
      <td><code>.00744</code></td>
    </tr>
    <tr>
      <td><strong>regions</strong></td>
      <td><em>array</em></td>
      <td>list of regions this size is available for create in</td>
      <td><code>["nyc1", "sfo1"]</code></td>
    </tr>
  </tbody>
</table>

## Sizes Collection [/v2/sizes]


### Sizes List [GET]

Lists all sizes.



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/sizes" -X GET \
    	-H "Authorization: Bearer 874471963e708603f7d6394ca774547f8bccd0e620cefd172e28916c7a94760e"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 874471963e708603f7d6394ca774547f8bccd0e620cefd172e28916c7a94760e
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927303
      Content-Length: 296
      ```
  
    - Body

      ```json
      [
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
            "sfo1",
            "ams4"
          ]
        }
      ]
      ```
  

# Regions

Sizes represent possible Droplet resources.

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
      <td>unique identifier of region</td>
      <td><code>nyc1</code></td>
    </tr>
    <tr>
      <td><strong>name</strong></td>
      <td><em>string</em></td>
      <td>display name of region</td>
      <td><code>New York 1</code></td>
    </tr>
    <tr>
      <td><strong>sizes</strong></td>
      <td><em>array</em></td>
      <td>array of sizes availabie in the region</td>
      <td><code>["512mb", "1024mb"]</code></td>
    </tr>
    <tr>
      <td><strong>available</strong></td>
      <td><em>boolean</em></td>
      <td>if new droplets can currently be created</td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><strong>transfer</strong></td>
      <td><em>integer</em></td>
      <td>transfer bandwidth available to this size in TB</td>
      <td><code>5</code></td>
    </tr>
    <tr>
      <td><strong>price_monthly</strong></td>
      <td><em>string</em></td>
      <td>price of this size per month in USD</td>
      <td><code>5</code></td>
    </tr>
    <tr>
      <td><strong>price_hourly</strong></td>
      <td><em>string</em></td>
      <td>price of this size per hour in USD</td>
      <td><code>.00744</code></td>
    </tr>
    <tr>
      <td><strong>regions</strong></td>
      <td><em>array</em></td>
      <td>list of regions this size is available for create in</td>
      <td><code>["nyc1", "sfo1"]</code></td>
    </tr>
  </tbody>
</table>

## Regions Collection [/v2/regions]


### Regions List [GET]

List all regions.



**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/regions" -X GET \
    	-H "Authorization: Bearer 5b6c37b053719f63ce7c1308e63b0a1b546a8d6f246be0f1ae9b1e7cdc09a168"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 5b6c37b053719f63ce7c1308e63b0a1b546a8d6f246be0f1ae9b1e7cdc09a168
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927303
      Content-Length: 226
      ```
  
    - Body

      ```json
      [
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
      ```
  

# Droplet Actions

Droplet actions are actions that can be executed on a droplet.

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
      <td><strong>progress</strong></td>
      <td><em>string</em></td>
      <td>current progress of the action (in-progress or completed)</td>
      <td><code>in-progress</code></td>
    </tr>
    <tr>
      <td><strong>type</strong></td>
      <td><em>string</em></td>
      <td>action type (EX: reboot, power_off, power_on ...)</td>
      <td><code>reboot</code></td>
    </tr>
    <tr>
      <td><strong>started_at</strong></td>
      <td><em>datetime</em></td>
      <td>date time of when the action started</td>
      <td><code>2014-05-08T19:11:41Z</code></td>
    </tr>
  </tbody>
</table>

## Droplet Actions Collection [/v2/droplets/{droplet_id}/actions]


### Droplet Actions Rename [POST]

Used to rename an droplet.


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
      <td>Must be 'rename'</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>params</strong></td>
      <td>Is JSON, that includes a key 'name' that contains the new name.</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>


**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/4/actions" -d '{"type":"rename","params":{"name":"Droplet-Name"}}' -X POST \
    	-H "Authorization: Bearer 0994b0deda30360111b0c7a4affed5ec30c68ddb04d79ee46565929e4a5c65b6" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 0994b0deda30360111b0c7a4affed5ec30c68ddb04d79ee46565929e4a5c65b6
      Content-Type: application/json
      ```
  
    - Body

      ```json
      {
        "type": "rename",
        "params": {
          "name": "Droplet-Name"
        }
      }
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927303
      Content-Length: 78
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "rename",
        "started_at": "2014-05-12T19:41:43Z"
      }
      ```
  


### Droplet Actions Reboot [POST]

Used to reboot a droplet.


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
      <td>Must be 'reboot'</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>


**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/5/actions" -d '{"type":"reboot"}' -X POST \
    	-H "Authorization: Bearer 4e7f5944191ca163d2ad172685008399b963af28335edd73d587d29e35a80734" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 4e7f5944191ca163d2ad172685008399b963af28335edd73d587d29e35a80734
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
      X-RateLimit-Reset: 1399927303
      Content-Length: 78
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "reboot",
        "started_at": "2014-05-12T19:41:43Z"
      }
      ```
  


### Droplet Actions Power Off [POST]

Used to power off a droplet.


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
      <td>Must be 'power_off'</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>


**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/6/actions" -d '{"type":"power_off"}' -X POST \
    	-H "Authorization: Bearer 5c90d2fea8347a868e988d8642774035e81491b0f5d212fed46bb5e92838e0c0" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 5c90d2fea8347a868e988d8642774035e81491b0f5d212fed46bb5e92838e0c0
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
      X-RateLimit-Reset: 1399927304
      Content-Length: 81
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "power_off",
        "started_at": "2014-05-12T19:41:44Z"
      }
      ```
  


### Droplet Actions Power Cycle [POST]

Used to power cycle a droplet.


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
      <td>Must be 'power_cycle'</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>


**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/7/actions" -d '{"type":"power_cycle"}' -X POST \
    	-H "Authorization: Bearer 77b29ffca6eb8344ad5c3105deee08c69f899b84fbf75047ae0227152fe2c38a" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 77b29ffca6eb8344ad5c3105deee08c69f899b84fbf75047ae0227152fe2c38a
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
      X-RateLimit-Reset: 1399927304
      Content-Length: 83
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "power_cycle",
        "started_at": "2014-05-12T19:41:44Z"
      }
      ```
  


### Droplet Actions Resize [POST]

Used to resize a droplet to a given size slug


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
      <td>Must be 'resize'</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>params</strong></td>
      <td>Is JSON, that includes a key 'size' that contains a size slug.</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>


**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/9/actions" -d '{"type":"resize","params":{"size":"1024mb"}}' -X POST \
    	-H "Authorization: Bearer 2387b5c2f7ea40c97699d584ef5192edc5e3f7a4f00dde1d05420a59d78fcb3f" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 2387b5c2f7ea40c97699d584ef5192edc5e3f7a4f00dde1d05420a59d78fcb3f
      Content-Type: application/json
      ```
  
    - Body

      ```json
      {
        "type": "resize",
        "params": {
          "size": "1024mb"
        }
      }
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927304
      Content-Length: 78
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "resize",
        "started_at": "2014-05-12T19:41:44Z"
      }
      ```
  


### Droplet Actions Rebuild [POST]

Used to rebuild a droplet from a given image id.


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
      <td>Must be 'rebuild'</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>params</strong></td>
      <td>Is JSON, that includes a key 'image' that contains an image id.</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>


**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/10/actions" -d '{"type":"rebuild","params":{"image":119192833}}' -X POST \
    	-H "Authorization: Bearer e14389603a8b65183d928c64be7132d33ad3c1f1644e5b0c0d361013c7e1338e" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer e14389603a8b65183d928c64be7132d33ad3c1f1644e5b0c0d361013c7e1338e
      Content-Type: application/json
      ```
  
    - Body

      ```json
      {
        "type": "rebuild",
        "params": {
          "image": 119192833
        }
      }
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927304
      Content-Length: 79
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "rebuild",
        "started_at": "2014-05-12T19:41:44Z"
      }
      ```
  


### Droplet Actions Power On [POST]

Used to power on a powered off droplet.


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
      <td>Must be 'power_on'</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>


**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/11/actions" -d '{"type":"power_on"}' -X POST \
    	-H "Authorization: Bearer 4433def1b614495a5a9f5931842261b1e13b8636893c48c02f5a760447f2d6c6" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 4433def1b614495a5a9f5931842261b1e13b8636893c48c02f5a760447f2d6c6
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
      X-RateLimit-Reset: 1399927304
      Content-Length: 80
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "power_on",
        "started_at": "2014-05-12T19:41:44Z"
      }
      ```
  


### Droplet Actions Restore [POST]

Used to restore a droplet from a given snapshot id.


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
      <td>Must be 'restore'</td>
      <td>true</td>
    </tr>
  
    <tr>
      <td><strong>params</strong></td>
      <td>Is JSON, that includes a key 'image' that contains an image id.</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>


**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/12/actions" -d '{"type":"restore","params":{"image":119192836}}' -X POST \
    	-H "Authorization: Bearer efbcde759ddaf5ae1bcbe42b71ad1b80f579eeee6568240f9a5f7265d5a3d71e" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer efbcde759ddaf5ae1bcbe42b71ad1b80f579eeee6568240f9a5f7265d5a3d71e
      Content-Type: application/json
      ```
  
    - Body

      ```json
      {
        "type": "restore",
        "params": {
          "image": 119192836
        }
      }
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927305
      Content-Length: 79
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "restore",
        "started_at": "2014-05-12T19:41:45Z"
      }
      ```
  


### Droplet Actions Shutdown [POST]

Used to shutdown a droplet.


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
      <td>Must be 'shutdown'</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>


**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/13/actions" -d '{"type":"shutdown"}' -X POST \
    	-H "Authorization: Bearer 933b60310680ff8869438aa08d16ee82d4bc444d84fa22affeac34ac4e713cf5" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 933b60310680ff8869438aa08d16ee82d4bc444d84fa22affeac34ac4e713cf5
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
      X-RateLimit-Reset: 1399927305
      Content-Length: 80
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "shutdown",
        "started_at": "2014-05-12T19:41:45Z"
      }
      ```
  


### Droplet Actions Password Reset [POST]

Used to reset a droplet's password


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
      <td>Must be 'password_reset'</td>
      <td>true</td>
    </tr>
  
  </tbody>
</table>


**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/14/actions" -d '{"type":"password_reset"}' -X POST \
    	-H "Authorization: Bearer 42802ddf4b3c06315817e059451d85eafb1ec156882f1225aab70a432701ee56" \
    	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 42802ddf4b3c06315817e059451d85eafb1ec156882f1225aab70a432701ee56
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
      X-RateLimit-Reset: 1399927305
      Content-Length: 86
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "password_reset",
        "started_at": "2014-05-12T19:41:45Z"
      }
      ```
  

## Droplet Actions Member [/v2/droplets/{droplet_id}/actions/{droplet_action_id}]


### Droplet Actions Show Action Status [GET]





**Example:**

  - **cURL**
    ```bash
    curl "https://api.digitalocean.com/v2/droplets/8/actions/10" -X GET \
    	-H "Authorization: Bearer 904ff1729880fbd41709fb14a4ac46b6add2ec6a92c655897e9a9c521c79edca"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 904ff1729880fbd41709fb14a4ac46b6add2ec6a92c655897e9a9c521c79edca
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
      X-RateLimit-Limit: 1200
      X-RateLimit-Remaining: 1199
      X-RateLimit-Reset: 1399927304
      Content-Length: 78
      ```
  
    - Body

      ```json
      {
        "progress": "in-progress",
        "type": "create",
        "started_at": "2014-05-12T19:41:44Z"
      }
      ```
  
