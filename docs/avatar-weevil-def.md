# WeevilDef format

This document records the first source-derived avatar system for the faithful HTML5 port.

## Source evidence

Original source paths audited:

```text
game-full/essential/internal.php
  isDefValid($weevilDef)
  changeDefinition($weevilDef)
  changeWeevilDefinition($weevilDef)

game-full/php2/weevil/changeWeevilDef.php
  receives POST def/idx/hash/timer
  calls changeWeevilDefinition($weevilDef)

server/Weevil.js
  sends weevilDef on login and room join packets
```

## Raw format

`weevilDef` is an 18-digit string.

```text
index/range   field
0             headType
1-2           headColourIndex
3             bodyType
4-5           bodyColourIndex
6             eyeType
7-8           eyeColourIndex
9             lids
10-11         antennaType
12-13         antennaColourIndex
14-15         legColourIndex
16-17         legType
```

Example debug sample:

```text
101102103001040501
```

Decoded as:

```text
headType            1
headColourIndex     01
bodyType            1
bodyColourIndex     02
eyeType             1
eyeColourIndex      03
lids                0
antennaType         01
antennaColourIndex  04
legColourIndex      05
legType             01
```

## Port destination

```text
src/avatar/WeevilDef.js
src/avatar/WeevilPalette.js
src/avatar/WeevilDefSamples.js
```

## Current implementation status

Implemented:

```text
18-digit structural decode
primary and secondary palettes copied from source
basic validation matching known source constraints
colour hex conversion for debug rendering
boot scene decode proof
```

Not implemented yet:

```text
renderer visuals
exact part asset mapping
creator/editor UI
save/apply flow
all backend restriction quirks
comparison against old HTML5 renderer
comparison screenshots against original SWF/Ruffle
```

## Important note

The renderer must not guess the meaning of part indexes. The next step is to map the decoded part fields to original avatar assets and/or the old demo renderer, then document that mapping before drawing the final weevil.
