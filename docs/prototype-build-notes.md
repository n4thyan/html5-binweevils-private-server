# Uploaded HTML5 prototype build notes

Inspected uploaded archive:

```text
BWR_HTML5_full_project_map_ui(1).zip
```

## What it appears to be

The build identifies itself as a Bin Weevils Rewritten mirror/community-site build rather than the final faithful KnowYourKnot HTML5 port.

It includes:

- local accounts/data JSON
- room chat
- map switching
- Weevil Studio / creator runtime
- Find4
- admin tooling
- verification/testing/deployment notes
- a The Peel-style room shell

## Useful files for later review

Server/backend prototype:

```text
server.mjs
lib/store.mjs
lib/auth.mjs
lib/render.mjs
lib/room-data.mjs
lib/services/peel-room.mjs
lib/services/creator-service.mjs
lib/services/session-state.mjs
```

Room/client prototype:

```text
public/js/room.js
public/js/weevil-room-renderer.js
public/js/app.js
public/js/creator-host.js
public/js/profile-weevil-preview.js
```

Weevil renderer/creator prototype:

```text
public/weevil-creator/index.html
public/weevil-creator/src/main.js
public/weevil-creator/src/runtime/WeevilRenderer.js
public/weevil-creator/src/runtime/WeevilCanvasRenderer.js
public/weevil-creator/src/runtime/WeevilDef.js
public/weevil-creator/src/runtime/atlasLoader.js
public/weevil-creator/src/runtime/canvasAtlasLoader.js
public/weevil-creator/src/runtime/math.js
public/weevil-creator/src/runtime/projection.js
```

Observed room images:

```text
public/img/the-peel-room.png          1024x640
public/img/the-peel-floor.png         1024x640
public/img/the-peel-foreground.png    1024x640
public/img/peel-garden-room.png       1024x640
public/img/lavender-lounge-room.png   1024x640
public/img/orange-hideout-room.png    2048x1365
public/img/statue-hall-room.png       1024x640
public/img/statue-square-room.png     2048x1365
public/img/single-room-floor.png      1024x682
```

## How to use this build

Use it as a working reference for implementation ideas and already-solved HTML5 behaviour.

Good candidates to reuse carefully:

- room state shape
- click-to-move experiments
- weevil canvas renderer work
- chat bubble positioning experiments
- admin command parser ideas
- local dev/server notes

Do not treat it as authoritative for:

- original room selection
- original UI layout
- original backend flow
- original database schema
- final asset paths
- final visual style

Every copied visual asset or gameplay behaviour should be checked against the KnowYourKnot source before becoming part of the faithful port.
