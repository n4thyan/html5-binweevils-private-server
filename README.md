# HTML5 Bin Weevils Private Server

This repository is being rebuilt as a clean, faithful Flash-to-HTML5 port of Bin Weevils.

The goal is not to make a loose remake, a reimagining, or a generic Bin Weevils-inspired MMO. The goal is to port the original Flash client behaviour, layout, asset usage, room flow, avatar rendering, UI logic, and server expectations into a native HTML5/JavaScript client.

## Current confirmed state

The project is currently in the source-backed foundation phase.

Confirmed working:

```text
HTML5/Vite app boots locally
core canvas/stage/scene foundation exists
legacy demo weevil asset renderer has been restored
weevil rendering visually matches the proven old HTML5 demo baseline
multiple sample weevil definitions render through the same asset-backed path
mainDEV661.swf and core5.swf decompiled exports are committed as reference assets
mainDEV661.swf boot flow is mapped into source-backed JS
core5.swf Bin.as init flow is mapped into source-backed JS
core5.swf UImain.as child structure is mapped
important core5.swf UI symbols are mapped to real FFDec DefineSprite export paths
real exported UI SVG file existence is tested
```

Not implemented yet:

```text
final UI shell
room rendering
click-to-move
chat
playercards
inventory
map
backend/session bridge
multiplayer sync
```

The visible debug scene is not intended to be the final client screen. It is a verification surface for renderer, boot-flow, source-map, and asset-path work.

## Source-of-truth order

1. Decompiled original SWF source and verified original assets.
2. Original KnowYourKnot/Binweevils source and verified OG assets.
3. Extracted or converted assets that can be traced back to the original files.
4. The old HTML5 demo only where it preserves already-solved implementation knowledge, such as the proven weevil renderer.
5. Temporary placeholders only when clearly labelled and removed before the relevant milestone is considered complete.

## Important source references

```text
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/
reference/decompiled-dumpassets/dumpassets/core5.swf/
reference/demo-html5/BWR_HTML5_the_peel_room_layers_and_auth_fix/
source/knowyourknot-binweevils/
```

Key decompiled files:

```text
mainDEV661.swf/scripts/com/binweevils/Main.as
mainDEV661.swf/scripts/com/binweevils/STAGE.as
core5.swf/scripts/com/binweevils/Bin.as
core5.swf/scripts/com/binweevils/UImain.as
core5.swf/scripts/com/binweevils/CamUI.as
core5.swf/symbolClass/symbols.csv
```

## Repository roles

```text
src/                    Clean HTML5 port source code.
tests/                  Smoke tests that pin source-backed behaviour and paths.
docs/                   Port rules, architecture notes, source audits, and roadmap.
reference/              Decompiled SWF exports and old demo reference material.
source/                 External source/reference material. Do not edit as port code.
public/                 Static files served by the browser during development.
```

## Porting rule

Every ported system must answer these questions before implementation:

```text
Which original Flash/ActionScript/source file controlled it?
Which original assets did it use?
Which data format did it expect?
What is the matching HTML5 module?
How will fidelity be tested?
```

No feature should be accepted just because it looks close. If behaviour or visuals are guessed, they must be marked as temporary.

## Development commands

Install dependencies:

```bash
npm install
```

Run local dev server:

```bash
npm run dev
```

Run all smoke tests:

```bash
npm test
```

Useful individual tests:

```bash
npm run test:boot-flow
npm run test:core-init-flow
npm run test:ui-main-source-map
npm run test:core-symbol-locator
npm run test:core-ui-asset-probe-plan
npm run test:core-ui-asset-files
npm run test:render-plan
npm run test:prototype-renderer
```

## Current roadmap snapshot

```text
Milestone 001: client foundation - mostly complete
Milestone 002: weevil renderer baseline - confirmed visually working
Milestone 003: main/core source mapping - in progress, strong progress
Milestone 004: real core UI asset probe - next immediate step
Milestone 005: source-backed UI shell from core5.swf/mainDEV661.swf assets
Milestone 006: first FixedCamera room audit
Milestone 007: first room render
Milestone 008: source-backed local movement/depth
Milestone 009: local chat and speech bubbles
Milestone 010: backend/session bridge
```

For the full roadmap, read:

```text
docs/roadmap.md
docs/milestones.md
docs/main-core-source-map.md
docs/decompiled-core-main-audit.md
```

## Start here

Read these first:

```text
docs/port-charter.md
docs/architecture.md
docs/roadmap.md
docs/milestones.md
docs/main-core-source-map.md
docs/decompiled-core-main-audit.md
docs/renderer-transplant-checklist.md
```

The project is intentionally moving slowly and verifiably. The aim is a proper 1:1 source-backed port, not a fast fake remake.
