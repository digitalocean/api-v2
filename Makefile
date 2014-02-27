
all: doc schema

doc:
	prmd doc schemas > doc.md

schema:
	prmd combine schemas