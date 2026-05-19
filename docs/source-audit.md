# Source audit

This file tracks what has been inspected before porting code into the clean HTML5 repo.

## Local reference layout

The original KnowYourKnot/Binweevils source should live locally at:

```text
legacy-reference/Binweevils-main/
```

This folder is intentionally ignored by Git. It is the local source of truth used for inspection and selective porting.

The latest uploaded HTML5 prototype build has been inspected separately. It appears to be a mirror/community-site build with room chat, Weevil Studio, map switching, Find4, admin tooling, and a current The Peel-style room shell.

## Existing HTML5 prototype notes

Useful prototype files observed in the uploaded build:

```text
server.mjs
lib/room-data.mjs
lib/services/peel-room.mjs
public/js/room.js
public/js/weevil-room-renderer.js
public/weevil-creator/src/runtime/WeevilRenderer.js
public/weevil-creator/src/runtime/WeevilCanvasRenderer.js
public/weevil-creator/src/runtime/WeevilDef.js
public/weevil-creator/src/runtime/atlasLoader.js
public/weevil-creator/src/runtime/canvasAtlasLoader.js
public/weevil-creator/src/runtime/projection.js
```

Room/image assets observed in the prototype build:

```text
public/img/the-peel-room.png
public/img/the-peel-floor.png
public/img/the-peel-foreground.png
public/img/peel-garden-room.png
public/img/lavender-lounge-room.png
public/img/orange-hideout-room.png
public/img/statue-hall-room.png
public/img/statue-square-room.png
public/img/single-room-floor.png
```

Important caveat: these prototype files prove useful implementation work exists, but they do not prove source authenticity. Before copying any room/UI/weevil asset into the new public app, match it against `legacy-reference/Binweevils-main/` or clearly mark it as a temporary prototype fallback.

## Audit buckets

### 1. Room assets

Find and record:

- real room backgrounds
- foreground/overlay layers
- object sprites
- room config files
- collision/clickable areas, if present
- room dimensions and stage scale

Candidate search terms:

```text
peel
orange
ink
park
nest
room
map
zone
```

### 2. UI assets

Find and record:

- game frame/chrome
- map button
- nest button
- chat bar
- send button
- chat bubble assets
- playercard/splat assets
- buddy/mailbox/shop buttons

Candidate search terms:

```text
chat
bubble
map
nest
splat
playercard
buddy
mail
shop
button
```

### 3. Weevil/avatar assets

Find and record:

- body parts
- head/eyes/mouth/antennae/legs
- colour/tint data
- hats/items/apparel
- creator/editor code
- ActionScript behaviour files, if present

Candidate search terms:

```text
weevil
avatar
head
eyes
mouth
antenna
legs
hat
apparel
creator
editor
```

### 4. Backend/database

Find and record:

- SQL schema
- login/register endpoints
- session flow
- users table
- avatar/weevil table
- inventory/items
- rooms
- mulch/XP/levels
- redeem codes
- admin/mod tables/tools

Candidate search terms:

```text
login
register
session
users
weevil
inventory
items
mulch
xp
level
redeem
admin
mod
```

### 5. Realtime/game server

Find and record:

- movement transport
- chat transport
- room join/leave flow
- admin command handling
- polling/WebSocket/raw socket behaviour

Candidate search terms:

```text
socket
websocket
server
room
join
leave
move
chat
command
```

## First-room decision criteria

The first room should be chosen by evidence, not preference.

For each candidate, answer:

```text
Do we have real source background art?
Do we have foreground/object layers?
Do we have room dimensions/scale?
Do we have spawn or movement bounds?
Do we have collision/click metadata?
Do we have matching UI/chrome assets?
Can it be served cleanly through Apache/XAMPP?
```

Preferred order remains:

1. Ink's Orange Peel / The Peel
2. Peel Park
3. Nest fallback

## Current status

- GitHub repo has been prepared with audit documentation and ignore rules.
- `legacy-reference/` is intentionally ignored.
- No gameplay code has been ported yet.
- Next pass should run the local audit commands in `docs/windows-audit-commands.md`, then paste or commit the generated index files so exact source paths can be reviewed.
