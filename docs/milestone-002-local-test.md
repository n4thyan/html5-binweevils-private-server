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

## Prepare local room assets

The repo does not commit the original game assets directly.

The current demo can run without extracted SWF objects because it draws labelled placeholders at the original XML coordinates. The only real asset it uses immediately is the floor image:

```text
public/assets/rooms/inks-orange/floors/inks.jpg
```

Use the helper script to copy the floor and the source SWFs locally:

```powershell
.\tools\prepare-inks-orange-assets.ps1
```

This copies:

```text
floors/inks.jpg -> public/assets/rooms/inks-orange/floors/inks.jpg
assets3D/*.swf -> public/assets/rooms/inks-orange/source-swfs/
```

The copied SWFs are only local source material for JPEXS/FFDec export. The HTML5 room does not render those SWFs directly.

These copied/exported assets are ignored by Git by default.

Manual floor-only copy if needed:

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
