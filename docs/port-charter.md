# Port charter

This project is a faithful Flash-to-HTML5 port of Bin Weevils.

It is not a remake, reimagining, fan-game rewrite, or modern MMO inspired by Bin Weevils. The aim is to replace the Flash runtime with a browser-native HTML5/JavaScript runtime while preserving the original behaviour and feel.

## Core promise

```text
Original Flash client behaviour -> HTML5 equivalent
ActionScript logic -> JavaScript modules
Flash display list -> HTML5 canvas/display tree
MovieClip/timeline behaviour -> explicit JS state/animation systems
Original assets -> reused, extracted, or converted with traceability
Original data flow -> preserved where practical
```

## What 1:1 means

1:1 means faithful behaviour, visuals, scale, layout, timing, and data flow.

It does not mean copying messy code line-for-line. It means understanding what the original did, then implementing the same result in clean HTML5 code.

## Authority order

1. Original KnowYourKnot/Binweevils source.
2. Verified original assets.
3. Extracted/converted assets with clear provenance.
4. Old HTML5 demo renderer/reference code.
5. Temporary placeholders, clearly labelled.

## Hard rules

- Do not build a generic modern MMO shell.
- Do not invent new UI chrome, buttons, room layouts, nameplates, or chat bubbles.
- Do not trust the old HTML5 demo as source authority.
- Do not start with multiplayer, accounts, admin tools, or minigames.
- Do not port huge subsystems in one pass.
- Do not edit `og-source/` as if it is the new codebase.
- Do not accept guessed behaviour as final.
- Do not commit massive asset dumps without a storage plan.

## Allowed modernisation

Modernisation is allowed only at the code/runtime level:

- cleaner JS modules
- better debug tooling
- explicit state machines
- asset manifests
- source traceability
- automated tests where practical
- browser-native rendering

Modernisation must not alter the original game identity or core flow.

## Minimum proof for each ported feature

Before a feature is considered ported, document:

```text
original source path
original asset paths
original data/config format
HTML5 destination module
known differences
fidelity test method
```

## Current project stance

The old HTML5 demo is considered a bad proof-of-concept. It is useful mainly because the weevil renderer proves that avatar rendering can work in HTML5.

Everything else should be rebuilt from original source evidence.
