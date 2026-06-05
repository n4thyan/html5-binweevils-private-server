# OG source setup

This repo is designed to work from original source material without mixing that material directly into the clean port code.

## Folder

Use this local folder for the original KnowYourKnot/Binweevils source:

```text
og-source/knowyourknot-binweevils/
```

`og-source/` is ignored by Git. It is source/reference material, not the HTML5 port itself.

## Clone source locally

From the repo root:

```powershell
git clone https://github.com/KnowYourKnot/Binweevils.git .\og-source\knowyourknot-binweevils
```

## Why ignored?

The port should not become a messy copy of the source repo. The clean port lives in `src/` and `public/`.

Use `og-source/` to inspect:

```text
ActionScript/source behaviour
SWF/original asset paths
PHP/backend flow
SQL/database assumptions
room config
UI assets
avatar/weevil definitions
```

Then port deliberately into clean HTML5 modules.

## Audit commands

Generate indexes that can be committed or pasted for review:

```powershell
mkdir docs -Force

Get-ChildItem .\og-source\knowyourknot-binweevils -Recurse -Directory |
  Select-Object FullName |
  Out-File .\docs\og-source-directory-index.txt

Get-ChildItem .\og-source\knowyourknot-binweevils -Recurse -File |
  Select-Object FullName, Length |
  Out-File .\docs\og-source-file-index.txt

Get-ChildItem .\og-source\knowyourknot-binweevils -Recurse -File -Include *.php,*.sql,*.js,*.as,*.xml,*.json,*.swf,*.png,*.jpg,*.jpeg,*.gif,*.css |
  Select-Object FullName, Length |
  Out-File .\docs\important-og-source-files.txt
```

## Do not

- Do not edit files inside `og-source/` as if they are the new project.
- Do not blindly copy whole folders into `src/`.
- Do not commit large asset dumps without a storage plan.
- Do not use source paths as final browser paths unless intentionally mapped.
