# Current progress handoff

Date: 2026-06-05

## Current state

The project is now in a strong source-backed foundation state.

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
videoPod1_10_05_12 audited as a related simple VOD/external scene candidate
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
core symbol locator
core UI asset probe plan
core UI asset file existence
render plan
prototype renderer
```

## Tomorrow recommended order

```text
1. Pull latest main.
2. Run npm.cmd test.
3. Put the Rums export into a stable reference folder if not already committed.
4. Create a RumsCove room manifest from locID 129 plus the Rums symbol map.
5. Add a debug-only Rums room preview page using frames/1.png.
6. Start the first real FixedCamera room render after the preview is verified.
7. Continue source-backed UI shell mapping in parallel.
```

## Do not do yet

```text
do not implement backend/session bridge
do not implement multiplayer
do not guess missing room data as final
do not prioritise 3D camera CamUI rooms before the first FixedCamera milestone
do not implement dynamic room extras before the static room render works
do not replace the proven weevil renderer
```
