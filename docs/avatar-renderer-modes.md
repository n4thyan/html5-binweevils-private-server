# Avatar renderer modes

This document describes the current renderer split for the faithful HTML5 port.

## Current goal

The old HTML5 demo renderer was visually close to the original weevil renderer. The repo is now structured so that good visual work can be transplanted without keeping the bad prototype project architecture.

## Mode split

```text
WeevilCanvasRenderer
  debug mode
  prototype mode
  atlas mode
```

### debug mode

File:

```text
src/avatar/WeevilCanvasRenderer.js
```

Purpose:

```text
lightweight visual-plan proof
simple placeholder shapes
useful when renderer data changes
not intended to match final visuals
```

### prototype mode

Files:

```text
src/avatar/WeevilCanvasRenderer.js
src/avatar/WeevilPrototypeRenderer.js
src/avatar/WeevilVisualConfig.js
```

Purpose:

```text
clean transplant path for the visually-correct old demo renderer
uses demo-backed body/head/eye/mouth/leg/antenna config
keeps renderer work isolated from room/backend/game systems
current default boot scene renderer mode
```

Status:

```text
vector shell active
visual config partially transplanted from demo app.js
full atlas/shape drawing still pending
```

### atlas mode

Files:

```text
src/avatar/WeevilCanvasRenderer.js
src/avatar/AtlasFrameRenderer.js
```

Purpose:

```text
future real asset drawing path
currently smoke-test only
intentionally gated so nobody mistakes it for final rendering
```

## Data flow

```text
AvatarState
  -> WeevilDef
  -> WeevilPose
  -> WeevilVisualConfig
  -> WeevilRenderPlan
  -> WeevilCanvasRenderer
  -> WeevilPrototypeRenderer
```

## Guardrail

Do not put room logic, movement logic, networking, backend login, or database behaviour inside avatar renderer files.

The renderer should only know how to draw an avatar from a complete render plan.

## Next renderer tasks

```text
1. Finish transplanting visual constants from the old demo renderer.
2. Add real atlas/shape drawing behind prototype mode.
3. Compare visually against the old demo renderer.
4. Only then treat weevil rendering as production-ready for rooms.
```
