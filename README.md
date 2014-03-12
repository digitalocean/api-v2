# DigitalOcean v2 API Schema

This is a work in progress repository, currently focusing on the design of the next major version of DigitalOcean API.

## Using this repo

The `output/doc.md` file is generated documentation from the resource schemas found in `schemas`. The full schema is available
in `output/schema.json`. 

There is also a changelog available in `CHANGELOG.md`. It currently focuses on changes from the v1 API.

## Todo

 * Refactor action resources to better model action types
 * Add "Pragma: event-wait" header as option for deferred result resources
 * Create template set for producing Blueprint Markdown from schemas
