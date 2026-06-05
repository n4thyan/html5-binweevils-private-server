# System port order

Every major system must be ported from the original Flash/ActionScript/source behaviour in a logical dependency order.

Do not jump ahead because a later feature looks more exciting. Later systems depend on earlier systems being correct.

## Core rule

```text
No system is final until its original source path, asset paths, data format, HTML5 destination, and fidelity test are documented.
```

## Dependency order

### 1. Source audit and port map

Purpose: know what exists before rebuilding anything.

Port evidence required:

```text
original source paths
asset paths
config/data files
server/database files
known missing pieces
```

Outputs:

```text
docs/port-map.md
docs/source-audit.md
docs/og-source-file-index.txt
```

### 2. HTML5 runtime foundation

Purpose: replace the Flash runtime environment with a stable browser-native base.

Systems:

```text
stage/canvas
game loop
scene manager
event bus
input router
debug overlay
legacy scale handling
```

### 3. Asset system

Purpose: load browser assets while keeping source traceability.

Systems:

```text
asset manifest
legacy path resolver
image loader
atlas loader
source provenance records
```

### 4. Weevil/avatar definition system

Purpose: decode and encode the original weevil definition format.

Systems:

```text
WeevilDef
body part IDs
colour IDs
part ordering
validation
save/load compatibility
```

### 5. Weevil/avatar renderer

Purpose: draw the avatar faithfully before using it in rooms or UI.

Systems:

```text
part loading
layering
colour/tint handling
projection/scale
idle pose
room placement support
```

### 6. UI primitives

Purpose: build original-style interface parts before full screens.

Systems:

```text
buttons
panels
labels/nameplates
speech bubble
chatbar shell
simple popup shell
```

### 7. Room data parser/manifest

Purpose: turn original room data into explicit HTML5 room manifests.

Systems:

```text
room ID/name/type
floor/background references
object placement data
entry positions
boundaries
no-go areas
doors/exits
camera/scale values
```

### 8. Room renderer

Purpose: render one real room in original coordinate space.

Systems:

```text
floor/background layer
object layers
foreground overlays
coordinate transform
depth sorting
weevil placement
```

### 9. Movement system

Purpose: reproduce original click-to-move feel.

Systems:

```text
click target handling
walk boundaries
no-go areas
speed/facing
idle state
Y-depth ordering
```

### 10. Local chat system

Purpose: reproduce chat visuals without server dependency first.

Systems:

```text
chat input
message validation
speech bubble display
bubble timing
basic local command parser
```

### 11. Navigation/door flow

Purpose: move between rooms after one room is already correct.

Systems:

```text
door hotspots
entry door mapping
room transition state
loading state
map hooks
```

### 12. Account/session bridge

Purpose: connect the faithful client to user state after local behaviour works.

Systems:

```text
login session
active user state
weevil definition load/save
inventory/user data access
```

### 13. Realtime multiplayer bridge

Purpose: sync faithful local room behaviour over the server.

Systems:

```text
room join/leave
movement packets
chat packets
remote avatar state
presence list
moderation/admin command handling
```

### 14. Playercard/profile systems

Purpose: port social/profile UI after avatars and sessions are stable.

Systems:

```text
player card
bio
BFF/friends display
avatar preview
profile actions
```

### 15. Inventory/shop/item systems

Purpose: port item ownership and item UI after account/session state works.

Systems:

```text
inventory
shop catalogues
purchase flow
wear/equip/apply item flow
mulch balance hooks
```

### 16. Map, nest, mail, buddy, and secondary UI

Purpose: port secondary game shell systems once room flow works.

Systems:

```text
map
nest entry
mailbox
buddy list
news/prompts
settings
```

### 17. Minigames and external UIs

Purpose: port larger isolated systems last.

Systems:

```text
Konnect-Mulch
Flip-Mulch
pool/6 Ball
Squares
missions
external UI popups
```

## Anti-rush rule

A later system can be stubbed only if it is required to test an earlier system. Stubs must be clearly labelled and replaced later.

Example:

```text
Allowed: fake local session object for testing avatar rendering.
Not allowed: building the full login/account system before the avatar and room foundations are correct.
```

## Commit rule

Each commit should port one small piece or document one specific audit result. Avoid giant commits that mix renderer, room, backend, and UI work together.
