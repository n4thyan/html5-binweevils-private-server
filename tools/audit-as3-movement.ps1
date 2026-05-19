param(
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$legacyRoot = Join-Path $RepoRoot "legacy-reference\Binweevils-main"
$outDir = Join-Path $RepoRoot "docs"
$outFile = Join-Path $outDir "as3-movement-candidates.txt"

if (!(Test-Path $legacyRoot)) {
    Write-Error "Legacy reference not found: $legacyRoot"
}

New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$patterns = @(
    "walk",
    "walking",
    "move",
    "movement",
    "speed",
    "target",
    "click",
    "path",
    "direction",
    "rotation",
    "yaw",
    "heading",
    "angle",
    "idle",
    "jump",
    "avatar",
    "weevil",
    "creature",
    "player"
)

$regex = ($patterns | ForEach-Object { [regex]::Escape($_) }) -join "|"

$matches = Get-ChildItem $legacyRoot -Recurse -File -Include *.as,*.xml,*.js,*.php |
    Where-Object { $_.FullName -notmatch "\\node_modules\\" } |
    ForEach-Object {
        $file = $_
        $hits = Select-String -Path $file.FullName -Pattern $regex -CaseSensitive:$false -ErrorAction SilentlyContinue
        if ($hits) {
            [PSCustomObject]@{
                FullName = $file.FullName
                MatchCount = @($hits).Count
                FirstMatches = (@($hits) | Select-Object -First 5 | ForEach-Object { "L$($_.LineNumber): $($_.Line.Trim())" }) -join " || "
            }
        }
    } |
    Sort-Object MatchCount -Descending, FullName

$matches | Format-Table -AutoSize | Out-String -Width 4096 | Set-Content $outFile

Write-Host "AS3/source movement candidate audit written to:"
Write-Host $outFile
Write-Host ""
Write-Host "Top 30 candidates:"
$matches | Select-Object -First 30 | Format-Table -AutoSize
