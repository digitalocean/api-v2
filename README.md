# DigitalOcean v2 API Schema

This is a work in progress repository, currently focusing on the design of the next major version of DigitalOcean API.

## Using this repo

The `doc.md` file is generated documentation from the resource schemas found in `schemas`. The full schema is available
in `schema.json`. 

# Development

The project uses a [forked version](https://github.com/progrium/prmd) of Heroku's toolchain for designing and managing their API. Any changes to the API should be done directly to resource schema files and then run `make` to re-build docs and the combined schema. 

# Roadmap

- [x] sketch out new resources and endpoints (see `sketch.txt`)
- [ ] create full schemas for them
- [ ] write API intro docs (auth, range, etc)
- [ ] get internal feedback, iterate
- [ ] start new Go frontend
- [ ] get trusted external feedback, iterate