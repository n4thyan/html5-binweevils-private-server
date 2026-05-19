param(
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$legacyRoot = Join-Path $RepoRoot "legacy-reference\Binweevils-main"
$outDir = Join-Path $RepoRoot "docs"
$outFile = Join-Path $outDir "source-camera-projection-candidates.txt"

if (!(Test-Path $legacyRoot)) {
    Write-Error "Legacy reference not found: $legacyRoot"
}

New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$patterns = @(
    "camPos",
    "camAim",
    "camBounds",
    "fixedCam",
    "preRend3D",
    "PerspectiveProjection",
    "Matrix3D",
    "Vector3D",
    "local3DToGlobal",
    "globalToLocal3D",
    "projectVector",
    "projection",
    "camera",
    "focalLength",
    "screenCenter",
    "vanishing",
    "rxMin",
    "rxMax",
    "ryMin",
    "ryMax",
    "framesY",
    "symAxes",
    "rIncr"
)

$regex = ($patterns | ForEach-Object { [regex]::Escape($_) }) -join "|"

$files = Get-ChildItem $legacyRoot -Recurse -File -Include *.as,*.js,*.xml,*.php,*.json |
    Where-Object { $_.FullName -notmatch "\\node_modules\\" }

$matches = foreach ($file in $files) {
    $hits = Select-String -Path $file.FullName -Pattern $regex -CaseSensitive:$false -ErrorAction SilentlyContinue
    if ($hits) {
        [PSCustomObject]@{
            FullName = $file.FullName
            Extension = $file.Extension
            MatchCount = @($hits).Count
            FirstMatches = (@($hits) | Select-Object -First 8 | ForEach-Object { "L$($_.LineNumber): $($_.Line.Trim())" }) -join " || "
        }
    }
}

$ranked = $matches | Sort-Object 
    @{Expression = { if ($_.Extension -eq ".as") { 0 } elseif ($_.Extension -eq ".js") { 1 } elseif ($_.Extension -eq ".xml") { 2 } else { 3 } }; Ascending = $true},
    @{Expression = "MatchCount"; Descending = $true},
    @{Expression = "FullName"; Ascending = $true}

$ranked | Format-Table -AutoSize | Out-String -Width 4096 | Set-Content $outFile

Write-Host "Source camera/projection candidate audit written to:"
Write-Host $outFile
Write-Host ""
Write-Host "Top 40 candidates:"
$ranked | Select-Object -First 40 | Format-Table -AutoSize
