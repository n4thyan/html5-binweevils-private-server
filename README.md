# HTML5 Bin Weevils Private Server

This repository is being reset into a clean, faithful Flash-to-HTML5 port of Bin Weevils.

The goal is not to make a loose remake, a reimagining, or a generic Bin Weevils-inspired MMO. The goal is to port the original Flash client behaviour, layout, asset usage, room flow, avatar rendering, UI logic, and server expectations into a native HTML5/JavaScript client.

## Current status

The old HTML5 build is now treated as a proof-of-concept only.

The only prototype work considered genuinely reusable at this stage is the weevil editor/rendering stack, because it proves that a weevil can be decoded and drawn in HTML5. All other systems must be rebuilt from the original source and verified assets.

## Source-of-truth order

1. Original KnowYourKnot/Binweevils source and verified OG assets.
2. Extracted or converted assets that can be traced back to the original files.
3. The old HTML5 demo only where it preserves already-solved implementation knowledge.
4. Temporary placeholders only when clearly labelled and removed before the relevant milestone is considered complete.

## Repository roles

```text
og-source/              External source/reference material. Do not edit as port code.
prototype-reference/    Old demo notes and any preserved renderer reference work.
src/                    Clean HTML5 port source code.
public/                 Static files served by the browser during development.
docs/                   Port rules, architecture notes, source audits, and milestone plans.
```

## Porting rule

Every ported system must answer these questions before implementation:

```text
Which original Flash/ActionScript/source file controlled it?
Which original assets did it use?
Which data format did it expect?
What is the matching HTML5 module?
How will fidelity be tested?
```

No feature should be accepted just because it looks close. If behaviour or visuals are guessed, they must be marked as temporary.

## Milestone 001: faithful client foundation

Milestone 001 does not aim to make a playable MMO room. It aims to build the clean runtime that later rooms and systems depend on.

Milestone 001 target:

```text
HTML5 app boots
legacy stage/canvas exists
core scene manager exists
asset loader shell exists
avatar renderer module boundary exists
prototype renderer reference is documented
one placeholder test scene renders
no room/chat/account systems are faked as permanent code
```

## Planned port order

1. Project charter and clean repo structure.
2. Source setup for KnowYourKnot/Binweevils reference material.
3. Core HTML5 runtime: stage, game loop, scene manager, input, debug overlay.
4. Asset manifest/resolver for original file tracing.
5. WeevilDef and avatar renderer port.
6. UI primitives: buttons, panels, labels, chat bubble.
7. First real room selected by source evidence.
8. Room renderer, layers, walk area, depth sorting.
9. Click-to-move.
10. Local chat bubble and chatbar.
11. Session/server bridge.
12. Multiplayer room sync.

## Development commands

```bash
npm install
npm run dev
```

The initial app is intentionally small. It is a foundation for the faithful port, not a replacement for the original game yet.

## Start here

Read these first:

```text
docs/port-charter.md
docs/architecture.md
docs/milestones.md
docs/prototype-reference.md
docs/og-source-setup.md
```
