# HTML5 Bin Weevils Private Server

This repository is being rebuilt as a clean, faithful Flash-to-HTML5 port of Bin Weevils.

The goal is not to make a loose remake, a reimagining, or a generic Bin Weevils-inspired MMO. The goal is to port the original Flash client behaviour, layout, asset usage, room flow, avatar rendering, UI logic, and server expectations into a native HTML5/JavaScript client.

## Current confirmed state

The project is currently in the source-backed foundation, Nest room rendering, Core5 movement research, and first gameplay UI reconstruction phase.

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
Nest room export has been inspected and selected as the simpler active room family
Nest navigation demo has source-backed room/door/scale/spawn movement probes
Core5 Walk.as behaviour ids, walking snapshot state, yaw bridge calibration, and floor projection module are checkpointed
Core5 gameplay UI sprite ids are tracked in a source-led registry
The current gameplay UI pass is narrowed to the user-confirmed Level icon and XP bar candidates only
```

Not implemented yet:

```text
final UI shell
real room rendering in the main client scene
source-backed FixedCam projection/depth in production scene
final Flash-accurate click-to-move
room-to-room navigation in the main client
chat
playercards
inventory
backend/session bridge
multiplayer sync
```

The visible debug scenes/probes are not intended to be the final client screen. They are verification surfaces for renderer, boot-flow, source-map, asset-path, room audit, UI registry, and movement-coordinate work.

## Current room direction

Rums Cove / Rums Airport remains valuable, but it is now parked as a complex research checkpoint.

The active first complete room family is the Nest room set from the uploaded `nest dump.zip`:

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
Nest Hall is available but more complex
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
src/movement/Core5WalkBehaviour.js
src/movement/Core5MovementModel.js
src/movement/Core5WeevilBehaviours.js
src/movement/Core5FloorProjection.js
scripts/audit-movement-source-data.mjs
tests/movement-coordinate-sandbox-smoke.mjs
tests/core5-weevil-behaviours-smoke.mjs
tests/core5-walk-behaviour-smoke.mjs
tests/core5-walk-snapshot-smoke.mjs
tests/core5-floor-projection-smoke.mjs
public/probes/movement-coordinate-sandbox.html
public/probes/nest-navigation-demo.html
```

Important rule:

```text
movement sandbox/probes are allowed
fake movement system is not
```

Movement is currently parked after the Core5 floor projection checkpoint. The next active work is the gameplay UI shell registry/canvas pass unless movement is explicitly resumed.

## UI shell direction

The green slime/loading/canvas shell belongs to `mainDEV661.swf`, not the core gameplay HUD track. It must not be used as the final gameplay background.

The gameplay HUD/core UI pass is now tracked separately:

```text
src/ui/Core5UiSpriteIds.js
src/ui/Core5UiCanvasFirstPassLayout.js
tests/core5-ui-sprite-ids-smoke.mjs
tests/core5-ui-canvas-first-pass-layout-smoke.mjs
docs/core5-first-pass-ui-sprite-registry.md
public/probes/nest-ui-canvas-port.html
public/probes/core5-ui-level-xp-candidate.html
```

Current active gameplay UI targets:

```text
level icon: DefineSprite 1704
XP bar below level icon: DefineSprite 1681
```

Parked source leads:

```text
other level parts: DefineSprite 1680, 1682, 1684, 1685
mulch: DefineSprite 1686, 1688
Dosh: DefineSprite 1701, 1706, 1708
hunger: DefineSprite 1697, 1699
chatbar: DefineSprite 1716, 1718, 1724, 1725
map: DefineSprite 1786 / 1790 are visible source-grid leads; DefineSprite 1757 is documented as a wrong map-panel candidate, not the HUD button
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
source/knowyourknot-binweevils/game-full/binConfig/getFile/200/uk/nestLocDefs.xml
reference/rooms/nest-dump/  # local extract target for nest dump.zip
```

Key decompiled files:

```text
mainDEV661.swf/scripts/com/binweevils/Main.as
mainDEV661.swf/scripts/com/binweevils/STAGE.as
core5.swf/scripts/com/binweevils/Bin.as
core5.swf/scripts/com/binweevils/UImain.as
core5.swf/scripts/com/binweevils/CamUI.as
core5.swf/scripts/com/binweevils/engine3D/Cam3D.as
core5.swf/scripts/com/binweevils/engine3D/ViewPort.as
core5.swf/scripts/com/binweevils/engine3D/visuals/LocFactory.as
core5.swf/scripts/com/binweevils/engine3D/visuals/Loc.as
core5.swf/scripts/com/binweevils/engine3D/visuals/LocNest.as
core5.swf/symbolClass/symbols.csv
```

Room audit docs:

```text
docs/rooms/rums-cove-source-audit.md
docs/rooms/rums-cove-layer-plan.md
docs/rooms/rums-cove-static-layout.md
docs/rooms/rums-cove-v2-layer-plan.md
docs/rooms/nest-room-port-plan.md
```

## Local development

```powershell
npm.cmd install
npm.cmd run dev
```

Useful current probes:

```text
/probes/nest-navigation-demo.html
/probes/nest-coordinate-lab.html
/probes/nest-ui-canvas-port.html
/probes/core5-ui-level-xp-candidate.html
```

Useful current tests:

```powershell
npm.cmd test
node .\tests\core5-ui-sprite-ids-smoke.mjs
node .\tests\core5-ui-canvas-first-pass-layout-smoke.mjs
node .\tests\core5-floor-projection-smoke.mjs
```
