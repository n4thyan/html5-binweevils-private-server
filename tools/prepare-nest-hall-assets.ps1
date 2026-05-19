param(
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$legacyRoot = Join-Path $RepoRoot "legacy-reference\Binweevils-main\game-full\cdn.binw.net"
$roomRoot = Join-Path $RepoRoot "public\assets\rooms\nest-hall"
$sourceOut = Join-Path $roomRoot "source"
$backgroundOut = Join-Path $roomRoot "background"

if (!(Test-Path $legacyRoot)) {
    Write-Error "Legacy asset root not found: $legacyRoot"
}

New-Item -ItemType Directory -Force -Path $sourceOut | Out-Null
New-Item -ItemType Directory -Force -Path $backgroundOut | Out-Null

$swfSource = Join-Path $legacyRoot "assetsNest\nestHall_06_05_21.swf"
$swfDest = Join-Path $sourceOut "nestHall_06_05_21.swf"

if (Test-Path $swfSource) {
    Copy-Item $swfSource $swfDest -Force
    Write-Host "Copied Nest Hall SWF source: $swfDest"
} else {
    Write-Warning "Missing Nest Hall SWF source: $swfSource"
}

# This script does not decompile SWF files by itself.
# It accepts either a hand-named export in the room source folder or a normal JPEXS export folder.
# For JPEXS, exported/frames/1.png is the full composed Nest Hall frame/stage.
$candidateExports = @(
    (Join-Path $sourceOut "nest-hall.png"),
    (Join-Path $sourceOut "nestHall_06_05_21.png"),
    (Join-Path $sourceOut "nest-hall.jpg"),
    (Join-Path $sourceOut "nestHall_06_05_21.jpg"),
    (Join-Path $sourceOut "nest-hall.jpeg"),
    (Join-Path $sourceOut "nestHall_06_05_21.jpeg"),
    (Join-Path $sourceOut "nest-hall.svg"),
    (Join-Path $sourceOut "nestHall_06_05_21.svg"),
    (Join-Path $RepoRoot "exported\frames\1.png"),
    (Join-Path $RepoRoot "exported\images\1.jpg"),
    (Join-Path $sourceOut "exported\frames\1.png"),
    (Join-Path $sourceOut "exported\images\1.jpg")
)

$copiedExport = $false
foreach ($candidate in $candidateExports) {
    if (Test-Path $candidate) {
        $extension = [System.IO.Path]::GetExtension($candidate).ToLowerInvariant()
        $destName = if ($extension -eq ".svg") { "nest-hall.svg" } elseif ($extension -eq ".jpg" -or $extension -eq ".jpeg") { "nest-hall.jpg" } else { "nest-hall.png" }
        $dest = Join-Path $backgroundOut $destName
        Copy-Item $candidate $dest -Force
        Write-Host "Copied exported background: $dest"
        Write-Host "Source export used: $candidate"
        $copiedExport = $true
        break
    }
}

Write-Host ""
Write-Host "Local Nest Hall assets prepared."
Write-Host "The SWF source is copied for JPEXS export and is ignored by Git by default."

if (!$copiedExport) {
    Write-Host "No exported Nest Hall background image was found yet."
    Write-Host "Next manual export step:"
    Write-Host "  1. Open public/assets/rooms/nest-hall/source/nestHall_06_05_21.swf in JPEXS."
    Write-Host "  2. Export the full background/stage as PNG."
    Write-Host "  3. Save it as either exported/frames/1.png at repo root, or public/assets/rooms/nest-hall/source/nest-hall.png."
    Write-Host "  4. Re-run this script."
    Write-Host "Until then, the HTML5 demo uses a source-coordinate placeholder background."
}
