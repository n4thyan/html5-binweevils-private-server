# UI layout reference notes

Date: 2026-06-05

A Bin Weevils Rewritten screenshot was used as a rough visual reference for the kind of later-era Bin Weevils UI composition the HTML5 port should eventually resemble.

This is a layout/style reference only. It is not the source of truth for assets or behaviour. Final implementation must still be backed by original/decompiled source assets and ActionScript structure.

## Visible layout pattern

The reference shows a later-style game view with:

```text
central room viewport framed by green slime/vine border
top horizontal navigation bar
logo area at top-left
user/settings/sign-out area at top-right
left vertical player status and navigation stack
right floating camera/control panel
bottom chat/action/status bar
bottom secret-code button
footer text links below the game view
```

## Important UI zones

### Main viewport

```text
large central room window
rounded green slime/vine border
room background inside the frame
foreground UI sits outside/over the room frame
```

### Top navigation

```text
download button
discord/community button
what's new button
help button
user name area
settings/sign out links
```

For this port, top navigation should be mapped against source/decompiled UI assets where possible, not copied blindly from this reference.

### Left-side player/status column

Visible components:

```text
level badge
mulch/coin-style counter
dosh/medal-style counter
hunger/energy bar
shop button
map button
pet/nest-style button
```

These should be mapped against `UImain.as`, core symbols, and later source assets before implementation.

### Bottom action/chat bar

Visible components:

```text
actions button
mouth/emote button
long chat/input field
chat bubble/message icons
notepad/list icon
exclamation/alert icon
smiley/emote icon
shield/badge icon
home/nest icon
clipboard/task icon
TV button
```

This aligns with the source-backed probe work around:

```text
actionsBtn
actionIcons
mouthIcons
controlTab
chat_spr
newsAndMessages
binBadges
```

### Right camera/control panel

Visible components:

```text
floating orange camera/control panel
camera/video-style tabs
arrow controls
camera lens controls
```

This should be mapped against:

```text
core5.swf/scripts/com/binweevils/CamUI.as
controls_mc.camUILoader_spr
controls_mc.camUI_spr
```

## Caution notes

```text
Do not use this screenshot as final asset source.
Do not use Bin Weevils Rewritten-specific assets blindly.
Use it only as a rough composition reference.
The final shell should be built from mainDEV661.swf/core5.swf decompiled assets and original source structure.
```

## Next implementation implication

The UI shell target should eventually have this broad composition:

```text
stage background
central room viewport
source-backed slime/vine frame if found in main/core/source assets
source-backed top navigation/control region
source-backed left status/menu column
source-backed bottom chat/action bar
source-backed right CamUI panel
```

The next source-backed task remains:

```text
map the exact source symbols/classes for the central viewport frame, controlTab, chat area, left status column, and CamUI panel before building the final UI layout
```
