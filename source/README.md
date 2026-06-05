# Source reference folder

This folder is for committed source/reference material used by the faithful Flash-to-HTML5 port.

The clean HTML5 port still lives in:

```text
src/
public/
docs/
```

This `source/` folder is not the new client code. It is evidence and raw material for porting.

## Primary source folder

The full KnowYourKnot/Binweevils repository should be committed here:

```text
source/knowyourknot-binweevils/
```

Expected layout after import:

```text
source/
  knowyourknot-binweevils/
    README.md
    game-full/
    server/
    electron/
    bwps.sql
```

This lets the porting work happen from GitHub without relying on uncommitted local files.

## Optional source folders

```text
source/
  prototype-html5-demo/
    README.md
    public/weevil-creator/src/runtime/
    public/weevil-creator/assets/atlases/
    public/weevil-creator/assets/raw/

  asset-packs/
    README.md
```

The prototype folder is only for the bad HTML5 demo/reference renderer. It is not authoritative.

## Git LFS

Large/binary files under `source/` are tracked with Git LFS through the repo `.gitattributes` file.

Before adding source assets locally, run:

```powershell
git lfs install
```

Then check what will be committed:

```powershell
git status
git lfs status
```

## Import command idea

From the repo root on Windows:

```powershell
mkdir source -Force
git clone https://github.com/KnowYourKnot/Binweevils.git .\source\knowyourknot-binweevils
Remove-Item .\source\knowyourknot-binweevils\.git -Recurse -Force
```

Then commit it into this private repo:

```powershell
git add .gitattributes source/knowyourknot-binweevils
git status
git lfs status
git commit -m "Add KnowYourKnot source reference"
git push
```

Removing the nested `.git` folder is important. Otherwise it becomes a nested Git repository instead of normal source files inside this repo.

## Do not

- Do not edit files in `source/` as if they are the clean HTML5 port.
- Do not copy a whole source system into `src/` without documenting the port.
- Do not add secrets, `.env` files, database passwords, live user data, or VPS backups.
- Do not add massive unrelated asset dumps without a manifest.

## Porting rule

For every system:

```text
source evidence in source/
   -> documented in docs/
      -> clean implementation in src/
```

The source material is evidence. The port is the clean implementation.
