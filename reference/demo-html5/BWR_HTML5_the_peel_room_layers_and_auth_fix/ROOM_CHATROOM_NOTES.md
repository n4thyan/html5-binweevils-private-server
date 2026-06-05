# Single Room Chatroom Notes

This pass keeps the one-room chat simple and tightens a few of the rough edges from the first integration.

## Added / fixed
- movement now updates locally first so your own weevil responds faster instead of feeling laggy
- move requests are now queued so rapid clicks or held arrow keys do not spam overlapping movement posts
- player speech bubbles and nameplates no longer flip or mirror when a weevil faces left
- avatar flip is now applied only to the sprite, while the room text UI stays readable
- shadow scaling is a bit cleaner so depth reads better as weevils move up and down the room
- longer chat bubbles wrap more safely instead of being forced into a single line
- added a clean unload close for the room stream connection

## Reused
- existing mirror-site authentication/session flow
- saved avatar data from `/api/me/avatar`
- existing HTML5 weevil SVG renderer from `public/js/avatar-studio`

## Technical notes
- single shared room only
- in-memory presence/feed state only
- no persistence for room position/chat history across restarts
- no room switching or inventory
- room rendering remains intentionally simple and 2D


Flow polish pass:
- registration now drops new users into Weevil Studio first
- studio can save and continue straight into /room
- /room now redirects unsaved users back through the studio
- auth pages preserve a safe next path for studio/room redirects
- profile now shows the simple studio -> room flow more clearly


## Fake 3D turn pass
- room avatars now use the improved SVG turn rig instead of a simple horizontal flip
- movement updates drive a shared previewTurn value so head, body, eyes, lids, proboscis, antennae, and limbs yaw together
- idle pose holds a slight three-quarter facing angle, while stronger horizontal travel pushes further into the fake-3D turn
- room shadow and bobbing were tightened so movement feels less flat

## Find4 / Connect 4 pass

This pass adds a simple in-room Find4 flow tied into the room SSE pipeline:
- challenge another online player from the Online now list
- accept or decline challenges in the room overlay
- play a server-authoritative 7x6 Find4 match in a simple room popup
- win/draw detection, forfeit, and room feed notices

Current scope intentionally stays simple:
- no spectator mode yet
- one active or pending challenge per user at a time
- in-memory match state only


## Map button + room collision pass
- Added a stage-level Map button with a room switcher for the original floor and the new Orange Hideout room.
- Added server-side and client-side collision clamping for the Orange Hideout bushes and orange shelter pieces so players cannot walk through the visible objects.
- Room switching is blocked while a Find4 match or pending Find4 challenge is active, so room state stays simple and stable.

Latest pass:
- Added Statue Square as a third room in the map drawer.
- Map chooser is now a compact collapsible button so it stays out of the way until opened.
- Added collision for the visible rocks and statue base in Statue Square.


## Find4 improvements
- Added outgoing challenge cancel flow.
- Added rematch requests after a finished game.
- Improved the Find4 overlay with clearer player cards, last-move highlighting, hover previews, and keyboard 1-7 column drops.
