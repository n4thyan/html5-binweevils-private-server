$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$main = Join-Path $root 'public\src\client\room\main.js'
$room = Join-Path $root 'public\assets\rooms\nest-hall\room.json'

$text = Get-Content $main -Raw

if ($text -notmatch 'renderYawInverted') {
  $text = $text.Replace(
"  renderYawOffset: finiteNumber(urlParams.get('yaw'), null),",
"  renderYawOffset: finiteNumber(urlParams.get('yaw'), null),`n  renderYawInverted: urlParams.has('mirror') ? urlParams.get('mirror') !== '0' : null,"
  )

  $text = $text.Replace(
"function getRenderScale() {`n  return Number(state.room?.entry?.renderScale ?? 0.52);`n}`n",
"function getRenderScale() {`n  return Number(state.room?.entry?.renderScale ?? 0.52);`n}`n`nfunction getRenderYawInverted() {`n  const configured = state.renderYawInverted ?? state.room?.entry?.renderYawInverted ?? false;`n  return configured === true || configured === 'true';`n}`n`nfunction getRenderYaw() {`n  const offset = getRenderYawOffset();`n  return normaliseAngle(getRenderYawInverted() ? offset - state.player.dir : state.player.dir + offset);`n}`n"
  )

  $text = $text.Replace(
"    `yaw offset: ${getRenderYawOffset().toFixed(0)}  (/yaw 180)`,",
"    `yaw offset: ${getRenderYawOffset().toFixed(0)}  (/yaw 180)`, `n    `yaw mirror: ${getRenderYawInverted() ? 'on' : 'off'}  (/mirror)`,"
  )

  $text = $text.Replace(
"  const yaw = normaliseAngle(state.player.dir + getRenderYawOffset());",
"  const yaw = getRenderYaw();"
  )

  $mirrorCase = @'
    case 'mirror':
      state.renderYawInverted = !getRenderYawInverted();
      resetRendererCache();
      addNotice(`yaw mirror ${state.renderYawInverted ? 'on' : 'off'}`);
      break;
'@

  $text = $text.Replace("    case 'scale': {", $mirrorCase + "    case 'scale': {")
  $text = $text.Replace(
"    addNotice('Type /speed 80, /yaw 180, /scale 0.50 for avatar tuning');",
"    addNotice('Type /speed 80, /yaw 180, /mirror, /scale 0.50 for avatar tuning');"
  )

  Set-Content -Path $main -Value $text -Encoding UTF8
  Write-Host 'Patched main.js with mirrored yaw support.'
} else {
  Write-Host 'main.js already has mirrored yaw support.'
}

$json = Get-Content $room -Raw
if ($json -notmatch 'renderYawInverted') {
  $json = $json.Replace('"renderYawOffset": 180,', '"renderYawOffset": 180,`n    "renderYawInverted": true,')
  Set-Content -Path $room -Value $json -Encoding UTF8
  Write-Host 'Patched Nest Hall room.json to default mirrored yaw on.'
} else {
  Write-Host 'Nest Hall room.json already has renderYawInverted.'
}

Write-Host 'Done. Re-copy public to XAMPP and hard refresh.'
