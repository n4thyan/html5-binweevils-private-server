# Ink's Orange / Orange Peel room audit

Status: selected first-room target.

## Source config

Primary audited config:

```text
legacy-reference/Binweevils-main/game-full/binConfig/getFile/1/uk/locationDefinitions.xml
```

Observed location block:

```xml
<location id="106" name="InksOrange" type="1" boundType="rect" boundary="-150,188,450,440" xWall="0" zWall="0" camPos="-42,197,-37" camAim="-66,15,436" camBounds="-90,35,-150,525,240,530" entryPos="-93,320" entryDir="-180" weevilScale="0.18">
```

## Room-level data

```json
{
  "id": 106,
  "name": "InksOrange",
  "type": 1,
  "boundType": "rect",
  "boundary": [-150, 188, 450, 440],
  "xWall": 0,
  "zWall": 0,
  "camPos": [-42, 197, -37],
  "camAim": [-66, 15, 436],
  "camBounds": [-90, 35, -150, 525, 240, 530],
  "entryPos": [-93, 320],
  "entryDir": -180,
  "weevilScale": 0.18
}
```

## Floor

```xml
<floor path="floors/inks.jpg"/>
```

Confirmed local source file:

```text
legacy-reference/Binweevils-main/game-full/cdn.binw.net/floors/inks.jpg
```

Observed size:

```text
82375 bytes
```

## Movement/no-go data

```xml
<noGoArea type="rad" x="74" z="270" r="35"/>
```

Doors:

```xml
<door id="1" toLoc="111" toDoor="2" x1="-180" z1="424" x2="-360" z2="424" entryDir="90"/>
<door id="2" toLoc="109" toDoor="1" x1="60" z1="630" x2="60" z2="800" entryDir="0"/>
<door id="3" toLoc="121" toDoor="2" x1="250" z1="606" x2="310" z2="606" entryDir="-90"/>
```

## Confirmed source asset inventory

All listed files were found under:

```text
legacy-reference/Binweevils-main/game-full/cdn.binw.net/assets3D/
```

```text
arrow.swf             55826
connectMulch.swf     227095
cottonReel.swf        27122
cottonReel_1.swf        921
flipMulch.swf         72879
needle.swf           297583
needle_2.swf            740
orangeBlob.swf         2873
orangePeel.swf      1710351
orangePeel_1.swf       5107
orangeSegment.swf   1031788
orangeSegment1.swf     9888
orangeSegment2.swf    11374
orangeSegment_1.swf    1236
orangeSegment_2.swf    1867
poolTable.swf         82052
signMsgBoard.swf    1247229
squares.swf           93529
```

## Key room assets

Arrow markers:

```xml
<preRend3D path="assets3D/arrow.swf" bg="true" doorID="1" x="-210" y="0" z="424" scale="0.13" ry="90" rxMin="9" rxMax="39" ryMin="0" ryMax="360" framesY="61" symAxes="1" rIncr="3"/>
<preRend3D path="assets3D/arrow.swf" bg="true" doorID="2" x="60" y="0" z="700" scale="0.13" ry="0" rxMin="9" rxMax="39" ryMin="0" ryMax="360" framesY="61" symAxes="1" rIncr="3"/>
<preRend3D path="assets3D/arrow.swf" bg="true" doorID="3" x="221" y="0" z="611" scale="0.13" ry="-90" rxMin="9" rxMax="39" ryMin="0" ryMax="360" framesY="61" symAxes="1" rIncr="3"/>
```

Orange assets:

```xml
<preRend3D path="assets3D/orangeSegment.swf" path1="assets3D/orangeSegment_1.swf" depthOffset="-32" x="-200" y="0" z="290" scale="0.4" ry="270" rxMin="6" rxMax="38" ryMin="90" ryMax="270" framesY="46" symAxes="1" rIncr="2"/>
<preRend3D path="assets3D/orangeSegment.swf" path1="assets3D/orangeSegment_2.swf" x="230" y="0" z="700" scale="0.4" ry="180" rxMin="6" rxMax="38" ryMin="90" ryMax="270" framesY="46" symAxes="1" rIncr="2"/>
<preRend3D path="assets3D/orangePeel.swf" path1="assets3D/orangePeel.swf" depthOffset="-128" x="-162" y="0" z="640" scale="0.84" ry="225" rxMin="6" rxMax="38" ryMin="141" ryMax="219" framesY="21" symAxes="1" rIncr="2"/>
```

Other prominent objects:

```xml
<preRend3D path="assets3D/signMsgBoard.swf" path1="assets3D/signMsgBoard.swf" x="126" y="0" z="650" scale="0.4" ry="90" rxMin="10" rxMax="40" ryMin="15" ryMax="165" framesY="51" symAxes="0" rIncr="3"/>
<preRend3D path="assets3D/cottonReel.swf" path1="assets3D/cottonReel.swf" x="74" y="0" z="270" scale="0.8" ry="0" rxMin="9" rxMax="45" ryMin="0" ryMax="1" framesY="1" symAxes="0" rIncr="1.5"/>
<preRend3D path="assets3D/needle.swf" path1="assets3D/orangeBlob.swf" x="315" y="0" z="175" scale="0.36" ry="-40" rxMin="9" rxMax="51" ryMin="0" ryMax="360" framesY="31" symAxes="2" rIncr="3"/>
```

## Mini-game slots in room

The room includes original mini-game placements for Konnect-Mulch, Flip-Mulch, 6 Ball, and Squares. These should not be implemented in milestone 002, but their coordinates should be preserved for later.

## Asset-porting note

The HTML5 client should not depend on Flash/Ruffle as the main room runtime. For milestone 002, use the original SWFs as source material and export/derive browser-native image assets where needed. Keep source-derived data and exported images traceable to the original file names.

## Milestone 002 target

Create an Apache/XAMPP-served HTML5 room shell using this source data:

- parse or manually transcribe the location data into `public/assets/rooms/inks-orange/room.json`
- copy verified/exported room source assets into `public/assets/rooms/inks-orange/`
- render the floor and object placements in original coordinate space
- wire click-to-move using `boundary` and `noGoArea`
- place the existing HTML5 weevil renderer at `entryPos` with `weevilScale`
- add an original-style chat bubble
- leave mini-games, doors, and external UIs as visible/non-functional markers until later
