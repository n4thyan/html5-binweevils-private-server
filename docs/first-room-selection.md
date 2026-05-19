# First room selection

The first playable HTML5 slice should port one real Bin Weevils room with the smallest amount of guesswork.

## Candidate 1: Ink's Orange Peel / The Peel

Status: preferred, pending source audit.

Why this is preferred:

- It is thematically strong for the first public room slice.
- The uploaded HTML5 prototype already contains a `the_peel` style room shell and related room renderer work.
- If the original source contains matching room art/config, this gives us the most direct path to a faithful first demo.

Needs verification from `legacy-reference/Binweevils-main/`:

- original background image or SWF
- floor/walkable layer, if present
- foreground layer, if present
- original room dimensions/stage scale
- spawn/movement bounds
- chat bubble placement style
- UI chrome used around the room

## Candidate 2: Peel Park

Status: fallback if its original files are cleaner than The Peel.

Needs verification:

- source room art
- room config
- movement/collision data
- matching UI assets

## Candidate 3: Nest room

Status: technical fallback only.

Use this if public-room assets are too hard to isolate during the first pass. A nest may be easier because it can prove account/session/avatar rendering without immediately solving every public room layer.

## Decision rule

Choose the first room only after the audit has real file paths for assets/config.

The chosen first room must have enough evidence to support:

```text
Apache/XAMPP-served HTML5 client
real source room background
real or source-derived UI frame
HTML5 weevil renderer using real weevil assets where possible
click-to-move
original-style chat bubble
basic chat transport
basic hidden/admin command parser
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
