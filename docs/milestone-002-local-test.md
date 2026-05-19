# Milestone 002 local test

This branch contains the first source-derived Ink's Orange / Orange Peel HTML5 room shell.

## Pull the branch

From Windows PowerShell:

```powershell
cd C:\Users\pc\Desktop\html5-binweevils-private-server
git fetch
git checkout milestone-002-inks-orange-room-shell
git pull
```

## Copy the original floor asset

The room shell expects this file:

```text
public/assets/rooms/inks-orange/floors/inks.jpg
```

Copy it from the local legacy reference:

```powershell
Copy-Item .\legacy-reference\Binweevils-main\game-full\cdn.binw.net\floors\inks.jpg .\public\assets\rooms\inks-orange\floors\inks.jpg -Force
```

The demo still runs without this file, but it will show a placeholder background.

## Serve with XAMPP/Apache

Option A: copy/sync the repo into your XAMPP `htdocs` folder.

Example:

```powershell
robocopy C:\Users\pc\Desktop\html5-binweevils-private-server\public C:\xampp\htdocs\html5-binweevils-private-server /MIR
```

Then open:

```text
http://localhost/html5-binweevils-private-server/
```

Option B: point an Apache vhost at the repo `public/` folder.

## What should work

- Orange Peel room data loads from `room.json`.
- The original `inks.jpg` floor appears if copied into place.
- The weevil spawns at the original `entryPos`.
- Click-to-move works inside the original rectangular boundary.
- The radial no-go area blocks movement.
- Chat input shows a bubble above the weevil.
- Debug commands work:

```text
/pos
/goto -93 320
/say hello
/debug
```

## Current limitations

- Room objects are labelled placeholders at original XML coordinates.
- SWF-derived PNG/SVG exports are not wired yet.
- No multiplayer server yet.
- No login/register/database yet.
- Door transitions and mini-games are visible data only, not functional.
