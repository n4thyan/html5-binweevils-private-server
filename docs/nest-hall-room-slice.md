# Milestone 003: Nest Hall fixed-camera room slice

Nest Hall is now the preferred first playable room for the HTML5 port.

Orange Peel / Ink's Orange is still valuable, but it is a rotatable pre-rendered 3D camera room. That makes it a bad first target for proving the core HTML5 room loop because object placement looks wrong until the camera rotation system is reconstructed.

Nest Hall is a better first slice because its source room data is fixed-camera style and appears directly in `nestLocDefs.xml`.

## Source of truth

Original source path:

```text
legacy-reference/Binweevils-main/game-full/binConfig/getFile/1/uk/nestLocDefs.xml
```

Source location:

```xml
<location id="5" name="nest" type="3" cat="0" boundType="rad" boundary="0,185,168" keepFree="1,6,5,10" camPos="0,145,-115" camAim="0,15,500" entryPos="0,200" weevilScale="0.45" noZoom="yes" upSideDown="no">
```

Source room background:

```xml
<roomBG path="assetsNest/nestHall_06_05_21.swf"/>
```

Ported HTML5 room definition:

```text
public/assets/rooms/nest-hall/room.json
```

## What this slice includes

- Nest Hall is now the default room via `public/assets/rooms/room-registry.json`.
- `?room=inks-orange` still loads the earlier Orange Peel shell for comparison.
- The room definition includes source-derived:
  - `camPos`
  - `camAim`
  - radial boundary
  - entry position
  - weevil scale
  - doors
  - interactives
  - named objects
- The renderer uses `source-camera` projection by default for Nest Hall.
- `/projection` toggles between flat and source-camera projection for debugging.
- `/debug` shows boundary, doors, and object placeholders.
- Click-to-move uses radial boundary clamping for Nest Hall.
- The existing imported prototype weevil renderer and source-style walking behaviour are reused.

## Asset prep

Run from the clean repo root:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\prepare-nest-hall-assets.ps1
```

That copies the original SWF source locally into:

```text
public/assets/rooms/nest-hall/source/nestHall_06_05_21.swf
```

The browser does not render that SWF directly. Export the room background from JPEXS as a PNG or SVG, then save it as:

```text
public/assets/rooms/nest-hall/source/nest-hall.png
```

Re-run the prep script. It will copy the exported background into:

```text
public/assets/rooms/nest-hall/background/nest-hall.png
```

Until the export exists, the demo uses a placeholder background but still uses the source room coordinates.

## Test URL

With XAMPP Apache serving the repo's `public/` folder:

```text
http://localhost/html5-binweevils-private-server/public/
```

Useful variants:

```text
http://localhost/html5-binweevils-private-server/public/?debug=1
http://localhost/html5-binweevils-private-server/public/?projection=flat&debug=1
http://localhost/html5-binweevils-private-server/public/?room=inks-orange&debug=1
```

## Current caveat

Camera projection is now source-aware, but exact pixel-perfect alignment depends on the exported SWF stage dimensions and any hidden Flash stage offset. Once the real Nest Hall background is exported, only small calibration should be needed.
