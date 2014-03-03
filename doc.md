# DigitalOcean API Reference

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

TODO

### Schema

TODO

### Errors

TODO

### Methods

TODO

### Method Override

TODO

### Parameters

TODO

### Ranges

TODO

### Responses

TODO

### Statuses

TODO

### Versioning

TODO



## Domain Record
Domain records are the DNS records for a domain.

### Attributes
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of domain record</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><strong>type</strong></td>
    <td><em>string</em></td>
    <td>type of DNS record (ex: A, CNAME, TXT, ...)</td>
    <td><code>"CNAME"</code></td>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>name to use for the DNS record</td>
    <td><code>"subdomain"</code></td>
  </tr>
  <tr>
    <td><strong>data</strong></td>
    <td><em>string</em></td>
    <td>value to use for the DNS record</td>
    <td><code>"@"</code></td>
  </tr>
  <tr>
    <td><strong>priority</strong></td>
    <td><em>nullable integer</em></td>
    <td>priority for SRV records</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>port</strong></td>
    <td><em>nullable integer</em></td>
    <td>port for SRV records</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>weight</strong></td>
    <td><em>nullable integer</em></td>
    <td>weight for SRV records</td>
    <td><code>null</code></td>
  </tr>
</table>

### Domain Record Create
Create a new domain record.

```
POST /domains/{domain_id}/records
```

#### Required Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>type</strong></td>
    <td><em>string</em></td>
    <td>type of DNS record (ex: A, CNAME, TXT, ...)</td>
    <td><code>"CNAME"</code></td>
  </tr>
  <tr>
    <td><strong>data</strong></td>
    <td><em>string</em></td>
    <td>value to use for the DNS record</td>
    <td><code>"@"</code></td>
  </tr>
</table>


#### Optional Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>name to use for the DNS record</td>
    <td><code>"subdomain"</code></td>
  </tr>
  <tr>
    <td><strong>priority</strong></td>
    <td><em>nullable integer</em></td>
    <td>priority for SRV records</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>port</strong></td>
    <td><em>nullable integer</em></td>
    <td>port for SRV records</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>weight</strong></td>
    <td><em>nullable integer</em></td>
    <td>weight for SRV records</td>
    <td><code>null</code></td>
  </tr>
</table>


#### Curl Example
```term
$ curl -n -X POST https://api.digitalocean.com/v1/domains/$DOMAIN_ID/records \
-H "Content-Type: application/json" \
-d '{"type":null,"name":null,"data":null,"priority":null,"port":null,"weight":null}'
```

#### Response Example
```
HTTP/1.1 201 Created
```
```javascript```
{
  "id": 32,
  "type": "CNAME",
  "name": "subdomain",
  "data": "@",
  "priority": null,
  "port": null,
  "weight": null
}
```

### Domain Record Delete
Delete an existing domain record.

```
DELETE /domains/{domain_id}/records/{domain-record_id}
```


#### Curl Example
```term
$ curl -n -X DELETE https://api.digitalocean.com/v1/domains/$DOMAIN_ID/records/$DOMAIN_RECORD_ID
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "type": "CNAME",
  "name": "subdomain",
  "data": "@",
  "priority": null,
  "port": null,
  "weight": null
}
```

### Domain Record Info
Info for existing domain records.

```
GET /domains/{domain_id}/records/{domain-record_id}
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/domains/$DOMAIN_ID/records/$DOMAIN_RECORD_ID
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "type": "CNAME",
  "name": "subdomain",
  "data": "@",
  "priority": null,
  "port": null,
  "weight": null
}
```

### Domain Record List
List existing domain records.

```
GET /domains/{domain_id}/records
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/domains/$DOMAIN_ID/records
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id
Content-Range: id 23..342; max=200
```
```javascript```
[
  {
    "id": 32,
    "type": "CNAME",
    "name": "subdomain",
    "data": "@",
    "priority": null,
    "port": null,
    "weight": null
  }
]
```

### Domain Record Update
Update an existing domain records.

```
PATCH /domains/{domain_id}/records/{domain-record_id}
```

#### Required Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>type</strong></td>
    <td><em>string</em></td>
    <td>type of DNS record (ex: A, CNAME, TXT, ...)</td>
    <td><code>"CNAME"</code></td>
  </tr>
  <tr>
    <td><strong>data</strong></td>
    <td><em>string</em></td>
    <td>value to use for the DNS record</td>
    <td><code>"@"</code></td>
  </tr>
</table>


#### Optional Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>name to use for the DNS record</td>
    <td><code>"subdomain"</code></td>
  </tr>
  <tr>
    <td><strong>priority</strong></td>
    <td><em>nullable integer</em></td>
    <td>priority for SRV records</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>port</strong></td>
    <td><em>nullable integer</em></td>
    <td>port for SRV records</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>weight</strong></td>
    <td><em>nullable integer</em></td>
    <td>weight for SRV records</td>
    <td><code>null</code></td>
  </tr>
</table>


#### Curl Example
```term
$ curl -n -X PATCH https://api.digitalocean.com/v1/domains/$DOMAIN_ID/records/$DOMAIN_RECORD_ID \
-H "Content-Type: application/json" \
-d '{"type":null,"name":null,"data":null,"priority":null,"port":null,"weight":null}'
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "type": "CNAME",
  "name": "subdomain",
  "data": "@",
  "priority": null,
  "port": null,
  "weight": null
}
```

## Domain
Domains are managed domain names that DigitalOcean provides DNS for.

### Attributes
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>name of the domain</td>
    <td><code>"example.com"</code></td>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of domain</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><strong>ttl</strong></td>
    <td><em>seconds</em></td>
    <td>time to live for records on this domain</td>
    <td><code>1800</code></td>
  </tr>
  <tr>
    <td><strong>zone_file</strong></td>
    <td><em>string</em></td>
    <td>contents of the zone file used by the DNS server</td>
    <td><code>"$TTL\\t600\\n@\\t\\tIN\\tSOA ..."</code></td>
  </tr>
  <tr>
    <td><strong>bad_zone_file</strong></td>
    <td><em>nullable string</em></td>
    <td>contents of updated zone file that produced an error or null</td>
    <td><code>"$TTL\\t600\\n@\\t\\tIN\\tSOA ..."</code></td>
  </tr>
  <tr>
    <td><strong>bad_zone_error</strong></td>
    <td><em>nullable string</em></td>
    <td>error information associated with bad_zone_file or null</td>
    <td><code>"error information..."</code></td>
  </tr>
</table>

### Domain Create
Create a new domain.

```
POST /domains
```

#### Required Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>name of the domain</td>
    <td><code>"example.com"</code></td>
  </tr>
</table>



#### Curl Example
```term
$ curl -n -X POST https://api.digitalocean.com/v1/domains \
-H "Content-Type: application/json" \
-d '{"name":null}'
```

#### Response Example
```
HTTP/1.1 201 Created
```
```javascript```
{
  "name": "example.com",
  "id": 32,
  "ttl": 1800,
  "zone_file": "$TTL\\t600\\n@\\t\\tIN\\tSOA ...",
  "bad_zone_file": "$TTL\\t600\\n@\\t\\tIN\\tSOA ...",
  "bad_zone_error": "error information..."
}
```

### Domain Delete
Delete an existing domain.

```
DELETE /domains/{domain_id}
```


#### Curl Example
```term
$ curl -n -X DELETE https://api.digitalocean.com/v1/domains/$DOMAIN_ID
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "name": "example.com",
  "id": 32,
  "ttl": 1800,
  "zone_file": "$TTL\\t600\\n@\\t\\tIN\\tSOA ...",
  "bad_zone_file": "$TTL\\t600\\n@\\t\\tIN\\tSOA ...",
  "bad_zone_error": "error information..."
}
```

### Domain Info
Info for existing domain.

```
GET /domains/{domain_id}
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/domains/$DOMAIN_ID
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "name": "example.com",
  "id": 32,
  "ttl": 1800,
  "zone_file": "$TTL\\t600\\n@\\t\\tIN\\tSOA ...",
  "bad_zone_file": "$TTL\\t600\\n@\\t\\tIN\\tSOA ...",
  "bad_zone_error": "error information..."
}
```

### Domain List
List existing domains.

```
GET /domains
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/domains
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id
Content-Range: id 23..342; max=200
```
```javascript```
[
  {
    "name": "example.com",
    "id": 32,
    "ttl": 1800,
    "zone_file": "$TTL\\t600\\n@\\t\\tIN\\tSOA ...",
    "bad_zone_file": "$TTL\\t600\\n@\\t\\tIN\\tSOA ...",
    "bad_zone_error": "error information..."
  }
]
```

## Droplet Action
Droplet actions are operations on droplets that may take a while to complete.

### Attributes
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of droplet action</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><strong>reboot</strong></td>
    <td><em>string</em></td>
    <td>reboot the machine, specifying a hard or soft reboot</td>
    <td><code>"hard"</code></td>
  </tr>
  <tr>
    <td><strong>shutdown</strong></td>
    <td><em>string</em></td>
    <td>shutdown the machine, specifying a hard or soft shutdown</td>
    <td><code>"soft"</code></td>
  </tr>
  <tr>
    <td><strong>boot</strong></td>
    <td><em>nullable null</em></td>
    <td>boot the machine, no value necessary</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>resetpassword</strong></td>
    <td><em>nullable null</em></td>
    <td>reset the root password, no value necessary</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>resize</strong></td>
    <td><em>string</em></td>
    <td>resize the machine, specifying a size id or slug</td>
    <td><code>"32mb"</code></td>
  </tr>
  <tr>
    <td><strong>snapshot</strong></td>
    <td><em>string</em></td>
    <td>snapshot the machine, specifying the name for the snapshot image</td>
    <td><code>"My snapshot"</code></td>
  </tr>
  <tr>
    <td><strong>rebuild</strong></td>
    <td><em>string or integer</em></td>
    <td>rebuild the machine, specifying an image id or slug</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><strong>restore</strong></td>
    <td><em>string or integer</em></td>
    <td>restore the machine, specifying an image id or slug</td>
    <td><code>32</code></td>
  </tr>
</table>

### Droplet Action Create
Create a new droplet action.

```
POST /droplet/{droplet_id}/actions
```

#### Optional Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>reboot</strong></td>
    <td><em>string</em></td>
    <td>reboot the machine, specifying a hard or soft reboot</td>
    <td><code>"hard"</code></td>
  </tr>
  <tr>
    <td><strong>shutdown</strong></td>
    <td><em>string</em></td>
    <td>shutdown the machine, specifying a hard or soft shutdown</td>
    <td><code>"soft"</code></td>
  </tr>
  <tr>
    <td><strong>boot</strong></td>
    <td><em>nullable null</em></td>
    <td>boot the machine, no value necessary</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>resetpassword</strong></td>
    <td><em>nullable null</em></td>
    <td>reset the root password, no value necessary</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>resize</strong></td>
    <td><em>string</em></td>
    <td>resize the machine, specifying a size id or slug</td>
    <td><code>"32mb"</code></td>
  </tr>
  <tr>
    <td><strong>snapshot</strong></td>
    <td><em>string</em></td>
    <td>snapshot the machine, specifying the name for the snapshot image</td>
    <td><code>"My snapshot"</code></td>
  </tr>
  <tr>
    <td><strong>rebuild</strong></td>
    <td><em>string or integer</em></td>
    <td>rebuild the machine, specifying an image id or slug</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><strong>restore</strong></td>
    <td><em>string or integer</em></td>
    <td>restore the machine, specifying an image id or slug</td>
    <td><code>32</code></td>
  </tr>
</table>


#### Curl Example
```term
$ curl -n -X POST https://api.digitalocean.com/v1/droplet/$DROPLET_ID/actions \
-H "Content-Type: application/json" \
-d '{"reboot":null,"shutdown":null,"boot":null,"resetpassword":null,"resize":null,"snapshot":null,"rebuild":null,"restore":null}'
```

#### Response Example
```
HTTP/1.1 201 Created
```
```javascript```
{
  "id": 32,
  "reboot": "hard",
  "shutdown": "soft",
  "boot": null,
  "resetpassword": null,
  "resize": "32mb",
  "snapshot": "My snapshot",
  "rebuild": 32,
  "restore": 32
}
```

### Droplet Action Info
Info for existing droplet action.

```
GET /droplet/{droplet_id}/actions/{droplet-action_id}
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/droplet/$DROPLET_ID/actions/$DROPLET_ACTION_ID
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "reboot": "hard",
  "shutdown": "soft",
  "boot": null,
  "resetpassword": null,
  "resize": "32mb",
  "snapshot": "My snapshot",
  "rebuild": 32,
  "restore": 32
}
```

## Droplet Self
Droplet meta-data reflection endpoint. This is only available from a droplet.

### Attributes
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of droplet</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>name used to identify droplet</td>
    <td><code>"my droplet"</code></td>
  </tr>
  <tr>
    <td><strong>region</strong></td>
    <td><em>string</em></td>
    <td>slug of region for this droplet</td>
    <td><code>"nyc2"</code></td>
  </tr>
  <tr>
    <td><strong>image:id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of image</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><strong>image:slug</strong></td>
    <td><em>nullable string</em></td>
    <td>url friendly name of the image</td>
    <td><code>"ubuntu-12.10-x32"</code></td>
  </tr>
  <tr>
    <td><strong>image:name</strong></td>
    <td><em>string</em></td>
    <td>display name of the image</td>
    <td><code>"My first snapshot"</code></td>
  </tr>
  <tr>
    <td><strong>image:distribution</strong></td>
    <td><em>string</em></td>
    <td>name of the Linux distribution this image is based on</td>
    <td><code>"Ubuntu"</code></td>
  </tr>
  <tr>
    <td><strong>image:public</strong></td>
    <td><em>boolean</em></td>
    <td>whether accessible by all accounts or just your account</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><strong>size:slug</strong></td>
    <td><em>string</em></td>
    <td>unique string identifier of size</td>
    <td><code>"512mb"</code></td>
  </tr>
  <tr>
    <td><strong>size:memory</strong></td>
    <td><em>string</em></td>
    <td>amount of RAM provided</td>
    <td><code>"512mb"</code></td>
  </tr>
  <tr>
    <td><strong>size:cpus</strong></td>
    <td><em>integer</em></td>
    <td>number of CPUs provided</td>
    <td><code>"1"</code></td>
  </tr>
  <tr>
    <td><strong>size:disk</strong></td>
    <td><em>string</em></td>
    <td>amount of SSD disk storage provided</td>
    <td><code>"20gb"</code></td>
  </tr>
  <tr>
    <td><strong>size:transfer</strong></td>
    <td><em>string</em></td>
    <td>amount of network transfer provided</td>
    <td><code>"1tb"</code></td>
  </tr>
  <tr>
    <td><strong>size:price_monthly</strong></td>
    <td><em>string</em></td>
    <td>cost of running for a month</td>
    <td><code>"5.00"</code></td>
  </tr>
  <tr>
    <td><strong>size:price_hourly</strong></td>
    <td><em>string</em></td>
    <td>cost of running for an hour</td>
    <td><code>"0.007"</code></td>
  </tr>
  <tr>
    <td><strong>backups</strong></td>
    <td><em>nullable string</em></td>
    <td>TODO</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>snapshots</strong></td>
    <td><em>nullable string</em></td>
    <td>TODO</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>locked</strong></td>
    <td><em>boolean</em></td>
    <td>???</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><strong>status</strong></td>
    <td><em>string</em></td>
    <td>current status of droplet</td>
    <td><code>"active"</code></td>
  </tr>
  <tr>
    <td><strong>public_ip</strong></td>
    <td><em>string</em></td>
    <td>public IP address of droplet</td>
    <td><code>"192.168.1.1"</code></td>
  </tr>
  <tr>
    <td><strong>private_ip</strong></td>
    <td><em>nullable string</em></td>
    <td>private IP address or null</td>
    <td><code>null</code></td>
  </tr>
</table>

### Droplet Self Info
Info for existing droplet.

```
GET /droplets/self
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/droplets/self
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "name": "my droplet",
  "region": "nyc2",
  "image": null,
  "size": null,
  "backups": null,
  "snapshots": null,
  "locked": false,
  "status": "active",
  "public_ip": "192.168.1.1",
  "private_ip": null
}
```

## Droplet
Droplets are VMs in the DigitalOcean cloud.

### Attributes
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of droplet</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>name used to identify droplet</td>
    <td><code>"my droplet"</code></td>
  </tr>
  <tr>
    <td><strong>region</strong></td>
    <td><em>string</em></td>
    <td>slug of region for this droplet</td>
    <td><code>"nyc2"</code></td>
  </tr>
  <tr>
    <td><strong>image:id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of image</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><strong>image:slug</strong></td>
    <td><em>nullable string</em></td>
    <td>url friendly name of the image</td>
    <td><code>"ubuntu-12.10-x32"</code></td>
  </tr>
  <tr>
    <td><strong>image:name</strong></td>
    <td><em>string</em></td>
    <td>display name of the image</td>
    <td><code>"My first snapshot"</code></td>
  </tr>
  <tr>
    <td><strong>image:distribution</strong></td>
    <td><em>string</em></td>
    <td>name of the Linux distribution this image is based on</td>
    <td><code>"Ubuntu"</code></td>
  </tr>
  <tr>
    <td><strong>image:public</strong></td>
    <td><em>boolean</em></td>
    <td>whether accessible by all accounts or just your account</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><strong>size:slug</strong></td>
    <td><em>string</em></td>
    <td>unique string identifier of size</td>
    <td><code>"512mb"</code></td>
  </tr>
  <tr>
    <td><strong>size:memory</strong></td>
    <td><em>string</em></td>
    <td>amount of RAM provided</td>
    <td><code>"512mb"</code></td>
  </tr>
  <tr>
    <td><strong>size:cpus</strong></td>
    <td><em>integer</em></td>
    <td>number of CPUs provided</td>
    <td><code>"1"</code></td>
  </tr>
  <tr>
    <td><strong>size:disk</strong></td>
    <td><em>string</em></td>
    <td>amount of SSD disk storage provided</td>
    <td><code>"20gb"</code></td>
  </tr>
  <tr>
    <td><strong>size:transfer</strong></td>
    <td><em>string</em></td>
    <td>amount of network transfer provided</td>
    <td><code>"1tb"</code></td>
  </tr>
  <tr>
    <td><strong>size:price_monthly</strong></td>
    <td><em>string</em></td>
    <td>cost of running for a month</td>
    <td><code>"5.00"</code></td>
  </tr>
  <tr>
    <td><strong>size:price_hourly</strong></td>
    <td><em>string</em></td>
    <td>cost of running for an hour</td>
    <td><code>"0.007"</code></td>
  </tr>
  <tr>
    <td><strong>backups</strong></td>
    <td><em>nullable string</em></td>
    <td>TODO</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>snapshots</strong></td>
    <td><em>nullable string</em></td>
    <td>TODO</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>locked</strong></td>
    <td><em>boolean</em></td>
    <td>???</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><strong>status</strong></td>
    <td><em>string</em></td>
    <td>current status of droplet</td>
    <td><code>"active"</code></td>
  </tr>
  <tr>
    <td><strong>public_ip</strong></td>
    <td><em>string</em></td>
    <td>public IP address of droplet</td>
    <td><code>"192.168.1.1"</code></td>
  </tr>
  <tr>
    <td><strong>private_ip</strong></td>
    <td><em>nullable string</em></td>
    <td>private IP address or null</td>
    <td><code>null</code></td>
  </tr>
</table>

### Droplet Create
Create a new droplet.

```
POST /droplets
```

#### Required Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>name used to identify droplet</td>
    <td><code>"my droplet"</code></td>
  </tr>
  <tr>
    <td><strong>region</strong></td>
    <td><em>string</em></td>
    <td>slug of region for this droplet</td>
    <td><code>"nyc2"</code></td>
  </tr>
  <tr>
    <td><strong>size</strong></td>
    <td><em>string</em></td>
    <td>slug of size for this droplet</td>
    <td><code>"512mb"</code></td>
  </tr>
  <tr>
    <td><strong>image_id</strong></td>
    <td><em>integer</em></td>
    <td>id of image to use</td>
    <td><code>32</code></td>
  </tr>
</table>


#### Optional Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>key_ids</strong></td>
    <td><em>nullable numeric CSV</em></td>
    <td>comma separated list of key ids for root access</td>
    <td><code>"32,64"</code></td>
  </tr>
  <tr>
    <td><strong>private_networking</strong></td>
    <td><em>boolean</em></td>
    <td>enable private networking, if available in this region</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><strong>backups</strong></td>
    <td><em>boolean</em></td>
    <td>enable backups for this droplet</td>
    <td><code>false</code></td>
  </tr>
</table>


#### Curl Example
```term
$ curl -n -X POST https://api.digitalocean.com/v1/droplets \
-H "Content-Type: application/json" \
-d '{"name":null,"region":null,"size":"512mb","image_id":null,"key_ids":null,"private_networking":false,"backups":false}'
```

#### Response Example
```
HTTP/1.1 201 Created
```
```javascript```
{
  "id": 32,
  "name": "my droplet",
  "region": "nyc2",
  "image": null,
  "size": null,
  "backups": null,
  "snapshots": null,
  "locked": false,
  "status": "active",
  "public_ip": "192.168.1.1",
  "private_ip": null
}
```

### Droplet Delete
Delete an existing droplet.

```
DELETE /droplets/{droplet_id}
```


#### Curl Example
```term
$ curl -n -X DELETE https://api.digitalocean.com/v1/droplets/$DROPLET_ID
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "name": "my droplet",
  "region": "nyc2",
  "image": null,
  "size": null,
  "backups": null,
  "snapshots": null,
  "locked": false,
  "status": "active",
  "public_ip": "192.168.1.1",
  "private_ip": null
}
```

### Droplet Info
Info for existing droplet.

```
GET /droplets/{droplet_id}
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/droplets/$DROPLET_ID
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "name": "my droplet",
  "region": "nyc2",
  "image": null,
  "size": null,
  "backups": null,
  "snapshots": null,
  "locked": false,
  "status": "active",
  "public_ip": "192.168.1.1",
  "private_ip": null
}
```

### Droplet List
List existing droplet.

```
GET /droplets
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/droplets
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id
Content-Range: id 23..342; max=200
```
```javascript```
[
  {
    "id": 32,
    "name": "my droplet",
    "region": "nyc2",
    "image": null,
    "size": null,
    "backups": null,
    "snapshots": null,
    "locked": false,
    "status": "active",
    "public_ip": "192.168.1.1",
    "private_ip": null
  }
]
```

### Droplet Update
Update an existing droplet.

```
PATCH /droplets/{droplet_id}
```

#### Required Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>name used to identify droplet</td>
    <td><code>"my droplet"</code></td>
  </tr>
</table>



#### Curl Example
```term
$ curl -n -X PATCH https://api.digitalocean.com/v1/droplets/$DROPLET_ID \
-H "Content-Type: application/json" \
-d '{"name":null}'
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "name": "my droplet",
  "region": "nyc2",
  "image": null,
  "size": null,
  "backups": null,
  "snapshots": null,
  "locked": false,
  "status": "active",
  "public_ip": "192.168.1.1",
  "private_ip": null
}
```

## Image Action
Image actions are operations on images that may take a while to complete.

### Attributes
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of image action</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><strong>transfer</strong></td>
    <td><em>string</em></td>
    <td>a region slug to transfer the image to</td>
    <td><code>"nyc2"</code></td>
  </tr>
</table>

### Image Action Create
Create a new image action.

```
POST /images/{image_id}/actions
```

#### Optional Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>transfer</strong></td>
    <td><em>string</em></td>
    <td>a region slug to transfer the image to</td>
    <td><code>"nyc2"</code></td>
  </tr>
</table>


#### Curl Example
```term
$ curl -n -X POST https://api.digitalocean.com/v1/images/$IMAGE_ID/actions \
-H "Content-Type: application/json" \
-d '{"transfer":null}'
```

#### Response Example
```
HTTP/1.1 201 Created
```
```javascript```
{
  "id": 32,
  "transfer": "nyc2"
}
```

### Image Action Info
Info for existing image action.

```
GET /images/{image_id}/actions/{image-action_id}
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/images/$IMAGE_ID/actions/$IMAGE_ACTION_ID
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "transfer": "nyc2"
}
```

## Image
Images are either snapshots or backups you've made, or public images of applications or base systems.

### Attributes
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of image</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>display name of the image</td>
    <td><code>"My first snapshot"</code></td>
  </tr>
  <tr>
    <td><strong>distribution</strong></td>
    <td><em>string</em></td>
    <td>name of the Linux distribution this image is based on</td>
    <td><code>"Ubuntu"</code></td>
  </tr>
  <tr>
    <td><strong>slug</strong></td>
    <td><em>nullable string</em></td>
    <td>url friendly name of the image</td>
    <td><code>"ubuntu-12.10-x32"</code></td>
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
    <td>slugs of regions this image is currently available in</td>
    <td><code>["nyc2","sf1"]</code></td>
  </tr>
</table>

### Image Delete
Delete an existing image.

```
DELETE /images/{image_id}
```


#### Curl Example
```term
$ curl -n -X DELETE https://api.digitalocean.com/v1/images/$IMAGE_ID
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "name": "My first snapshot",
  "distribution": "Ubuntu",
  "slug": "ubuntu-12.10-x32",
  "public": false,
  "regions": [
    "nyc2",
    "sf1"
  ]
}
```

### Image Info
Info for existing image.

```
GET /images/{image_id}
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/images/$IMAGE_ID
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "name": "My first snapshot",
  "distribution": "Ubuntu",
  "slug": "ubuntu-12.10-x32",
  "public": false,
  "regions": [
    "nyc2",
    "sf1"
  ]
}
```

### Image List
List existing images.

```
GET /images
```

#### Optional Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>private</strong></td>
    <td><em>boolean</em></td>
    <td>only show images for your account</td>
    <td><code>true</code></td>
  </tr>
</table>


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/images \
-H "Content-Type: application/json" \
-d '{"private":null}'
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id
Content-Range: id 23..342; max=200
```
```javascript```
[
  {
    "id": 32,
    "name": "My first snapshot",
    "distribution": "Ubuntu",
    "slug": "ubuntu-12.10-x32",
    "public": false,
    "regions": [
      "nyc2",
      "sf1"
    ]
  }
]
```

### Image Update
Update an existing image.

```
PATCH /images/{image_id}
```

#### Required Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>display name of the image</td>
    <td><code>"My first snapshot"</code></td>
  </tr>
</table>



#### Curl Example
```term
$ curl -n -X PATCH https://api.digitalocean.com/v1/images/$IMAGE_ID \
-H "Content-Type: application/json" \
-d '{"name":null}'
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 32,
  "name": "My first snapshot",
  "distribution": "Ubuntu",
  "slug": "ubuntu-12.10-x32",
  "public": false,
  "regions": [
    "nyc2",
    "sf1"
  ]
}
```

## Key
Keys are your public SSH keys that you can use to access Droplets.

### Attributes
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of key</td>
    <td><code>18</code></td>
  </tr>
  <tr>
    <td><strong>fingerprint</strong></td>
    <td><em>string</em></td>
    <td>a unique identifying string based on contents</td>
    <td><code>"17:63:a4:ba:24:d3:7f:af:17:c8:94:82:7e:80:56:bf"</code></td>
  </tr>
  <tr>
    <td><strong>public_key</strong></td>
    <td><em>string</em></td>
    <td>full public key string</td>
    <td><code>"ssh-rsa AAAAB3NzaC1ycVc/../839Uv username@example.com"</code></td>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>user specified identifier</td>
    <td><code>"primary-key"</code></td>
  </tr>
</table>

### Key Create
Create a new key.

```
POST /account/keys
```

#### Required Parameters
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>public_key</strong></td>
    <td><em>string</em></td>
    <td>full public key string</td>
    <td><code>"ssh-rsa AAAAB3NzaC1ycVc/../839Uv username@example.com"</code></td>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>user specified identifier</td>
    <td><code>"primary-key"</code></td>
  </tr>
</table>



#### Curl Example
```term
$ curl -n -X POST https://api.digitalocean.com/v1/account/keys \
-H "Content-Type: application/json" \
-d '{"public_key":null,"name":null}'
```

#### Response Example
```
HTTP/1.1 201 Created
```
```javascript```
{
  "id": 18,
  "fingerprint": "17:63:a4:ba:24:d3:7f:af:17:c8:94:82:7e:80:56:bf",
  "public_key": "ssh-rsa AAAAB3NzaC1ycVc/../839Uv username@example.com",
  "name": "primary-key"
}
```

### Key Delete
Delete an existing key.

```
DELETE /account/keys/{key_id_or_fingerprint}
```


#### Curl Example
```term
$ curl -n -X DELETE https://api.digitalocean.com/v1/account/keys/$KEY_ID_OR_FINGERPRINT
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 18,
  "fingerprint": "17:63:a4:ba:24:d3:7f:af:17:c8:94:82:7e:80:56:bf",
  "public_key": "ssh-rsa AAAAB3NzaC1ycVc/../839Uv username@example.com",
  "name": "primary-key"
}
```

### Key Info
Info for existing key.

```
GET /account/keys/{key_id_or_fingerprint}
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/account/keys/$KEY_ID_OR_FINGERPRINT
```

#### Response Example
```
HTTP/1.1 200 OK
```
```javascript```
{
  "id": 18,
  "fingerprint": "17:63:a4:ba:24:d3:7f:af:17:c8:94:82:7e:80:56:bf",
  "public_key": "ssh-rsa AAAAB3NzaC1ycVc/../839Uv username@example.com",
  "name": "primary-key"
}
```

### Key List
List existing keys.

```
GET /account/keys
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/account/keys
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id, fingerprint
Content-Range: id 23..342; max=200
```
```javascript```
[
  {
    "id": 18,
    "fingerprint": "17:63:a4:ba:24:d3:7f:af:17:c8:94:82:7e:80:56:bf",
    "public_key": "ssh-rsa AAAAB3NzaC1ycVc/../839Uv username@example.com",
    "name": "primary-key"
  }
]
```

## Region
Regions are available datacenters within the DigitalOcean cloud.

### Attributes
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>slug</strong></td>
    <td><em>string</em></td>
    <td>unique string identifier of region</td>
    <td><code>"nyc1"</code></td>
  </tr>
  <tr>
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>display name of region</td>
    <td><code>"New York 1"</code></td>
  </tr>
  <tr>
    <td><strong>sizes</strong></td>
    <td><em>array</em></td>
    <td>slugs of sizes this region currently has capacity for</td>
    <td><code>["512mb","1gb","2gb","4gb","8gb"]</code></td>
  </tr>
  <tr>
    <td><strong>available</strong></td>
    <td><em>bool</em></td>
    <td>if new droplets can currently be created</td>
    <td><code>true</code></td>
  </tr>
</table>

### Region List
List available regions.

```
GET /regions
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/regions
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id
Content-Range: id 23..342; max=200
```
```javascript```
[
  {
    "slug": "nyc1",
    "name": "New York 1",
    "sizes": [
      "512mb",
      "1gb",
      "2gb",
      "4gb",
      "8gb"
    ],
    "available": true
  }
]
```

## Size
Sizes represent possible Droplet resources.

### Attributes
<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><strong>slug</strong></td>
    <td><em>string</em></td>
    <td>unique string identifier of size</td>
    <td><code>"512mb"</code></td>
  </tr>
  <tr>
    <td><strong>memory</strong></td>
    <td><em>string</em></td>
    <td>amount of RAM provided</td>
    <td><code>"512mb"</code></td>
  </tr>
  <tr>
    <td><strong>cpus</strong></td>
    <td><em>integer</em></td>
    <td>number of CPUs provided</td>
    <td><code>"1"</code></td>
  </tr>
  <tr>
    <td><strong>disk</strong></td>
    <td><em>string</em></td>
    <td>amount of SSD disk storage provided</td>
    <td><code>"20gb"</code></td>
  </tr>
  <tr>
    <td><strong>transfer</strong></td>
    <td><em>string</em></td>
    <td>amount of network transfer provided</td>
    <td><code>"1tb"</code></td>
  </tr>
  <tr>
    <td><strong>price_monthly</strong></td>
    <td><em>string</em></td>
    <td>cost of running for a month</td>
    <td><code>"5.00"</code></td>
  </tr>
  <tr>
    <td><strong>price_hourly</strong></td>
    <td><em>string</em></td>
    <td>cost of running for an hour</td>
    <td><code>"0.007"</code></td>
  </tr>
  <tr>
    <td><strong>regions</strong></td>
    <td><em>array</em></td>
    <td>slugs of regions this size is currently available in</td>
    <td><code>["nyc2","sf1"]</code></td>
  </tr>
</table>

### Size List
List available sizes.

```
GET /sizes
```


#### Curl Example
```term
$ curl -n -X GET https://api.digitalocean.com/v1/sizes
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: slug
Content-Range: id 23..342; max=200
```
```javascript```
[
  {
    "slug": "512mb",
    "memory": "512mb",
    "cpus": "1",
    "disk": "20gb",
    "transfer": "1tb",
    "price_monthly": "5.00",
    "price_hourly": "0.007",
    "regions": [
      "nyc2",
      "sf1"
    ]
  }
]
```

