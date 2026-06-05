# Client source map

This document maps committed KnowYourKnot source evidence to the HTML5 client systems that must be ported.

Primary source root:

```text
source/knowyourknot-binweevils/
```

## Confirmed source access

The KnowYourKnot source has been committed into this repo and is accessible through GitHub.

Confirmed fetched paths:

```text
source/knowyourknot-binweevils/game-full/essential/internal.php
source/knowyourknot-binweevils/server/Weevil.js
```

## Avatar definition and palette

Source evidence:

```text
source/knowyourknot-binweevils/game-full/essential/internal.php
  isDefValid($weevilDef)
  changeDefinition($weevilDef)
  changeWeevilDefinition($weevilDef)
```

Port destination:

```text
src/avatar/WeevilDef.js
src/avatar/WeevilPalette.js
```

Status:

```text
first-pass source-backed port exists
```

Important discovered behaviour:

```text
weevilDef is exactly 18 digits
palettes clrs1 and clrs2 are defined inside isDefValid
substring positions define head/body/eyes/lids/antennae/legs and colour indexes
changeDefinition has stricter normal-editor restrictions
changeWeevilDefinition allows wider customisation but has level/admin restrictions
```

## Login/session user data

Source evidence:

```text
source/knowyourknot-binweevils/server/Weevil.js
  loginToBin(data)
```

Observed fields:

```text
id
isModerator
def
loginKey
canSpeak
curHat
active
```

Server response carries:

```text
weevilDef
apparel
idx
userID
```

Port destination later:

```text
src/net/Session.js
src/data/UserState.js
```

Status:

```text
deferred until the local client/game systems are ported
```

## Room join/user state

Source evidence:

```text
source/knowyourknot-binweevils/server/Weevil.js
  changeRoom(roomName, x, y, z, r, locId, ...)
  returnJoinOK(roomId, ...)
  spawnWeevil(roomId, locId, userId, weevilName, isMod, weevilDef, x, y, z, r, weevilIdx, currentHat, currentExpression)
```

Observed user variables in join/spawn packets:

```text
weevilDef
r
ps
ex
x
y
z
apparel
idx
doorID
locID
```

Port destination later:

```text
src/rooms/RoomSession.js
src/avatar/AvatarState.js
src/net/Packets.js
```

Status:

```text
deferred until avatar renderer and local room engine exist
```

## Movement/user variable updates

Source evidence:

```text
source/knowyourknot-binweevils/server/Weevil.js
  setUVars(data, ...)
  moveWeevil(roomId, x, z, r, ...)
```

Observed movement/state variables:

```text
x
y
z
r
```

Notes:

```text
Y is tracked but often remains 0
moveWeevil broadcasts %xt%2#1%-1%userID%x%z%r%
setUVars broadcasts uVarsUpdate with x/z/r/y
```

Port destination later:

```text
src/movement/MovementState.js
src/movement/ClickToMove.js
src/net/Packets.js
```

Status:

```text
not started
```

## Actions/poses

Source evidence:

```text
source/knowyourknot-binweevils/server/Weevil.js
  doAction(roomId, userId, actionId, power, ...)
```

Observed behaviour:

```text
action 6 sets ps = 6 // sitting
action 7 sets ps = 7 // standing
other action IDs usually reset ps = 0
action 10 may update x/y/z/r when power contains 4 comma-separated coordinates
actions are broadcast as %xt%2#3%-1%userId%actionId%power%
```

Port destination later:

```text
src/avatar/WeevilActions.js
src/avatar/WeevilPose.js
src/net/Packets.js
```

Status:

```text
not started
```

## Public chat

Source evidence:

```text
source/knowyourknot-binweevils/server/Weevil.js
  sendPublicMessage(data, ...)
```

Observed behaviour:

```text
messages are room-scoped
message is limited to 38 characters
basic validation/filtering occurs server-side
packet action is pubMsg
```

Port destination later:

```text
src/ui/ChatBar.js
src/ui/ChatBubble.js
src/net/Packets.js
```

Status:

```text
not started
```

## Current priority

Do not start movement, room networking, actions, or chat yet.

Current active priority remains:

```text
Milestone 002: source-backed avatar definition and renderer foundation
```

Next work:

```text
1. verify prototype renderer asset names against source assets
2. cleanly transplant reusable renderer logic
3. keep debug renderer until real atlas assets are proven
```
