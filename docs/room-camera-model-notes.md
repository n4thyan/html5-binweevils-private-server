# Room camera model notes

Date: 2026-06-05

## Important distinction

Bin Weevils rooms do not all use the same camera model.

For the current HTML5 port plan, there are two relevant categories:

```text
FixedCamera rooms
3D camera / movable camera rooms
```

## FixedCamera rooms

These are the first priority for the port.

Reason:

```text
simpler initial room rendering target
better suited for first source-backed room audit
less dependent on CamUI behaviour
lets us prove room layer rendering, avatar placement, depth, click-to-move and actions first
```

Current plan:

```text
start with one original FixedCamera room
ignore the old custom The Peel test room
map room assets/data before rendering
then add source-backed walking/depth/actions inside that room
```

## 3D camera rooms

These use the camera control panel and camera movement behaviours mapped from:

```text
core5.swf/scripts/com/binweevils/CamUI.as
```

Example room type:

```text
Flum's Fountain
```

The mapped `CamUiSourceMap` is still valuable, but it is not an immediate implementation priority while the first target is a FixedCamera room.

## CamUI status

Mapped but deferred.

Current mapped details:

```text
zoomRotate_spr
elevation_spr
joy1_spr / joy2_spr
left/right/forward/back/up/down buttons
resetCamBtn_mc
closeUpCamBtn_mc
aimFollowCamBtn_mc
weevilCamBtn_mc
help_sign
vx/vy/vz behaviour values
keyboard arrow mappings
mode button selected-frame behaviour
```

Why it was still worth mapping:

```text
it preserves real source-backed behaviour before we need it
it helps identify the right-side camera panel seen in later UI references
it prevents guessing when 3D camera rooms are eventually ported
```

## Priority order

```text
1. FixedCamera room audit
2. FixedCamera room render
3. Local weevil placement/depth
4. Click-to-move and basic actions
5. Chat/action UI pieces
6. Later: 3D camera rooms and CamUI activation
```

Do not let CamUI work distract from the first FixedCamera-room milestone.
