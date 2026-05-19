# Port rules

This repo is for a faithful HTML5 port/rewrite of the KnowYourKnot/Binweevils private server.

## Source of truth order

1. `legacy-reference/Binweevils-main/` local checkout of the KnowYourKnot/Binweevils source.
2. Verified original game/private-server assets extracted from that source.
3. Existing HTML5 prototype code only where it helps preserve already-solved behaviour.

The existing HTML5 build is a useful reference, but it is not the visual or behavioural source of truth.

## Do not do

- Do not build a generic modern MMO shell.
- Do not replace the backend with Socket.IO by default.
- Do not invent UI, room chrome, buttons, or nameplates that were not present in the original client.
- Do not overwrite source-reference files.
- Do not commit `legacy-reference/` directly.
- Do not port a whole subsystem in one giant pass.
- Do not assume paths; inspect and document real files first.

## Faithfulness targets

- Original room art, scale, composition, and layering.
- Original-style UI frame and controls.
- Original-style chat bubbles.
- Original-feeling click-to-move.
- Weevil rendering based on real weevil/avatar assets where possible.
- Backend/database flow kept close to the original PHP/MySQL/server structure where sensible.

## Allowed private-server extensions

These are allowed, but must not visually take over the client:

- level bank
- prestige
- admin/mod commands
- cleaner internal code
- maintenance/debug tooling

## First milestone

Port one real room into HTML5. Preferred order:

1. Ink's Orange Peel / The Peel, if source assets are complete enough.
2. Peel Park, if easier or more complete.
3. A nest room only if public-room assets are harder to isolate.
