# Rums Cove / video pod first-room audit

Date: 2026-06-05

Uploaded room asset ZIP:

```text
RumsAirport_dynamAds_videoPodv2_release.zip
```

Related locationDefinitions path supplied by Nathan:

```text
source/knowyourknot-binweevils/game-full/binConfig/getFile/7/uk/locationDefinitions.xml
```

## Important decision

Rums Cove is a better first strict `LocFixedCam` target than the standalone `videoPod1_10_05_12` external/VOD scene, because Rums Cove has a real `locationDefinitions.xml` entry.

This lets the port work on:

```text
real FixedCam room rendering
real locID/entry/door/boundary data
source-backed room background asset
later navigation toward the video pod / VOD scene path
```

## Matching location entry

Found in `locationDefinitions.xml`:

```xml
<location id="129" name='RumsCove' type='2' boundType='rect' boundary='-240,60,680,90' camPos='0,190,-330' camAim='0,90,260' entryPos='0,80' entryDir='180' weevilScale='0.18'>
  <roomBG path='fixedCam/RumsAirport_180321.swf'/>
  <door id='1' toLoc='107' toDoor='1' x1='-190' z1='125' x2='-260' z2='125' entryDir='180'/>
  <door id='2' toLoc='103' toDoor='1' x1='180' z1='92' x2='250' z2='92' entryDir='180'/>
  <door id='3' toLoc='132' toDoor='1' x1='15' z1='155' x2='15' z2='260' entryDir='0'/>
  <door id='4' toLoc='154' toDoor='1' x1='-179' z1='155' x2='-179' z2='260' entryDir='0'/>
  <door id='5' toLoc='104' toDoor='4' x1='100' z1='130' x2='326' z2='132' y2='1500' entryDir='0'/>
  <interactive type="door" path='buildings.airport.slidingDoors_mc' actRect='-20,140,60,200'/>
  <interactive type="door" path='buildings.diner.slidingDoors_mc' actRect='-200,140,50,200'/>
  <object name='door6_mc' x='137' y='0' z='115'/>
  <object name='mulchtasticBooth' x='80' y='0' z='150'/>
  <object name='buildings' x='-150' y='0' z='198'/>
  <object name='fence' x='0' y='0' z='160'/>
  <object name='door3_mc' x='0' y='0' z='190'/>
  <object name='door4_mc' x='0' y='0' z='191'/>
  <object name='door5_mc' x='0' y='0' z='0'/>
  <anim path='plane1'/>
  <anim path='plane2'/>
  <object name="bobbleOverlay_mc" x="0" y="0" z="335"/>
</location>
```

## Parsed location data

```text
locID: 129
name: RumsCove
type: 2 / FixedCam
boundType: rect
boundary: -240,60,680,90
camPos: 0,190,-330
camAim: 0,90,260
entryPos: 0,80
entryDir: 180
weevilScale: 0.18
roomBG: fixedCam/RumsAirport_180321.swf
```

## Door graph

```text
door 1 -> loc 107, door 1, from -190/125 to -260/125, entryDir 180
door 2 -> loc 103, door 1, from 180/92 to 250/92, entryDir 180
door 3 -> loc 132, door 1, from 15/155 to 15/260, entryDir 0
door 4 -> loc 154, door 1, from -179/155 to -179/260, entryDir 0
door 5 -> loc 104, door 4, from 100/130 to 326/132, y2 1500, entryDir 0
```

There is also a commented-out door 6 lotto/extUI entry in the XML, so it must not be treated as active final data unless another source proves it is enabled.

## Objects from XML

```text
door6_mc @ x 137, y 0, z 115
mulchtasticBooth @ x 80, y 0, z 150
buildings @ x -150, y 0, z 198
fence @ x 0, y 0, z 160
door3_mc @ x 0, y 0, z 190
door4_mc @ x 0, y 0, z 191
door5_mc @ x 0, y 0, z 0
bobbleOverlay_mc @ x 0, y 0, z 335
```

## Interactives from XML

```text
buildings.airport.slidingDoors_mc actRect -20,140,60,200
buildings.diner.slidingDoors_mc actRect -200,140,50,200
```

These are useful because they give nested MovieClip paths inside the exported room SWF.

## Anims from XML

```text
plane1
plane2
```

These should be deferred until after static room render and local weevil placement.

## Uploaded SWF export summary

The uploaded FFDec-style ZIP contains:

```text
3689 total entries
1 frame preview image
2 raster images
15 button exports
4 fonts
3 sounds
27 ActionScript files
3277 sprite SVG entries
330 shape SVG entries
13 morphshape entries
symbolClass/symbols.csv
```

Preview frame:

```text
frames/1.png
614x366 RGBA
```

## symbolClass map highlights

```text
0;RumsAirport_dynamAds
1;P90
42;RumsAirport_databaseAds_mexican2_fireworks_fla.firework_161
121;RumsAirport_databaseAds_mexican2_fireworks_fla.firework_binweevils_BW_flipped_136
139;RumsAirport_dynamAds_videoPodv2_fla.door6_82
142;RumsAirport_dynamAds_videoPodv2_fla.door4_80
144;RumsAirport_dynamAds_videoPodv2_fla.door3_78
149;RumsAirport_dynamAds_videoPodv2_fla.door1_76
179;RumsAirport_dynamAds_videoPodv2_fla.Door_002_71
180;RumsAirport_dynamAds_videoPodv2_fla.remoteOverlay_74
263;RumsAirport_dynamAds_videoPodv2_fla.t_67
264;RumsAirport_dynamAds_videoPodv2_fla.podText_66
265;RumsAirport_dynamAds_videoPodv2_fla.remoteBack_31
266;RumsAirport_dynamAds_videoPodv2_fla.overlay_70
269;RumsAirport_dynamAds_videoPodv2_fla.Door_animated2_26
293;RumsAirport_dynamAds_videoPodv2_fla.airport_23
297;RumsAirport_dynamAds_videoPodv2_fla.cafedooropenanim_18
300;RumsAirport_dynamAds_videoPodv2_fla.adBoard_right_16
361;RumsAirport_dynamAds_videoPodv2_fla.buildings_12
370;RumsAirport_dynamAds_videoPodv2_fla.plane_runway_anim_5
373;RumsAirport_dynamAds_videoPodv2_fla.plane_takeoff_3
```

## Main ActionScript class

Main room script:

```text
scripts/RumsAirport_dynamAds.as
```

Exposed useful children:

```text
door1_mc
fence
door4_mc
buildings
door7_mc
plane2
door2_mc
plane1
door5_mc
remoteBack
floorClickArea_btn
mulchtasticBooth
remoteDoorOverlay
door3_mc
door6_mc
fireworks
firework4
firework7
```

## Video pod / remote behaviour

`RumsAirport_dynamAds.as` contains a simple pod text toggle, not a full room load:

```text
podMessage = "               Pod 3    :      The Adventures of Brush Lee and Jackie Chain"
remoteBack.addEventListener(MouseEvent.MOUSE_UP, onPodClick)
```

`onPodClick()` toggles the scrolling pod message on `remoteBack.podText`.

This is useful for proving the exterior pod object and text behaviour later, but it does not by itself prove navigation into `videoPod1_10_05_12`.

## Dynamic ads behaviour

The room has dynamic ad behaviour:

```text
buildings.diner.adBoard_mc
adHolder_spr
getAdPaths.php
ad link can navigate, loadLoc, or loadInterface
```

For the first static room render, ad loading should be stubbed/ignored.

## File-name mismatch note

`locationDefinitions.xml` references:

```text
fixedCam/RumsAirport_180321.swf
```

The uploaded ZIP is named:

```text
RumsAirport_dynamAds_videoPodv2_release.zip
```

This is likely a later/specific release variant of the same Rums Cove room family, but the exact source-backed manifest should record this mismatch.

Before finalising the room manifest, prefer to confirm whether `fixedCam/RumsAirport_180321.swf` and `RumsAirport_dynamAds_videoPodv2_release.swf` are equivalent, related variants, or separate versions.

## Recommendation

Use Rums Cove as the first strict room milestone:

```text
first true FixedCam room: RumsCove locID 129
first room visual asset candidate: RumsAirport_dynamAds_videoPodv2_release
later linked scene: videoPod1_10_05_12 external/VOD pod interior
```

This lets the project eventually prove:

```text
room render
weevil placement
walk boundary
door graph
navigation into another room/scene
```

## Safe next steps

```text
1. Commit/extract RumsAirport_dynamAds_videoPodv2_release into reference/rooms or public/probes only.
2. Create a Rums Cove room manifest from locID 129 + symbolClass + frame preview.
3. Add a debug-only Rums Cove room asset probe page using frames/1.png.
4. Confirm the visual room preview loads in the browser.
5. Only then wire a source-backed room scene into the app.
```

## Do not do yet

```text
do not implement dynamic ads
ndo not implement fireworks/plane animations first
do not treat commented XML door 6 as active
do not claim videoPod1 navigation is proven until the matching door/loadInterface path is found
do not guess missing equivalence between RumsAirport_180321 and the uploaded release SWF
```
