# Source reference folder

This folder is for committed source/reference material used by the faithful Flash-to-HTML5 port.

The clean HTML5 port still lives in:

```text
src/
public/
docs/
```

This `source/` folder is not the new client code. It is evidence and raw material for porting.

## Suggested layout

```text
source/
  knowyourknot-binweevils/
    README.md
    game-full/
    server/
    bwps.sql

  prototype-html5-demo/
    README.md
    public/weevil-creator/src/runtime/
    public/weevil-creator/assets/atlases/
    public/weevil-creator/assets/raw/

  asset-packs/
    README.md
```

## Git LFS

Large/binary files under `source/` are tracked with Git LFS through the repo `.gitattributes` file.

Before adding large source assets locally, run:

```powershell
git lfs install
```

Then check what will be committed:

```powershell
git status
git lfs status
```

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
