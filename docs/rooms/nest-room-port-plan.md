# Nest room port plan

This is the next recommended room/rendering direction after the Rums Cove / Rums Airport research pass.

The Rums work is not being thrown away. It proved XML placement extraction, source-backed image/SVG layering, bitmap-filled base shapes, depth ordering, door visuals, and movement-coordinate planning. It also proved that Rums Cove / Airport is too complex for the first complete navigation target.

## New first-room family

Use the uploaded `nest dump.zip` as the next room family.

Inspected contents:

```text
nestRoom1.swf
nestRoom2.swf
nestRoom3.swf
nestRoom4.swf
nestRoom6.swf
nestRoom7.swf
nestRoom8.swf
nestRoom9.swf
nestHall_03_06_11.swf
SWF XML/*.xml
```

The simple `nestRoom*.swf` files are much smaller than Rums Cove and are better suited to proving room rendering and movement together.

## Why Nest rooms are better for the next pass

```text
simple rooms are 20-30 exported files each
simple rooms have 1-2 door movieclips
simple rooms expose roomBG_spr, door*_mc and clickArea_btn names
simple rooms have one exported frame preview each
simple rooms have matching SWF XML exports
no dynamic ads/video pod/planes/fireworks in the simple rooms
```

This makes them ideal for a slow source-backed movement and navigation pass.

## Suggested order

```text
1. Copy/extract nest dump into reference/rooms/nest-dump
2. Build a Nest room audit script from the SWF XML files
3. Start with nestRoom1 as the first complete render target
4. Add movement sandbox overlay using the existing x/y/z/r coordinate model
5. Add nestRoom2 as the second room
6. Add a local two-room navigation smoke test
7. Expand to nestRoom3/nestRoom8
8. Add two-door rooms nestRoom4/nestRoom6/nestRoom7/nestRoom9
9. Defer nestHall_03_06_11 until simple rooms are proven
```

## Initial inspected room facts

```text
nestRoom1: 22 files, 7 shapes, 4 sprites, 1 button, 2 scripts, MainTimeline vars door1_mc + roomBG_spr
nestRoom2: 20 files, 6 shapes, 3 sprites, 1 button, 2 scripts, MainTimeline vars door1_mc + roomBG_spr
nestRoom3: 22 files, 7 shapes, 4 sprites, 1 button, 2 scripts, MainTimeline vars door1_mc + roomBG_spr
nestRoom4: 28 files, 10 shapes, 5 sprites, 2 buttons, 3 scripts, MainTimeline vars door1_mc + roomBG_spr + door2_mc
nestRoom6: 28 files, 10 shapes, 5 sprites, 2 buttons, 3 scripts, MainTimeline vars door1_mc + roomBG_spr + door2_mc
nestRoom7: 30 files, 11 shapes, 6 sprites, 2 buttons, 3 scripts, MainTimeline vars door1_mc + roomBG_spr + door2_mc
nestRoom8: 22 files, 7 shapes, 4 sprites, 1 button, 2 scripts, MainTimeline vars door1_mc + roomBG_spr
nestRoom9: 30 files, 11 shapes, 6 sprites, 2 buttons, 3 scripts, MainTimeline vars door1_mc + roomBG_spr + door2_mc
nestHall_03_06_11: 2683 files, 247 shapes, 126 sprites, 13 buttons, 41 scripts, deferred
```

## First target pair

Use:

```text
nestRoom1
nestRoom2
```

Reason:

```text
both are simple
both have one visible door movieclip
both have roomBG_spr
both have clickArea_btn
both have small export footprints
both have matching XML files
```

## Movement rule

The movement coordinate sandbox remains valid. It should now be attached to the simple Nest room target rather than Rums Cove.

Rules:

```text
use audited movement coordinate model
keep state as x/y/z/r
use source clickArea/boundary data where available
use source door movieclip names and act areas
use source room frames/SVGs for rendering
no fake room layout
no invented permanent movement behaviour
```

## Deferred

```text
Nest Hall / Nest Hell
full nest customisation
inventory/furniture placement
save/load nest state
multiplayer sync
```

Nest Hall is useful later, but it is too large for the first movement/render/navigation pass.
