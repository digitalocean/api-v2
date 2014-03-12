
all: doc schema

doc:
	prmd doc -m meta.json -p docs/header.md,docs/overview.md schemas > output/doc.md

schema:
	prmd combine -m meta.json schemas > output/schema.json