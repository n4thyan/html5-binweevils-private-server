# Current progress handoff

Date: 2026-06-13

## Current state

The project is now in a source-backed Nest-room and gameplay UI reconstruction phase.

Confirmed:

```text
HTML5/Vite app boots locally
weevil renderer restored from the proven old HTML5 demo
mainDEV661.swf boot flow mapped and tested
core5.swf Bin.as init flow mapped and tested
core5.swf UImain.as structure mapped and tested
core5.swf CamUI.as structure and behaviour mapped and tested for later 3D-camera rooms
real core UI SVG exports load in browser probes
Nest room family selected as the active simpler room target
Nest navigation demo has source-backed loc, door, spawn, scale, movement snapshot, yaw bridge, and projection research checkpoints
Core5 Walk.as behaviour ids and walking snapshot state are ported/tested
Core5 getFloorClickCoords-style floor projection module exists and is smoke-tested
mainDEV661.swf green loading/shell candidates are separated from core5 gameplay HUD work
core5 gameplay HUD sprite registry is source-led and the active render pass is narrowed to the user-selected Level icon and XP bar only
```

## Current UI shell direction

The gameplay HUD pieces are a `core5.swf` target and are tracked in a first-pass registry.

Current UI registry/layout files:

```text
src/ui/Core5UiSpriteIds.js
src/ui/Core5UiCanvasFirstPassLayout.js
tests/core5-ui-sprite-ids-smoke.mjs
tests/core5-ui-canvas-first-pass-layout-smoke.mjs
docs/core5-first-pass-ui-sprite-registry.md
public/probes/core5-ui-level-xp-candidate.html
```

Current active UI pass:

```text
Level icon: DefineSprite 1704
XP bar below level icon: DefineSprite 1681
```

Source leads for later passes:

```text
Other level parts: DefineSprite 1680, 1682, 1684, 1685
Mulch: DefineSprite 1686, 1688
Dosh: DefineSprite 1701, 1706, 1708
Hunger: DefineSprite 1697, 1699
Chatbar: DefineSprite 1716, 1718, 1724, 1725
Map: DefineSprite 1786 and 1790 are visible source-grid leads; exact sidebar Map button still needs its own visual pass
```

Current UI rule:

```text
Do one UI element group at a time.
Do not invent UI art.
Use the registry and original exported SVGs.
Screenshots/JPEXS grids are identification aids only.
Do not stretch later candidates into the canvas before confirming them.
Verify the raw Level/XP candidates before placing more HUD elements into the main Nest UI canvas.
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

## Current Nest proof pages

```text
/probes/nest-navigation-demo.html
/probes/nest-coordinate-lab.html
/probes/nest-ui-canvas-port.html
/probes/core5-ui-level-xp-candidate.html
```

## Current test suite additions

`npm.cmd test` includes UI and movement/projection smoke tests.

Useful individual checks:

```text
node tests/core5-ui-sprite-ids-smoke.mjs
node tests/core5-ui-canvas-first-pass-layout-smoke.mjs
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
3. Open /probes/core5-ui-level-xp-candidate.html.
4. Confirm DefineSprite 1704 and DefineSprite 1681 visibly load from the local core5 export.
5. Only after that, place those two confirmed pieces into /probes/nest-ui-canvas-port.html.
6. Then move to Mulch as the next UI group.
7. Keep movement parked unless explicitly resumed.
8. Do not add public/generated, xml, or local decompiled scratch folders to commits.
```
