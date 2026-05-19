# HTML5 Binweevils Private Server

A faithful HTML5 port/rewrite of the KnowYourKnot/Binweevils private server project.

The goal is not to make a generic Bin Weevils-inspired MMO. The goal is to preserve the original private-server structure, assets, UI style, room flow, backend logic, and weevil behaviour as closely as practical while replacing the Flash/SWF client with an HTML5 client.

## Current milestone

Milestone 001 is a source audit and first-room selection pass.

Before building the game client, the repo will document:

- where the local KnowYourKnot source is expected to live
- which original assets exist
- which room is cleanest for the first playable slice
- which parts of the uploaded HTML5 prototype are reusable
- which backend/database/game-server systems should be preserved

## Local source reference

Place the original KnowYourKnot/Binweevils source locally at:

```text
legacy-reference/Binweevils-main/
```

`legacy-reference/` is ignored by Git on purpose. It is a source-of-truth reference folder, not something to blindly commit into this repo.

## Preferred first playable slice

Port one real room into HTML5:

1. Ink's Orange Peel / The Peel, if the original source has complete enough assets.
2. Peel Park, if it is cleaner.
3. A nest room only if public-room assets are harder to isolate.

The first playable demo should focus on:

- Apache/XAMPP-served HTML5 client
- one real room background/assets from the original source
- faithful UI frame/buttons using original UI assets
- HTML5 weevil renderer using real weevil assets where possible
- click-to-move
- original-style chat bubble
- basic chat and hidden/admin command parsing
- backend/database flow kept close to the original where practical

## Project docs

Start here:

- `docs/port-rules.md`
- `docs/source-audit.md`
- `docs/windows-audit-commands.md`
- `docs/first-room-selection.md`
- `docs/prototype-build-notes.md`
