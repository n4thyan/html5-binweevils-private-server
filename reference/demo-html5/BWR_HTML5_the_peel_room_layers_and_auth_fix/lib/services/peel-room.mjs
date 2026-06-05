import crypto from 'crypto';
import { clampRoomPosition, getRoomDefinition, roomSpawnForUser } from '../room-data.mjs';

const WS_GUID = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11';
const DEFAULT_ROOM_ID = 'the_peel';
const MAX_FEED = 28;
const CHAT_TTL_MS = 7000;

function compactAvatar(avatar = {}) {
  const def = /^\d{18}$/.test(String(avatar.weevilDef || '').trim()) ? String(avatar.weevilDef).trim() : '401135129001323200';
  return {
    weevilDef: def,
    expression: Number.parseInt(String(avatar.expression ?? '0'), 10) || 0,
    proboscis: Number.parseInt(String(avatar.proboscis ?? '0'), 10) || 0,
    hatId: Number.parseInt(String(avatar.hatId ?? '0'), 10) || 0,
    hatColour: Number.parseInt(String(avatar.hatColour ?? avatar.hatColor ?? '7620096'), 10) || 7620096,
    preferredRenderer: 'html5-canvas'
  };
}

function writeHttpError(socket, statusCode, text) {
  try {
    socket.write(`HTTP/1.1 ${statusCode} ${text}\r\nConnection: close\r\nContent-Type: text/plain; charset=utf-8\r\nContent-Length: ${Buffer.byteLength(text)}\r\n\r\n${text}`);
  } catch {}
  socket.destroy();
}

function socketAcceptValue(key) {
  return crypto.createHash('sha1').update(`${String(key || '')}${WS_GUID}`).digest('base64');
}

function encodeFrame(payload, opcode = 1) {
  const buffer = Buffer.isBuffer(payload) ? payload : Buffer.from(String(payload || ''), 'utf8');
  let header;
  if (buffer.length < 126) {
    header = Buffer.alloc(2);
    header[0] = 0x80 | opcode;
    header[1] = buffer.length;
  } else if (buffer.length < 65536) {
    header = Buffer.alloc(4);
    header[0] = 0x80 | opcode;
    header[1] = 126;
    header.writeUInt16BE(buffer.length, 2);
  } else {
    header = Buffer.alloc(10);
    header[0] = 0x80 | opcode;
    header[1] = 127;
    header.writeBigUInt64BE(BigInt(buffer.length), 2);
  }
  return Buffer.concat([header, buffer]);
}

function sendJson(socket, payload) {
  if (!socket || socket.destroyed || !payload) return;
  socket.write(encodeFrame(JSON.stringify(payload)));
}

function sendClose(socket, code = 1000, reason = '') {
  if (!socket || socket.destroyed) return;
  const reasonBuffer = Buffer.from(String(reason || '').slice(0, 120), 'utf8');
  const payload = Buffer.alloc(2 + reasonBuffer.length);
  payload.writeUInt16BE(code, 0);
  reasonBuffer.copy(payload, 2);
  try {
    socket.write(encodeFrame(payload, 0x8));
  } catch {}
  socket.end();
}

function parseFrames(socket, onMessage, onClose) {
  let buffer = Buffer.alloc(0);
  let closed = false;

  const finish = () => {
    if (closed) return;
    closed = true;
    onClose?.();
  };

  socket.on('data', (chunk) => {
    buffer = Buffer.concat([buffer, chunk]);
    while (buffer.length >= 2) {
      const first = buffer[0];
      const second = buffer[1];
      const opcode = first & 0x0f;
      const masked = Boolean(second & 0x80);
      let length = second & 0x7f;
      let offset = 2;

      if (length === 126) {
        if (buffer.length < offset + 2) return;
        length = buffer.readUInt16BE(offset);
        offset += 2;
      } else if (length === 127) {
        if (buffer.length < offset + 8) return;
        const bigLength = buffer.readBigUInt64BE(offset);
        if (bigLength > BigInt(2 ** 31)) {
          sendClose(socket, 1009, 'Payload too large');
          finish();
          return;
        }
        length = Number(bigLength);
        offset += 8;
      }

      const maskLength = masked ? 4 : 0;
      const frameLength = offset + maskLength + length;
      if (buffer.length < frameLength) return;

      let payload = buffer.subarray(offset + maskLength, frameLength);
      if (masked) {
        const mask = buffer.subarray(offset, offset + 4);
        payload = Buffer.from(payload);
        for (let index = 0; index < payload.length; index += 1) {
          payload[index] ^= mask[index % 4];
        }
      }
      buffer = buffer.subarray(frameLength);

      if (opcode === 0x8) {
        finish();
        socket.end();
        return;
      }
      if (opcode === 0x9) {
        socket.write(encodeFrame(payload, 0xA));
        continue;
      }
      if (opcode !== 0x1) continue;

      try {
        const parsed = JSON.parse(payload.toString('utf8'));
        onMessage?.(parsed);
      } catch {
        sendJson(socket, { type: 'room:notice', kind: 'error', message: 'A malformed room message was ignored.' });
      }
    }
  });

  socket.on('close', finish);
  socket.on('end', finish);
  socket.on('error', finish);
}

export function createPeelRoomService() {
  const room = getRoomDefinition(DEFAULT_ROOM_ID);
  const clients = new Map();
  const presence = new Map();
  const connectionCounts = new Map();
  const feed = [];

  function pushFeed(entry = {}) {
    feed.push({
      id: crypto.randomUUID(),
      type: entry.type || 'system',
      username: entry.username || 'System',
      text: String(entry.text || '').slice(0, 180),
      createdAt: new Date().toISOString()
    });
    while (feed.length > MAX_FEED) feed.shift();
  }

  function markPresence(user, options = {}) {
    const current = presence.get(user.id);
    const spawn = current
      ? { x: current.x, y: current.y }
      : roomSpawnForUser(user.id, room.id);
    const nextPosition = clampRoomPosition(
      room.id,
      options.x ?? current?.x ?? spawn.x,
      options.y ?? current?.y ?? spawn.y
    );
    const next = {
      userId: user.id,
      username: user.username,
      roomId: room.id,
      x: nextPosition.x,
      y: nextPosition.y,
      facing: options.facing || current?.facing || 'right',
      avatar: compactAvatar(options.avatar || current?.avatar || user.avatar || {}),
      chatText: options.chatText !== undefined ? options.chatText : (current?.chatText || ''),
      chatExpiresAt: options.chatExpiresAt !== undefined ? options.chatExpiresAt : (current?.chatExpiresAt || 0),
      connectedAt: current?.connectedAt || Date.now(),
      lastSeenAt: Date.now()
    };
    presence.set(user.id, next);
    return next;
  }

  function removePresence(userId, { silent = false } = {}) {
    const existing = presence.get(userId);
    if (!existing) return;
    presence.delete(userId);
    if (!silent) pushFeed({ type: 'leave', username: existing.username, text: `${existing.username} left The Peel.` });
  }

  function snapshotFor(viewerUserId = '') {
    const players = Array.from(presence.values())
      .sort((a, b) => a.y - b.y)
      .map((player) => ({
        userId: player.userId,
        username: player.username,
        roomId: room.id,
        x: player.x,
        y: player.y,
        facing: player.facing,
        avatar: compactAvatar(player.avatar),
        chatText: player.chatText || ''
      }));

    return {
      room: {
        currentRoomId: room.id,
        currentRoomName: room.name,
        roomSummary: room.summary,
        bounds: { ...room.bounds },
        players,
        feed: feed.slice(-18),
        playerCount: players.length,
        backgroundPath: room.backgroundPath,
        floorPath: room.floorPath || room.backgroundPath,
        foregroundPath: room.foregroundPath || ''
      },
      viewer: viewerUserId ? { userId: viewerUserId } : null
    };
  }

  function broadcast() {
    for (const [socket, client] of Array.from(clients.entries())) {
      if (!socket || socket.destroyed) {
        clients.delete(socket);
        continue;
      }
      sendJson(socket, { type: 'room:snapshot', payload: snapshotFor(client.userId) });
    }
  }

  function cleanupState() {
    let changed = false;
    const now = Date.now();
    for (const state of presence.values()) {
      if (state.chatText && state.chatExpiresAt && state.chatExpiresAt <= now) {
        state.chatText = '';
        state.chatExpiresAt = 0;
        changed = true;
      }
    }
    if (changed) broadcast();
  }

  const cleanupTimer = setInterval(cleanupState, 1000);
  cleanupTimer.unref?.();

  function updateAvatar(user, avatar) {
    if (!user) return;
    const existing = presence.get(user.id);
    if (!existing) return;
    existing.avatar = compactAvatar(avatar || user.avatar || {});
    existing.lastSeenAt = Date.now();
    presence.set(user.id, existing);
    broadcast();
  }

  function handleMove(user, payload = {}, socket) {
    const state = markPresence(user);
    const next = clampRoomPosition(room.id, payload.x, payload.y);
    const prevX = state.x;
    state.x = next.x;
    state.y = next.y;
    if (next.x < prevX) state.facing = 'left';
    else if (next.x > prevX) state.facing = 'right';
    state.lastSeenAt = Date.now();
    presence.set(user.id, state);
    broadcast();
    sendJson(socket, { type: 'room:ack', action: 'move', x: next.x, y: next.y });
  }

  function handleChat(user, payload = {}, socket) {
    const raw = String(payload.message || '').replace(/\s+/g, ' ').trim().slice(0, 160);
    if (!raw) {
      sendJson(socket, { type: 'room:notice', kind: 'error', message: 'Type a message before sending it.' });
      return;
    }
    if (raw.startsWith('/')) {
      sendJson(socket, { type: 'room:notice', kind: 'info', message: 'Slash commands are not live in The Peel yet. Plain chat is ready for testing.' });
      return;
    }
    const state = markPresence(user, { chatText: raw, chatExpiresAt: Date.now() + CHAT_TTL_MS });
    pushFeed({ type: 'chat', username: user.username, text: raw });
    presence.set(user.id, state);
    broadcast();
  }

  function registerConnection(user, socket) {
    const currentCount = connectionCounts.get(user.id) || 0;
    connectionCounts.set(user.id, currentCount + 1);
    const state = markPresence(user);
    if (currentCount === 0) {
      pushFeed({ type: 'join', username: user.username, text: `${user.username} arrived in The Peel.` });
    }
    clients.set(socket, { userId: user.id, username: user.username });
    broadcast();
    return state;
  }

  function unregisterConnection(user, socket) {
    clients.delete(socket);
    const nextCount = Math.max(0, (connectionCounts.get(user.id) || 0) - 1);
    if (nextCount === 0) {
      connectionCounts.delete(user.id);
      removePresence(user.id);
      broadcast();
      return;
    }
    connectionCounts.set(user.id, nextCount);
  }

  function handleUpgrade(req, socket, head, user) {
    if (!user) {
      writeHttpError(socket, 401, 'Sign in first.');
      return;
    }
    const key = req.headers['sec-websocket-key'];
    if (!key) {
      writeHttpError(socket, 400, 'Missing WebSocket key.');
      return;
    }

    socket.write([
      'HTTP/1.1 101 Switching Protocols',
      'Upgrade: websocket',
      'Connection: Upgrade',
      `Sec-WebSocket-Accept: ${socketAcceptValue(key)}`,
      '\r\n'
    ].join('\r\n'));

    if (head && head.length) socket.unshift(head);
    registerConnection(user, socket);
    sendJson(socket, { type: 'room:ready', payload: { roomId: room.id, roomName: room.name } });
    sendJson(socket, { type: 'room:snapshot', payload: snapshotFor(user.id) });

    parseFrames(
      socket,
      (message) => {
        if (!message || typeof message !== 'object') return;
        if (message.type === 'room:move') {
          handleMove(user, message, socket);
          return;
        }
        if (message.type === 'room:chat') {
          handleChat(user, message, socket);
          return;
        }
        if (message.type === 'room:ping') {
          sendJson(socket, { type: 'room:pong', payload: { now: Date.now() } });
        }
      },
      () => unregisterConnection(user, socket)
    );
  }

  function getAdminSnapshot() {
    return snapshotFor('').room;
  }

  return {
    room,
    handleUpgrade,
    updateAvatar,
    getAdminSnapshot,
    snapshotFor
  };
}
