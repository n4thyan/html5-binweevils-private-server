# Avatar atlas rendering helpers

This document records the current atlas rendering helper layer.

## Added module

```text
src/avatar/AtlasFrameRenderer.js
```

## Purpose

This module provides small generic helpers for drawing frames from JSON/PNG atlases.

It does not define final weevil layout, animation, projection, scale, or layer order.

## Helpers

```text
getAtlasFrame(atlas, frameName)
getFrameRect(frameEntry)
drawAtlasFrame(ctx, atlas, frameName, x, y, options)
drawTintedAtlasFrame(ctx, atlas, frameName, x, y, colourHex, options)
```

## Supported atlas frame shapes

The helper is intentionally tolerant of common atlas JSON shapes:

```text
frames as object map: frames[frameName]
frames as array: entries with filename or name
frame rectangle keys: x/y/w/h or x/y/width/height
```

## Tinting approach

Tinting currently uses a scratch canvas:

```text
1. draw source frame to scratch canvas
2. use source-atop composite mode
3. fill with the requested colour
4. draw tinted scratch result to the destination canvas
```

This is a basic first pass. It may need to be adjusted once compared against the old renderer and original Flash visual output.

## Not final yet

Still not ported:

```text
exact avatar coordinates
exact draw order
projection math
rotation/facing
body/head masks
leg layout
antennae layout
eye positions
mouth positions
shadow handling
real atlas asset provenance
```

## Next step

Use these helpers inside a renderer method only after a tiny local atlas asset subset exists, or after original/prototype atlas files are placed locally under the expected ignored asset path.
