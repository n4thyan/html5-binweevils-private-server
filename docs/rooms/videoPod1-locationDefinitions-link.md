# videoPod1_10_05_12 locationDefinitions linkage

Date: 2026-06-05

Source checked:

```text
source/knowyourknot-binweevils/game-full/binConfig/getFile/7/uk/locationDefinitions.xml
```

Uploaded file checked:

```text
locationDefinitions.xml
```

## Important finding

The exact SWF name below was not found directly in `locationDefinitions.xml`:

```text
videoPod1_10_05_12
```

That means `videoPod1_10_05_12.swf` does not appear to be a normal `roomBG` FixedCam location entry in this locationDefinitions file.

Instead, the matching source path found is the Rigg's Palladium video-door flow:

```text
externalUIs/riggsVOD_110416.swf
```

This suggests `videoPod1_10_05_12` is part of the video/VOD external UI flow rather than a standard `LocFixedCam` room background.

## Matching FixedCam location found

The relevant location entry is:

```xml
<location id='112' name='PalladiumLobbyG' type='2' boundType='rect' boundary='-180,20,360,360' camPos='0,190,-330' camAim='0,90,260' entryPos='0,80' weevilScale='0.28'>
  <roomBG path='fixedCam/palladiumLobbyG_160321a.swf'/>
  <door id='5' toLoc='111' toDoor='1' x1='0' z1='125' x2='0' z2='-50' entryDir='180'/>
  <door id='6' toLoc='151' toDoor='5' x1='-37' z1='360' x2='-37' z2='460' entryDir='180'/>
  <door id='7' toLoc='151' toDoor='6' x1='37' z1='360' x2='37' z2='460' entryDir='180'/>
  <door id="1" extUIData="locName:in Rigg's Palladium Screen 1,path:externalUIs/riggsVOD_110416.swf,area:cinema,screenNum:1,channelLockedTo:BW" type="vid" x1="-182" z1="137" x2="-240" z2="137" entryDir="90"/>
  <door id="2" extUIData="locName:in Rigg's Palladium Screen 2,path:externalUIs/riggsVOD_110416.swf,area:cinema,screenNum:2,channelLockedTo:BW" type="vid" x1="-116" z1="390" x2="-108" z2="500" entryDir="-180"/>
  <door id="3" extUIData="locName:in Rigg's Palladium Screen 3,path:externalUIs/riggsVOD_110416.swf,area:cinema,screenNum:3,channelLockedTo:BW" type="vid" x1="116" z1="390" x2="108" z2="500" entryDir="-180"/>
  <door id="4" extUIData="locName:in Rigg's Palladium Screen 4,path:externalUIs/riggsVOD_110416.swf,area:cinema,screenNum:4,channelLockedTo:BW" type="vid" x1="182" z1="137" x2="240" z2="137" entryDir="-90"/>
  <interactive type="door" path='door6_mc' actRect='-60,404,50,100'/>
  <interactive type="door" path='door7_mc' actRect='10,350,50,50'/>
  <object name='doors1_4_overlay' x='0' y='0' z='112'/>
  <object name='doors2_3_liftOverlay' x='0' y='0' z='400'/>
  <object name='door5_mc' x='0' y='0' z='401'/>
  <object name='door6_mc' x='0' y='0' z='402'/>
</location>
```

## Meaning for the port

There are now two possible paths:

### Path A: first true FixedCam room

Use the real `LocFixedCam` location:

```text
locID: 112
name: PalladiumLobbyG
type: 2
roomBG: fixedCam/palladiumLobbyG_160321a.swf
boundary: -180,20,360,360
camPos: 0,190,-330
camAim: 0,90,260
entryPos: 0,80
weevilScale: 0.28
```

This is the cleaner path if the milestone is specifically:

```text
first real LocFixedCam room rendered from locationDefinitions.xml
```

### Path B: first video pod / external UI room-like scene

Use the uploaded/decompiled:

```text
videoPod1_10_05_12
```

This has useful room-like ActionScript and movement constants, including:

```text
floorClickArea_btn
seat1_btn / seat2_btn / seat3_btn / seat4_btn
door1_mc
screen_mc
floor boundary [-200,100,400,300]
seat/chair target positions
```

This is still useful and simple, but it should be treated as:

```text
external UI / VOD pod scene, not a normal LocFixedCam roomBG entry
```

## Recommendation

For tomorrow, keep both options open:

```text
1. Use PalladiumLobbyG as the first true FixedCam location if we want strict LocFactory/LocFixedCam progress.
2. Use videoPod1_10_05_12 as a simpler external-UI scene probe if we want fast visual proof of a room-like scene.
```

Do not pretend videoPod1 has a normal `locationDefinitions.xml` `roomBG` entry unless a different XML/source file proves it.
