# Architecture

This document defines the clean structure for the faithful HTML5 port.

The architecture is intentionally small at first. The first goal is not a playable MMO. The first goal is a reliable Flash-to-HTML5 runtime foundation.

## Top-level folders

```text
src/
  core/
  assets/
  avatar/
  ui/
  rooms/
  net/
  data/
public/
  assets/
  index.html
docs/
og-source/              ignored local source/reference material
prototype-reference/    notes or extracted reference snippets only
```

## Runtime layers

```text
GameApp
  owns Stage
  owns SceneManager
  owns AssetLoader
  owns DebugOverlay

SceneManager
  switches between boot/test/room scenes

Stage
  wraps the canvas/display root
  preserves legacy dimensions and coordinate assumptions

GameLoop
  ticks active scene and renderer
```

## Source modules

### `src/core/`

Core Flash-runtime replacement pieces.

```text
GameApp.js
GameLoop.js
Stage.js
SceneManager.js
EventBus.js
DebugOverlay.js
LegacyScale.js
```

### `src/assets/`

Original asset tracing and browser loading.

```text
AssetLoader.js
AssetManifest.js
LegacyAssetResolver.js
```

Every final asset should eventually trace back to an original source file.

### `src/avatar/`

Weevil definition and rendering.

```text
WeevilDef.js
WeevilRenderer.js
WeevilCanvasRenderer.js
WeevilParts.js
WeevilPalette.js
WeevilPose.js
```

The old demo renderer can be reviewed here, but this module must be cleaned and matched against original source behaviour.

### `src/ui/`

Original-style UI primitives.

```text
Button.js
Panel.js
Label.js
ChatBar.js
ChatBubble.js
PlayerCard.js
```

Do not invent new UI visuals. Use source evidence and verified assets.

### `src/rooms/`

Room rendering and behaviour.

```text
Room.js
RoomLoader.js
RoomLayer.js
RoomObject.js
WalkArea.js
DepthSorter.js
ExitHotspot.js
```

Rooms come after the core runtime and avatar renderer, not before.

### `src/net/`

Session and server bridge. This comes later.

```text
Session.js
Packets.js
ServerConnection.js
RoomSession.js
```

Do not start here. The client must feel correct locally first.

## Development principle

Build in this order:

```text
core runtime
asset resolver
avatar renderer
UI primitives
room renderer
movement
chat
network/session
```

This order prevents the project from becoming another feature-first proof-of-concept.
