## Region


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
    <td><code>"3"</code></td>
  </tr>
  <tr>
    <td><strong>slug</strong></td>
    <td><em>string</em></td>
    <td>url friendly name</td>
    <td><code>"nyc1"</code></td>
  </tr>
</table>

### Region List
List existing region.

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
    "id": "3",
    "slug": "nyc1"
  }
]
```

