import { createRoomWeevilRenderer } from './weevil-room-renderer.js';

const root = document.getElementById('mirrorRoomApp');

if (root) {
  const stage = root.querySelector('[data-room-stage]');
  const floorImg = root.querySelector('[data-room-floor-img]');
  const foregroundImg = root.querySelector('[data-room-foreground-img]');
  const playersMount = root.querySelector('[data-room-players]');
  const status = root.querySelector('[data-room-status]');
  const onlineList = root.querySelector('[data-room-online-list]');
  const feedMount = root.querySelector('[data-room-feed]');
  const chatForm = root.querySelector('[data-room-chat-form]');
  const chatInput = chatForm?.querySelector('input[name="message"]');
  const chatHelp = root.querySelector('[data-room-chat-help]');
  const me = root.dataset.currentUserId || '';
  const roomName = root.dataset.roomName || 'The Peel';
  const roomWidth = Number.parseInt(root.dataset.worldWidth || '1024', 10) || 1024;
  const roomHeight = Number.parseInt(root.dataset.worldHeight || '640', 10) || 640;
  const roomBounds = JSON.parse(root.dataset.roomBounds || '{"minX":120,"maxX":922,"minY":332,"maxY":596}');

  const CAMERA_STORAGE_KEY = 'bwr:the-peel:camera-yaw';
  const CAMERA_STEP = 20;
  const WORLD_SCALE_Y = 0.82;
  const RENDER_WIDTH = 256;
  const RENDER_HEIGHT = 256;
  const CAMERA_PITCH = 18;
  const entities = new Map();
  let latestPlayers = [];
  let latestFeed = [];
  let socket = null;
  let reconnectTimer = 0;
  let pendingLocalMove = null;
  let cameraYaw = Number.parseInt(window.localStorage.getItem(CAMERA_STORAGE_KEY) || '0', 10) || 0;

  const roomCenter = {
    x: roomWidth * 0.5,
    y: (roomBounds.minY + roomBounds.maxY) * 0.5,
  };

  function escapeHtml(value) {
    return String(value || '')
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
  }

  function wrap360(value) {
    const number = Number(value) || 0;
    return ((number % 360) + 360) % 360;
  }

  function angleRad(deg) {
    return wrap360(deg) * Math.PI / 180;
  }

  function isTypingTarget(target) {
    if (!target) return false;
    const tag = String(target.tagName || '').toLowerCase();
    return tag === 'input' || tag === 'textarea' || target.isContentEditable;
  }

  function setStatus(message, live = false) {
    if (!status) return;
    status.textContent = message;
    status.classList.toggle('is-live', live);
  }

  function showNotice(message = '', kind = 'info') {
    if (!chatHelp) return;
    const clean = String(message || '').trim();
    chatHelp.textContent = clean || 'The Peel is now using the full HTML5 studio renderer. Click to move, talk below, and use ← / → to rotate the room camera.';
    chatHelp.dataset.kind = clean ? kind : '';
    window.clearTimeout(showNotice.timer);
    if (clean) {
      showNotice.timer = window.setTimeout(() => {
        chatHelp.textContent = 'The Peel is now using the full HTML5 studio renderer. Click to move, talk below, and use ← / → to rotate the room camera.';
        chatHelp.dataset.kind = '';
      }, 4200);
    }
  }

  function clampPoint(x, y) {
    return {
      x: Math.max(roomBounds.minX, Math.min(roomBounds.maxX, Math.round(Number(x) || 0))),
      y: Math.max(roomBounds.minY, Math.min(roomBounds.maxY, Math.round(Number(y) || 0)))
    };
  }

  function roomSocketUrl() {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    return `${protocol}//${window.location.host}/ws/the-peel`;
  }

  function sendRoomMessage(payload) {
    if (!socket || socket.readyState !== WebSocket.OPEN) {
      showNotice('The room connection is not ready yet. Please wait a moment.', 'error');
      return false;
    }
    socket.send(JSON.stringify(payload));
    return true;
  }

  function markAllForRerender() {
    for (const entity of entities.values()) {
      entity.needsAvatarRefresh = true;
    }
  }

  function persistCamera() {
    window.localStorage.setItem(CAMERA_STORAGE_KEY, String(cameraYaw));
  }

  function rotateCamera(delta) {
    cameraYaw = wrap360(cameraYaw + delta);
    persistCamera();
    markAllForRerender();
    showNotice(`Camera turned ${delta < 0 ? 'left' : 'right'} · ${cameraYaw}°`, 'info');
  }

  function projectWorldPoint(x, y) {
    const dx = Number(x || 0) - roomCenter.x;
    const dz = Number(y || 0) - roomCenter.y;
    const angle = angleRad(cameraYaw);
    const cos = Math.cos(angle);
    const sin = Math.sin(angle);
    const rx = dx * cos - dz * sin;
    const rz = dx * sin + dz * cos;
    return {
      x: roomCenter.x + rx,
      y: roomCenter.y + rz * WORLD_SCALE_Y,
      depthY: roomCenter.y + rz,
    };
  }

  function worldPointFromScreen(x, y) {
    const dx = Number(x || 0) - roomCenter.x;
    const rz = (Number(y || 0) - roomCenter.y) / WORLD_SCALE_Y;
    const angle = angleRad(cameraYaw);
    const cos = Math.cos(angle);
    const sin = Math.sin(angle);
    return clampPoint(
      roomCenter.x + dx * cos + rz * sin,
      roomCenter.y - dx * sin + rz * cos,
    );
  }

  function baseYawForFacing(facing = 'right') {
    return facing === 'left' ? 68 : 292;
  }

  function createPlayerEntity(player) {
    const node = document.createElement('div');
    node.className = 'mirror-room-player';
    node.innerHTML = `
      <div class="mirror-room-player-avatar">
        <div class="mirror-room-player-shadow"></div>
        <canvas class="mirror-room-player-canvas" width="${RENDER_WIDTH}" height="${RENDER_HEIGHT}" aria-hidden="true"></canvas>
      </div>
      <div class="mirror-room-player-bubble" hidden></div>
      <div class="mirror-room-player-name"></div>
    `;
    playersMount.appendChild(node);
    const canvas = node.querySelector('.mirror-room-player-canvas');
    const preview = createRoomWeevilRenderer(canvas);
    const entity = {
      id: player.userId,
      node,
      avatarWrap: node.querySelector('.mirror-room-player-avatar'),
      shadow: node.querySelector('.mirror-room-player-shadow'),
      bubble: node.querySelector('.mirror-room-player-bubble'),
      name: node.querySelector('.mirror-room-player-name'),
      canvas,
      preview,
      currentX: player.x,
      currentY: player.y,
      targetX: player.x,
      targetY: player.y,
      currentYaw: wrap360(baseYawForFacing(player.facing)),
      targetYaw: wrap360(baseYawForFacing(player.facing)),
      renderYaw: null,
      avatarRecord: player.avatar || {},
      avatarKey: '',
      avatarMetrics: { anchorX: RENDER_WIDTH * 0.5, anchorY: RENDER_HEIGHT - 10, topY: 24, width: 140, height: 210, canvasWidth: RENDER_WIDTH, canvasHeight: RENDER_HEIGHT },
      needsAvatarRefresh: true,
      chatText: '',
      movePhase: Math.random() * Math.PI * 2,
      facing: player.facing || 'right'
    };
    entities.set(player.userId, entity);
    return entity;
  }

  function updatePlayerEntity(player) {
    const entity = entities.get(player.userId) || createPlayerEntity(player);
    entity.targetX = player.x;
    entity.targetY = player.y;
    entity.facing = player.facing || entity.facing || 'right';
    entity.node.classList.toggle('is-self', player.userId === me);
    entity.name.textContent = player.username;
    const avatarKey = JSON.stringify(player.avatar || {});
    if (avatarKey !== entity.avatarKey) {
      entity.avatarKey = avatarKey;
      entity.avatarRecord = player.avatar || {};
      entity.needsAvatarRefresh = true;
    }
    const chatText = String(player.chatText || '').trim();
    if (chatText !== entity.chatText) {
      entity.chatText = chatText;
      entity.bubble.textContent = chatText;
      entity.bubble.hidden = !chatText;
    }
  }

  function renderOnlineList() {
    if (!onlineList) return;
    if (!latestPlayers.length) {
      onlineList.innerHTML = '<p class="mirror-room-empty">No one is in The Peel yet.</p>';
      return;
    }
    onlineList.innerHTML = latestPlayers
      .slice()
      .sort((a, b) => a.username.localeCompare(b.username))
      .map((player) => `
        <div class="mirror-room-online-item ${player.userId === me ? 'is-self' : ''}">
          <strong>${escapeHtml(player.username)}</strong>
          <span>${player.userId === me ? 'You are here now.' : 'Testing in The Peel.'}</span>
        </div>
      `).join('');
  }

  function renderFeed() {
    if (!feedMount) return;
    if (!latestFeed.length) {
      feedMount.innerHTML = '<p class="mirror-room-empty">Room updates will appear here once people move and chat.</p>';
      return;
    }
    feedMount.innerHTML = latestFeed
      .slice()
      .reverse()
      .map((entry) => `
        <div class="mirror-room-feed-item is-${escapeHtml(entry.type || 'system')}">
          <strong>${escapeHtml(entry.username || 'System')}</strong>
          <span>${escapeHtml(entry.text || '')}</span>
        </div>
      `).join('');
  }

  function syncRoomLayers(room = {}) {
    const floorPath = room.floorPath || root.dataset.roomFloor || room.backgroundPath || root.dataset.roomBackground || '';
    const foregroundPath = room.foregroundPath || root.dataset.roomForeground || '';
    if (floorImg && floorPath && floorImg.getAttribute('src') !== floorPath) floorImg.setAttribute('src', floorPath);
    if (foregroundImg) {
      if (foregroundPath) {
        foregroundImg.removeAttribute('hidden');
        if (foregroundImg.getAttribute('src') !== foregroundPath) foregroundImg.setAttribute('src', foregroundPath);
      } else {
        foregroundImg.setAttribute('hidden', 'hidden');
      }
    }
  }

  function applySnapshot(payload) {
    const room = payload?.room || {};
    syncRoomLayers(room);
    latestPlayers = Array.isArray(room.players) ? room.players.slice() : [];
    if (pendingLocalMove) {
      latestPlayers = latestPlayers.map((player) => player.userId === me ? { ...player, x: pendingLocalMove.x, y: pendingLocalMove.y, facing: pendingLocalMove.facing } : player);
    }
    latestFeed = Array.isArray(room.feed) ? room.feed.slice() : [];

    const liveIds = new Set(latestPlayers.map((player) => player.userId));
    latestPlayers.forEach(updatePlayerEntity);
    for (const [userId, entity] of Array.from(entities.entries())) {
      if (!liveIds.has(userId)) {
        entity.node.remove();
        entities.delete(userId);
      }
    }

    renderOnlineList();
    renderFeed();
    const currentRoomName = room.currentRoomName || roomName;
    setStatus(`Connected to ${currentRoomName} · ${latestPlayers.length} online · camera ${cameraYaw}°`, true);
  }

  function animate() {
    for (const entity of entities.values()) {
      const diffX = entity.targetX - entity.currentX;
      const diffY = entity.targetY - entity.currentY;
      const moving = Math.abs(diffX) > 0.8 || Math.abs(diffY) > 0.8;

      const projectedCurrent = projectWorldPoint(entity.currentX, entity.currentY);
      const projectedTarget = projectWorldPoint(entity.targetX, entity.targetY);

      if (moving && Math.abs(projectedTarget.x - projectedCurrent.x) > 0.8) {
        entity.facing = projectedTarget.x < projectedCurrent.x ? 'left' : 'right';
      }

      entity.targetYaw = wrap360(baseYawForFacing(entity.facing) + cameraYaw);
      let yawDiff = wrap360(entity.targetYaw - entity.currentYaw);
      if (yawDiff > 180) yawDiff -= 360;
      entity.currentYaw = wrap360(entity.currentYaw + yawDiff * 0.18);
      entity.currentX += diffX * 0.16;
      entity.currentY += diffY * 0.16;
      if (Math.abs(entity.targetX - entity.currentX) < 0.3) entity.currentX = entity.targetX;
      if (Math.abs(entity.targetY - entity.currentY) < 0.3) entity.currentY = entity.targetY;

      const projected = projectWorldPoint(entity.currentX, entity.currentY);
      const depthRatio = Math.max(0, Math.min(1, (projected.depthY - roomBounds.minY) / Math.max(1, roomBounds.maxY - roomBounds.minY)));
      const scale = 0.92 + depthRatio * 0.52;
      const renderYaw = Math.round(wrap360(entity.currentYaw) / 5) * 5;

      if (entity.needsAvatarRefresh || renderYaw !== entity.renderYaw) {
        entity.renderYaw = renderYaw;
        entity.needsAvatarRefresh = false;
        entity.preview.paint(entity.avatarRecord, { width: RENDER_WIDTH, height: RENDER_HEIGHT, yaw: renderYaw, pitch: CAMERA_PITCH }).then((metrics) => {
          entity.avatarMetrics = metrics || entity.avatarMetrics;
        }).catch((error) => {
          console.error('Room weevil render failed.', error);
        });
      }

      const metrics = entity.avatarMetrics;
      const bobPx = moving ? Math.sin(entity.movePhase += 0.22) * (1.5 + scale * 0.8) : 0;
      const shadowScale = 0.88 + depthRatio * 0.38;
      const spriteTop = (-metrics.anchorY + metrics.topY) * scale + bobPx;

      entity.node.style.left = `${(projected.x / roomWidth) * 100}%`;
      entity.node.style.top = `${(projected.y / roomHeight) * 100}%`;
      entity.node.style.zIndex = String(Math.round(projected.depthY * 10));
      entity.avatarWrap.style.width = `${metrics.canvasWidth || RENDER_WIDTH}px`;
      entity.avatarWrap.style.height = `${metrics.canvasHeight || RENDER_HEIGHT}px`;
      entity.canvas.style.width = `${metrics.canvasWidth || RENDER_WIDTH}px`;
      entity.canvas.style.height = `${metrics.canvasHeight || RENDER_HEIGHT}px`;
      entity.avatarWrap.style.transformOrigin = `${metrics.anchorX}px ${metrics.anchorY}px`;
      entity.avatarWrap.style.transform = `translate(${-metrics.anchorX * scale}px, ${(-metrics.anchorY * scale) + bobPx}px) scale(${scale})`;
      entity.shadow.style.transform = `translate(${-32 * shadowScale}px, ${-11 * shadowScale}px) scale(${shadowScale}, 1)`;
      entity.shadow.style.opacity = String(Math.max(0.16, 0.16 + depthRatio * 0.36));
      entity.name.style.top = `${spriteTop - 14}px`;
      entity.bubble.style.top = `${spriteTop - 56}px`;
    }
    requestAnimationFrame(animate);
  }

  function connectRoom() {
    window.clearTimeout(reconnectTimer);
    setStatus(`Connecting to ${roomName}...`, false);
    socket = new WebSocket(roomSocketUrl());

    socket.addEventListener('open', () => {
      setStatus(`Connected to ${roomName}.`, true);
      showNotice('', '');
    });

    socket.addEventListener('message', (event) => {
      let payload;
      try {
        payload = JSON.parse(event.data);
      } catch {
        return;
      }
      if (payload.type === 'room:snapshot') {
        applySnapshot(payload.payload || {});
        return;
      }
      if (payload.type === 'room:notice') {
        showNotice(payload.message || '', payload.kind || 'info');
        return;
      }
      if (payload.type === 'room:ack' && payload.action === 'move') {
        pendingLocalMove = null;
      }
    });

    socket.addEventListener('close', () => {
      setStatus(`Disconnected from ${roomName}. Reconnecting...`, false);
      reconnectTimer = window.setTimeout(connectRoom, 1600);
    });

    socket.addEventListener('error', () => {
      showNotice(`The ${roomName} connection hit an error. Reconnecting...`, 'error');
    });
  }

  function stagePointFromEvent(event) {
    const rect = stage.getBoundingClientRect();
    const x = ((event.clientX - rect.left) / rect.width) * roomWidth;
    const y = ((event.clientY - rect.top) / rect.height) * roomHeight;
    return worldPointFromScreen(x, y);
  }

  stage?.addEventListener('pointerdown', (event) => {
    if (!stage || event.button !== 0) return;
    const point = stagePointFromEvent(event);
    const self = latestPlayers.find((player) => player.userId === me);
    const selfProjected = self ? projectWorldPoint(self.x, self.y) : projectWorldPoint(point.x, point.y);
    const targetProjected = projectWorldPoint(point.x, point.y);
    const facing = targetProjected.x < selfProjected.x ? 'left' : 'right';
    pendingLocalMove = { ...point, facing };
    sendRoomMessage({ type: 'room:move', x: point.x, y: point.y });
  });

  window.addEventListener('keydown', (event) => {
    if (isTypingTarget(event.target)) return;
    if (event.key === 'ArrowLeft') {
      event.preventDefault();
      rotateCamera(-CAMERA_STEP);
    } else if (event.key === 'ArrowRight') {
      event.preventDefault();
      rotateCamera(CAMERA_STEP);
    }
  });

  chatForm?.addEventListener('submit', (event) => {
    event.preventDefault();
    const message = String(chatInput?.value || '').trim();
    if (!message) return;
    if (sendRoomMessage({ type: 'room:chat', message })) {
      chatInput.value = '';
    }
  });

  syncRoomLayers({ floorPath: root.dataset.roomFloor || root.dataset.roomBackground || '', foregroundPath: root.dataset.roomForeground || '' });
  connectRoom();
  animate();
}
