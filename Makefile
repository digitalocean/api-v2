
all: doc schema

doc:
	prmd doc -m meta.json -p docs/overview.md schemas > doc.md

schema:
	prmd combine schemas > schema.json