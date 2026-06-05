# First room selection

Room work is not the current milestone. The active milestone remains the avatar/rendering foundation.

When room work begins, do not use the old `The Peel`, `Ink's Orange`, or custom-room plan as the first target. That plan came from the earlier bad HTML5 proof-of-concept and should not drive the faithful port.

## Correct first-room policy

The first room should be one verified original `fixedCam` room from the committed KnowYourKnot source.

It does not matter which `fixedCam` room is selected first, as long as it has enough source evidence to port cleanly.

Required evidence:

```text
locationDefinitions entry
fixedCam room background/SWF reference
walk boundary data
entry position
camera/scale values
object/layer references where available
matching source asset files
```

## Candidate source areas

Audit these when room work starts:

```text
source/knowyourknot-binweevils/game-full/binConfig/
source/knowyourknot-binweevils/game-full/binConfig/getFile/
source/knowyourknot-binweevils/game-full/cdn.binw.net/
source/knowyourknot-binweevils/game-full/cdn.binw.net/assets3D/
```

Look for room references like:

```text
fixedCam/*.swf
fixedCam/*.jpg
fixedCam/*.png
```

## Selection rule

Pick the first room by evidence quality, not preference.

Good first candidate:

```text
small fixedCam room
clear locationDefinitions block
simple rectangular or simple no-go boundary
few objects
obvious entry position
assets present in source/
```

Avoid for the first room:

```text
custom rooms from the old demo
The Peel / Ink's Orange custom plan
rooms with lots of minigame-specific scripting
rooms with missing assets
rooms requiring backend/session logic to look correct
```

## Not part of room milestone

Do not begin these until avatar rendering and a local room shell are reliable:

```text
backend login/session
multiplayer sync
full map
buddy list
mailbox
shops
inventory
mulch/XP/level systems
minigames
full door transition network
external UI popups
```

## Current status

```text
rooms: deferred
current priority: source-backed avatar renderer foundation
future room target: verified original fixedCam room
```
