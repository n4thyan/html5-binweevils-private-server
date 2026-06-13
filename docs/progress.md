# Current progress handoff

Date: 2026-06-13

## Current state

The project is now in a strong source-backed Nest-room and first-pass gameplay UI reconstruction phase.

Confirmed:

```text
HTML5/Vite app boots locally
weevil renderer restored from the proven old HTML5 demo
weevil rendering visually confirmed
mainDEV661.swf boot flow mapped and tested
core5.swf Bin.as init flow mapped and tested
core5.swf UImain.as structure mapped and tested
core5.swf CamUI.as structure and behaviour mapped and tested for later 3D-camera rooms
core5.swf UI symbols mapped to real FFDec DefineSprite export paths
real core UI SVG exports load in browser probes
FixedCamera LocFactory/Loc/LocFixedCam source model mapped and tested
RumsCove/RumsAirport preserved as a complex research checkpoint
Nest room family selected as the active simpler room target
Nest navigation demo has source-backed loc, door, spawn, scale, movement snapshot, yaw bridge, and projection research checkpoints
Core5 Walk.as behaviour ids and walking snapshot state are ported/tested
Core5 getFloorClickCoords-style floor projection module exists and is smoke-tested
mainDEV661.swf green slime/canvas shell separated from core5 gameplay HUD work
core5 gameplay HUD sprite registry now exists for level, mulch, Dosh, hunger, chatbar, and map candidates
```

## Active room decision

Use the Nest room set as the active first complete room family.

```text
loc 1,2,3,4,6,7,8,9: normal Nest rooms
loc 5: Nest Hall
loc 10: home cinema / tycoon room, deferred
loc 20: garden, deferred
```

Source file:

```text
source/knowyourknot-binweevils/game-full/binConfig/getFile/200/uk/nestLocDefs.xml
```

Important camera/scale source values:

```text
normal Nest rooms: camPos 0,190,-330 / camAim 0,90,260 / weevilScale 0.5
Nest Hall: camPos 0,145,-115 / camAim 0,15,500 / weevilScale 0.45
Nest Garden: camPos -880,870,-680 / camAim 10,108,200 / weevilScale 0.16
```

## Current Nest proof pages

```text
/probes/nest-navigation-demo.html
/probes/nest-coordinate-lab.html
/probes/nest-ui-canvas-port.html
```

Status:

```text
room render and visual door targets are source-backed enough for debug work
rendered weevil overlay works
Core5 movement snapshot HUD works
yaw bridge calibration exists but is not final movement
Core5 floor projection module is checkpointed but not yet wired as final movement
clean UI canvas is the active UI reconstruction surface
```

## Current UI shell direction

The green slime/canvas shell is a `mainDEV661.swf` target.

The gameplay HUD pieces are a `core5.swf` target and are now tracked in a first-pass registry.

Current UI registry files:

```text
src/ui/Core5UiSpriteIds.js
tests/core5-ui-sprite-ids-smoke.mjs
docs/core5-first-pass-ui-sprite-registry.md
```

First-pass gameplay UI targets:

```text
level: DefineSprite 1680, 1681, 1682, 1684, 1685
mulch: DefineSprite 1686, 1688
Dosh: DefineSprite 1701, 1706, 1708
hunger: DefineSprite 1697, 1699
chatbar: DefineSprite 1716, 1718, 1721, 1723, 1724, 1725
map: DefineSprite 1757, 1761, 1786, 1790, 1795 candidates
```

Current UI rule:

```text
Do not invent UI art.
Use the registry and original exported SVGs.
Screenshots/JPEXS grids are identification aids only.
```

## Movement status

Movement is parked for now.

Completed checkpoints:

```text
Core5 behaviour ID registry
Core5 Walk.as movement model
Core5 walk snapshot state
Nest movement debug HUD
yaw bridge calibration layer
Core5 floor projection module
```

Not final yet:

```text
full 1:1 click-to-world wiring in the demo
reverse Core5 x/z to screen placement in the demo
leg animation bridge into the renderer
legaliseClick/isForbidden/walk-mask integration
```

## Useful docs

```text
docs/roadmap.md
docs/rooms/nest-room-port-plan.md
docs/rooms/rums-cove-video-pod-audit.md
docs/rooms/videoPod1_10_05_12-audit.md
docs/rooms/videoPod1-locationDefinitions-link.md
docs/room-camera-model-notes.md
docs/core-ui-asset-probe-findings.md
docs/core5-first-pass-ui-sprite-registry.md
docs/ui-layout-reference-notes.md
```

## Current test suite additions

`npm.cmd test` now includes:

```text
node tests/core5-ui-sprite-ids-smoke.mjs
```

Useful individual checks:

```text
node tests/core5-ui-sprite-ids-smoke.mjs
node tests/core5-floor-projection-smoke.mjs
node tests/core5-weevil-behaviours-smoke.mjs
node tests/core5-walk-snapshot-smoke.mjs
node tests/core5-walk-behaviour-smoke.mjs
node tests/nest-weevil-spawn-profiles-smoke.mjs
node tests/nest-weevil-scale-profiles-smoke.mjs
node tests/nest-door-visual-targets-smoke.mjs
```

## Next recommended order

```text
1. Pull latest nest-room-demo.
2. Run npm.cmd test.
3. Open /probes/nest-ui-canvas-port.html.
4. Start wiring level/mulch/Dosh/hunger/chatbar/map visual candidates from src/ui/Core5UiSpriteIds.js.
5. Keep movement parked unless explicitly resumed.
6. Do not add public/generated, xml, or local decompiled scratch folders to commits.
```

## Do not do yet

```text
do not implement backend/session bridge
do not implement multiplayer
do not guess missing UI art as final
do not replace the proven weevil renderer
do not resume movement unless requested
do not treat screenshots as final assets
do not hand-draw permanent gameplay HUD pieces
```
