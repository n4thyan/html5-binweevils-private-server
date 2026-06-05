# Renderer transplant checklist

This checklist keeps the avatar work focused on the proven old renderer without pulling in bad demo architecture.

## Current renderer foundation

Done:

```text
AvatarState model
WeevilDef parser and validation
WeevilPalette mapping
WeevilPose helpers
WeevilVisualConfig scaffold
partial demo-backed visual constants
WeevilRenderPlan visual data
WeevilPrototypeRenderer path
renderer diagnostics helper
render-plan smoke test
renderer mode documentation
```

## Renderer modes

```text
debug: quick placeholder proof
prototype: clean transplant path for the visually-correct demo renderer
atlas: future real asset draw path, currently smoke-test only
```

## Next transplant work

### 1. Finish demo visual constants

Need to finish moving these from the old demo renderer into `WeevilVisualConfig.js`:

```text
antenna layout table
special antenna handling
leg layout table
special leg colour rules
body registration offsets
head registration offsets
mouth offsets per head type
proboscis / face detail placement
```

### 2. Replace vector shell with real draw functions

Current `WeevilPrototypeRenderer.js` is a vector shell. It should gradually absorb the old renderer's real drawing code:

```text
body draw function
head draw function
eye draw function
mouth draw function
antenna draw function
leg draw function
layer ordering
yaw/facing adjustments
```

### 3. Add asset-backed render path

Do not rush this until the draw constants are stable.

Target files:

```text
src/avatar/WeevilAtlasManifest.js
src/avatar/WeevilAtlasLoader.js
src/avatar/AtlasFrameRenderer.js
src/avatar/WeevilPrototypeRenderer.js
```

### 4. Compare against the old demo

Before marking avatar rendering as stable, compare:

```text
same weevilDef
same colours
same eyes
same antennae
same legs
same expression
same rotation
```

Compare visually against the old demo output, because that was the only part of the old HTML5 project that was trusted.

## Hard rule

Do not start rooms, movement, multiplayer, backend, or game systems until the avatar renderer foundation is stable enough to use inside a local room shell.

```text
renderer first
local room shell later
backend last
```
