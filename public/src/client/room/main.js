import { SourceWalkBehaviour } from './weevil-behaviour.js';
import { ProjectionModes, createRoomProjection } from './room-projection.js';

const canvas = document.getElementById('roomCanvas');
const ctx = canvas.getContext('2d', { willReadFrequently: true });
const statusEl = document.getElementById('roomStatus');
const roomTitleEl = document.getElementById('roomTitle');
const roomSubtitleEl = document.getElementById('roomSubtitle');
const debugEl = document.getElementById('debugOutput');
const chatForm = document.getElementById('chatForm');
const chatInput = document.getElementById('chatInput');

const urlParams = new URLSearchParams(window.location.search);
const now = () => performance.now();

function finiteNumber(value, fallback) {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

function normaliseAngle(value) {
  return ((value % 360) + 360) % 360;
}

const state = {
  registry: null,
  roomSlug: urlParams.get('room') || null,
  room: null,
  projection: null,
  projectionMode: urlParams.get('projection') || null,
  floorImage: null,
  floorReady: false,
  renderYawOffset: finiteNumber(urlParams.get('yaw'), null),
  player: {
    x: 0,
    z: 0,
    targetX: 0,
    targetZ: 0,
    dir: -180,
    message: '',
    messageUntil: 0,
    speed: finiteNumber(urlParams.get('speed'), 88),
    walk: new SourceWalkBehaviour(),
    walkSnapshot: null
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
  state.notices = state.notices.slice(0, 12);
}

function getIdleDirection() {
  return Number(state.room?.entry?.idleDirection ?? state.room?.entry?.direction ?? -180);
}

function getRenderYawOffset() {
  return Number(state.renderYawOffset ?? state.room?.entry?.renderYawOffset ?? 180);
}

function getRenderScale() {
  return Number(state.room?.entry?.renderScale ?? 0.52);
}

function resetRendererCache() {
  state.weevilRenderer.lastKey = '';
}

function updateDebug() {
  if (!state.room) return;
  const p = state.player;
  const walk = p.walkSnapshot;
  debugEl.textContent = [
    `room: ${state.room.displayName} (${state.room.id})`,
    `stage: ${canvas.width}x${canvas.height}`,
    `projection: ${state.projectionMode}  (/projection to toggle)`,
    `debug overlays: ${state.debug ? 'on' : 'off'}  (/debug to toggle)`,
    `weevil renderer: ${state.weevilRenderer.status}  (/weevil to toggle)`,
    `speed: ${p.speed.toFixed(0)}  (/speed 80)`,
    `yaw offset: ${getRenderYawOffset().toFixed(0)}  (/yaw 180)`,
    `render scale: ${getRenderScale().toFixed(2)}  (/scale 0.50)`,
    `player x/z: ${p.x.toFixed(1)}, ${p.z.toFixed(1)}`,
    `target x/z: ${p.targetX.toFixed(1)}, ${p.targetZ.toFixed(1)}`,
    `walk: ${walk?.moving ? 'moving' : 'idle'} turning ${walk?.turning ? 'yes' : 'no'} rotY ${p.dir.toFixed(1)} idle ${getIdleDirection().toFixed(1)}`,
    `floor: ${state.floorReady ? 'loaded' : 'placeholder'}`,
    '',
    ...state.notices
  ].join('\n');
}

function applyRoomStageSize() {
  const width = Number(state.room?.stage?.width || canvas.width);
  const height = Number(state.room?.stage?.height || canvas.height);
  if (canvas.width !== width) canvas.width = width;
  if (canvas.height !== height) canvas.height = height;
}

function setProjectionMode(mode) {
  state.projectionMode = mode;
  if (state.room) state.projection = createRoomProjection(state.room, canvas, mode);
  addNotice(`projection: ${mode}`);
}

function worldToScreen(x, z, y = 0) {
  return state.projection.worldToScreen(x, z, y);
}

function screenToWorld(sx, sy) {
  const rect = canvas.getBoundingClientRect();
  const px = (sx - rect.left) * (canvas.width / rect.width);
  const py = (sy - rect.top) * (canvas.height / rect.height);
  return state.projection.screenToWorld(px, py);
}

function clampToBoundary(x, z) {
  if (state.room.bounds.type === 'rad') {
    const [cx, cz, r] = state.room.bounds.boundary;
    const dx = x - cx;
    const dz = z - cz;
    const distance = Math.hypot(dx, dz);
    if (distance <= r) return { x, z };
    const scale = r / (distance || 1);
    return { x: cx + dx * scale, z: cz + dz * scale };
  }

  const [minX, minZ, maxX, maxZ] = state.room.bounds.boundary;
  return { x: clamp(x, minX, maxX), z: clamp(z, minZ, maxZ) };
}

function pointHitsNoGo(x, z) {
  return state.room.noGoAreas.some((area) => {
    if (area.type !== 'rad') return false;
    return Math.hypot(x - area.x, z - area.z) < area.r;
  });
}

function isInsideBoundary(x, z) {
  if (state.room.bounds.type === 'rad') {
    const [cx, cz, r] = state.room.bounds.boundary;
    return Math.hypot(x - cx, z - cz) <= r;
  }

  const [minX, minZ, maxX, maxZ] = state.room.bounds.boundary;
  return x >= minX && x <= maxX && z >= minZ && z <= maxZ;
}

function isWalkable(x, z) {
  return isInsideBoundary(x, z) && !pointHitsNoGo(x, z);
}

function isWalking() {
  return Boolean(state.player.walkSnapshot?.moving || state.player.walkSnapshot?.turning);
}

function syncPlayerFromWalk(snapshot) {
  state.player.walkSnapshot = snapshot;
  state.player.x = snapshot.x;
  state.player.z = snapshot.z;
  state.player.dir = snapshot.rotY;
}

function initialiseWalkState(x, z, rotY = getIdleDirection()) {
  state.player.walk.reset();
  syncPlayerFromWalk(state.player.walk.init({
    x,
    z,
    rotY,
    targetX: x,
    targetZ: z,
    targetRotY: rotY,
    speed: state.player.speed / 60,
    reverse: false
  }));
}

function startWalkTo(x, z) {
  const clamped = clampToBoundary(x, z);
  if (!isWalkable(clamped.x, clamped.z)) {
    addNotice(`Blocked: ${clamped.x.toFixed(0)}, ${clamped.z.toFixed(0)}`);
    return;
  }

  const dx = clamped.x - state.player.x;
  const dz = clamped.z - state.player.z;
  if (Math.hypot(dx, dz) <= 1.5) return;

  state.player.targetX = clamped.x;
  state.player.targetZ = clamped.z;

  syncPlayerFromWalk(state.player.walk.init({
    x: state.player.x,
    z: state.player.z,
    rotY: state.player.dir,
    targetX: clamped.x,
    targetZ: clamped.z,
    targetRotY: getIdleDirection(),
    speed: state.player.speed / 60,
    reverse: false
  }));
}

function loadImage(src) {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () => resolve(image);
    image.onerror = reject;
    image.src = src;
  });
}

async function loadRegistry() {
  const response = await fetch('./assets/rooms/room-registry.json', { cache: 'no-store' });
  if (!response.ok) throw new Error(`room-registry.json failed: ${response.status}`);
  state.registry = await response.json();
  state.roomSlug = state.roomSlug || state.registry.defaultRoom;
  return state.registry.rooms[state.roomSlug];
}

async function loadRoom() {
  const roomEntry = await loadRegistry();
  if (!roomEntry) throw new Error(`Unknown room: ${state.roomSlug}`);

  const response = await fetch(roomEntry.definition, { cache: 'no-store' });
  if (!response.ok) throw new Error(`${roomEntry.definition} failed: ${response.status}`);
  state.room = await response.json();
  applyRoomStageSize();

  state.player.speed = finiteNumber(urlParams.get('speed'), Number(state.room.entry?.walkSpeed ?? state.player.speed));
  state.projectionMode = state.projectionMode || state.room.projection?.mode || ProjectionModes.FLAT;
  state.projection = createRoomProjection(state.room, canvas, state.projectionMode);

  roomTitleEl.textContent = state.room.displayName;
  roomSubtitleEl.textContent = 'Milestone 003 fixed-camera room slice';

  const [entryX, entryZ] = state.room.entry.position;
  state.player.x = entryX;
  state.player.z = entryZ;
  state.player.targetX = entryX;
  state.player.targetZ = entryZ;
  state.player.dir = getIdleDirection();
  initialiseWalkState(entryX, entryZ, getIdleDirection());

  try {
    state.floorImage = await loadImage(`./assets/rooms/${state.room.slug}/${state.room.floor.path}`);
    state.floorReady = true;
    setStatus(`${state.room.displayName} loaded with source-export background`);
  } catch (error) {
    state.floorReady = false;
    setStatus(`${state.room.displayName} loaded - export ${state.room.floor.sourceSwf || 'room SWF'} to ${state.room.floor.path}`);
    addNotice('Room background image missing; using source-coordinate placeholder');
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
  gradient.addColorStop(0, '#4b260a');
  gradient.addColorStop(0.42, '#a45d18');
  gradient.addColorStop(1, '#2e1706');
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  ctx.save();
  ctx.translate(canvas.width / 2, canvas.height * 0.56);
  ctx.fillStyle = 'rgba(255, 206, 88, 0.2)';
  ctx.beginPath();
  ctx.ellipse(0, 0, 270, 150, 0, 0, Math.PI * 2);
  ctx.fill();
  ctx.strokeStyle = 'rgba(255, 245, 190, 0.38)';
  ctx.lineWidth = 4;
  ctx.stroke();
  ctx.restore();

  ctx.fillStyle = '#fff3ce';
  ctx.font = 'bold 18px Verdana, Arial, sans-serif';
  const source = state.room?.floor?.sourceSwf || 'room SWF';
  const target = state.room?.floor?.path || 'background image';
  ctx.fillText(`Missing room background export: ${source}`, 28, 42);
  ctx.font = '14px Verdana, Arial, sans-serif';
  ctx.fillText(`Place exported image at public/assets/rooms/${state.room?.slug}/${target}`, 28, 66);
}

function drawProjectedCircle(cx, cz, r, fillStyle, strokeStyle) {
  const steps = 96;
  ctx.beginPath();
  for (let i = 0; i <= steps; i += 1) {
    const angle = (i / steps) * Math.PI * 2;
    const p = worldToScreen(cx + Math.cos(angle) * r, cz + Math.sin(angle) * r);
    if (i === 0) ctx.moveTo(p.x, p.y);
    else ctx.lineTo(p.x, p.y);
  }
  ctx.closePath();
  if (fillStyle) {
    ctx.fillStyle = fillStyle;
    ctx.fill();
  }
  if (strokeStyle) {
    ctx.strokeStyle = strokeStyle;
    ctx.stroke();
  }
}

function drawBoundary() {
  ctx.save();
  ctx.lineWidth = 2;
  ctx.setLineDash([8, 6]);

  if (state.room.bounds.type === 'rad') {
    const [cx, cz, r] = state.room.bounds.boundary;
    drawProjectedCircle(cx, cz, r, 'rgba(255, 255, 255, 0.08)', 'rgba(255, 255, 255, 0.45)');
  } else {
    const [minX, minZ, maxX, maxZ] = state.room.bounds.boundary;
    const corners = [worldToScreen(minX, minZ), worldToScreen(maxX, minZ), worldToScreen(maxX, maxZ), worldToScreen(minX, maxZ)];
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.45)';
    ctx.beginPath();
    ctx.moveTo(corners[0].x, corners[0].y);
    for (const corner of corners.slice(1)) ctx.lineTo(corner.x, corner.y);
    ctx.closePath();
    ctx.stroke();
  }
  ctx.restore();
}

function drawNoGoAreas() {
  ctx.save();
  ctx.lineWidth = 2;
  for (const area of state.room.noGoAreas) {
    if (area.type === 'rad') drawProjectedCircle(area.x, area.z, area.r, 'rgba(255, 0, 0, 0.16)', 'rgba(255, 60, 60, 0.65)');
  }
  ctx.restore();
}

function drawDoorPlaceholders() {
  if (!state.debug) return;

  ctx.save();
  ctx.strokeStyle = 'rgba(130, 220, 255, 0.78)';
  ctx.fillStyle = 'rgba(130, 220, 255, 0.18)';
  ctx.lineWidth = 3;
  ctx.setLineDash([4, 4]);
  ctx.font = 'bold 10px Verdana, Arial, sans-serif';
  ctx.textAlign = 'center';

  for (const door of state.room.doors || []) {
    const a = worldToScreen(Number(door.x1), Number(door.z1), 0);
    const b = worldToScreen(Number(door.x2), Number(door.z2), Number(door.y2 || 0));
    ctx.beginPath();
    ctx.moveTo(a.x, a.y);
    ctx.lineTo(b.x, b.y);
    ctx.stroke();
    ctx.beginPath();
    ctx.arc(a.x, a.y, 8, 0, Math.PI * 2);
    ctx.fill();
    ctx.fillStyle = '#e7f8ff';
    ctx.fillText(`door ${door.id}`, a.x, a.y - 12);
    ctx.fillStyle = 'rgba(130, 220, 255, 0.18)';
  }
  ctx.restore();
}

function drawObjectPlaceholders() {
  if (!state.debug) return;

  const objects = [...(state.room.objects || []), ...(state.room.gameSlots || []).map((slot) => ({ ...slot, type: 'gameSlot' }))];
  objects.sort((a, b) => state.projection.depthForWorld(a.x, a.z, a.y ?? 0) - state.projection.depthForWorld(b.x, b.z, b.y ?? 0));

  for (const object of objects) {
    const point = worldToScreen(object.x, object.z, object.y ?? 0);
    const isGame = object.type === 'gameSlot';
    const projectionScale = state.projection.scaleForWorld(object.x, object.z, object.y ?? 0);
    const radius = Math.max(5, Math.min(28, (object.scale ?? 0.14) * 40 * projectionScale));

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
    const label = object.label || object.name || object.path || 'object';
    ctx.fillText(label.replace('assets3D/', '').replace('.swf', ''), 0, -radius - 4);
    ctx.restore();
  }
}

function getRendererPoseState() {
  return state.player.walkSnapshot?.poseState ?? null;
}

function requestRenderedWeevilSprite() {
  const wr = state.weevilRenderer;
  if (!wr.enabled || wr.status !== 'ready' || !wr.renderer || wr.pending) return;

  const poseState = getRendererPoseState();
  const yaw = normaliseAngle(state.player.dir + getRenderYawOffset());
  const key = JSON.stringify({
    yaw: Math.round(yaw / 3) * 3,
    walking: isWalking(),
    legs: poseState?.legs?.join(',') ?? 'idle',
    headY: Math.round((poseState?.headRotY ?? 0) * 2) / 2,
    bodyY: Math.round((poseState?.creatureRotY ?? 0) * 2) / 2
  });
  if (key === wr.lastKey && wr.metrics) return;

  wr.pending = true;
  wr.lastKey = key;
  wr.renderer.paint(demoAvatar, {
    width: 240,
    height: 240,
    yaw,
    pitch: Number(state.room?.entry?.renderPitch ?? 18),
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
  const p = worldToScreen(state.player.x, state.player.z, 0);
  requestRenderedWeevilSprite();

  if (state.weevilRenderer.enabled && state.weevilRenderer.status === 'ready' && state.weevilRenderer.canvas && state.weevilRenderer.metrics) {
    drawRenderedWeevil(p);
  } else {
    drawPlaceholderWeevil(p);
  }
}

function drawRenderedWeevil(p) {
  const wr = state.weevilRenderer;
  const projectionScale = state.projection.scaleForWorld(state.player.x, state.player.z, 0);
  const scale = 0.7 * projectionScale * getRenderScale();
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
  const scale = state.room.entry.weevilScale * state.projection.scaleForWorld(state.player.x, state.player.z, 0);
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
  context.arcTo(x, y, x + radius, y, radius);
  context.closePath();
}

function update(deltaSeconds) {
  const frameScale = deltaSeconds * 60;
  syncPlayerFromWalk(state.player.walk.step(frameScale, {
    isForbidden: (x, z) => !isWalkable(x, z)
  }));
}

function draw() {
  if (!state.room) return;
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  drawFloor();
  if (state.debug) {
    drawBoundary();
    drawNoGoAreas();
    drawDoorPlaceholders();
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
  startWalkTo(point.x, point.z);
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
        initialiseWalkState(x, z, getIdleDirection());
        addNotice(`teleported to ${x},${z}`);
      } else {
        addNotice('usage: /goto <x> <z> inside walkable area');
      }
      break;
    }
    case 'say':
      state.player.message = args.join(' ') || `Hello from ${state.room.displayName}!`;
      state.player.messageUntil = now() + 5500;
      break;
    case 'debug':
      state.debug = !state.debug;
      addNotice(`debug overlays ${state.debug ? 'on' : 'off'}`);
      break;
    case 'projection': {
      const modes = [ProjectionModes.FIXED_FLOOR, ProjectionModes.SOURCE_CAMERA, ProjectionModes.FLAT];
      const index = modes.indexOf(state.projectionMode);
      setProjectionMode(modes[(index + 1) % modes.length]);
      break;
    }
    case 'speed': {
      const speed = Number(args[0]);
      if (!Number.isFinite(speed)) {
        addNotice(`speed is ${state.player.speed.toFixed(0)}`);
      } else {
        state.player.speed = clamp(speed, 30, 180);
        addNotice(`speed set to ${state.player.speed.toFixed(0)}`);
      }
      break;
    }
    case 'yaw': {
      const yaw = Number(args[0]);
      if (!Number.isFinite(yaw)) {
        addNotice(`yaw offset is ${getRenderYawOffset().toFixed(0)}`);
      } else {
        state.renderYawOffset = normaliseAngle(yaw);
        resetRendererCache();
        addNotice(`yaw offset set to ${state.renderYawOffset.toFixed(0)}`);
      }
      break;
    }
    case 'scale': {
      const scale = Number(args[0]);
      if (!Number.isFinite(scale)) {
        addNotice(`scale is ${getRenderScale().toFixed(2)}`);
      } else {
        state.room.entry.renderScale = clamp(scale, 0.25, 1.2);
        resetRendererCache();
        addNotice(`scale set to ${state.room.entry.renderScale.toFixed(2)}`);
      }
      break;
    }
    case 'front':
    case 'face':
      initialiseWalkState(state.player.x, state.player.z, getIdleDirection());
      resetRendererCache();
      addNotice(`facing idle direction ${getIdleDirection().toFixed(0)}`);
      break;
    case 'room':
      addNotice(`rooms: ${Object.keys(state.registry.rooms).join(', ')}`);
      addNotice('switch with ?room=nest-hall or ?room=inks-orange');
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
    addNotice(`Loaded source-derived ${state.room.displayName} room definition`);
    addNotice('Type /speed 80, /yaw 180, /scale 0.50 for avatar tuning');
    addNotice('Type /projection to compare fixed-floor, source-camera, and flat projection');
    if (!state.debug) addNotice('Type /debug to show source coordinate overlays');
    requestAnimationFrame(frame);
  })
  .catch((error) => {
    console.error(error);
    setStatus('Failed to load room data');
    debugEl.textContent = error.stack || String(error);
  });
