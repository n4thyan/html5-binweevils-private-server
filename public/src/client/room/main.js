const canvas = document.getElementById('roomCanvas');
const ctx = canvas.getContext('2d');
const statusEl = document.getElementById('roomStatus');
const debugEl = document.getElementById('debugOutput');
const chatForm = document.getElementById('chatForm');
const chatInput = document.getElementById('chatInput');

const urlParams = new URLSearchParams(window.location.search);
const now = () => performance.now();

const state = {
  room: null,
  floorImage: null,
  floorReady: false,
  player: {
    x: 0,
    z: 0,
    targetX: 0,
    targetZ: 0,
    dir: -180,
    visualDir: -180,
    message: '',
    messageUntil: 0,
    speed: 135,
    walkStartedAt: 0
  },
  weevilRenderer: {
    status: 'not-loaded',
    enabled: true,
    renderer: null,
    canvas: null,
    metrics: null,
    pending: false,
    error: null,
    lastKey: ''
  },
  notices: [],
  lastTime: now(),
  debug: urlParams.get('debug') === '1'
};

const demoAvatar = {
  weevilDef: '401135129001323200',
  hatId: 0,
  hatColour: 7620096,
  expression: 0
};

function setStatus(message) {
  statusEl.textContent = message;
}

function addNotice(message) {
  state.notices.unshift(`[${new Date().toLocaleTimeString()}] ${message}`);
  state.notices = state.notices.slice(0, 10);
}

function normaliseAngle(value) {
  return ((value % 360) + 360) % 360;
}

function angleDelta(from, to) {
  return ((normaliseAngle(to) - normaliseAngle(from) + 540) % 360) - 180;
}

function approachAngle(current, target, maxStep) {
  const delta = angleDelta(current, target);
  if (Math.abs(delta) <= maxStep) return normaliseAngle(target);
  return normaliseAngle(current + Math.sign(delta) * maxStep);
}

function updateDebug() {
  if (!state.room) return;
  const p = state.player;
  debugEl.textContent = [
    `room: ${state.room.displayName} (${state.room.id})`,
    `debug overlays: ${state.debug ? 'on' : 'off'}  (/debug to toggle)`,
    `weevil renderer: ${state.weevilRenderer.status}  (/weevil to toggle)`,
    `player x/z: ${p.x.toFixed(1)}, ${p.z.toFixed(1)}`,
    `target x/z: ${p.targetX.toFixed(1)}, ${p.targetZ.toFixed(1)}`,
    `direction: ${p.dir.toFixed(1)} visual ${p.visualDir.toFixed(1)}`,
    `floor: ${state.floorReady ? 'loaded' : 'placeholder'}`,
    '',
    ...state.notices
  ].join('\n');
}

function getBoundary() {
  return state.room.bounds.boundary;
}

function worldExtents() {
  const [minX, minZ, maxX, maxZ] = getBoundary();
  const pad = state.room.stage.worldPadding ?? 80;
  return { minX: minX - pad, minZ: minZ - pad, maxX: maxX + pad, maxZ: maxZ + pad };
}

// Milestone 002 uses a flat temporary projection.
// The original InksOrange source has camera data, so a later pass should replace this with source-aware projection.
function worldToScreen(x, z) {
  const ext = worldExtents();
  const nx = (x - ext.minX) / (ext.maxX - ext.minX);
  const nz = (z - ext.minZ) / (ext.maxZ - ext.minZ);
  return { x: nx * canvas.width, y: nz * canvas.height };
}

function screenToWorld(sx, sy) {
  const rect = canvas.getBoundingClientRect();
  const px = (sx - rect.left) * (canvas.width / rect.width);
  const py = (sy - rect.top) * (canvas.height / rect.height);
  const ext = worldExtents();
  return {
    x: ext.minX + (px / canvas.width) * (ext.maxX - ext.minX),
    z: ext.minZ + (py / canvas.height) * (ext.maxZ - ext.minZ)
  };
}

function clampToBoundary(x, z) {
  const [minX, minZ, maxX, maxZ] = getBoundary();
  return { x: Math.max(minX, Math.min(maxX, x)), z: Math.max(minZ, Math.min(maxZ, z)) };
}

function pointHitsNoGo(x, z) {
  return state.room.noGoAreas.some((area) => {
    if (area.type !== 'rad') return false;
    const dx = x - area.x;
    const dz = z - area.z;
    return Math.sqrt(dx * dx + dz * dz) < area.r;
  });
}

function isWalkable(x, z) {
  const [minX, minZ, maxX, maxZ] = getBoundary();
  if (x < minX || x > maxX || z < minZ || z > maxZ) return false;
  return !pointHitsNoGo(x, z);
}

function isWalking() {
  const dx = state.player.targetX - state.player.x;
  const dz = state.player.targetZ - state.player.z;
  return Math.sqrt(dx * dx + dz * dz) > 1.5;
}

function setTarget(x, z) {
  const clamped = clampToBoundary(x, z);
  if (!isWalkable(clamped.x, clamped.z)) {
    addNotice(`Blocked: ${clamped.x.toFixed(0)}, ${clamped.z.toFixed(0)}`);
    return;
  }

  const dx = clamped.x - state.player.x;
  const dz = clamped.z - state.player.z;
  if (Math.sqrt(dx * dx + dz * dz) > 1.5) {
    state.player.dir = Math.atan2(dx, dz) * (180 / Math.PI);
    state.player.walkStartedAt = now();
  }

  state.player.targetX = clamped.x;
  state.player.targetZ = clamped.z;
}

function loadImage(src) {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () => resolve(image);
    image.onerror = reject;
    image.src = src;
  });
}

async function loadRoom() {
  const response = await fetch('./assets/rooms/inks-orange/room.json', { cache: 'no-store' });
  if (!response.ok) throw new Error(`room.json failed: ${response.status}`);
  state.room = await response.json();

  const [entryX, entryZ] = state.room.entry.position;
  state.player.x = entryX;
  state.player.z = entryZ;
  state.player.targetX = entryX;
  state.player.targetZ = entryZ;
  state.player.dir = state.room.entry.direction;
  state.player.visualDir = state.room.entry.direction;

  try {
    state.floorImage = await loadImage(`./assets/rooms/inks-orange/${state.room.floor.path}`);
    state.floorReady = true;
    setStatus('Room loaded with source floor asset');
  } catch (error) {
    state.floorReady = false;
    setStatus('Room loaded - copy inks.jpg into assets/rooms/inks-orange/floors/');
    addNotice('Floor image missing; using placeholder background');
  }
}

async function loadWeevilRenderer() {
  if (!state.weevilRenderer.enabled) return;
  state.weevilRenderer.status = 'loading';

  try {
    const module = await import('./room-weevil-renderer.js');
    const spriteCanvas = document.createElement('canvas');
    spriteCanvas.width = 240;
    spriteCanvas.height = 240;
    state.weevilRenderer.canvas = spriteCanvas;
    state.weevilRenderer.renderer = module.createRoomWeevilRenderer(spriteCanvas);
    state.weevilRenderer.status = 'ready';
    addNotice('Prototype weevil renderer loaded');
  } catch (error) {
    state.weevilRenderer.status = 'fallback';
    state.weevilRenderer.error = error;
    addNotice('Prototype weevil renderer unavailable; using placeholder');
    console.warn('Prototype weevil renderer unavailable', error);
  }
}

function drawFloor() {
  if (state.floorReady && state.floorImage) {
    ctx.drawImage(state.floorImage, 0, 0, canvas.width, canvas.height);
    return;
  }

  const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
  gradient.addColorStop(0, '#d07a19');
  gradient.addColorStop(0.5, '#8f4a0d');
  gradient.addColorStop(1, '#3f2108');
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  ctx.fillStyle = 'rgba(255, 235, 150, 0.18)';
  for (let i = -canvas.width; i < canvas.width * 2; i += 48) {
    ctx.beginPath();
    ctx.ellipse(i, canvas.height * 0.68, 220, 44, -0.24, 0, Math.PI * 2);
    ctx.fill();
  }

  ctx.fillStyle = '#fff3ce';
  ctx.font = 'bold 18px Verdana, Arial, sans-serif';
  ctx.fillText('Missing floor asset: public/assets/rooms/inks-orange/floors/inks.jpg', 28, 42);
}

function drawBoundary() {
  const [minX, minZ, maxX, maxZ] = getBoundary();
  const a = worldToScreen(minX, minZ);
  const b = worldToScreen(maxX, maxZ);
  ctx.save();
  ctx.strokeStyle = 'rgba(255, 255, 255, 0.45)';
  ctx.lineWidth = 2;
  ctx.setLineDash([8, 6]);
  ctx.strokeRect(a.x, a.y, b.x - a.x, b.y - a.y);
  ctx.restore();
}

function drawNoGoAreas() {
  ctx.save();
  for (const area of state.room.noGoAreas) {
    if (area.type !== 'rad') continue;
    const centre = worldToScreen(area.x, area.z);
    const edge = worldToScreen(area.x + area.r, area.z);
    const radius = Math.abs(edge.x - centre.x);
    ctx.fillStyle = 'rgba(255, 0, 0, 0.16)';
    ctx.strokeStyle = 'rgba(255, 60, 60, 0.65)';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.arc(centre.x, centre.y, radius, 0, Math.PI * 2);
    ctx.fill();
    ctx.stroke();
  }
  ctx.restore();
}

function drawObjectPlaceholders() {
  const objects = [...state.room.objects, ...state.room.gameSlots.map((slot) => ({ ...slot, type: 'gameSlot' }))];
  objects.sort((a, b) => (a.z + (a.depthOffset ?? 0)) - (b.z + (b.depthOffset ?? 0)));

  for (const object of objects) {
    const point = worldToScreen(object.x, object.z);
    const isGame = object.type === 'gameSlot';
    const radius = Math.max(5, Math.min(24, (object.scale ?? 0.1) * 34));

    ctx.save();
    ctx.translate(point.x, point.y);
    ctx.fillStyle = isGame ? 'rgba(40, 120, 255, 0.55)' : 'rgba(255, 198, 45, 0.62)';
    ctx.strokeStyle = isGame ? '#cfe1ff' : '#fff2a8';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.arc(0, 0, radius, 0, Math.PI * 2);
    ctx.fill();
    ctx.stroke();

    ctx.font = 'bold 10px Verdana, Arial, sans-serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'bottom';
    ctx.fillStyle = '#1b0b01';
    const label = object.label || object.path || 'object';
    ctx.fillText(label.replace('assets3D/', '').replace('.swf', ''), 0, -radius - 4);
    ctx.restore();
  }
}

function makeWalkPose() {
  if (!isWalking()) return null;

  const elapsed = now() - state.player.walkStartedAt;
  const phase = Math.floor(elapsed / 85) % 8;
  const bodyBob = Math.sin(elapsed / 55) * 5;
  const bodyTwist = Math.sin(elapsed / 90) * 3;

  // Temporary visible walk loop. The real values should be replaced after the AS3 movement audit.
  const poses = [
    [14, 4, 7, 16, 4, 6],
    [15, 5, 6, 17, 3, 5],
    [16, 6, 4, 14, 4, 7],
    [17, 5, 3, 15, 5, 6],
    [16, 4, 6, 14, 4, 7],
    [15, 3, 5, 17, 5, 4],
    [14, 4, 7, 16, 4, 6],
    [7, 4, 14, 6, 4, 16]
  ];

  return {
    creatureY: bodyBob,
    creatureRotY: bodyTwist,
    headRotX: Math.sin(elapsed / 130) * 1.5,
    headRotY: Math.sin(elapsed / 160) * 4,
    shadowAlpha: 0.92 + Math.abs(Math.sin(elapsed / 80)) * 0.08,
    legs: poses[phase]
  };
}

function requestRenderedWeevilSprite() {
  const wr = state.weevilRenderer;
  if (!wr.enabled || wr.status !== 'ready' || !wr.renderer || wr.pending) return;

  const poseState = makeWalkPose();
  const yaw = normaliseAngle(state.player.visualDir + 302);
  const key = JSON.stringify({
    yaw: Math.round(yaw / 3) * 3,
    walking: Boolean(poseState),
    legs: poseState?.legs?.join(',') ?? 'idle',
    bob: Math.round((poseState?.creatureY ?? 0) * 2) / 2,
    twist: Math.round((poseState?.creatureRotY ?? 0) * 2) / 2
  });
  if (key === wr.lastKey && wr.metrics) return;

  wr.pending = true;
  wr.lastKey = key;
  wr.renderer.paint(demoAvatar, {
    width: 240,
    height: 240,
    yaw,
    pitch: 18,
    poseState
  }).then((metrics) => {
    wr.metrics = metrics;
    wr.pending = false;
  }).catch((error) => {
    wr.status = 'fallback';
    wr.error = error;
    wr.pending = false;
    addNotice('Renderer failed; reverted to placeholder');
    console.error('Weevil renderer failed', error);
  });
}

function drawWeevil() {
  const p = worldToScreen(state.player.x, state.player.z);
  requestRenderedWeevilSprite();

  if (state.weevilRenderer.enabled && state.weevilRenderer.status === 'ready' && state.weevilRenderer.canvas && state.weevilRenderer.metrics) {
    drawRenderedWeevil(p);
  } else {
    drawPlaceholderWeevil(p);
  }
}

function drawRenderedWeevil(p) {
  const wr = state.weevilRenderer;
  const scale = 0.7;
  const width = wr.canvas.width * scale;
  const height = wr.canvas.height * scale;
  const anchorX = (wr.metrics?.anchorX ?? wr.canvas.width * 0.5) * scale;
  const anchorY = (wr.metrics?.anchorY ?? wr.canvas.height - 10) * scale;

  ctx.save();
  ctx.drawImage(wr.canvas, p.x - anchorX, p.y - anchorY, width, height);

  if (state.player.message && now() < state.player.messageUntil) {
    const bubbleY = p.y - anchorY + ((wr.metrics?.topY ?? 20) * scale) - 8;
    drawChatBubble(state.player.message, p.x, bubbleY);
  }
  ctx.restore();
}

function drawPlaceholderWeevil(p) {
  const scale = state.room.entry.weevilScale;
  const bodyW = 170 * scale;
  const bodyH = 260 * scale;

  ctx.save();
  ctx.translate(p.x, p.y);

  ctx.fillStyle = 'rgba(0, 0, 0, 0.28)';
  ctx.beginPath();
  ctx.ellipse(0, bodyH * 0.38, bodyW * 0.55, bodyH * 0.18, 0, 0, Math.PI * 2);
  ctx.fill();

  ctx.fillStyle = '#88d344';
  ctx.strokeStyle = '#254a11';
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.ellipse(0, -bodyH * 0.18, bodyW * 0.45, bodyH * 0.48, 0, 0, Math.PI * 2);
  ctx.fill();
  ctx.stroke();

  ctx.fillStyle = '#fff8df';
  ctx.beginPath();
  ctx.arc(-bodyW * 0.17, -bodyH * 0.3, bodyW * 0.12, 0, Math.PI * 2);
  ctx.arc(bodyW * 0.17, -bodyH * 0.3, bodyW * 0.12, 0, Math.PI * 2);
  ctx.fill();

  ctx.fillStyle = '#1b0b01';
  ctx.beginPath();
  ctx.arc(-bodyW * 0.15, -bodyH * 0.29, bodyW * 0.045, 0, Math.PI * 2);
  ctx.arc(bodyW * 0.19, -bodyH * 0.29, bodyW * 0.045, 0, Math.PI * 2);
  ctx.fill();

  ctx.strokeStyle = '#254a11';
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.moveTo(-bodyW * 0.18, -bodyH * 0.62);
  ctx.quadraticCurveTo(-bodyW * 0.42, -bodyH * 0.86, -bodyW * 0.28, -bodyH * 0.95);
  ctx.moveTo(bodyW * 0.18, -bodyH * 0.62);
  ctx.quadraticCurveTo(bodyW * 0.42, -bodyH * 0.86, bodyW * 0.28, -bodyH * 0.95);
  ctx.stroke();

  ctx.fillStyle = '#254a11';
  ctx.fillRect(-bodyW * 0.45, bodyH * 0.1, bodyW * 0.9, bodyH * 0.08);

  if (state.player.message && now() < state.player.messageUntil) {
    drawChatBubble(state.player.message, 0, -bodyH * 0.95);
  }

  ctx.restore();
}

function drawChatBubble(message, x, y) {
  const paddingX = 12;
  const paddingY = 8;
  ctx.font = 'bold 13px Verdana, Arial, sans-serif';
  const maxWidth = 260;
  const words = message.split(/\s+/);
  const lines = [];
  let line = '';

  for (const word of words) {
    const test = line ? `${line} ${word}` : word;
    if (ctx.measureText(test).width > maxWidth && line) {
      lines.push(line);
      line = word;
    } else {
      line = test;
    }
  }
  lines.push(line);

  const width = Math.min(maxWidth, Math.max(...lines.map((l) => ctx.measureText(l).width))) + paddingX * 2;
  const height = lines.length * 18 + paddingY * 2;
  const bx = x - width / 2;
  const by = y - height;

  ctx.save();
  ctx.fillStyle = 'rgba(255, 251, 218, 0.96)';
  ctx.strokeStyle = '#7b3d05';
  ctx.lineWidth = 2;
  roundRect(ctx, bx, by, width, height, 14);
  ctx.fill();
  ctx.stroke();

  ctx.beginPath();
  ctx.moveTo(x - 8, by + height - 1);
  ctx.lineTo(x + 2, by + height + 12);
  ctx.lineTo(x + 13, by + height - 1);
  ctx.closePath();
  ctx.fill();
  ctx.stroke();

  ctx.fillStyle = '#2b1202';
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  lines.forEach((text, index) => ctx.fillText(text, x, by + paddingY + 9 + index * 18));
  ctx.restore();
}

function roundRect(context, x, y, width, height, radius) {
  context.beginPath();
  context.moveTo(x + radius, y);
  context.arcTo(x + width, y, x + width, y + height, radius);
  context.arcTo(x + width, y + height, x, y + height, radius);
  context.arcTo(x, y + height, x, y, radius);
  context.arcTo(x, y, x + width, y, radius);
  context.closePath();
}

function update(deltaSeconds) {
  const p = state.player;
  const dx = p.targetX - p.x;
  const dz = p.targetZ - p.z;
  const distance = Math.sqrt(dx * dx + dz * dz);

  p.visualDir = approachAngle(p.visualDir, p.dir, 420 * deltaSeconds);

  if (distance <= 1) {
    p.x = p.targetX;
    p.z = p.targetZ;
    return;
  }

  const step = Math.min(distance, p.speed * deltaSeconds);
  const nx = p.x + (dx / distance) * step;
  const nz = p.z + (dz / distance) * step;

  if (isWalkable(nx, nz)) {
    p.x = nx;
    p.z = nz;
    p.dir = Math.atan2(dx, dz) * (180 / Math.PI);
  } else {
    p.targetX = p.x;
    p.targetZ = p.z;
  }
}

function draw() {
  if (!state.room) return;
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  drawFloor();
  if (state.debug) {
    drawBoundary();
    drawNoGoAreas();
    drawObjectPlaceholders();
  }
  drawWeevil();
}

function frame(timestamp) {
  const deltaSeconds = Math.min(0.05, (timestamp - state.lastTime) / 1000);
  state.lastTime = timestamp;
  update(deltaSeconds);
  draw();
  updateDebug();
  requestAnimationFrame(frame);
}

canvas.addEventListener('click', (event) => {
  if (!state.room) return;
  const point = screenToWorld(event.clientX, event.clientY);
  setTarget(point.x, point.z);
});

chatForm.addEventListener('submit', (event) => {
  event.preventDefault();
  const text = chatInput.value.trim();
  if (!text) return;

  if (text.startsWith('/')) {
    handleCommand(text);
  } else {
    state.player.message = text;
    state.player.messageUntil = now() + 5500;
    addNotice(`chat: ${text}`);
  }

  chatInput.value = '';
});

function handleCommand(text) {
  const [command, ...args] = text.slice(1).split(/\s+/);
  switch (command.toLowerCase()) {
    case 'pos':
      addNotice(`pos ${state.player.x.toFixed(1)},${state.player.z.toFixed(1)}`);
      break;
    case 'goto': {
      const x = Number(args[0]);
      const z = Number(args[1]);
      if (Number.isFinite(x) && Number.isFinite(z) && isWalkable(x, z)) {
        state.player.x = x;
        state.player.z = z;
        state.player.targetX = x;
        state.player.targetZ = z;
        addNotice(`teleported to ${x},${z}`);
      } else {
        addNotice('usage: /goto <x> <z> inside walkable area');
      }
      break;
    }
    case 'say':
      state.player.message = args.join(' ') || 'Hello from Ink\'s Orange!';
      state.player.messageUntil = now() + 5500;
      break;
    case 'debug':
      state.debug = !state.debug;
      addNotice(`debug overlays ${state.debug ? 'on' : 'off'}`);
      break;
    case 'weevil':
      state.weevilRenderer.enabled = !state.weevilRenderer.enabled;
      addNotice(`weevil renderer ${state.weevilRenderer.enabled ? 'enabled' : 'disabled'}`);
      if (state.weevilRenderer.enabled && state.weevilRenderer.status === 'not-loaded') loadWeevilRenderer();
      break;
    default:
      addNotice(`unknown command: /${command}`);
  }
}

Promise.all([loadRoom(), loadWeevilRenderer()])
  .then(() => {
    addNotice('Loaded source-derived Orange Peel room definition');
    if (!state.debug) addNotice('Type /debug to show source coordinate overlays');
    requestAnimationFrame(frame);
  })
  .catch((error) => {
    console.error(error);
    setStatus('Failed to load room data');
    debugEl.textContent = error.stack || String(error);
  });
