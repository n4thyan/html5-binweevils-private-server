# Source-backed port roadmap

This roadmap tracks the faithful Flash-to-HTML5 Bin Weevils port. It is intentionally conservative. A milestone is not complete just because something looks similar; it must be traceable to original source, decompiled SWF code, or verified original assets.

## Guiding rule

```text
Do not invent permanent assets, UI, room layouts, or behaviour.
Use source/decompiled files first.
Use the old HTML5 demo only for already-proven renderer knowledge.
Mark all debug probes and placeholders clearly.
```

## Current status snapshot

```text
App foundation: working
Weevil renderer: restored from proven old demo and visually confirmed
Decompiled main/core dump: committed
mainDEV661.swf boot order: mapped and tested
core5.swf Bin.as init order: mapped and tested
core5.swf UImain.as structure: mapped and tested
core5.swf UI symbol paths: corrected to real FFDec DefineSprite paths and tested
Real exported UI SVG existence: tested
Final UI shell: not started
Rooms: not started
Movement: not started
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
```

Rule:

```text
Do not rewrite the renderer unless there is a source-backed reason.
Use it as the visual baseline while porting rooms and UI.
```

## Milestone 003: main/core source mapping

Status: in progress, strong progress.

Purpose:

```text
Map the real Flash boot and core client structure before implementing UI or rooms.
```

Done:

```text
mainDEV661.swf Main.as boot flow mapped
mainDEV661.swf STAGE.as noted
core5.swf Bin.as constructor/init flow mapped
core5.swf UImain.as child structure mapped
core5.swf CamUI.as child names documented
core5.swf symbolClass IDs mapped for important UI symbols
FFDec DefineSprite path format corrected
real UI SVG file existence confirmed
```

Next:

```text
wire new tests into normal npm test flow
map Main.as loader visuals more deeply
map UImain setupCamUI and control button behaviours
map ChatLog and chatbar source paths
map action/emote/phrase source paths
```

## Milestone 004: real core UI asset probe

Status: next immediate coding target.

Purpose:

```text
Load and display real exported core5.swf UI SVGs in a debug-only probe panel.
```

Scope:

```text
weevilProfile
controlTab
alertBox
dialogueBox
sidebtnsflipout
actionsBtn
actionIcons
mouthIcons
petProfile
```

Rules:

```text
This is not the final UI shell.
Do not hand-draw replacements.
Only display actual exported source assets.
Clearly label it debug-only.
```

Completion criteria:

```text
browser loads all probe SVGs
probe reports loaded/error state
assets are visibly drawn in a debug panel
file existence tests remain green
no invented UI shell is added
```

## Milestone 005: source-backed UI shell

Status: not started.

Purpose:

```text
Build the real client UI shell from mainDEV661.swf and core5.swf assets/classes.
```

Source files:

```text
mainDEV661.swf/scripts/com/binweevils/Main.as
mainDEV661.swf/scripts/com/binweevils/STAGE.as
core5.swf/scripts/com/binweevils/UImain.as
core5.swf/scripts/com/binweevils/CamUI.as
core5.swf/symbolClass/symbols.csv
```

Expected pieces:

```text
contentHolderU_spr/contentHolderL_spr equivalent layers
loader handoff model
control tab
side buttons
profile panel holder
chat holder
camera UI holder
alert/dialogue/invite overlay layers
```

Not included yet:

```text
final room rendering
real server login
multiplayer
inventory functionality
shops
```

## Milestone 006: first FixedCamera room audit

Status: not started.

Purpose:

```text
Select the first room from source evidence and map all required assets/data before rendering it.
```

Rules:

```text
Do not use the old custom The Peel room.
Start with an original FixedCamera room.
Pick the room based on available source/assets, not preference.
```

Audit needs:

```text
room SWF/source path
background/floor/object layers
entry/spawn coordinates
camera parameters
walkable area/floor click data
foreground/depth layers
object interaction stubs
known missing dependencies
```

## Milestone 007: first room render

Status: not started.

Purpose:

```text
Render one real source-backed FixedCamera room locally.
```

Completion criteria:

```text
room background/layers visible
coordinate system documented
one weevil placed in room
depth debug overlay present
no invented room art
room manifest created
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

## Tonight/tomorrow handoff

Current recommended next step:

```text
1. Pull latest main.
2. Run npm test.
3. Wire CoreUiAssetProbeRenderer into BootScene with a small safe patch.
4. Visually confirm real core5.swf UI SVGs load in browser.
5. Then begin source-backed UI shell planning from UImain.as and Main.as.
```

Do not jump to movement, rooms, backend, or custom UI until Milestone 004 is visually confirmed.
