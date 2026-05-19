# Next local weevil renderer test

This is the next safe test after the Orange Peel floor demo works.

## 1. Pull latest branch changes

```powershell
cd C:\Users\pc\Desktop\html5-binweevils-private-server
git pull
```

## 2. Import the old working renderer locally

The old project was extracted to:

```text
legacy-reference/BWR_HTML5_full_project_map_ui/project
```

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\import-prototype-weevil-renderer.ps1 -PrototypeRoot "C:\Users\pc\Desktop\html5-binweevils-private-server\legacy-reference\BWR_HTML5_full_project_map_ui\project"
```

This copies the old working runtime into:

```text
public/weevil-creator/
public/src/client/room/room-weevil-renderer.js
```

These copied files are ignored by Git for now.

## 3. Confirm files exist

```powershell
Test-Path .\public\weevil-creator\src\runtime\WeevilCanvasRenderer.js
Test-Path .\public\src\client\room\room-weevil-renderer.js
```

Expected:

```text
True
True
```

## 4. Sync to XAMPP

```powershell
robocopy C:\Users\pc\Desktop\html5-binweevils-private-server\public C:\xampp\htdocs\html5-binweevils-private-server /MIR
```

## 5. Test

Open:

```text
http://localhost/html5-binweevils-private-server/
```

For debug:

```text
http://localhost/html5-binweevils-private-server/?debug=1
```

## Note

The current branch has the import helper and documentation. The next code pass wires `main.js` to automatically use `room-weevil-renderer.js` when present, while keeping the placeholder fallback.
