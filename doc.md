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
    <td><strong>created_at</strong></td>
    <td><em>date-time</em></td>
    <td>when domain-record was created</td>
    <td><code>"2012-01-01T12:00:00Z"</code></td>
  </tr>
  <tr>
    <td><strong>id</strong></td>
    <td><em>uuid</em></td>
    <td>unique identifier of domain-record</td>
    <td><code>"01234567-89ab-cdef-0123-456789abcdef"</code></td>
  </tr>
  <tr>
    <td><strong>updated_at</strong></td>
    <td><em>date-time</em></td>
    <td>when domain-record was updated</td>
    <td><code>"2012-01-01T12:00:00Z"</code></td>
  </tr>
</table>

### Domain Record Create
Create a new domain-record.

```
POST /domain-records
```


#### Curl Example
```term
$ curl -n -X POST https://api.heroku.com/domain-records
```

#### Response Example
```
HTTP/1.1 201 Created
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "created_at": "2012-01-01T12:00:00Z",
  "id": "01234567-89ab-cdef-0123-456789abcdef",
  "updated_at": "2012-01-01T12:00:00Z"
}
```

### Domain Record Delete
Delete an existing domain-record.

```
DELETE /domain-records/{domain_record_identity}
```


#### Curl Example
```term
$ curl -n -X DELETE https://api.heroku.com/domain-records/$DOMAIN_RECORD_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "created_at": "2012-01-01T12:00:00Z",
  "id": "01234567-89ab-cdef-0123-456789abcdef",
  "updated_at": "2012-01-01T12:00:00Z"
}
```

### Domain Record Info
Info for existing domain-record.

```
GET /domain-records/{domain_record_identity}
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/domain-records/$DOMAIN_RECORD_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "created_at": "2012-01-01T12:00:00Z",
  "id": "01234567-89ab-cdef-0123-456789abcdef",
  "updated_at": "2012-01-01T12:00:00Z"
}
```

### Domain Record List
List existing domain-record.

```
GET /domain-records
```


#### Curl Example
```term
$ curl -n -X GET https://api.heroku.com/domain-records
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
    "created_at": "2012-01-01T12:00:00Z",
    "id": "01234567-89ab-cdef-0123-456789abcdef",
    "updated_at": "2012-01-01T12:00:00Z"
  }
]
```

### Domain Record Update
Update an existing domain-record.

```
PATCH /domain-records/{domain_record_identity}
```


#### Curl Example
```term
$ curl -n -X PATCH https://api.heroku.com/domain-records/$DOMAIN_RECORD_IDENTITY
```

#### Response Example
```
HTTP/1.1 200 OK
ETag: "0123456789abcdef0123456789abcdef"
RateLimit-Remaining: 1200
```
```javascript```
{
  "created_at": "2012-01-01T12:00:00Z",
  "id": "01234567-89ab-cdef-0123-456789abcdef",
  "updated_at": "2012-01-01T12:00:00Z"
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

