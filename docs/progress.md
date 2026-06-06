# Current progress handoff

Date: 2026-06-06

## Current state

The project is now in a strong source-backed foundation state with the first real room and first main-shell UI candidates visually proven.

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
real core UI SVG exports load in a browser probe page
FixedCamera LocFactory/Loc/LocFixedCam source model mapped and tested
FixedCamera loc XML parser/candidate scorer added and tested
locationDefinitions.xml checked
RumsCove locID 129 selected as first strict FixedCamera room target
RumsCove manifest added and tested
Rums Cove room preview loads in-browser from exported room-family assets
Rums Cove canvas overlay probe consumes source-backed manifest data
Rums Cove + real weevil probe works after renderer preload fix
Rums Cove weevilScale 0.18 visually looks correct in the room preview
Rums Cove preview calibration constants added and tested
mainDEV661.swf green slime/canvas shell separated from core/playercard UI work
mainDEV661.swf slime shell candidates identified for browser probing
```

## Current first-room decision

Use Rums Cove as the first strict FixedCamera room milestone.

```text
locID: 129
name: RumsCove
type: 2 / FixedCam
roomBG from XML: fixedCam/RumsAirport_180321.swf
uploaded room-family export: RumsAirport_dynamAds_videoPodv2_release.zip
boundary: -240,60,680,90
camPos: 0,190,-330
camAim: 0,90,260
entryPos: 0,80
entryDir: 180
weevilScale: 0.18
```

Important caution:

```text
locationDefinitions.xml references fixedCam/RumsAirport_180321.swf
uploaded export is RumsAirport_dynamAds_videoPodv2_release.zip
```

Treat these as the same room family for planning, but do not claim exact equivalence until checked.

## Current Rums proof pages

```text
/probes/rums-cove-preview.html
/probes/rums-cove-canvas.html
/probes/rums-cove-weevil.html
```

Status:

```text
preview image loads
manifest data can be overlaid
real weevil renderer appears after preload
scale 0.18 looks correct for this room
placement is still manually calibrated and debug-only
```

## Current UI shell direction

The green slime/canvas shell is a `mainDEV661.swf` target.

The playercard icons/assets are a separate `core5.swf` playercard target and must not be mixed into the slime-frame work.

Current main slime shell candidates:

```text
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/frames/1.png
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_4/1.svg
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_96/1.svg
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_113/1.svg
```

Current slime shell probe:

```text
/probes/main-slime-shell.html
```

## Related scene

`videoPod1_10_05_12` is useful, but it is not the first strict FixedCam room target.

Use it later as a related VOD/interior scene candidate once Rums Cove render and door/navigation logic are further along.

## Useful docs

```text
docs/rooms/rums-cove-video-pod-audit.md
docs/rooms/videoPod1_10_05_12-audit.md
docs/rooms/videoPod1-locationDefinitions-link.md
docs/room-camera-model-notes.md
docs/core-ui-asset-probe-findings.md
docs/ui-layout-reference-notes.md
```

## Current test suite

`npm.cmd test` covers:

```text
boot flow
core init flow
UImain source map
CamUI source map
FixedCam room source map
FixedCam loc definition parser
RumsCove manifest
RumsCove preview calibration
core symbol locator
core UI asset probe plan
core UI asset file existence
render plan
prototype renderer
```

Individual useful new checks:

```text
node tests/rums-cove-manifest-smoke.mjs
node tests/rums-cove-preview-calibration-smoke.mjs
node tests/viewport-slime-frame-source-map-smoke.mjs
```

## Next recommended order

```text
1. Pull latest main.
2. Run npm.cmd test.
3. Open /probes/main-slime-shell.html and verify mainDEV661 slime shell candidates load.
4. If the main shell probe looks correct, record which candidate(s) are the real shell pieces.
5. Begin a reusable FixedCam/RumsCove scene module from the successful room + weevil probe.
6. Add a source-backed UI shell probe that puts RumsCove behind the main slime frame.
7. Only after that, begin projection/depth/movement work.
```

## Do not do yet

```text
do not implement backend/session bridge
do not implement multiplayer
do not guess missing room data as final
do not prioritise 3D camera CamUI rooms before the first FixedCamera milestone
do not implement dynamic room extras before the static room render works
do not replace the proven weevil renderer
do not treat playercard icon screenshots as slime-frame assets
do not hand-draw a permanent slime border
```
