param(
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$legacyRoot = Join-Path $RepoRoot "legacy-reference\Binweevils-main\game-full\cdn.binw.net"
$roomRoot = Join-Path $RepoRoot "public\assets\rooms\inks-orange"
$floorOut = Join-Path $roomRoot "floors"
$swfOut = Join-Path $roomRoot "source-swfs"

if (!(Test-Path $legacyRoot)) {
    Write-Error "Legacy asset root not found: $legacyRoot"
}

New-Item -ItemType Directory -Force -Path $floorOut | Out-Null
New-Item -ItemType Directory -Force -Path $swfOut | Out-Null

$floorSource = Join-Path $legacyRoot "floors\inks.jpg"
$floorDest = Join-Path $floorOut "inks.jpg"

if (Test-Path $floorSource) {
    Copy-Item $floorSource $floorDest -Force
    Write-Host "Copied floor: $floorDest"
} else {
    Write-Warning "Missing floor source: $floorSource"
}

$swfs = @(
    "arrow.swf",
    "orangePeel.swf",
    "orangeSegment.swf",
    "orangeSegment_1.swf",
    "orangeSegment_2.swf",
    "orangeBlob.swf",
    "signMsgBoard.swf",
    "cottonReel.swf",
    "needle.swf",
    "connectMulch.swf",
    "flipMulch.swf",
    "poolTable.swf",
    "squares.swf"
)

foreach ($swf in $swfs) {
    $source = Join-Path $legacyRoot "assets3D\$swf"
    $dest = Join-Path $swfOut $swf

    if (Test-Path $source) {
        Copy-Item $source $dest -Force
        Write-Host "Copied SWF source: $swf"
    } else {
        Write-Warning "Missing SWF source: $source"
    }
}

Write-Host ""
Write-Host "Local Ink's Orange assets prepared."
Write-Host "Floor is used by the current demo."
Write-Host "SWFs are copied only as local source material for JPEXS export; the HTML5 room does not render them directly."
Write-Host "These copied assets are ignored by Git by default."
