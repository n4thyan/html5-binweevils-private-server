# Avatar renderer audit

This document records the audit of the old HTML5 demo renderer before any final renderer code is ported.

## Prototype source inspected

Uploaded archive:

```text
BWR_HTML5_the_peel_room_layers_and_auth_fix.zip
```

Runtime files inspected:

```text
public/weevil-creator/src/runtime/WeevilDef.js              2978 bytes
public/weevil-creator/src/runtime/WeevilCanvasRenderer.js   35473 bytes
public/weevil-creator/src/runtime/WeevilRenderer.js         24409 bytes
public/weevil-creator/src/runtime/atlasLoader.js            1166 bytes
public/weevil-creator/src/runtime/canvasAtlasLoader.js      1280 bytes
public/weevil-creator/src/runtime/math.js                   1352 bytes
public/weevil-creator/src/runtime/projection.js             1304 bytes
```

## Renderer decision

The old demo contains two renderers:

```text
WeevilRenderer.js          PixiJS container renderer
WeevilCanvasRenderer.js    plain 2D canvas renderer
```

For the clean port, use `WeevilCanvasRenderer.js` as the main reference first because:

```text
it has fewer external dependencies
it contains explicit draw commands
it directly shows draw/depth order
it keeps atlas lookup, tinting, projection, legs, antennae, mouth and eyes in one place
```

The Pixi renderer can still be reviewed later for comparison, but should not define the first clean implementation.

## Prototype atlas inventory

Observed atlas JSON files:

```text
body_cone.json
body_cone_narrow_inv.json
body_cuboid.json
body_spheroid.json
eyes.json
eyes_Eye_iris1_mc.json
eyes_Eye_iris2_mc.json
eyes_Eye_lid1_mc.json
eyes_Eye_lid2_mc.json
eyes_Eye_white1_mc.json
hats_tophat.json
head_cone.json
head_cone_inv.json
head_cuboid.json
head_spheroid.json
head_spheroid_mask.json
manifest.json
misc.json
misc_Prob1_mc.json
mouth_Mouth1_mc.json
mouth_Mouth2_mc.json
mouth_Mouth3_mc.json
mouth_Mouth4_mc.json
mouth_Mouth5_mc.json
mouth_Mouth6_mc.json
mouth_Mouth7_mc.json
```

Observed raw asset folders:

```text
body
eyes
hats
head
misc
mouth
```

## Prototype part mapping

These mappings are useful but are still marked prototype-derived until matched against OG asset/source evidence.

### Body type

```text
1 -> body_spheroid
2 -> body_cone
3 -> body_cone_narrow_inv
4 -> body_cuboid
```

### Head type

```text
1 -> head_spheroid
2 -> head_cone
3 -> head_cone_inv
4 -> head_cuboid
```

### Eye type

```text
1..6 -> EYE_POSITIONS tables per head type
1..3 generally use Eye_white1 / iris1 atlas set
4..6 use the alternate eyes / iris2 atlas set in the prototype renderer
```

### Mouth/expression

Mouth is not encoded directly inside the 18-digit `weevilDef`. The server sends expression separately as `ex` in room/user packets.

Prototype mouth order:

```text
0 -> Mouth2_mc
1 -> Mouth1_mc
2 -> Mouth3_mc
3 -> Mouth4_mc
4 -> Mouth5_mc
5 -> Mouth6_mc
6 -> Mouth7_mc
```

### Antennae

`antennaType` comes from digits 10-11 of `weevilDef`.

Prototype has basic layouts for:

```text
0..9
```

and a fallback `SUPER_ANTENNA_LAYOUT` for unsupported/special values.

### Legs

`legType` comes from digits 16-17 of `weevilDef`.

Prototype has:

```text
0/default -> normal lower_leg.png with source leg colour
1         -> lower_leg_stripy.png with source leg colour
2..40     -> special per-leg front/mid/rear colour palettes in CanvasRenderer
```

This must be checked against original source or observed game behaviour before being considered final.

## Clean port approach

Do not copy the old renderer wholesale.

Port in this order:

```text
1. WeevilDef source-format decoder       done
2. Palette source-format values          done
3. Prototype part map documentation      done
4. Asset manifest loader for atlases     next
5. Renderer math/projection helpers      later
6. Static one-weevil canvas render       later
7. Rotation/pose/depth accuracy          later
8. Room placement integration            later
```

## Warning

The prototype assets may be extracted/packed from original SWFs, but their provenance must still be documented. Until then, they are allowed as local reference material only, not final proof of authenticity.
