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

### Domain Records List all Domain Records [GET]

Lists all Domain Records for a Domain

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com/records" -X GET \
	-H "Authorization: Bearer 9e93325e40510c30d142ffaf0756d0f4a50aa401dd20d097897e81f75b73b961"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 9e93325e40510c30d142ffaf0756d0f4a50aa401dd20d097897e81f75b73b961
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994788
Content-Length: 750
      ```

  
    - Body

      ```json
      [
  {
    "id": 27,
    "type": "A",
    "name": "@",
    "data": "8.8.8.8",
    "priority": null,
    "port": null,
    "weight": null
  },
  {
    "id": 28,
    "type": "NS",
    "name": null,
    "data": "NS1.DIGITALOCEAN.COM.",
    "priority": null,
    "port": null,
    "weight": null
  },
  {
    "id": 29,
    "type": "NS",
    "name": null,
    "data": "NS2.DIGITALOCEAN.COM.",
    "priority": null,
    "port": null,
    "weight": null
  },
  {
    "id": 30,
    "type": "NS",
    "name": null,
    "data": "NS3.DIGITALOCEAN.COM.",
    "priority": null,
    "port": null,
    "weight": null
  },
  {
    "id": 31,
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

### Domain Records Retrieve an existing Domain Record [GET]

Shows a Domain Record

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com/records/21" -X GET \
	-H "Authorization: Bearer 63abf6f6fac5b90bf02534e8f5de25deb5bca9b51878ba63a9734681ad6e5af4"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 63abf6f6fac5b90bf02534e8f5de25deb5bca9b51878ba63a9734681ad6e5af4
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994787
Content-Length: 124
      ```

  
    - Body

      ```json
      {
  "id": 21,
  "type": "CNAME",
  "name": "example",
  "data": "@",
  "priority": null,
  "port": null,
  "weight": null
}
      ```
  

### Domain Records Create a new Domain Record [POST]

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
    curl "https://api.digitalocean.com/v2/domains/example.com/records/26" -d '{
  "name": "subdomain",
  "data": "2001:db8::ff00:42:8329",
  "type": "AAAA"
}' -X POST \
	-H "Authorization: Bearer 688df124e33bbe30b270434f461b7cdb2a0a8efa1f9ca99a90c0c9f1dd64e5e7" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 688df124e33bbe30b270434f461b7cdb2a0a8efa1f9ca99a90c0c9f1dd64e5e7
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
X-RateLimit-Reset: 1401994787
Content-Length: 82
      ```

  
    - Body

      ```json
      {"id":"not_found","message":"The resource you were accessing could not be found."}
      ```
  

### Domain Records Delete a Domain Record [DELETE]

Destroying a Domain Record

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com/records/36" -d '' -X DELETE \
	-H "Authorization: Bearer 3303b0ad67c036fb5c43018475e789f8a4b2b4ba7f7cff69f366f3ebb4aaf668" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 3303b0ad67c036fb5c43018475e789f8a4b2b4ba7f7cff69f366f3ebb4aaf668
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994788
      ```

  

### Domain Records Update a Domain Record [PUT]

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
    curl "https://api.digitalocean.com/v2/domains/example.com/records/41" -d '{
  "name": "new_name"
}' -X PUT \
	-H "Authorization: Bearer 0b33b32071c00a9e9482e1b8880e8940f24ca28c421de84eb4c0bfeac6d16bc9" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 0b33b32071c00a9e9482e1b8880e8940f24ca28c421de84eb4c0bfeac6d16bc9
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
X-RateLimit-Reset: 1401994788
Content-Length: 125
      ```

  
    - Body

      ```json
      {
  "id": 41,
  "type": "CNAME",
  "name": "new_name",
  "data": "@",
  "priority": null,
  "port": null,
  "weight": null
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

### Domains Create a new Domain [POST]

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
	-H "Authorization: Bearer 871bb31b2a4cb3389039887d9b50c1f224f609d5a48f5fbe57ca9bee024f75b2" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 871bb31b2a4cb3389039887d9b50c1f224f609d5a48f5fbe57ca9bee024f75b2
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
X-RateLimit-Reset: 1401994787
Content-Length: 64
      ```

  
    - Body

      ```json
      {
  "name": "example.com",
  "ttl": 1800,
  "zone_file": null
}
      ```
  

### Domains List all Domains [GET]

Lists all Domains

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/domains" -X GET \
	-H "Authorization: Bearer eb2111266e0d8ceb8faeb45fc5a456aac6d06ce40e560c2e9f7c97761893bdb3"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer eb2111266e0d8ceb8faeb45fc5a456aac6d06ce40e560c2e9f7c97761893bdb3
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994787
Total: 1
Content-Length: 101
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
  

## Domains Member [/v2/domains/{domain_name}]

### Domains Delete a Domain [DELETE]

Permanently deletes the Domain

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com" -d '' -X DELETE \
	-H "Authorization: Bearer c00e8e70eec65834768b80cb66d0bbe2b460f9230f69d9372237532e2ac71ba3" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer c00e8e70eec65834768b80cb66d0bbe2b460f9230f69d9372237532e2ac71ba3
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994787
      ```

  

### Domains Show [GET]

Retrieve an existing Domain

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/domains/example.com" -X GET \
	-H "Authorization: Bearer ba08be5a5ab9d76d5a1278b5c6cd2e30d2d3dc296629cab01687585ea0474f75"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer ba08be5a5ab9d76d5a1278b5c6cd2e30d2d3dc296629cab01687585ea0474f75
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994787
Content-Length: 87
      ```

  
    - Body

      ```json
      {
  "name": "example.com",
  "ttl": 1800,
  "zone_file": "Example zone file text..."
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
      <td><em>object</em></td>
      <td>v4 and v6 seperated networks</td>
      <td><code>{"v4":[{"ip_address":"127.0.0.2","netmask":"255.255.255.0","gateway":"127.0.0.1","type":"public"}],"v6":[]}</code></td>
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

### Droplet Create a new Droplet [POST]

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
  "image": 119192838
}' -X POST \
	-H "Authorization: Bearer acde17a1456875d9bd4f7b088799c94eb02170d9625edd7c5175ca813b3bdedb" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer acde17a1456875d9bd4f7b088799c94eb02170d9625edd7c5175ca813b3bdedb
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "name": "My-Droplet",
  "region": "nyc1",
  "size": "512mb",
  "image": 119192838
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994788
Link: <http://example.org/v2/droplets/13/actions/16>; rel="monitor"
Content-Length: 684
      ```

  
    - Body

      ```json
      {
  "id": 13,
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
    "id": 119192838,
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
  "networks": {
  }
}
      ```
  

### Droplet List all Droplets [GET]

Lists all Droplets

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/droplets" -X GET \
	-H "Authorization: Bearer 696febe5ee442798d5fac780036cc227493817a5d8740d957cfb8acdf3aa5081"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 696febe5ee442798d5fac780036cc227493817a5d8740d957cfb8acdf3aa5081
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994789
Total: 1
Content-Length: 1199
      ```

  
    - Body

      ```json
      [
  {
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
        "ams4",
        "sfo1"
      ]
    },
    "backups": [

    ],
    "snapshots": [

    ],
    "locked": false,
    "status": "active",
    "networks": {
      "v4": [
        {
          "ip_address": "127.0.0.3",
          "netmask": "255.255.255.0",
          "gateway": "127.0.0.4",
          "type": "public"
        }

      ],
      "v6": [
        {
          "ip_address": "2400:6180:0000:00D0:0000:0000:0009:7003",
          "cidr": 124,
          "gateway": "2400:6180:0000:00D0:0000:0000:0009:7000",
          "type": "public"
        }

      ]
    }
  }
]
      ```
  

## Droplet Member [/v2/droplets/{droplet_id}]

### Droplet Delete a Droplet [DELETE]

Deletes a given Droplet

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/droplets/12" -d '' -X DELETE \
	-H "Authorization: Bearer 9ba53a8e1482353c28d035031c3d7f26b35208f07859c84746ecc1136d1c356d" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 9ba53a8e1482353c28d035031c3d7f26b35208f07859c84746ecc1136d1c356d
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994788
      ```

  

### Droplet Retrieve an existing Droplet by id [GET]

Shows all of the info for a given Droplet.

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/droplets/14" -X GET \
	-H "Authorization: Bearer ae8f7c006e8823de4428c6bdd74539f25fcc39c540c50bd03df97a3fd1894ee9"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer ae8f7c006e8823de4428c6bdd74539f25fcc39c540c50bd03df97a3fd1894ee9
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994789
Content-Length: 1073
      ```

  
    - Body

      ```json
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
  }
}
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
      <td><strong>id</strong></td>
      <td><em>integer</em></td>
      <td>unique identifier for droplet actions</td>
      <td><code>1234</code></td>
    </tr>
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

### Droplet Actions Rename a Droplet [POST]

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
    curl "https://api.digitalocean.com/v2/droplets/1/actions" -d '{"type":"rename","params":{"name":"Droplet-Name"}}' -X POST \
	-H "Authorization: Bearer 4caf32a8e1f4ac5064c766d4249a0167cb179da7a0f0b51d41bcbd4070c273ba" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 4caf32a8e1f4ac5064c766d4249a0167cb179da7a0f0b51d41bcbd4070c273ba
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
X-RateLimit-Reset: 1401994785
Content-Length: 103
      ```

  
    - Body

      ```json
      {
  "id": 4,
  "progress": "in-progress",
  "type": "rename",
  "started_at": "2014-06-05T17:59:45Z"
}
      ```
  

### Droplet Actions Rebuild a Droplet [POST]

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
    curl "https://api.digitalocean.com/v2/droplets/2/actions" -d '{"type":"rebuild","params":{"image":119192827}}' -X POST \
	-H "Authorization: Bearer 347e89f0a2a90a8d6033cb285353afb009224a53803e69292298c0d4e40e48d2" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 347e89f0a2a90a8d6033cb285353afb009224a53803e69292298c0d4e40e48d2
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "rebuild",
  "params": {
    "image": 119192827
  }
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994785
Content-Length: 104
      ```

  
    - Body

      ```json
      {
  "id": 5,
  "progress": "in-progress",
  "type": "rebuild",
  "started_at": "2014-06-05T17:59:45Z"
}
      ```
  

### Droplet Actions Restore a Droplet [POST]

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
    curl "https://api.digitalocean.com/v2/droplets/3/actions" -d '{"type":"restore","params":{"image":119192829}}' -X POST \
	-H "Authorization: Bearer c6f8a809c05da80a8335aaec378951008455fd4af69c8d7917f2abe4a6fad544" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer c6f8a809c05da80a8335aaec378951008455fd4af69c8d7917f2abe4a6fad544
Content-Type: application/json
      ```

  
    - Body

      ```json
      {
  "type": "restore",
  "params": {
    "image": 119192829
  }
}
      ```
  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994785
Content-Length: 104
      ```

  
    - Body

      ```json
      {
  "id": 6,
  "progress": "in-progress",
  "type": "restore",
  "started_at": "2014-06-05T17:59:45Z"
}
      ```
  

### Droplet Actions Power On a Droplet [POST]

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
    curl "https://api.digitalocean.com/v2/droplets/4/actions" -d '{"type":"power_on"}' -X POST \
	-H "Authorization: Bearer 9910f13fc392e46f43802b211d7d23f12318b79e162ad51d990553bfb0412ed3" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 9910f13fc392e46f43802b211d7d23f12318b79e162ad51d990553bfb0412ed3
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
X-RateLimit-Reset: 1401994785
Content-Length: 105
      ```

  
    - Body

      ```json
      {
  "id": 7,
  "progress": "in-progress",
  "type": "power_on",
  "started_at": "2014-06-05T17:59:45Z"
}
      ```
  

### Droplet Actions Power Cycle a Droplet [POST]

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
    curl "https://api.digitalocean.com/v2/droplets/5/actions" -d '{"type":"power_cycle"}' -X POST \
	-H "Authorization: Bearer 57809603d8c0d13adcac69b9c4e034e3dde2825e6904109512a04a5a794f9dec" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 57809603d8c0d13adcac69b9c4e034e3dde2825e6904109512a04a5a794f9dec
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
X-RateLimit-Reset: 1401994785
Content-Length: 108
      ```

  
    - Body

      ```json
      {
  "id": 8,
  "progress": "in-progress",
  "type": "power_cycle",
  "started_at": "2014-06-05T17:59:45Z"
}
      ```
  

### Droplet Actions Reboot a Droplet [POST]

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
    curl "https://api.digitalocean.com/v2/droplets/6/actions" -d '{"type":"reboot"}' -X POST \
	-H "Authorization: Bearer 1d5d2039f0201d483b9588a1bcf62d1e3f5ceb65bae9758ab1e3ab4143d408db" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 1d5d2039f0201d483b9588a1bcf62d1e3f5ceb65bae9758ab1e3ab4143d408db
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
X-RateLimit-Reset: 1401994786
Content-Length: 103
      ```

  
    - Body

      ```json
      {
  "id": 9,
  "progress": "in-progress",
  "type": "reboot",
  "started_at": "2014-06-05T17:59:46Z"
}
      ```
  

### Droplet Actions Resize a Droplet [POST]

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
    curl "https://api.digitalocean.com/v2/droplets/8/actions" -d '{"type":"resize","params":{"size":"1024mb"}}' -X POST \
	-H "Authorization: Bearer feb77ba228187647882c0f731093d9f480ef23b7e9f29d37c2f1abcec33a4a38" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer feb77ba228187647882c0f731093d9f480ef23b7e9f29d37c2f1abcec33a4a38
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
X-RateLimit-Reset: 1401994786
Content-Length: 104
      ```

  
    - Body

      ```json
      {
  "id": 11,
  "progress": "in-progress",
  "type": "resize",
  "started_at": "2014-06-05T17:59:46Z"
}
      ```
  

### Droplet Actions Password Reset a Droplet [POST]

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
    curl "https://api.digitalocean.com/v2/droplets/9/actions" -d '{"type":"password_reset"}' -X POST \
	-H "Authorization: Bearer c0e76023d2a581465a5d32c0c94f91a05f40e1edf1349cc3db9b05e4fb3f4947" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer c0e76023d2a581465a5d32c0c94f91a05f40e1edf1349cc3db9b05e4fb3f4947
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
X-RateLimit-Reset: 1401994786
Content-Length: 112
      ```

  
    - Body

      ```json
      {
  "id": 12,
  "progress": "in-progress",
  "type": "password_reset",
  "started_at": "2014-06-05T17:59:46Z"
}
      ```
  

### Droplet Actions Shutdown a Droplet [POST]

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
    curl "https://api.digitalocean.com/v2/droplets/10/actions" -d '{"type":"shutdown"}' -X POST \
	-H "Authorization: Bearer 51274b81133758fc409db912eb09ac943b080e44d02aa57f1899d845afbf8a19" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 51274b81133758fc409db912eb09ac943b080e44d02aa57f1899d845afbf8a19
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
X-RateLimit-Reset: 1401994786
Content-Length: 106
      ```

  
    - Body

      ```json
      {
  "id": 13,
  "progress": "in-progress",
  "type": "shutdown",
  "started_at": "2014-06-05T17:59:46Z"
}
      ```
  

### Droplet Actions Power Off a Droplet [POST]

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
    curl "https://api.digitalocean.com/v2/droplets/11/actions" -d '{"type":"power_off"}' -X POST \
	-H "Authorization: Bearer b8cf67bde5abc9ffd3992a1683dd02ffe585a6c45cb7496090493342b0575396" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer b8cf67bde5abc9ffd3992a1683dd02ffe585a6c45cb7496090493342b0575396
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
X-RateLimit-Reset: 1401994786
Content-Length: 107
      ```

  
    - Body

      ```json
      {
  "id": 14,
  "progress": "in-progress",
  "type": "power_off",
  "started_at": "2014-06-05T17:59:46Z"
}
      ```
  

## Droplet Actions Member [/v2/droplets/{droplet_id}/actions/{droplet_action_id}]

### Droplet Actions Retrieve a Droplet Action [GET]



**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/droplets/7/actions/10" -X GET \
	-H "Authorization: Bearer 44435f01f059dd4a6cd5939bdf3c57da3eb4cae279d85815f92c39e62121b2a9"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 44435f01f059dd4a6cd5939bdf3c57da3eb4cae279d85815f92c39e62121b2a9
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994786
Content-Length: 104
      ```

  
    - Body

      ```json
      {
  "id": 10,
  "progress": "in-progress",
  "type": "create",
  "started_at": "2014-06-05T17:59:46Z"
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
      <td><strong>id</strong></td>
      <td><em>integer</em></td>
      <td>unique identifier for image actions</td>
      <td><code>1234</code></td>
    </tr>
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

### Image Actions Transfer an Image [POST]



**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/images/119192819/actions" -d '{"type":"transfer","params":{"region":"sfo1"}}' -X POST \
	-H "Authorization: Bearer ea0471d88884020c617073e36f05a12da5611aebf2c2c92313c1a25f48631761" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer ea0471d88884020c617073e36f05a12da5611aebf2c2c92313c1a25f48631761
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
X-RateLimit-Reset: 1401994784
Content-Length: 105
      ```

  
    - Body

      ```json
      {
  "id": 2,
  "progress": "in-progress",
  "type": "transfer",
  "started_at": "2014-06-05T17:59:44Z"
}
      ```
  

## Image Actions Member [/v2/images/{image_id}/actions/{image_action_id}]

### Image Actions Retrieve an existing Image Action [GET]



**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/images/119192818/actions/1" -X GET \
	-H "Authorization: Bearer 1fe0e68d071eb257d0b4e7cd35e4fa1bf76993d0f236b11e4c656a625bfbcb8b"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 1fe0e68d071eb257d0b4e7cd35e4fa1bf76993d0f236b11e4c656a625bfbcb8b
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994784
Content-Length: 105
      ```

  
    - Body

      ```json
      {
  "id": 1,
  "progress": "in-progress",
  "type": "transfer",
  "started_at": "2014-06-05T17:59:44Z"
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

### Images List all Images [GET]

Lists all images a user has access to.

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/images/" -X GET \
	-H "Authorization: Bearer b1653b2c8a44cc6150f7c18702f1b30ce80056bfbbf82e78551238c3bb19c603"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer b1653b2c8a44cc6150f7c18702f1b30ce80056bfbbf82e78551238c3bb19c603
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994784
Total: 2
Content-Length: 332
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
    "id": 119192822,
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

### Images Retrieve an existing Image by id [GET]

Shows all of the info for a given image.

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/images/119192820" -X GET \
	-H "Authorization: Bearer 0ead286c67d9a2022b44f1a8ade5614bfe17b1ba7527619b6ea82ecd941bc6bf"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 0ead286c67d9a2022b44f1a8ade5614bfe17b1ba7527619b6ea82ecd941bc6bf
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994784
Content-Length: 138
      ```

  
    - Body

      ```json
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
      ```
  

### Images Retrieve an existing Image by slug [GET]

Shows all of the info for a given public image.

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/images/ubuntu1304" -X GET \
	-H "Authorization: Bearer 5f74b56afd2c68bf469d4e61af5d3c778b99aeb914e5f649419f9b5b180e487b"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 5f74b56afd2c68bf469d4e61af5d3c778b99aeb914e5f649419f9b5b180e487b
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994784
Content-Length: 149
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
  

### Images Delete an Image [DELETE]

Permanently deletes an image.

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/images/119192823" -d '' -X DELETE \
	-H "Authorization: Bearer 6da90fe34c965658820c2598c39ed0cff1f0d7081e6a177adb2eb10ba73b05b0" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 6da90fe34c965658820c2598c39ed0cff1f0d7081e6a177adb2eb10ba73b05b0
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994784
      ```

  

### Images Update an Image [PUT]

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
    curl "https://api.digitalocean.com/v2/images/119192824" -d '{"name":"New Image Name"}' -X PUT \
	-H "Authorization: Bearer 83d774d1015fdcdaf3dae490fdb3372c95efc129ce981406dada47f11dd046cd" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 83d774d1015fdcdaf3dae490fdb3372c95efc129ce981406dada47f11dd046cd
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
X-RateLimit-Reset: 1401994784
Content-Length: 140
      ```

  
    - Body

      ```json
      {
  "id": 119192824,
  "name": "New Image Name",
  "distribution": null,
  "slug": null,
  "public": false,
  "regions": [
    "nyc1"
  ]
}
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

### Keys Create a new Key [POST]

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
	-H "Authorization: Bearer 75b43fa7154f32c1d0a208eb3f7fc27ba14419eeda3ecd86468d9d39139bf454" \
	-H "Content-Type: application/json"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 75b43fa7154f32c1d0a208eb3f7fc27ba14419eeda3ecd86468d9d39139bf454
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
X-RateLimit-Reset: 1401994789
Content-Length: 524
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
  

### Keys List all Keys [GET]

Lists all Keys

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/account/keys" -X GET \
	-H "Authorization: Bearer 3f86ef9d77e9af7f35629108cc9474de96cea3d2856f92268e53172376e157e8"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 3f86ef9d77e9af7f35629108cc9474de96cea3d2856f92268e53172376e157e8
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994789
Content-Length: 540
      ```

  
    - Body

      ```json
      [
  {
    "id": 5,
    "fingerprint": "f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2",
    "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com",
    "name": "Example Key"
  }
]
      ```
  

## Keys Member [/v2/account/keys/{id_or_fingerprint}]

### Keys Destroy [DELETE]

Delete a Key

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/account/keys/f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2" -d '' -X DELETE \
	-H "Authorization: Bearer 43a4441ace1e57a5a971e362fb8f768fb1a5494016a29a3628be2c7ad67abf67" \
	-H "Content-Type: application/x-www-form-urlencoded"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 43a4441ace1e57a5a971e362fb8f768fb1a5494016a29a3628be2c7ad67abf67
Content-Type: application/x-www-form-urlencoded
      ```

  

  - **Response**

    - Headers

      ```
      X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994789
      ```

  

### Keys Show [GET]

Retrieve an existing Key

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/account/keys/f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2" -X GET \
	-H "Authorization: Bearer be28f50dfba0c224adc12d7f9e51ff8d2f5ecffaa50b52ceb996031421305740"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer be28f50dfba0c224adc12d7f9e51ff8d2f5ecffaa50b52ceb996031421305740
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994789
Content-Length: 524
      ```

  
    - Body

      ```json
      {
  "id": 2,
  "fingerprint": "f5:de:eb:64:2d:6a:b6:d5:bb:06:47:7f:04:4b:f8:e2",
  "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPrtBjQaNBwDSV3ePC86zaEWu06g4+KEiivyqWAiOTvIp33Nia3b91NjfQydMkJlVfKuFs+hf2buQvCvslF4NNmWqxkPB69d+fS0ZL8Y4FMqut2I8hJuDg5MHO66QX6BkMqjqt3vsaJqbn7/dy0rKsqnaHgH0xqg0sPccK98nhL3nuoDGrzlsK0zMdfktX/yRSdjlpj4KdufA8/9uX14YGXNyduKMr8Sl7fLiAgtM0J3HHPAEOXce1iSmfIbxn16c8ikOddgM5MGK8DveX4EEscqwG0MxNkXJxgrU3e+k6dkb6RKuvGCtdSthrJ5X6O99lZCP0L6i3CD69d13YFobB name@example.com",
  "name": "Example Key"
}
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
  </tbody>
</table>

## Regions Collection [/v2/regions]

### Regions List all Regions [GET]

List all regions.

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/regions" -X GET \
	-H "Authorization: Bearer 4e2e346413c8c2f63ec4f0ceb15d56f4d73e1a0139b92f4a238f4c681367b529"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 4e2e346413c8c2f63ec4f0ceb15d56f4d73e1a0139b92f4a238f4c681367b529
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994783
Content-Length: 362
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
      "512mb",
      "1024mb"
    ],
    "available": true
  },
  {
    "slug": "ams4",
    "name": "Amsterdam",
    "sizes": [
      "512mb",
      "1024mb"
    ],
    "available": true
  }
]
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

### Sizes List all Sizes [GET]

Lists all sizes.

**Example:**

  - **cURL**

    ```bash
    curl "https://api.digitalocean.com/v2/sizes" -X GET \
	-H "Authorization: Bearer 034ecb5514c90ca2263e994ca24a99d3ddb52dc5fd9c16ef54176ce81c9d2fc6"
    ```

  - **Request**

    - Headers

      ```
      Authorization: Bearer 034ecb5514c90ca2263e994ca24a99d3ddb52dc5fd9c16ef54176ce81c9d2fc6
      ```

  

  - **Response**

    - Headers

      ```
      Content-Type: application/json; charset=utf-8
X-RateLimit-Limit: 1200
X-RateLimit-Remaining: 1199
X-RateLimit-Reset: 1401994789
Content-Length: 458
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
  

