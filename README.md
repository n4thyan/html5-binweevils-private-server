# HTML5 Bin Weevils Private Server

This repository is being rebuilt as a clean, faithful Flash-to-HTML5 port of Bin Weevils.

The goal is not to make a loose remake, a reimagining, or a generic Bin Weevils-inspired MMO. The goal is to port the original Flash client behaviour, layout, asset usage, room flow, avatar rendering, UI logic, and server expectations into a native HTML5/JavaScript client.

## Current confirmed state

The project is currently in the source-backed foundation, room-rendering research, movement-coordinate, and first simple room-family planning phase.

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
core5.swf CamUI.as behaviour/child structure is mapped for later 3D-camera rooms
important core5.swf UI symbols are mapped to real FFDec DefineSprite export paths
real exported UI SVG file existence is tested
standalone core UI asset probe page loads real core5.swf exported SVGs in the browser
FixedCamera room source model is mapped from LocFactory/Loc/LocFixedCam
FixedCamera location XML parser/candidate scorer exists and is tested
RumsCove locID 129 has been identified and heavily audited
RumsCove source-backed manifest is tested
RumsCove preview/render probes proved XML placement, source sprites, bitmap base layers, and door overlays
RumsCove/RumsAirport is now treated as a complex research checkpoint, not the first complete room target
movement source data audit scans real locationDefinitions data
movement scale baselines separate normal sandbox scale from room-specific scale
blank movement coordinate sandbox model and smoke test exist
Nest room export has been inspected and selected as the next simpler room family
```

Not implemented yet:

```text
final UI shell
real room rendering in the main client scene
source-backed FixedCam projection/depth in production scene
final Flash-accurate click-to-move
room-to-room navigation
chat
playercards
inventory
map
backend/session bridge
multiplayer sync
```

The visible debug scenes/probes are not intended to be the final client screen. They are verification surfaces for renderer, boot-flow, source-map, asset-path, room audit, and movement-coordinate work.

## Current room direction

Rums Cove / Rums Airport remains valuable, but it is now parked as a complex research checkpoint.

The new recommended first complete room family is the Nest room set from the uploaded `nest dump.zip`:

```text
nestRoom1.swf
nestRoom2.swf
nestRoom3.swf
nestRoom4.swf
nestRoom6.swf
nestRoom7.swf
nestRoom8.swf
nestRoom9.swf
nestHall_03_06_11.swf
SWF XML/*.xml
```

Reason:

```text
nestRoom1/nestRoom2 are small and source-backed
simple rooms expose roomBG_spr, door1_mc and clickArea_btn
simple rooms have matching SWF XML exports
simple rooms avoid dynamic ads, planes, video pods and complex one-off Rums layers
Nest Hall is available but deferred because it is much larger and more complex
```

Current Nest source manifest / plan:

```text
src/rooms/NestRoomManifest.js
docs/rooms/nest-room-port-plan.md
```

Rums proof pages remain useful research references:

```text
/probes/rums-cove-preview.html
/probes/rums-cove-canvas.html
/probes/rums-cove-weevil.html
/probes/rums-cove-render-basics-v2.html
```

## Movement direction

Movement is being treated as a source-backed coordinate port, not a fake HTML5 movement system.

Current files:

```text
src/movement/MovementPortPlan.js
src/movement/MovementScaleBaselines.js
src/movement/MovementCoordinateSandbox.js
scripts/audit-movement-source-data.mjs
tests/movement-coordinate-sandbox-smoke.mjs
public/probes/movement-coordinate-sandbox.html
```

Important rule:

```text
movement sandbox is allowed
fake movement system is not
```

The sandbox uses a normal audited `0.28` movement baseline, while room-specific values such as Rums Cove exterior `0.18` stay attached to their original rooms only.

## UI shell direction

The green slime/canvas shell belongs to `mainDEV661.swf`, not the core/playercard UI asset track.

Current slime shell candidate paths:

```text
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/frames/1.png
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_4/1.svg
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_96/1.svg
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_113/1.svg
```

Playercard icons/assets are a separate core/playercard target. Recent playercard icon screenshots should not be used as slime-frame sources.

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
source/knowyourknot-binweevils/game-full/binConfig/getFile/7/uk/locationDefinitions.xml
reference/rooms/nest-dump/  # local extract target for nest dump.zip
```

Key decompiled files:

```text
mainDEV661.swf/scripts/com/binweevils/Main.as
mainDEV661.swf/scripts/com/binweevils/STAGE.as
core5.swf/scripts/com/binweevils/Bin.as
core5.swf/scripts/com/binweevils/UImain.as
core5.swf/scripts/com/binweevils/CamUI.as
core5.swf/scripts/com/binweevils/engine3D/visuals/LocFactory.as
core5.swf/scripts/com/binweevils/engine3D/visuals/Loc.as
core5.swf/scripts/com/binweevils/engine3D/visuals/LocFixedCam.as
core5.swf/symbolClass/symbols.csv
```

Room audit docs:

```text
docs/rooms/nest-room-port-plan.md
docs/rooms/rums-cove-video-pod-audit.md
docs/rooms/videoPod1_10_05_12-audit.md
docs/rooms/videoPod1-locationDefinitions-link.md
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
npm run test:cam-ui-source-map
npm run test:fixed-cam-room-source-map
npm run test:fixed-cam-loc-definition
npm run test:rums-cove-manifest
npm run test:rums-cove-preview-calibration
npm run test:core-symbol-locator
npm run test:core-ui-asset-probe-plan
npm run test:core-ui-asset-files
npm run test:render-plan
npm run test:prototype-renderer
node tests/movement-coordinate-sandbox-smoke.mjs
```

Useful debug pages:

```text
/probes/core-ui-assets.html
/probes/rums-cove-preview.html
/probes/rums-cove-canvas.html
/probes/rums-cove-weevil.html
/probes/rums-cove-render-basics-v2.html
/probes/movement-coordinate-sandbox.html
/probes/main-slime-shell.html
```

## Current roadmap snapshot

```text
Milestone 001: client foundation - mostly complete
Milestone 002: weevil renderer baseline - confirmed visually working
Milestone 003: main/core source mapping - strong progress
Milestone 004: real core UI asset probe - debug page working
Milestone 005: source-backed UI shell from mainDEV661.swf/core5.swf assets - active source mapping
Milestone 006: FixedCamera/Rums research checkpoint - strong progress, parked for later
Milestone 007: Nest simple room render + movement - next target
Milestone 008: source-backed local movement/depth
Milestone 009: local chat and speech bubbles
Milestone 010: backend/session bridge
```

For the full roadmap, read:

```text
docs/roadmap.md
docs/milestones.md
docs/progress.md
docs/main-core-source-map.md
docs/decompiled-core-main-audit.md
```

## Start here

Read these first:

```text
docs/progress.md
docs/port-charter.md
docs/architecture.md
docs/roadmap.md
docs/milestones.md
docs/main-core-source-map.md
docs/decompiled-core-main-audit.md
docs/renderer-transplant-checklist.md
docs/rooms/nest-room-port-plan.md
docs/rooms/rums-cove-video-pod-audit.md
```

The project is intentionally moving slowly and verifiably. The aim is a proper 1:1 source-backed port, not a fast fake remake.
