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
    <td><em>uuid</em></td>
    <td>unique identifier of domain-record</td>
    <td><code>"01234567-89ab-cdef-0123-456789abcdef"</code></td>
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
POST /domains/{domain_identity}/records
```


#### Curl Example
```term
$ curl -n -X POST https://api.heroku.com/domains/$DOMAIN_IDENTITY/records
```

#### Response Example
```
HTTP/1.1 201 Created
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "id": "01234567-89ab-cdef-0123-456789abcdef",
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
DELETE /domains/{domain_identity}/records/{domain_record_identity}
```


#### Curl Example
```term
$ curl -n -X DELETE https://api.heroku.com/domains/$DOMAIN_IDENTITY/records/$DOMAIN_RECORD_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "id": "01234567-89ab-cdef-0123-456789abcdef",
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
GET /domains/{domain_identity}/records/{domain_record_identity}
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/domains/$DOMAIN_IDENTITY/records/$DOMAIN_RECORD_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "id": "01234567-89ab-cdef-0123-456789abcdef",
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
GET /domains/{domain_identity}/records
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/domains/$DOMAIN_IDENTITY/records
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id
Content-Range: id 01234567-89ab-cdef-0123-456789abcdef..01234567-89ab-cdef-0123-456789abcdef; max=200
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
[
  {
    "id": "01234567-89ab-cdef-0123-456789abcdef",
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
PATCH /domains/{domain_identity}/records/{domain_record_identity}
```


#### Curl Example
```term
$ curl -n -X PATCH https://api.heroku.com/domains/$DOMAIN_IDENTITY/records/$DOMAIN_RECORD_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "id": "01234567-89ab-cdef-0123-456789abcdef",
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
$ curl -n -X POST https://api.heroku.com/domains \
-H "Content-Type: application/json" \
-d '{"name":"example.com"}'
```

#### Response Example
```
HTTP/1.1 201 Created
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
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
DELETE /domains/{domain_identity}
```


#### Curl Example
```term
$ curl -n -X DELETE https://api.heroku.com/domains/$DOMAIN_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
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
GET /domains/{domain_identity}
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/domains/$DOMAIN_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
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
$ curl -n -X GET https://api.heroku.com/domains
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id
Content-Range: id 01234567-89ab-cdef-0123-456789abcdef..01234567-89ab-cdef-0123-456789abcdef; max=200
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
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
POST /droplet/{schema%droplet_identity}/actions
```


#### Curl Example
```term
$ curl -n -X POST https://api.heroku.com/droplet/$SCHEMA%DROPLET_IDENTITY/actions
```

#### Response Example
```
HTTP/1.1 201 Created
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
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
GET /droplet/{schema%droplet_identity}/actions/{droplet_action_identity}
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/droplet/$SCHEMA%DROPLET_IDENTITY/actions/$DROPLET_ACTION_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
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
    <td><strong>image</strong></td>
    <td><em>string</em></td>
    <td>name used to identify droplet</td>
    <td><code>"my droplet"</code></td>
  </tr>
  <tr>
    <td><strong>region</strong></td>
    <td><em>nullable string</em></td>
    <td>TODO</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><strong>size</strong></td>
    <td><em>nullable string</em></td>
    <td>TODO</td>
    <td><code>null</code></td>
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
    <td><em>string</em></td>
    <td>name used to identify droplet</td>
    <td><code>"my droplet"</code></td>
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


#### Curl Example
```term
$ curl -n -X POST https://api.heroku.com/droplets
```

#### Response Example
```
HTTP/1.1 201 Created
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "id": 32,
  "name": "my droplet",
  "image": "my droplet",
  "region": null,
  "size": null,
  "backups": null,
  "snapshots": null,
  "locked": "my droplet",
  "status": "active",
  "public_ip": "192.168.1.1",
  "private_ip": null
}
```

### Droplet Delete
Delete an existing droplet.

```
DELETE /droplets/{droplet_identity}
```


#### Curl Example
```term
$ curl -n -X DELETE https://api.heroku.com/droplets/$DROPLET_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "id": 32,
  "name": "my droplet",
  "image": "my droplet",
  "region": null,
  "size": null,
  "backups": null,
  "snapshots": null,
  "locked": "my droplet",
  "status": "active",
  "public_ip": "192.168.1.1",
  "private_ip": null
}
```

### Droplet Info
Info for existing droplet.

```
GET /droplets/{droplet_identity}
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/droplets/$DROPLET_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "id": 32,
  "name": "my droplet",
  "image": "my droplet",
  "region": null,
  "size": null,
  "backups": null,
  "snapshots": null,
  "locked": "my droplet",
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
$ curl -n -X GET https://api.heroku.com/droplets
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id
Content-Range: id 01234567-89ab-cdef-0123-456789abcdef..01234567-89ab-cdef-0123-456789abcdef; max=200
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
[
  {
    "id": 32,
    "name": "my droplet",
    "image": "my droplet",
    "region": null,
    "size": null,
    "backups": null,
    "snapshots": null,
    "locked": "my droplet",
    "status": "active",
    "public_ip": "192.168.1.1",
    "private_ip": null
  }
]
```

### Droplet Update
Update an existing droplet.

```
PATCH /droplets/{droplet_identity}
```


#### Curl Example
```term
$ curl -n -X PATCH https://api.heroku.com/droplets/$DROPLET_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "id": 32,
  "name": "my droplet",
  "image": "my droplet",
  "region": null,
  "size": null,
  "backups": null,
  "snapshots": null,
  "locked": "my droplet",
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
    <td>a region id or slug to transfer the image to</td>
    <td><code>"nyc2"</code></td>
  </tr>
</table>

### Image Action Create
Create a new image action.

```
POST /images/{image_identity}/actions
```


#### Curl Example
```term
$ curl -n -X POST https://api.heroku.com/images/$IMAGE_IDENTITY/actions
```

#### Response Example
```
HTTP/1.1 201 Created
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
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
GET /images/{image_identity}/actions/{droplet_action_identity}
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/images/$IMAGE_IDENTITY/actions/$DROPLET_ACTION_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
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
</table>

### Image Delete
Delete an existing image.

```
DELETE /images/{image_identity}
```


#### Curl Example
```term
$ curl -n -X DELETE https://api.heroku.com/images/$IMAGE_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "id": 32,
  "name": "My first snapshot",
  "distribution": "Ubuntu",
  "slug": "ubuntu-12.10-x32",
  "public": false
}
```

### Image Info
Info for existing image.

```
GET /images/{image_identity}
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/images/$IMAGE_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "id": 32,
  "name": "My first snapshot",
  "distribution": "Ubuntu",
  "slug": "ubuntu-12.10-x32",
  "public": false
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
$ curl -n -X GET https://api.heroku.com/images \
-H "Content-Type: application/json" \
-d '{"private":true}'
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id
Content-Range: id 01234567-89ab-cdef-0123-456789abcdef..01234567-89ab-cdef-0123-456789abcdef; max=200
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
[
  {
    "id": 32,
    "name": "My first snapshot",
    "distribution": "Ubuntu",
    "slug": "ubuntu-12.10-x32",
    "public": false
  }
]
```

### Image Update
Update an existing image.

```
PATCH /images/{image_identity}
```


#### Curl Example
```term
$ curl -n -X PATCH https://api.heroku.com/images/$IMAGE_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "id": 32,
  "name": "My first snapshot",
  "distribution": "Ubuntu",
  "slug": "ubuntu-12.10-x32",
  "public": false
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
    <td><strong>fingerprint</strong></td>
    <td><em>string</em></td>
    <td>a unique identifying string based on contents</td>
    <td><code>"17:63:a4:ba:24:d3:7f:af:17:c8:94:82:7e:80:56:bf"</code></td>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of key</td>
    <td><code>18</code></td>
  </tr>
  <tr>
    <td><strong>public_key</strong></td>
    <td><em>string</em></td>
    <td>full public_key as uploaded</td>
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
    <td>full public_key as uploaded</td>
    <td><code>"ssh-rsa AAAAB3NzaC1ycVc/../839Uv username@example.com"</code></td>
  </tr>
</table>



#### Curl Example
```term
$ curl -n -X POST https://api.heroku.com/account/keys \
-H "Content-Type: application/json" \
-d '{"public_key":"ssh-rsa AAAAB3NzaC1ycVc/../839Uv username@example.com"}'
```

#### Response Example
```
HTTP/1.1 201 Created
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "fingerprint": "17:63:a4:ba:24:d3:7f:af:17:c8:94:82:7e:80:56:bf",
  "id": 18,
  "public_key": "ssh-rsa AAAAB3NzaC1ycVc/../839Uv username@example.com",
  "name": "primary-key"
}
```

### Key Delete
Delete an existing key.

```
DELETE /account/keys/{key_identity}
```


#### Curl Example
```term
$ curl -n -X DELETE https://api.heroku.com/account/keys/$KEY_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "fingerprint": "17:63:a4:ba:24:d3:7f:af:17:c8:94:82:7e:80:56:bf",
  "id": 18,
  "public_key": "ssh-rsa AAAAB3NzaC1ycVc/../839Uv username@example.com",
  "name": "primary-key"
}
```

### Key Info
Info for existing key.

```
GET /account/keys/{key_identity}
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/account/keys/$KEY_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "fingerprint": "17:63:a4:ba:24:d3:7f:af:17:c8:94:82:7e:80:56:bf",
  "id": 18,
  "public_key": "ssh-rsa AAAAB3NzaC1ycVc/../839Uv username@example.com",
  "name": "primary-key"
}
```

### Key List
List existing key.

```
GET /account/keys
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/account/keys
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id, fingerprint
Content-Range: id 01234567-89ab-cdef-0123-456789abcdef..01234567-89ab-cdef-0123-456789abcdef; max=200
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
[
  {
    "fingerprint": "17:63:a4:ba:24:d3:7f:af:17:c8:94:82:7e:80:56:bf",
    "id": 18,
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
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>display name of region</td>
    <td><code>"New York 1"</code></td>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of region</td>
    <td><code>3</code></td>
  </tr>
  <tr>
    <td><strong>slug</strong></td>
    <td><em>string</em></td>
    <td>url friendly name</td>
    <td><code>"nyc1"</code></td>
  </tr>
</table>

### Region List
List available regions.

```
GET /regions
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/regions
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id
Content-Range: id 01234567-89ab-cdef-0123-456789abcdef..01234567-89ab-cdef-0123-456789abcdef; max=200
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
[
  {
    "name": "New York 1",
    "id": 3,
    "slug": "nyc1"
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
    <td><strong>name</strong></td>
    <td><em>string</em></td>
    <td>display name of size</td>
    <td><code>"512MB"</code></td>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>integer</em></td>
    <td>unique identifier of size</td>
    <td><code>2</code></td>
  </tr>
  <tr>
    <td><strong>slug</strong></td>
    <td><em>string</em></td>
    <td>url friendly name</td>
    <td><code>"512mb"</code></td>
  </tr>
</table>

### Size List
List available sizes.

```
GET /sizes
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/sizes
```

#### Response Example
```
HTTP/1.1 200 OK
Accept-Range: id
Content-Range: id 01234567-89ab-cdef-0123-456789abcdef..01234567-89ab-cdef-0123-456789abcdef; max=200
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
[
  {
    "name": "512MB",
    "id": 2,
    "slug": "512mb"
  }
]
```

