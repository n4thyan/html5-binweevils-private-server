# Decompiled core/main asset audit

This audit is based on the uploaded `dumpassets.zip` export. The export contains decompiled output for:

```text
core5.swf
mainDEV661.swf
```

## Archive summary

```text
Total entries: 7,423
core5.swf entries: 6,733
mainDEV661.swf entries: 690
```

By extension:

```text
.svg: 4,639
.as: 638
.txt: 181
.png: 125
.ttf: 19
.mp3: 14
.swf: 2
.csv: 2
.jpg: 1
```

## core5.swf contents

```text
sprites: 4,410
shapes: 1,213
scripts: 679
buttons: 199
texts: 175
images: 23
fonts: 17
sounds: 8
morphshapes: 4
frames: 2
symbolClass: 2
```

Important symbols/classes found in `core5.swf/symbolClass/symbols.csv` include:

```text
warningBox
alertBox
invitation
dialogueBox
pleaseWait
sidebtnsflipout
lottoResults
weevilProfile
tycoonBusinessIcons
tycoonPanelLower
controlTab
star_rating
lists
actionIconscopy
actionIcons
actionBtn_bg_clrs
myStuffShake
mouthIcons
tableticon4
actionsBtn
energyBar_bg
levelBar
petProfile
petCommands
petcommandmc
emojii_1 through emojii_40
xmas_emojii / xmas_phrase / xmas_things variants
```

Important ActionScript areas found in `core5.swf/scripts` include:

```text
com/binweevils/Bin.as
com/binweevils/Bin_extInterface.as
com/binweevils/CamUI.as
com/binweevils/ChatLog.as
com/binweevils/EventManager.as
com/binweevils/conf/MessageProtocol.as
com/binweevils/engine3D/*
com/binweevils/engine3D/visuals/*
com/binweevils/engine3D/visuals/creatures/weevils/*
com/binweevils/engine3D/visuals/creatures/weevils/behaviours/*
com/binweevils/buddies/*
assetsWeevil/*
core390_fla/*
emojii_* / phrase_* / xmas_* symbol scripts
SmartFoxClient source under it/gotoandplay/smartfoxserver/*
```

This means `core5.swf` is not only UI art. It also contains important game client behaviour, SmartFox protocol helpers, engine3D visual classes, weevil behaviour classes, chat/buddy UI, profile UI, alerts/dialogue boxes, emotes, phrases, and several gameplay panels.

## mainDEV661.swf contents

```text
sprites: 503
shapes: 115
scripts: 46
texts: 8
fonts: 4
buttons: 3
images: 3
morphshapes: 3
frames: 2
symbolClass: 2
```

Important symbols/classes found in `mainDEV661.swf/symbolClass/symbols.csv` include:

```text
com.binweevils.Main
main_29_03_17_fla.loaderBinPet_41
main_29_03_17_fla.splatInvMask_50
```

Important ActionScript files found in `mainDEV661.swf/scripts` include:

```text
com/binweevils/Main.as
com/binweevils/STAGE.as
com/binweevils/EventManager.as
com/binweevils/VersionHandler.as
com/binweevils/MainTextLoaderAnim.as
com/binweevils/AdLocations.as
com/binweevils/GalleryData.as
com/binweevils/utilities/URLhandler.as
com/binweevils/utilities/XMLLoader.as
main_29_03_17_fla/loaderBinPet_41.as
main_29_03_17_fla/splatInvMask_50.as
```

This makes `mainDEV661.swf` the correct source to study first for top-level boot, stage/canvas setup, loader shell, and main-client wiring.

## Porting rule

Do not invent UI assets or layout. UI and game shell work must wait until these decompiled assets are committed into the repo and mapped.

```text
Renderer: keep current restored legacy-demo-assets renderer.
Main shell / slime frame / loader: port from mainDEV661.swf.
Buttons / panels / profile / chat / emotes / actions / alerts: port from core5.swf.
Movement / room behaviours / visual depth: port from core5.swf engine3D and room/visual classes.
Backend/session/protocol: later, using MessageProtocol/SmartFox/PHP call references where useful.
```

## Recommended next source-map order

```text
1. Commit this decompiled dump under reference/decompiled-dumpassets/.
2. Build an asset index from symbolClass/symbols.csv, scripts, sprites, buttons, shapes and images.
3. Study mainDEV661.swf/scripts/com/binweevils/Main.as and STAGE.as.
4. Study core5.swf/scripts/com/binweevils/Bin.as and CamUI.as.
5. Map the real shell/slime/canvas stage assets.
6. Only then build the UI shell from source assets.
7. After shell, port one FixedCam room using core engine3D classes.
```
