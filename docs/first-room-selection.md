# First room selection

The first playable HTML5 slice should port one real Bin Weevils room with the smallest amount of guesswork.

## Selected first room: Ink's Orange / Orange Peel

Status: selected for milestone 002.

Why this is now selected:

- The original source contains a full `location` block for `id="106" name="InksOrange"`.
- The location has a real floor reference: `floors/inks.jpg`.
- The location has movement data: rectangular boundary, entry position, entry direction, camera values, and weevil scale.
- The location has door definitions and a radial no-go area.
- The location has object placements for `orangePeel.swf`, `orangeSegment.swf`, `orangeBlob.swf`, `cottonReel.swf`, `needle.swf`, `signMsgBoard.swf`, arrows, and mini-game slots.
- The source also includes matching room asset files under `cdn.binw.net/assets3D/`.

Detailed room audit:

- `docs/rooms/inks-orange.md`

## Candidate 2: Peel Park

Status: fallback/later public-room port.

Needs verification:

- source room art
- room config
- movement/collision data
- matching UI assets

## Candidate 3: Nest room

Status: technical fallback/later private-room port.

A nest room may still be useful for account/session/avatar rendering, but it is no longer needed as the first room because Orange Peel has enough original config data to drive a real port.

## Milestone 002 target

Build a small Apache/XAMPP-served HTML5 Orange Peel room shell using source data from:

```text
legacy-reference/Binweevils-main/game-full/binConfig/getFile/1/uk/locationDefinitions.xml
```

The first playable demo should support:

```text
real source room floor/reference asset
source-derived room JSON
source-derived object placement data
HTML5 room renderer in original coordinate space
click-to-move using boundary and no-go data
existing HTML5 weevil renderer placed at entryPos
original-style chat bubble
basic local chat/admin command parser
```

## Not part of first slice

These systems are important, but should wait until the room foundation feels right:

- full map
- full login/register polish
- buddy list
- mailbox
- shops
- inventory
- mulch/XP/level bank/prestige UI
- minigames
- functional door transitions
- external UI popups
