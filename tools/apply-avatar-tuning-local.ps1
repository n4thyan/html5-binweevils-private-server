$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$main = Join-Path $root 'public\src\client\room\main.js'
$text = Get-Content $main -Raw

$text = $text.Replace("const ctx = canvas.getContext('2d');", "const ctx = canvas.getContext('2d', { willReadFrequently: true });")
$text = $text.Replace("  floorReady: false,`n  player: {", "  floorReady: false,`n  renderYawOffset: Number.isFinite(Number(urlParams.get('yaw'))) ? Number(urlParams.get('yaw')) : null,`n  player: {")
$text = $text.Replace("    speed: 135,", "    speed: Number.isFinite(Number(urlParams.get('speed'))) ? Number(urlParams.get('speed')) : 88,")
$text = $text.Replace("function normaliseAngle(value) {`n  return ((value % 360) + 360) % 360;`n}`n", "function normaliseAngle(value) {`n  return ((value % 360) + 360) % 360;`n}`n`nfunction getIdleDirection() {`n  return Number(state.room?.entry?.idleDirection ?? state.room?.entry?.direction ?? -180);`n}`n`nfunction getRenderYawOffset() {`n  return Number(state.renderYawOffset ?? state.room?.entry?.renderYawOffset ?? 180);`n}`n`nfunction getRenderScale() {`n  return Number(state.room?.entry?.renderScale ?? 0.52);`n}`n`nfunction resetRendererCache() {`n  state.weevilRenderer.lastKey = '';`n}`n")
$text = $text.Replace("    `weevil renderer: ${state.weevilRenderer.status}  (/weevil to toggle)`,", "    `weevil renderer: ${state.weevilRenderer.status}  (/weevil to toggle)`,`n    `speed: ${p.speed.toFixed(0)}  (/speed 80 etc)`,`n    `yaw offset: ${getRenderYawOffset().toFixed(0)}  (/yaw 180 etc)`,`n    `render scale: ${getRenderScale().toFixed(2)}  (/scale 0.50 etc)`,")
$text = $text.Replace("    targetRotY: state.player.dir,`n    speed: state.player.speed / 60,", "    targetRotY: getIdleDirection(),`n    speed: state.player.speed / 60,")
$text = $text.Replace("  state.player.dir = state.room.entry.direction;", "  state.player.speed = Number(urlParams.get('speed')) || Number(state.room.entry?.walkSpeed ?? state.player.speed);`n  state.player.dir = getIdleDirection();")
$text = $text.Replace("    rotY: state.room.entry.direction,", "    rotY: getIdleDirection(),")
$text = $text.Replace("    targetRotY: state.room.entry.direction,", "    targetRotY: getIdleDirection(),")
$text = $text.Replace("  const yaw = normaliseAngle(state.player.dir + 302);", "  const yaw = normaliseAngle(state.player.dir + getRenderYawOffset());")
$text = $text.Replace("    pitch: 18,", "    pitch: Number(state.room?.entry?.renderPitch ?? 18),")
$text = $text.Replace("  const scale = 0.7 * projectionScale * (state.room.entry.renderScale ?? 1);", "  const scale = 0.7 * projectionScale * getRenderScale();")

$insert = @'
    case 'speed': {
      const speed = Number(args[0]);
      if (!Number.isFinite(speed)) addNotice(`speed is ${state.player.speed.toFixed(0)}`);
      else {
        state.player.speed = Math.max(30, Math.min(180, speed));
        addNotice(`speed set to ${state.player.speed.toFixed(0)}`);
      }
      break;
    }
    case 'yaw': {
      const yaw = Number(args[0]);
      if (!Number.isFinite(yaw)) addNotice(`yaw offset is ${getRenderYawOffset().toFixed(0)}`);
      else {
        state.renderYawOffset = normaliseAngle(yaw);
        resetRendererCache();
        addNotice(`yaw offset set to ${state.renderYawOffset.toFixed(0)}`);
      }
      break;
    }
    case 'scale': {
      const scale = Number(args[0]);
      if (!Number.isFinite(scale)) addNotice(`scale is ${getRenderScale().toFixed(2)}`);
      else {
        state.room.entry.renderScale = Math.max(0.25, Math.min(1.2, scale));
        addNotice(`scale set to ${state.room.entry.renderScale.toFixed(2)}`);
      }
      break;
    }
    case 'front':
      state.player.walk.reset();
      syncPlayerFromWalk(state.player.walk.init({
        x: state.player.x,
        z: state.player.z,
        rotY: getIdleDirection(),
        targetX: state.player.x,
        targetZ: state.player.z,
        targetRotY: getIdleDirection(),
        speed: state.player.speed / 60,
        reverse: false
      }));
      resetRendererCache();
      addNotice(`facing idle direction ${getIdleDirection().toFixed(0)}`);
      break;
'@
$text = $text.Replace("    case 'room':`n", $insert + "    case 'room':`n")
$text = $text.Replace("    addNotice('Type /projection to compare fixed-floor, source-camera, and flat projection');", "    addNotice('Type /speed 80, /yaw 180, /scale 0.50 for avatar tuning');`n    addNotice('Type /projection to compare fixed-floor, source-camera, and flat projection');")

Set-Content -Path $main -Value $text -Encoding UTF8
Write-Host 'Avatar tuning patch applied to public/src/client/room/main.js'
Write-Host 'Commands added: /speed, /yaw, /scale, /front'
