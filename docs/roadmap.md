# Source-backed port roadmap

This roadmap tracks the faithful Flash-to-HTML5 Bin Weevils port. It is intentionally conservative. A milestone is not complete just because something looks similar; it must be traceable to original source, decompiled SWF code, or verified original assets.

## Guiding rule

```text
Do not invent permanent assets, UI, room layouts, or behaviour.
Use source/decompiled files first.
Use the old HTML5 demo only for already-proven renderer knowledge.
Mark all debug probes and placeholders clearly.
Do not confuse main/root shell assets with core/playercard assets.
```

## Current status snapshot

```text
App foundation: working
Weevil renderer: restored from proven old demo and visually confirmed
Decompiled main/core dump: committed
mainDEV661.swf boot order: mapped and tested
core5.swf Bin.as init order: mapped and tested
core5.swf UImain.as structure: mapped and tested
core5.swf CamUI.as structure/behaviour: mapped and tested for later 3D-camera rooms
core5.swf UI symbol paths: corrected to real FFDec DefineSprite paths and tested
Real exported core UI SVG existence: tested
Core UI asset probe page: working
FixedCamera source model: mapped and tested
FixedCamera loc XML parser/scorer: mapped and tested
RumsCove locID 129: selected as first strict FixedCamera candidate
RumsCove manifest: added and tested
RumsCove room preview: loads in browser
RumsCove + real weevil probe: working after renderer preload fix
RumsCove weevilScale 0.18: visually confirmed plausible
mainDEV661 green slime/canvas shell: source candidates identified
main slime shell probe page: added
Final UI shell: not implemented
Real main-client room scene: not implemented
Movement: not implemented
Backend: not started
```

## Milestone 001: client foundation

Status: mostly complete.

Purpose:

```text
Create a clean browser runtime for the port.
```

Done:

```text
Vite app
canvas/stage foundation
scene manager
game loop
basic debug boot scene
initial docs and rules
```

Still to clean later:

```text
remove or hide obsolete debug-only surfaces when real scenes exist
keep tests updated as source maps become stricter
```

## Milestone 002: weevil renderer baseline

Status: visually confirmed.

Purpose:

```text
Restore the proven old HTML5 demo renderer so we do not regress avatar visuals while porting the real client around it.
```

Done:

```text
legacy demo renderer reference committed
LegacyDemoAssetRenderer adapter added
real extracted weevil assets load
main weevil renders correctly
baseline sample definitions render
render plan tests pass
RumsCove probe confirms the renderer can be drawn over a real room preview
```

Rule:

```text
Do not rewrite the renderer unless there is a source-backed reason.
Use it as the visual baseline while porting rooms and UI.
```

## Milestone 003: main/core source mapping

Status: strong progress.

Purpose:

```text
Map the real Flash boot and core client structure before implementing UI or rooms.
```

Done:

```text
mainDEV661.swf Main.as boot flow mapped
mainDEV661.swf STAGE.as noted
mainDEV661.swf slime/canvas shell candidates recorded
core5.swf Bin.as constructor/init flow mapped
core5.swf UImain.as child structure mapped
core5.swf CamUI.as child names and velocity/button behaviours mapped
core5.swf symbolClass IDs mapped for important UI symbols
FFDec DefineSprite path format corrected
real UI SVG file existence confirmed
```

Next:

```text
prove mainDEV661 slime shell candidates load in browser
map exact main shell symbol composition
map ChatLog and chatbar source paths
map action/emote/phrase source paths
map playercard icons separately from slime shell work
```

## Milestone 004: real core UI asset probe

Status: working as standalone debug page.

Purpose:

```text
Load and display real exported core5.swf UI SVGs in a debug-only probe panel.
```

Done:

```text
/probes/core-ui-assets.html added
weevilProfile/controlTab/alert/dialogue/actions/mouth/pet symbols visually load
raw exported frame caveats documented
side-buttons/pet-profile/weevil-profile notes documented
```

Rules:

```text
This is not the final UI shell.
Do not hand-draw replacements.
Only display actual exported source assets.
Clearly label it debug-only.
```

Remaining optional cleanup:

```text
move probe rendering into canvas only when useful
do not block room/UI progress on this debug page
```

## Milestone 005: source-backed UI shell

Status: active source mapping.

Purpose:

```text
Build the real client UI shell from mainDEV661.swf and core5.swf assets/classes.
```

Current split:

```text
mainDEV661.swf = green slime/canvas shell, root background, already-open frame/panel
core5.swf = gameplay UI pieces such as playercard icons, controls, alerts, dialogue, action UI
screenshots = layout/reference notes only, not asset sources
```

Main slime shell candidates:

```text
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/frames/1.png
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_4/1.svg
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_96/1.svg
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_113/1.svg
```

Current debug page:

```text
/probes/main-slime-shell.html
```

Expected pieces:

```text
contentHolderU_spr/contentHolderL_spr equivalent layers
main slime/canvas shell behind/around room viewport
room content clipped behind frame
lower controls/chat/action strip above correct layer
profile panel holder
chat holder
alert/dialogue/invite overlay layers
rough composition matching later Bin Weevils layout reference
```

Deferred pieces:

```text
pet profile internals
shops/inventory
full buddy tablet internals
3D camera CamUI activation for FixedCamera rooms
backend/session state
```

## Milestone 006: first FixedCamera room audit

Status: active, strong progress.

Purpose:

```text
Select the first room from source evidence and map all required assets/data before rendering it.
```

Rules:

```text
Do not use the old custom The Peel room.
Start with an original FixedCamera room.
Pick the room based on available source/assets, not preference alone.
Record filename/version mismatches instead of hiding them.
```

Done:

```text
FixedCam LocFactory/Loc/LocFixedCam source model mapped
FixedCam loc XML parser/candidate scorer added
videoPod1_10_05_12 audited as related VOD/external scene
locationDefinitions.xml checked
RumsCove locID 129 found and selected as first strict FixedCam candidate
RumsAirport_dynamAds_videoPodv2_release export audited
RumsCove manifest added and tested
RumsCove preview image loaded in browser
RumsCove source manifest consumed by canvas overlay probe
RumsCove + real weevil probe working
RumsCove preview calibration added and tested
```

Current selected room candidate:

```text
locID: 129
name: RumsCove
type: 2
roomBG from XML: fixedCam/RumsAirport_180321.swf
uploaded export: RumsAirport_dynamAds_videoPodv2_release
boundary: -240,60,680,90
camPos: 0,190,-330
camAim: 0,90,260
entryPos: 0,80
entryDir: 180
weevilScale: 0.18
```

Caution:

```text
XML references RumsAirport_180321.swf.
Uploaded export is RumsAirport_dynamAds_videoPodv2_release.
Treat as same room family/variant until exact equivalence is proven.
```

Next:

```text
verify main slime shell probe
create a reusable RumsCove/FixedCam scene module from the successful probe logic
move room preview + weevil render out of throwaway HTML into source modules
add debug boundary/entry/door options to the scene module
```

## Milestone 007: first room render

Status: next room target.

Purpose:

```text
Render one real source-backed FixedCamera room locally.
```

First target:

```text
RumsCove locID 129
```

Completion criteria:

```text
room background/layers visible
coordinate system documented
one real weevil placed with source-backed weevilScale
boundary debug overlay present
door graph available in debug output
no invented room art
room manifest consumed from src/rooms/RumsCoveManifest.js
```

## Milestone 008: local movement and depth

Status: not started.

Purpose:

```text
Port click-to-move, facing, walking and depth sorting from source behaviour.
```

Source areas:

```text
core5.swf/scripts/com/binweevils/Bin.as
core5.swf/scripts/com/binweevils/engine3D/
core5.swf/scripts/com/binweevils/engine3D/visuals/
core5.swf/scripts/com/binweevils/engine3D/visuals/Loc.as
core5.swf/scripts/com/binweevils/engine3D/visuals/LocFixedCam.as
core5.swf/scripts/com/binweevils/engine3D/visuals/creatures/weevils/
core5.swf/scripts/com/binweevils/engine3D/visuals/creatures/weevils/behaviours/
```

Completion criteria:

```text
click target resolves in room coordinates
weevil turns correctly
walk interpolation feels source-backed
Y/depth sorting works
idle state returns correctly
walk boundaries respected where source data exists
```

## Milestone 009: local chat and speech bubbles

Status: not started.

Purpose:

```text
Implement local-only chat UI and speech bubble behaviour before server sync.
```

Source areas:

```text
core5.swf/scripts/com/binweevils/ChatLog.as
core5.swf/scripts/com/binweevils/UImain.as
core5.swf scripts related to chat bar, bubbles and message protocol
```

Completion criteria:

```text
chatbar input exists
bubble appears above local weevil
bubble timing is close to original
chat log/debug output exists
no server dependency yet
```

## Milestone 010: backend/session bridge

Status: not started.

Purpose:

```text
Only after local room behaviour is faithful, connect to backend/session systems.
```

Source areas:

```text
core5.swf/scripts/com/binweevils/conf/MessageProtocol.as
SmartFoxClient references
Bin.as ssclient calls
PHP/PHP2 service call references
existing private-server backend code
```

Completion criteria:

```text
session model
room join flow
movement packet bridge
chat packet bridge
compatibility notes
safe local/dev configuration
```

## Current handoff

Current recommended next step:

```text
1. Pull latest main.
2. Run npm.cmd test.
3. Open /probes/main-slime-shell.html.
4. Verify which mainDEV661 slime shell candidates visibly load.
5. Record the confirmed main shell symbol(s).
6. Create a reusable FixedCam/RumsCove scene module from the room + weevil proof.
7. Put RumsCove behind the source-backed main slime shell in a debug UI-shell probe.
```

Do not jump to backend, multiplayer, dynamic ads, plane/firework animations, guessed playercard UI, or hand-drawn slime borders yet.
