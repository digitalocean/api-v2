
all: doc schema

doc:
	prmd doc -m meta.json -p docs/header.md,docs/overview.md schemas > output/doc.md

schema:
	prmd combine -m meta.json schemas > output/schema.json

blueprint:
	prmd doc -m meta.json -v blueprint -p blueprint/header.md,docs/overview.md schemas > output/blueprint.md

aglio: blueprint
	aglio -i output/blueprint.md -s

validate: blueprint
	cat output/blueprint.md | snowcrash -v

.PHONY: blueprint