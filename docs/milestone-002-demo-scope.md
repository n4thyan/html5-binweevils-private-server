# Milestone 002 demo scope

Milestone 002 is a playable Orange Peel room demo. It is allowed to be a glorified chatroom while the deeper game systems are still being ported.

The purpose is to prove the faithful HTML5 room foundation:

- source-derived room config
- original floor/background asset
- original coordinate space
- visible player/weevil in the room
- click-to-move
- chat bubble
- basic chat
- hidden/admin command parsing
- placeholders or first-pass exports for original room objects

## Demo target

The player should be able to open the room in a browser and feel like they are standing in the original Ink's Orange / Orange Peel space, even if most interactions are not functional yet.

Minimum acceptable demo:

```text
Apache/XAMPP serves the client
Orange Peel room loads
floor image comes from the original source
room.json is derived from the original locationDefinitions.xml block
player spawns at entryPos
click-to-move is bounded by the original room boundary
radial no-go area is respected
chat input shows an original-style bubble above the weevil
admin/debug commands can be typed but stay visually hidden from normal UI
object placeholders appear at original XML coordinates
```

Better demo if time allows:

```text
first JPEXS-exported Orange Peel assets replace placeholders
orangePeel/orangeSegment/signMsgBoard appear visually in the room
simple local multi-tab chat works
basic room user list exists internally but is not shown as modern nameplates
```

## Explicitly out of scope for milestone 002

Do not block the first demo on these:

```text
full account system
full MySQL-backed registration/login
full multiplayer server
full map navigation
functional doors
mini-games
shops
inventory
buddy list
mailbox
playercard/splat
XP/mulch/level bank/prestige UI
perfect animated preRend3D frame selection
full SWF parity for every object
```

These systems matter, but the first successful milestone is a faithful room/chat foundation.

## Implementation rule

Build this as a small slice that can be reviewed and improved. Do not use milestone 002 as an excuse to dump the old prototype into the clean repo wholesale.

Useful code can be borrowed from the uploaded HTML5 prototype, especially:

```text
room shell ideas
click-to-move logic
chat bubble experiments
weevil renderer work
admin command parser ideas
```

But copied code should be cleaned up and connected to source-derived Orange Peel data rather than prototype-only assumptions.
