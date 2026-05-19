param(
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$PrototypeRoot = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($PrototypeRoot)) {
    $candidates = @(
        (Join-Path $RepoRoot "legacy-reference\BWR_HTML5_full_project_map_ui\project"),
        (Join-Path $RepoRoot "legacy-reference\BWR_HTML5_full_project_map_ui(1)\project"),
        (Join-Path $RepoRoot "..\BWR_HTML5_full_project_map_ui\project"),
        (Join-Path $RepoRoot "..\BWR_HTML5_full_project_map_ui(1)\project")
    )

    foreach ($candidate in $candidates) {
        if (Test-Path (Join-Path $candidate "public\weevil-creator\src\runtime\WeevilCanvasRenderer.js")) {
            $PrototypeRoot = (Resolve-Path $candidate).Path
            break
        }
    }
}

if ([string]::IsNullOrWhiteSpace($PrototypeRoot)) {
    Write-Host "Could not auto-find the previous HTML5 prototype project."
    Write-Host "Run again with:"
    Write-Host "  .\tools\import-prototype-weevil-renderer.ps1 -PrototypeRoot C:\path\to\old\project"
    exit 1
}

$PrototypeRoot = (Resolve-Path $PrototypeRoot).Path
$creatorSource = Join-Path $PrototypeRoot "public\weevil-creator"
$roomRendererSource = Join-Path $PrototypeRoot "public\js\weevil-room-renderer.js"

if (!(Test-Path $creatorSource)) {
    Write-Error "Missing prototype weevil creator folder: $creatorSource"
}

if (!(Test-Path $roomRendererSource)) {
    Write-Error "Missing prototype room renderer: $roomRendererSource"
}

$creatorDest = Join-Path $RepoRoot "public\weevil-creator"
$roomRendererDest = Join-Path $RepoRoot "public\src\client\room\room-weevil-renderer.js"

New-Item -ItemType Directory -Force -Path (Split-Path $roomRendererDest -Parent) | Out-Null

Write-Host "Copying weevil creator runtime/assets..."
robocopy $creatorSource $creatorDest /MIR /XD .git node_modules | Out-Host

Write-Host "Copying room renderer bridge..."
Copy-Item $roomRendererSource $roomRendererDest -Force

# The prototype was served from the domain root. The clean repo is often served from a subfolder in XAMPP,
# so patch absolute imports to relative imports for this demo branch.
$content = Get-Content $roomRendererDest -Raw
$content = $content.Replace("from '/weevil-creator/src/runtime/canvasAtlasLoader.js'", "from '../../../weevil-creator/src/runtime/canvasAtlasLoader.js'")
$content = $content.Replace("from '/weevil-creator/src/runtime/WeevilDef.js'", "from '../../../weevil-creator/src/runtime/WeevilDef.js'")
$content = $content.Replace("from '/weevil-creator/src/runtime/WeevilCanvasRenderer.js'", "from '../../../weevil-creator/src/runtime/WeevilCanvasRenderer.js'")
$content = $content.Replace("new URL('/weevil-creator/', window.location.origin).href.replace(/\/$/, '')", "new URL('../../../weevil-creator/', import.meta.url).href.replace(/\/$/, '')")
Set-Content $roomRendererDest $content

Write-Host ""
Write-Host "Imported prototype weevil renderer locally."
Write-Host "Destination folder: $creatorDest"
Write-Host "Bridge file: $roomRendererDest"
Write-Host ""
Write-Host "These files are ignored by Git by default. They are used for local testing before we decide what to commit permanently."
