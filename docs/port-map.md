# Port map

This file maps original KnowYourKnot/Binweevils source evidence to the clean HTML5 port modules.

The project must grow from this map, not from random feature work.

## Source repository

Original reference currently audited from:

```text
KnowYourKnot/Binweevils
```

Repository facts observed through GitHub:

```text
visibility: public
default branch: main
clone URL: https://github.com/KnowYourKnot/Binweevils.git
observed GitHub repo size: 1182558 KB
```

Because the source repo is large, the clean HTML5 repo should audit and port selectively instead of committing the whole source tree.

## Initial audited systems

### 1. Weevil/avatar definition

Original source evidence:

```text
game-full/essential/internal.php
  function isDefValid($weevilDef)
  function changeDefinition($weevilDef)
  function changeWeevilDefinition($weevilDef)

game-full/php2/weevil/changeWeevilDef.php
  POST def/idx/hash/timer -> checkHash -> changeWeevilDefinition

server/Weevil.js
  login response includes <var n='weevilDef'>...</var>
  room join packets include weevilDef, x, y, z, r, apparel, expression, locID
```

HTML5 destination:

```text
src/avatar/WeevilDef.js
src/avatar/WeevilPalette.js
```

Key data discovered:

```text
weevilDef is expected to be exactly 18 digits
positions 0..17 encode head/body/eyes/lids/antennae/legs and colour indexes
backend has two colour palettes: clrs1 and clrs2
server packets carry weevilDef as a string field
```

Planned first port action:

```text
Port decoder and structural validation first.
Do not touch renderer visuals until the definition format is stable.
```

### 2. Login/session and user state

Original source evidence:

```text
server/Weevil.js
  loginToBin(data)
  SELECT id, isModerator, def, loginKey, canSpeak, curHat, active FROM users
  sends xtRes login success with weevilDef, apparel, idx, userID

game-full/essential/internal.php
  confirmSessionKey($username, $key)
  getLoginDetails()
  getWeevilStats()
  weevilGetData($username)
  weevilData($username)
```

HTML5 destination later:

```text
src/net/Session.js
src/net/ServerConnection.js
src/data/UserState.js
```

Port status:

```text
deferred until local avatar, UI, room, movement, and chat behaviour are stable
```

### 3. Room/location data

Original source evidence:

```text
game-full/binConfig/locationDefinitions_250210.xml
game-full/binConfig/locationDefinitions03_12_10.xml
game-full/binConfig/locationDefinitions06_12_10.xml
game-full/binConfig/locationDefinitions_01_09_11.xml
game-full/binConfig/locationDefinitions_08_03_12.xml
game-full/binConfig/getFile/66666/uk/locationDefinitions.xml
```

Example data shape observed:

```text
<location id='104' name='ShoppingMall' type='2' boundType='rect' boundary='-185,0,351,177' camPos='258,219,-271' camAim='-62,20,284' entryPos='0,80' weevilScale='0.28'>
  <roomBG path='fixedCam/shoppingMall_dynamAds.swf'/>
  <door ... />
  <object ... />
  <preRend3D ... />
</location>
```

HTML5 destination later:

```text
src/rooms/RoomManifest.js
src/rooms/RoomLoader.js
src/rooms/Room.js
src/rooms/WalkArea.js
src/rooms/DepthSorter.js
```

Port status:

```text
deferred until runtime, asset system, avatar definition, avatar renderer, and UI primitives are stable
```

### 4. Realtime room/session packets

Original source evidence:

```text
server/Weevil.js
  changeRoom(roomName, x, y, z, r, locId, ...)
  returnJoinOK(roomId, ...)
  spawnWeevil(...)
  setBVars(...)
```

Observed packet fields:

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

HTML5 destination later:

```text
src/net/Packets.js
src/net/RoomSession.js
```

Port status:

```text
deferred until local room behaviour exists
```

## Current next action

Start Milestone 002 with a source-derived `WeevilDef` decoder and palette file.

Do not start room rendering yet.
