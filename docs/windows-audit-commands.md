# Windows audit commands

Run these from the clean repo root in Windows PowerShell:

```powershell
cd C:\Users\pc\Desktop\html5-binweevils-private-server
```

Confirm the local legacy reference exists:

```powershell
Get-ChildItem .\legacy-reference
Get-ChildItem .\legacy-reference\Binweevils-main
```

Create the docs folder if needed:

```powershell
mkdir docs -Force
```

Generate a directory index:

```powershell
Get-ChildItem .\legacy-reference\Binweevils-main -Recurse -Directory |
  Select-Object FullName |
  Out-File .\docs\source-directory-index.txt
```

Generate a file index:

```powershell
Get-ChildItem .\legacy-reference\Binweevils-main -Recurse -File |
  Select-Object FullName |
  Out-File .\docs\source-file-index.txt
```

Generate an important source file list:

```powershell
Get-ChildItem .\legacy-reference\Binweevils-main -Recurse -File -Include *.php,*.sql,*.js,*.as,*.xml,*.json,*.swf,*.png,*.jpg,*.jpeg,*.gif,*.css |
  Select-Object FullName |
  Out-File .\docs\important-source-files.txt
```

Generate candidate room/UI/weevil/backend files:

```powershell
Get-ChildItem .\legacy-reference\Binweevils-main -Recurse -File |
  Where-Object {
    $_.Name -match "peel|orange|ink|park|nest|room|weevil|avatar|chat|bubble|map|splat|playercard|buddy|mail|shop|login|register|session|socket|server|mulch|xp|level|redeem|admin"
  } |
  Select-Object FullName |
  Out-File .\docs\asset-candidate-files.txt
```

Optional: print the first 100 candidate results in the terminal:

```powershell
Get-Content .\docs\asset-candidate-files.txt -TotalCount 100
```

Check Git state:

```powershell
git status
```

Important: these generated `.txt` indexes may contain local Windows paths. Review before committing if you do not want local path details in GitHub.
