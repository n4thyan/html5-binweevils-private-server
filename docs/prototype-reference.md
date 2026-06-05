# Prototype reference policy

The old HTML5 build is not the foundation of this project.

It is a proof-of-concept that showed some useful ideas, especially the weevil editor/rendering work. It also contains many systems that should not be treated as faithful or final.

## Reusable with review

The following areas may be reviewed and selectively ported:

```text
weevil definition parsing
weevil renderer
canvas renderer
atlas loader
projection/math helpers
chat bubble positioning experiments
click-to-move experiments
```

## Not authoritative

Do not use the old demo as authority for:

```text
room choice
room scale
UI chrome
backend architecture
account system
admin tools
map flow
minigames
visual style
asset provenance
```

## Extraction rule

If a prototype file is reused, record:

```text
prototype path
why it is useful
original source file it was checked against
changes made during cleanup
known gaps
```

## Storage

Raw extracted demo files, if needed locally, should go under:

```text
prototype-reference/raw/
```

That folder is ignored by Git.

Small notes, diagrams, and reviewed snippets can be committed under `docs/` or clean source modules under `src/`.
