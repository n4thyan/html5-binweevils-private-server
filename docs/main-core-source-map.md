# Main/core source map

This document maps the newly committed decompiled `mainDEV661.swf` and `core5.swf` dump into the HTML5 port order.

## Confirmed source locations

```text
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/
reference/decompiled-dumpassets/dumpassets/core5.swf/
```

## Main SWF responsibilities

Source:

```text
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/scripts/com/binweevils/Main.as
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/scripts/com/binweevils/STAGE.as
reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/symbolClass/symbols.csv
```

`mainDEV661.swf` is the top-level loader/boot SWF. Its `Main.as` shows this order:

```text
1. Read loader/root params such as cluster, loginPath, autoBin and zone.
2. Set global STAGE.
3. Start a delayed config load.
4. Load binConfig/config.xml.
5. Resolve URLhandler domain/services/CDN paths.
6. Check version through binConfig/<cluster>/checkVersion.php.
7. Resolve default locID for logged-in users.
8. Optionally load loader ad/campaign content.
9. Load core<version>.swf.
10. Call core.init(contentHolderU_spr, contentHolderL_spr, showLoader, hideLoader, defaultLocID).
```

Symbols from `mainDEV661.swf/symbolClass/symbols.csv`:

```text
0;com.binweevils.Main
98;main_29_03_17_fla.splatInvMask_50
100;main_29_03_17_fla.loaderBinPet_41
```

The HTML5 port should treat this as the source for:

```text
boot lifecycle
stage references
loader/bin pet loading UI
core loading handoff
upper/lower content holder concept
login/default loc bootstrap order
```

Do not invent the shell/loader. Port it from this SWF when ready.

## Core SWF responsibilities

Source:

```text
reference/decompiled-dumpassets/dumpassets/core5.swf/scripts/com/binweevils/Bin.as
reference/decompiled-dumpassets/dumpassets/core5.swf/scripts/com/binweevils/CamUI.as
reference/decompiled-dumpassets/dumpassets/core5.swf/symbolClass/symbols.csv
```

`core5.swf` is the main game client. `Bin.as` imports and owns the major runtime systems:

```text
Cam3D / ViewPort / Matrix3x3 / Vector3D
Loc / LocFactory / LocNest / Door / Teleporter / Spinner / GameSlot
NPC / Pet / PetFactory / Weevil / WeevilFactory
UImain
SmartFoxClient / SFSEvent
PHP/PHP2 service calls
external UI holders
overlay UI holders
big game holder
floorClickArea
loaded interfaces
current location/current weevil/current user state
```

Important `core5.swf` symbols include:

```text
warningBox
alertBox
invitation
dialogueBox
pleaseWait
sidebtnsflipout
weevilProfile
controlTab
actionIcons
actionsBtn
energyBar_bg
levelBar
petProfile
petCommands
emojii_1 through emojii_40
```

The HTML5 port should treat this as the source for:

```text
main client runtime
room/location system
camera and viewport
floor click / movement entry point
weevil factory and creature state
chat/actions/emotes/profile panels
alerts/dialogue boxes
external/overlay UI layering
SmartFox/message protocol references
```

## CamUI notes

Source:

```text
reference/decompiled-dumpassets/dumpassets/core5.swf/scripts/com/binweevils/CamUI.as
```

`CamUI.as` expects a sprite with named children:

```text
zoomRotate_spr
elevation_spr
resetCamBtn_mc
closeUpCamBtn_mc
aimFollowCamBtn_mc
weevilCamBtn_mc
help_sign
```

Inside the camera UI it references:

```text
joy1_spr
joy2_spr
left_btn
right_btn
forward_btn
backward_btn
up_btn
down_btn
```

This confirms the camera controls should be ported from actual named Flash children/symbols, not redrawn from scratch.

## Correct milestone order from here

```text
Milestone 003: keep restored weevil renderer locked.
Milestone 004: source-map main/core UI and boot assets.
Milestone 005: port main loader/stage shell from mainDEV661 assets.
Milestone 006: port core UI frame/panels/buttons from core5 assets.
Milestone 007: load one source-backed FixedCam room.
Milestone 008: port movement/floor click/depth from Bin/engine3D/Loc/Weevil classes.
```

## Hard rule

Do not draw replacement UI by hand unless it is explicitly marked as temporary debug-only. The real UI should come from exported SWF symbols/assets and the decompiled class structure.
