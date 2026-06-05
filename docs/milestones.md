# Milestones

The port must move in small, verified milestones. Do not jump straight into rooms, multiplayer, accounts, or admin tools.

## Milestone 001: faithful client foundation

Goal: create the clean HTML5 runtime foundation.

Deliverables:

```text
HTML5 app boots
canvas/stage created
legacy stage size defined
scene manager working
asset loader shell working
debug overlay showing coordinates and scene name
placeholder test scene renders
project folders established
old demo marked as reference only
```

Not included:

```text
rooms
chat
login
server sync
multiplayer
admin commands
minigames
shops
map
```

## Milestone 002: avatar/weevil foundation

Goal: port the weevil definition and renderer properly.

Deliverables:

```text
WeevilDef decoder/encoder reviewed against original source
renderer extracted from bad demo only where useful
renderer moved into src/avatar/
asset paths cleaned
one test weevil rendered
colour handling documented
part ordering documented
comparison notes created
```

## Milestone 003: original UI primitives

Goal: build the basic UI building blocks before full game screens.

Deliverables:

```text
original-style button primitive
panel primitive
label/nameplate primitive
chat bubble primitive
chatbar shell
UI asset provenance notes
```

## Milestone 004: first room source audit

Goal: choose the first room from evidence, not preference.

Deliverables:

```text
room source paths documented
room config transcribed or parsed
background/floor/objects identified
walkable/collision data identified
spawn/entry data identified
known missing pieces listed
```

## Milestone 005: first room render

Goal: render one real original room locally.

Deliverables:

```text
room JSON manifest
floor/background rendered
object layers rendered
original coordinate system preserved
one weevil placed at source entry position
debug overlay shows room coordinates/layers
```

## Milestone 006: local movement

Goal: match the original click-to-move feel locally.

Deliverables:

```text
click target calculation
walk area/boundary handling
no-go area handling where known
weevil facing/direction handling
Y-depth sorting
idle state
```

## Milestone 007: local chat

Goal: add chat UI without server dependency.

Deliverables:

```text
chatbar input
speech bubble
bubble timing
bubble positioning
basic local command parser
```

## Milestone 008: session/server bridge

Goal: only after local room behaviour feels faithful, connect to backend/session systems.

Deliverables:

```text
session model
room join flow
movement packet bridge
chat packet bridge
server compatibility notes
```

## Rule

A milestone is not complete if it relies on guessed behaviour without being marked as temporary.
