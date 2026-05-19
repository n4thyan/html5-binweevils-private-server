# Weevil renderer integration plan

Milestone 002 currently uses a temporary canvas placeholder weevil so the Orange Peel room shell remains playable while renderer integration is tested.

The previous uploaded HTML5 build already has a working weevil creator/renderer. We should reuse it carefully instead of rewriting that system from scratch.

## Prototype files to import locally

From the previous HTML5 build:

```text
public/weevil-creator/
public/js/weevil-room-renderer.js
```

Useful runtime files inside `public/weevil-creator/` include:

```text
src/runtime/WeevilCanvasRenderer.js
src/runtime/WeevilRenderer.js
src/runtime/WeevilDef.js
src/runtime/canvasAtlasLoader.js
src/runtime/atlasLoader.js
src/runtime/math.js
src/runtime/projection.js
assets/atlases/*.json
assets/atlases/*.png
assets/raw/**
```

## Local import helper

Use:

```powershell
.\tools\import-prototype-weevil-renderer.ps1 -PrototypeRoot C:\path\to\old\project
```

The helper copies:

```text
old public/weevil-creator/ -> new public/weevil-creator/
old public/js/weevil-room-renderer.js -> new public/src/client/room/room-weevil-renderer.js
```

It also patches the old room renderer's absolute `/weevil-creator/` imports so it can work when this repo is served from an XAMPP subfolder.

The copied files are ignored by Git by default for now. This keeps the clean repo safe while we verify the integration.

## Safe integration rule

Do not remove the placeholder weevil yet.

The room should support:

```text
real renderer available -> draw real weevil
real renderer missing/error -> keep placeholder weevil
```

That way click-to-move, chat bubbles, and room testing remain usable even if the first renderer pass has animation or asset issues.

## Movement versus animation

Keep these as separate systems:

```text
movement path: x/z, target, speed, boundary, no-go
weevil animation: idle/walk frames, yaw, leg poses, apparel alignment
```

The first renderer pass only needs to prove:

```text
idle weevil appears in the room
weevil follows click-to-move position
rough yaw/turning follows movement direction
chat bubble remains anchored above the weevil
placeholder fallback still works
```

A later pass can tune:

```text
walk-cycle speed
foot sliding
turn smoothing
hat/apparel alignment while moving
scale against room perspective
true source-aware room camera projection
```

## Why the room looks spatially off right now

The milestone 002 room shell uses a simple flat `x/z -> canvas` mapping.

The original `InksOrange` config includes camera data:

```text
camPos
camAim
camBounds
preRend3D x/y/z
rotation/frame metadata
```

So the current room is good as a technical existence demo, but final placement should eventually respect the original camera/projection rather than manually nudging coordinates by eye.
