# videoPod1_10_05_12 first-room audit

Date: 2026-06-05

Uploaded room asset ZIP:

```text
videoPod1_10_05_12.zip
```

Status:

```text
candidate selected for first FixedCamera room work
safe audit only completed so far
assets not wired into the runtime yet
main client, renderer, backend and movement code untouched
```

## Why this is a good first candidate

This is an unconventional but sensible first room candidate because it is visually complete and mechanically simple.

Reasons:

```text
small contained room
single obvious exit/entry point
no minigame slots needed for first pass
video/ad playback can be stubbed or ignored
clear floor click area exists
clear door symbol exists
clear seat/click targets exist
room frame/background can be visually verified from exported frame image
```

## ZIP inspection summary

The uploaded FFDec-style export contains:

```text
647 total ZIP entries
1 frame preview image
1 raster image
4 exported button PNGs
1 font
28 ActionScript files
188 sprite SVG files
226 shape SVG files
1 symbolClass CSV
```

Top-level folders:

```text
buttons/
fonts/
frames/
images/
scripts/
shapes/
sprites/
symbolClass/
texts/
```

Preview frame:

```text
frames/1.png
825x490 RGBA
```

The preview frame shows the complete room composition with the large central video screen, chairs/seats, vending machine, door/exit area and room frame.

## Key ActionScript files

```text
scripts/VideoPod1.as
scripts/VODPod.as
scripts/videoPod1_10_05_12_fla/TVArea_7.as
scripts/videoPod1_10_05_12_fla/door_front_108.as
scripts/videoPod1_10_05_12_fla/newPodChair_001_58.as
scripts/videoPod1_10_05_12_fla/newPodChair_002_44.as
scripts/videoPod1_10_05_12_fla/shownotavailable_12.as
```

## symbolClass map

The export includes these mapped symbols:

```text
0;VideoPod1
33;videoPod1_10_05_12_fla.shownotavailable_12
41;videoPod1_10_05_12_fla.TVArea_7
151;videoPod1_10_05_12_fla.newPodChair_002_44
156;videoPod1_10_05_12_fla.newPodChair_001_58
268;videoPod1_10_05_12_fla.door_front_108
```

Important exported sprite paths:

```text
sprites/DefineSprite_41_videoPod1_10_05_12_fla.TVArea_7/1.svg
sprites/DefineSprite_151_videoPod1_10_05_12_fla.newPodChair_002_44/1.svg
sprites/DefineSprite_156_videoPod1_10_05_12_fla.newPodChair_001_58/1.svg
sprites/DefineSprite_268_videoPod1_10_05_12_fla.door_front_108/1.svg
```

## VideoPod1.as confirmed children

`VideoPod1` exposes the following useful room children:

```text
screen_mc
chairRight
playerHolder_spr
seat1_btn
vendingMachine
chairLeft
floorClickArea_btn
fullScreenHolder_spr
tycoon_btn
tableRight
tableLeft
seat4_btn
door1_mc
sofaL
sofaR
seat3_btn
transistor_mc
frameLarge_spr
blankScreen_spr
seat2_btn
```

For the first room render, these are the most important:

```text
floorClickArea_btn
door1_mc
seat1_btn
seat2_btn
seat3_btn
seat4_btn
screen_mc
blankScreen_spr
```

## VODPod.as behaviour notes

`VODPod.init()` does this:

```text
bin = Bin_extInterface.bin
locNum = bin.crntLocID
loadData()
initFloorAndSeats()
door1MC = MovieClip(this).door1_mc
bind added/removed stage handlers
```

For the first port pass, the video/data parts can be stubbed. The useful room movement pieces are in `initFloorAndSeats`, `floor_clicked`, `seatClicked`, and `jumpOnStep`.

## Floor click behaviour

`initFloorAndSeats()` binds:

```text
seat1_btn -> seatClicked
seat2_btn -> seatClicked
seat3_btn -> seatClicked
seat4_btn -> seatClicked
floorClickArea_btn -> floor_clicked
```

`floor_clicked()` calls:

```text
jumpOnStep(event, 0, 0, [-200, 100, 400, 300])
```

Meaning for the first HTML5 pass:

```text
floor movement should reset/use rectangular boundary [-200, 100, 400, 300]
base floor y appears to be 0
```

## Seat click behaviour

`seatClicked()` maps four seats:

```text
seat1_btn -> jumpOnStep(event, 1, 30, [-125, 70, 1, 1], -125, 70, 180)
seat2_btn -> jumpOnStep(event, 2, 30, [-85, 70, 1, 1], -85, 70, 180)
seat3_btn -> jumpOnStep(event, 3, 30, [85, 70, 1, 1], 85, 70, 180)
seat4_btn -> jumpOnStep(event, 4, 30, [125, 70, 1, 1], 125, 70, 180)
```

This is useful later for clickable seat interactions. It does not need to be implemented for the first room render.

## Chair click behaviour

`VideoPod1.onChairClick()` maps the side chairs:

```text
chairLeft.hit_btn -> jumpOnStep(event, 101, 30, [-170, 370, 1, 1], -170, 370, -45)
chairRight.hit_btn -> jumpOnStep(event, 102, 30, [165, 360, 1, 1], 165, 360, 45)
```

Again, useful later, but not required for the first static room render.

## jumpOnStep behaviour summary

`jumpOnStep` does the important movement/interact logic:

```text
checks bin.ctrlsEnabled
uses stageX/stageY and bin.getFloorClickCoords when x/z are not supplied
adds small randomisation to z
compares distance against y-step difference
resets Loc rect boundary to the supplied rectangle
legalises the click through bin.crntLoc.legaliseClick
updates crntStep
hides door1_mc when on steps/seats, shows it when crntStep is 0
sends bin.myWeevilAct(10, 0, "x,y,z,dir") for step jumps
falls back to bin.mouseDownHandler for plain floor movement
falls back to bin.moveMyWeevil for legalised non-floor moves
```

For first pass, we can reduce this to:

```text
floor click -> legalised local movement in rectangle [-200,100,400,300]
seat/chair hotspots -> later optional click target positions
video playback -> ignored/stubbed
```

## Missing piece: matching locationDefinitions.xml entry

The ZIP does not appear to contain a `locationDefinitions.xml` loc entry.

Still needed for a fully source-backed room port:

```text
<loc ...> entry for the videoPod1_10_05_12 room
real locID
real type attribute
weevilScale
camPos
camAim
entryPos
entryDir
boundary
any door/toLoc/toDoor values
any object/walkMask/noGoArea/cta definitions
```

Without the XML, the SWF still provides useful room children and interaction constants, but the proper LocFactory/LocFixedCam creation data remains incomplete.

## Recommended next step

```text
1. Commit/extract the room export into a reference folder.
2. Find the matching locationDefinitions.xml entry for this room.
3. Feed the <loc> XML into FixedCamLocDefinition parser.
4. Create a room manifest from both sources.
5. Build a debug-only room asset probe page using frames/1.png first.
6. Only after that, wire the room into the canvas runtime.
```

## Do not do yet

```text
do not implement video/ad playback
do not implement seat interactions first
do not wire this into main BootScene tonight
do not guess missing loc XML values as final data
do not replace the source-backed weevil renderer
```
