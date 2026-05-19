# Asset export pipeline

The original client uses Flash/SWF assets. The HTML5 port should not depend on Ruffle as the main runtime, so SWFs should be treated as source material and exported into browser-native assets.

Recommended tool:

```text
JPEXS Free Flash Decompiler / FFDec
```

## Export strategy

Use the least lossy browser-native format that works for each asset type.

```text
Original JPEG/PNG floor/backgrounds -> copy as-is
Simple vector symbols/shapes -> SVG where clean
Complex Flash symbols/filters/bitmaps -> PNG/WebP
Angle-based or animated assets -> numbered PNG/WebP frames
Metadata/coordinates -> JSON derived from original XML
```

## Orange Peel first export set

Source folder:

```text
legacy-reference/Binweevils-main/game-full/cdn.binw.net/
```

Priority files:

```text
floors/inks.jpg
assets3D/orangePeel.swf
assets3D/orangeSegment.swf
assets3D/orangeSegment_1.swf
assets3D/orangeSegment_2.swf
assets3D/orangeBlob.swf
assets3D/signMsgBoard.swf
assets3D/cottonReel.swf
assets3D/needle.swf
assets3D/arrow.swf
```

Optional/later files for visible mini-game markers:

```text
assets3D/connectMulch.swf
assets3D/flipMulch.swf
assets3D/poolTable.swf
assets3D/squares.swf
```

## Suggested output layout

```text
public/assets/rooms/inks-orange/
  room.json
  floors/
    inks.jpg
  objects/
    orange-peel/
      source.txt
      frame_000.png
      frame_001.png
    orange-segment/
      source.txt
      frame_000.png
    sign-msg-board/
      source.txt
      frame_000.png
    cotton-reel/
      source.txt
      frame_000.png
    needle/
      source.txt
      frame_000.png
    orange-blob/
      source.txt
      frame_000.png
    arrow/
      source.txt
      frame_000.png
```

`source.txt` should record the original SWF path and any export notes.

Example:

```text
Original source: legacy-reference/Binweevils-main/game-full/cdn.binw.net/assets3D/orangePeel.swf
Exported with: JPEXS/FFDec
Export mode: PNG frames
Notes: source uses preRend3D placement from locationDefinitions.xml
```

## Handling preRend3D metadata

The original XML includes fields such as:

```text
x, y, z
scale
ry
rxMin, rxMax
ryMin, ryMax
framesY
symAxes
rIncr
depthOffset
bg
doorID
logicID
```

For milestone 002, preserve all original fields in `room.json` even if the first renderer only uses a subset.

Example object shape:

```json
{
  "type": "preRend3D",
  "path": "assets3D/orangePeel.swf",
  "exportedAsset": "objects/orange-peel/frame_000.png",
  "depthOffset": -128,
  "x": -162,
  "y": 0,
  "z": 640,
  "scale": 0.84,
  "ry": 225,
  "rxMin": 6,
  "rxMax": 38,
  "ryMin": 141,
  "ryMax": 219,
  "framesY": 21,
  "symAxes": 1,
  "rIncr": 2
}
```

## Milestone 002A fallback

If exports are not ready yet, the first HTML5 room shell can still use:

- `floors/inks.jpg`
- source-derived `room.json`
- labelled object placeholders at original coordinates
- click-to-move boundary and no-go checks
- existing weevil renderer at `entryPos`

Then milestone 002B replaces placeholders with exported original assets.

## Do not

- Do not embed SWFs directly as the final room renderer.
- Do not use screenshots as the source of truth when vector/frame export is possible.
- Do not invent positions by eye if XML coordinates exist.
- Do not discard original metadata just because the first renderer does not use it yet.
