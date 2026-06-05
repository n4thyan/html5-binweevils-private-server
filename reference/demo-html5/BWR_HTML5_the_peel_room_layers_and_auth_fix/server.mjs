import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import crypto from 'crypto';
import { bootstrapData, loadAllData, readJson, writeJson } from './lib/store.mjs';
import { hashPassword, verifyPassword, createSession, destroySession, getCurrentUser } from './lib/auth.mjs';
import { ROOM_WORLD, getRoomDefinition, clampRoomPosition, roomSpawnForUser, getPublicRoomConfig } from './lib/room-data.mjs';
import { defaultAvatar, avatarPayloadFromForm, normaliseAvatar, validateAvatarPayload, validateRegistration } from './lib/services/creator-service.mjs';
import { buildSessionState } from './lib/services/session-state.mjs';
import { createPeelRoomService } from './lib/services/peel-room.mjs';
import {
  renderHome,
  renderAuth,
  renderDownloads,
  renderCommunity,
  renderAbout,
  renderRules,
  renderProfile,
  renderWeevilStudio,
  renderRoom,
  renderAdmin,
  renderNewsFeed,
  renderNewsPost,
  renderHallOfShame,
  slugPath
} from './lib/render.mjs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ROOT_DIR = __dirname;
const PORT = Number(process.env.PORT || 3000);
const IS_PRODUCTION = String(process.env.NODE_ENV || '').toLowerCase() === 'production';
const TRUST_PROXY = ['1', 'true', 'yes', 'on'].includes(String(process.env.TRUST_PROXY || '').toLowerCase());
const PUBLIC_BASE_URL = String(process.env.PUBLIC_BASE_URL || process.env.SITE_ORIGIN || '').trim();
const ALLOW_FIRST_USER_ADMIN = ['1', 'true', 'yes', 'on'].includes(String(process.env.ALLOW_FIRST_USER_ADMIN || (IS_PRODUCTION ? 'false' : 'true')).toLowerCase());
const ENABLE_HSTS = ['1', 'true', 'yes', 'on'].includes(String(process.env.ENABLE_HSTS || (IS_PRODUCTION ? 'true' : 'false')).toLowerCase());

bootstrapData(ROOT_DIR);

const DEFAULT_AVATAR = Object.freeze(defaultAvatar());

const DEFAULT_POST_LOGIN_PATH = '/profile';
const DEFAULT_STUDIO_PATH = '/weevil-studio?next=%2Fprofile';
const roomClients = new Set();
const roomPresence = new Map();
const roomConnections = new Map();
const roomFeed = [];
const find4Challenges = [];
const find4Matches = new Map();
const FIND4_COLUMNS = 7;
const FIND4_ROWS = 6;

const ROOM_PUBLIC_CONFIG = getPublicRoomConfig();
const rateLimitBuckets = new Map();
const peelRoomService = createPeelRoomService();


function compactRoomAvatar(avatar = {}) {
  return {
    weevilDef: /^\d{18}$/.test(String(avatar.weevilDef || '')) ? String(avatar.weevilDef) : DEFAULT_AVATAR.weevilDef,
    expression: Number.parseInt(String(avatar.expression ?? '0'), 10) || 0,
    proboscis: Number.parseInt(String(avatar.proboscis ?? '0'), 10) || 0,
    hatId: Number.parseInt(String(avatar.hatId ?? '0'), 10) || 0,
    hatColour: Number.parseInt(String(avatar.hatColour ?? avatar.hatColor ?? DEFAULT_AVATAR.hatColour), 10) || DEFAULT_AVATAR.hatColour,
    preferredRenderer: ['pixi', 'html5-canvas'].includes(String(avatar.preferredRenderer || DEFAULT_AVATAR.preferredRenderer)) ? String(avatar.preferredRenderer || DEFAULT_AVATAR.preferredRenderer) : 'svg'
  };
}

function hasCustomAvatarSetup(user = {}) {
  const avatar = compactRoomAvatar(user.avatar || {});
  return Boolean(
    user.avatarConfigured
    || user.avatarUpdatedAt
    || avatar.weevilDef !== DEFAULT_AVATAR.weevilDef
    || avatar.expression !== DEFAULT_AVATAR.expression
    || avatar.proboscis !== DEFAULT_AVATAR.proboscis
    || avatar.hatId !== DEFAULT_AVATAR.hatId
    || avatar.hatColour !== DEFAULT_AVATAR.hatColour
    || avatar.preferredRenderer !== DEFAULT_AVATAR.preferredRenderer
  );
}

function safeNextPath(raw, fallback = '/profile') {
  const value = String(raw || '').trim();
  if (!value) return fallback;
  if (!value.startsWith('/')) return fallback;
  if (value.startsWith('//')) return fallback;
  if (!/^\/[a-zA-Z0-9\-._~!$&'()*+,;=:@/?%]*$/.test(value)) return fallback;
  return value;
}

function withFlash(pathname, params = {}) {
  const search = new URLSearchParams();
  for (const [key, value] of Object.entries(params)) {
    if (value === undefined || value === null || value === '') continue;
    search.set(key, String(value));
  }
  const query = search.toString();
  return query ? `${pathname}?${query}` : pathname;
}

function pushRoomFeed(entry) {
  roomFeed.push({
    id: crypto.randomUUID(),
    createdAt: new Date().toISOString(),
    roomId: entry.roomId || '',
    ...entry
  });
  while (roomFeed.length > 40) roomFeed.shift();
}

function find4CreateBoard() {
  return Array.from({ length: FIND4_ROWS }, () => Array(FIND4_COLUMNS).fill(0));
}

function find4DropDisc(board, column, disc) {
  const safeColumn = Math.max(0, Math.min(FIND4_COLUMNS - 1, Number.parseInt(String(column), 10)));
  for (let row = FIND4_ROWS - 1; row >= 0; row -= 1) {
    if (!board[row][safeColumn]) {
      board[row][safeColumn] = disc;
      return { row, column: safeColumn };
    }
  }
  return null;
}

function find4WinningCells(board, row, column, disc) {
  const directions = [
    [[0, -1], [0, 1]],
    [[-1, 0], [1, 0]],
    [[-1, -1], [1, 1]],
    [[-1, 1], [1, -1]]
  ];
  for (const direction of directions) {
    const cells = [{ row, column }];
    for (const [dy, dx] of direction) {
      let nextRow = row + dy;
      let nextColumn = column + dx;
      while (
        nextRow >= 0 && nextRow < FIND4_ROWS
        && nextColumn >= 0 && nextColumn < FIND4_COLUMNS
        && board[nextRow][nextColumn] === disc
      ) {
        cells.push({ row: nextRow, column: nextColumn });
        nextRow += dy;
        nextColumn += dx;
      }
    }
    if (cells.length >= 4) return cells;
  }
  return null;
}

function find4IsBoardFull(board) {
  return board.every((row) => row.every(Boolean));
}

function cleanupFind4(now = Date.now()) {
  let changed = false;
  for (let index = find4Challenges.length - 1; index >= 0; index -= 1) {
    const challenge = find4Challenges[index];
    if (now - Number(challenge.createdAtMs || 0) > 120000) {
      find4Challenges.splice(index, 1);
      changed = true;
    }
  }
  for (const [matchId, match] of Array.from(find4Matches.entries())) {
    if (match.status === 'finished' && now - Number(match.updatedAtMs || 0) > 15 * 60_000) {
      find4Matches.delete(matchId);
      changed = true;
    }
  }
  return changed;
}

function getFind4MatchByUserId(userId) {
  for (const match of find4Matches.values()) {
    if (match.playerIds.includes(userId) && match.status !== 'archived') return match;
  }
  return null;
}

function sanitizeFind4MatchForUser(match, viewerUserId) {
  if (!match || !match.playerIds.includes(viewerUserId)) return null;
  const yourDisc = match.playerIds[0] === viewerUserId ? 1 : 2;
  const opponentIndex = yourDisc === 1 ? 1 : 0;
  const rematchRequestedUserIds = Array.isArray(match.rematchRequestedUserIds) ? match.rematchRequestedUserIds : [];
  return {
    id: match.id,
    status: match.status,
    playerIds: match.playerIds.slice(),
    playerUsernames: match.playerUsernames.slice(),
    yourDisc,
    opponentUserId: match.playerIds[opponentIndex],
    opponentUsername: match.playerUsernames[opponentIndex],
    turnUserId: match.turnUserId,
    winnerUserId: match.winnerUserId || '',
    board: match.board.map((row) => row.slice()),
    winningCells: Array.isArray(match.winningCells) ? match.winningCells.map((cell) => ({ row: cell.row, column: cell.column })) : [],
    lastMove: match.lastMove ? { ...match.lastMove } : null,
    createdAt: match.createdAt,
    updatedAt: match.updatedAt,
    rematchRequestedByYou: rematchRequestedUserIds.includes(viewerUserId),
    rematchRequestedByOpponent: rematchRequestedUserIds.includes(match.playerIds[opponentIndex])
  };
}

function serializeFind4ForUser(viewerUserId) {
  const activeMatch = getFind4MatchByUserId(viewerUserId);
  const incomingChallenges = find4Challenges
    .filter((challenge) => challenge.toUserId === viewerUserId)
    .map((challenge) => ({
      id: challenge.id,
      fromUserId: challenge.fromUserId,
      fromUsername: challenge.fromUsername,
      createdAt: challenge.createdAt
    }));
  const outgoingChallenges = find4Challenges
    .filter((challenge) => challenge.fromUserId === viewerUserId)
    .map((challenge) => ({
      id: challenge.id,
      toUserId: challenge.toUserId,
      toUsername: challenge.toUsername,
      createdAt: challenge.createdAt
    }));
  return {
    activeMatch: sanitizeFind4MatchForUser(activeMatch, viewerUserId),
    incomingChallenges,
    outgoingChallenges,
    canChallenge: !activeMatch
  };
}

function snapshotRoom(viewerUserId = '') {
  const now = Date.now();
  let changed = false;
  for (const presence of roomPresence.values()) {
    if (presence.chatText && presence.chatExpiresAt && presence.chatExpiresAt <= now) {
      presence.chatText = '';
      presence.chatExpiresAt = 0;
      changed = true;
    }
  }
  if (cleanupFind4(now)) changed = true;

  const viewerPresence = viewerUserId ? roomPresence.get(viewerUserId) : null;
  const viewerRoomId = viewerPresence?.roomId || ROOM_PUBLIC_CONFIG.defaultRoomId;
  const viewerRoom = getRoomDefinition(viewerRoomId);
  const visiblePlayers = Array.from(roomPresence.values())
    .filter((presence) => !viewerUserId || presence.roomId === viewerRoomId)
    .sort((a, b) => a.y - b.y)
    .map((presence) => ({
      userId: presence.userId,
      username: presence.username,
      roomId: presence.roomId || ROOM_PUBLIC_CONFIG.defaultRoomId,
      x: presence.x,
      y: presence.y,
      facing: presence.facing || 'right',
      avatar: compactRoomAvatar(presence.avatar),
      chatText: presence.chatText || '',
      isPlayingFind4: Boolean(getFind4MatchByUserId(presence.userId)?.status === 'active')
    }));
  const visibleFeed = roomFeed
    .filter((entry) => !viewerUserId || !entry.roomId || entry.roomId === viewerRoomId)
    .slice(-18);

  return {
    ok: true,
    room: {
      width: ROOM_WORLD.width,
      height: ROOM_WORLD.height,
      currentRoomId: viewerRoom.id,
      currentRoomName: viewerRoom.name,
      currentRoomBackground: viewerRoom.backgroundPath,
      players: visiblePlayers,
      feed: visibleFeed
    },
    find4: viewerUserId ? serializeFind4ForUser(viewerUserId) : null,
    changed
  };
}

function broadcastRoom() {
  for (const client of Array.from(roomClients)) {
    try {
      client.res.write(`data: ${JSON.stringify(snapshotRoom(client.userId))}

`);
    } catch {
      roomClients.delete(client);
    }
  }
}

function markRoomPresence(user, options = {}) {
  const current = roomPresence.get(user.id);
  const desiredRoom = getRoomDefinition(options.roomId || current?.roomId || user.lastRoomId || ROOM_PUBLIC_CONFIG.defaultRoomId).id;
  const roomChanged = Boolean(current && current.roomId !== desiredRoom);
  const spawn = current && !roomChanged ? { x: current.x, y: current.y } : roomSpawnForUser(user.id, desiredRoom);
  const coords = clampRoomPosition(desiredRoom, options.x ?? spawn.x, options.y ?? spawn.y);
  const next = {
    userId: user.id,
    username: user.username,
    avatar: compactRoomAvatar(user.avatar || {}),
    roomId: desiredRoom,
    x: coords.x,
    y: coords.y,
    facing: options.facing || current?.facing || 'right',
    chatText: roomChanged ? '' : (current?.chatText || ''),
    chatExpiresAt: roomChanged ? 0 : (current?.chatExpiresAt || 0),
    lastSeenAt: Date.now()
  };
  roomPresence.set(user.id, next);
  if (!current) {
    pushRoomFeed({ roomId: desiredRoom, type: 'join', username: user.username, text: `${user.username} joined the room.` });
  } else if (roomChanged) {
    pushRoomFeed({ roomId: current.roomId || ROOM_PUBLIC_CONFIG.defaultRoomId, type: 'leave', username: user.username, text: `${user.username} left the room.` });
    pushRoomFeed({ roomId: desiredRoom, type: 'join', username: user.username, text: `${user.username} joined the room.` });
  }
  return next;
}

function removeRoomPresence(userId, reason = 'left') {
  const existing = roomPresence.get(userId);
  if (!existing) return;
  roomPresence.delete(userId);
  if (reason !== 'silent') {
    pushRoomFeed({ roomId: existing.roomId || ROOM_PUBLIC_CONFIG.defaultRoomId, type: 'leave', username: existing.username, text: `${existing.username} left the room.` });
  }
}

function bumpRoomConnection(userId, delta) {
  const next = Math.max(0, (roomConnections.get(userId) || 0) + delta);
  if (next === 0) roomConnections.delete(userId);
  else roomConnections.set(userId, next);
  return next;
}

setInterval(() => {
  const now = Date.now();
  let changed = false;
  for (const [userId, presence] of Array.from(roomPresence.entries())) {
    if (presence.chatText && presence.chatExpiresAt && presence.chatExpiresAt <= now) {
      presence.chatText = '';
      presence.chatExpiresAt = 0;
      changed = true;
    }
    const activeConnections = roomConnections.get(userId) || 0;
    if (activeConnections <= 0 && now - presence.lastSeenAt > 12000) {
      removeRoomPresence(userId);
      changed = true;
    }
  }
  if (cleanupFind4(now)) changed = true;
  if (changed) broadcastRoom();
}, 3000).unref();

function cleanupRateLimitBucket(bucket, now) {
  while (bucket.length && bucket[0] <= now) bucket.shift();
}

function getClientIp(req) {
  if (TRUST_PROXY) {
    const cfIp = String(req.headers['cf-connecting-ip'] || '').trim();
    if (cfIp) return cfIp;
    const forwarded = String(req.headers['x-forwarded-for'] || '').split(',').map((part) => part.trim()).filter(Boolean);
    if (forwarded.length) return forwarded[0];
  }
  return String(req.socket?.remoteAddress || req.headers['x-real-ip'] || 'unknown');
}

function enforceRateLimit(req, res, scope, { limit, windowMs, message, asJson = false } = {}) {
  if (!limit || !windowMs) return true;
  const now = Date.now();
  const key = `${scope}:${getClientIp(req)}`;
  const bucket = rateLimitBuckets.get(key) || [];
  cleanupRateLimitBucket(bucket, now - windowMs);
  if (bucket.length >= limit) {
    const retryAfterSeconds = Math.max(1, Math.ceil((bucket[0] + windowMs - now) / 1000));
    if (asJson) return sendJson(res, 429, { ok: false, error: message || 'Too many requests. Slow down and try again shortly.' }, { 'Retry-After': String(retryAfterSeconds) }), false;
    return redirect(res, withFlash('/login', { error: message || 'Too many requests. Slow down and try again shortly.' })), false;
  }
  bucket.push(now);
  rateLimitBuckets.set(key, bucket);
  return true;
}

function sameOriginValue(raw) {
  if (!raw) return '';
  try {
    return new URL(String(raw)).origin;
  } catch {
    return '';
  }
}

function allowedOriginsForRequest(req) {
  const origins = new Set();
  if (PUBLIC_BASE_URL) origins.add(sameOriginValue(PUBLIC_BASE_URL));
  const host = String(req.headers.host || '').trim();
  if (host) {
    origins.add(`http://${host}`);
    origins.add(`https://${host}`);
  }
  return Array.from(origins).filter(Boolean);
}

function enforceSameOrigin(req, res, { asJson = false, redirectPath = '/login', message = 'This request was blocked because the origin check failed.' } = {}) {
  const candidates = [sameOriginValue(req.headers.origin), sameOriginValue(req.headers.referer)].filter(Boolean);
  const allowed = allowedOriginsForRequest(req);
  const ok = !candidates.length || candidates.some((entry) => allowed.includes(entry));
  if (ok) return true;
  if (asJson) return sendJson(res, 403, { ok: false, error: message }), false;
  return redirect(res, withFlash(redirectPath, { error: message })), false;
}

function rateLimitRedirect(req, res, scope, redirectPath, message, limit, windowMs) {
  const now = Date.now();
  const key = `${scope}:${getClientIp(req)}`;
  const bucket = rateLimitBuckets.get(key) || [];
  cleanupRateLimitBucket(bucket, now - windowMs);
  if (bucket.length >= limit) {
    return redirect(res, withFlash(redirectPath, { error: message || 'Too many requests. Slow down and try again shortly.' })), false;
  }
  bucket.push(now);
  rateLimitBuckets.set(key, bucket);
  return true;
}

function parseUrl(req) {
  return new URL(req.url, `http://${req.headers.host || `localhost:${PORT}`}`);
}

function readBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', (chunk) => {
      body += chunk;
      if (body.length > 1_000_000) {
        reject(new Error('Request body too large.'));
        req.destroy();
      }
    });
    req.on('end', () => {
      const contentType = String(req.headers['content-type'] || '').toLowerCase();
      if (contentType.includes('application/json')) {
        try {
          const parsed = body ? JSON.parse(body) : {};
          const params = new URLSearchParams();
          for (const [key, value] of Object.entries(parsed || {})) {
            if (value === undefined || value === null) continue;
            params.set(key, typeof value === 'object' ? JSON.stringify(value) : String(value));
          }
          return resolve(params);
        } catch {
          return reject(new Error('Invalid JSON body.'));
        }
      }
      return resolve(new URLSearchParams(body));
    });
    req.on('error', reject);
  });
}

function commonHeaders(extra = {}) {
  return {
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'SAMEORIGIN',
    'Referrer-Policy': 'strict-origin-when-cross-origin',
    'Permissions-Policy': 'camera=(), microphone=(), geolocation=(), payment=(), usb=()',
    'Cross-Origin-Resource-Policy': 'same-origin',
    'Cross-Origin-Opener-Policy': 'same-origin',
    'X-Robots-Tag': 'noindex, nofollow, noarchive, nosnippet, noimageindex',
    ...(ENABLE_HSTS ? { 'Strict-Transport-Security': 'max-age=15552000; includeSubDomains' } : {}),
    ...extra
  };
}

function htmlHeaders(extra = {}) {
  return commonHeaders({
    'Content-Type': 'text/html; charset=utf-8',
    'Cache-Control': 'no-store',
    'Content-Security-Policy': "default-src 'self'; img-src 'self' data: https:; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline'; font-src 'self' data:; connect-src 'self' ws: wss:; media-src 'self'; object-src 'none'; base-uri 'self'; frame-ancestors 'self'; form-action 'self'",
    ...extra
  });
}

function send(res, status, body, headers = {}) {
  res.writeHead(status, htmlHeaders(headers));
  res.end(body);
}

function sendJson(res, status, payload, headers = {}) {
  res.writeHead(status, commonHeaders({ 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store', ...headers }));
  res.end(JSON.stringify(payload));
}

function redirect(res, location) {
  res.writeHead(302, commonHeaders({ Location: location, 'Cache-Control': 'no-store' }));
  res.end();
}

function inferContentType(filePath) {
  const lower = filePath.toLowerCase();
  const mapping = [
    ['.css', 'text/css; charset=utf-8'],
    ['.js', 'application/javascript; charset=utf-8'],
    ['.png', 'image/png'],
    ['.jpg', 'image/jpeg'],
    ['.jpeg', 'image/jpeg'],
    ['.gif', 'image/gif'],
    ['.svg', 'image/svg+xml'],
    ['.ico', 'image/x-icon'],
    ['.webp', 'image/webp'],
    ['.mp4', 'video/mp4'],
    ['.woff2', 'font/woff2'],
    ['.woff', 'font/woff'],
    ['.ttf', 'font/ttf'],
    ['.otf', 'font/otf'],
    ['.eot', 'application/vnd.ms-fontobject'],
    ['.html', 'text/html; charset=utf-8']
  ];

  for (const [ext, type] of mapping) {
    if (lower.endsWith(ext) || lower.includes(`${ext}__`) || lower.includes(`${ext}?`) || lower.includes(`${ext}&`)) {
      return type;
    }
  }

  return 'application/octet-stream';
}

function serveStatic(res, filePath) {
  if (!fs.existsSync(filePath) || fs.statSync(filePath).isDirectory()) {
    send(res, 404, '<h1>Not found</h1>');
    return;
  }
  res.writeHead(200, commonHeaders({ 'Content-Type': inferContentType(filePath), 'Cache-Control': 'public, max-age=3600' }));
  fs.createReadStream(filePath).pipe(res);
}

function dataFile(name) {
  return path.join(ROOT_DIR, 'data', name);
}

function loadSiteState() {
  const { officialPosts, mirrorPosts, comments, users, site } = loadAllData(ROOT_DIR);
  const posts = [...mirrorPosts, ...officialPosts]
    .sort((a, b) => (b.publishedAt || '').localeCompare(a.publishedAt || ''))
    .map((post) => ({
      ...post,
      commentCount: comments.filter((comment) => comment.postSlug === post.slug).length
    }));

  return { posts, comments, users, site };
}

function getPostComments(postSlug, comments, users, posts) {
  return comments
    .filter((comment) => comment.postSlug === postSlug)
    .sort((a, b) => a.createdAt.localeCompare(b.createdAt))
    .map((comment) => {
      const user = users.find((entry) => entry.id === comment.userId);
      const post = posts.find((entry) => entry.slug === comment.postSlug);
      return {
        ...comment,
        username: user?.username || comment.username || 'Unknown',
        postTitle: post?.title || comment.postSlug
      };
    });
}

function parseMessage(url) {
  return url.searchParams.get('message') || '';
}

function parseError(url) {
  return url.searchParams.get('error') || '';
}

function parseNext(url, fallback = DEFAULT_POST_LOGIN_PATH) {
  return safeNextPath(url.searchParams.get('next'), fallback);
}

function postLoginPathForUser(user, requestedPath = DEFAULT_POST_LOGIN_PATH) {
  const cleanRequested = safeNextPath(requestedPath, DEFAULT_POST_LOGIN_PATH);
  if (cleanRequested !== '/profile') return cleanRequested;
  return hasCustomAvatarSetup(user) ? DEFAULT_POST_LOGIN_PATH : DEFAULT_STUDIO_PATH;
}

function validateUsername(value) {
  return /^[a-zA-Z0-9_-]{3,24}$/.test(value);
}

function normaliseRole(value = 'user') {
  return String(value || '').toLowerCase() === 'admin' ? 'admin' : 'user';
}

function configuredAdminUsernames(site = {}) {
  const siteList = Array.isArray(site.adminUsernames) ? site.adminUsernames : [];
  const envList = String(process.env.ADMIN_USERNAMES || '')
    .split(',')
    .map((value) => value.trim().toLowerCase())
    .filter(Boolean);
  return new Set([...siteList, ...envList].map((value) => String(value || '').trim().toLowerCase()).filter(Boolean));
}

function isAdminUser(user, site = {}) {
  if (!user) return false;
  if (normaliseRole(user.role) === 'admin') return true;
  return configuredAdminUsernames(site).has(String(user.username || '').toLowerCase());
}

function decorateUser(user, site = {}) {
  if (!user) return null;
  return {
    ...user,
    role: normaliseRole(user.role),
    isAdmin: isAdminUser(user, site),
    isMuted: Boolean(user.isMuted),
    isBanned: Boolean(user.isBanned)
  };
}

function ensureAdminBootstrapForNewUser({ users = [], site = {}, username = '' }) {
  const lower = String(username || '').toLowerCase();
  const configuredAdmins = configuredAdminUsernames(site);
  if (configuredAdmins.has(lower)) return true;
  if (!users.some((entry) => isAdminUser(entry, site))) return ALLOW_FIRST_USER_ADMIN;
  return false;
}

function requireAdminOrRedirect(currentUser, site, req, res) {
  if (!currentUser) {
    redirect(res, withFlash('/login', { error: 'Sign in with an admin account first.', next: '/admin' }));
    return false;
  }
  if (!isAdminUser(currentUser, site)) {
    send(res, 403, '<h1>Admin only</h1>');
    return false;
  }
  return true;
}

function collectAdminView({ users = [], comments = [], posts = [] }, currentUser, site) {
  const room = peelRoomService.getAdminSnapshot();
  const decoratedUsers = users
    .slice()
    .sort((a, b) => String(a.username || '').localeCompare(String(b.username || '')))
    .map((entry) => ({
      ...decorateUser(entry, site),
      canEditRole: entry.id !== currentUser?.id,
      canModerate: entry.id !== currentUser?.id
    }));
  const recentComments = comments
    .slice()
    .sort((a, b) => String(b.createdAt || '').localeCompare(String(a.createdAt || '')))
    .slice(0, 18)
    .map((comment) => {
      const post = posts.find((entry) => entry.slug === comment.postSlug);
      return { ...comment, postTitle: post?.title || comment.postSlug };
    });
  const mirrorPosts = posts
    .filter((entry) => entry.type === 'mirror')
    .slice()
    .sort((a, b) => String(b.publishedAt || '').localeCompare(String(a.publishedAt || '')))
    .slice(0, 12);
  const stats = {
    users: users.length,
    admins: users.filter((entry) => isAdminUser(entry, site)).length,
    comments: comments.length,
    roomPlayers: room.players.length,
    mirrorPosts: mirrorPosts.length
  };
  return { stats, users: decoratedUsers, comments: recentComments, room, posts: mirrorPosts };
}

function escapeHtmlText(value) {
  return String(value || '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

function createSlug(value, fallback = 'mirror-post') {
  const slug = String(value || '')
    .toLowerCase()
    .replace(/&/g, ' and ')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 96);
  return slug || fallback;
}

function normaliseLookup(value = '') {
  return String(value || '').toLowerCase().replace(/[^a-z0-9]+/g, '');
}

function resolveUserByName(users = [], rawQuery = '', { roomId = '', requirePresence = false } = {}) {
  const query = String(rawQuery || '').trim().replace(/^@+/, '');
  if (!query) return null;
  const queryLower = query.toLowerCase();
  const queryNorm = normaliseLookup(query);
  let pool = users.slice();
  if (roomId) {
    const roomUserIds = new Set(Array.from(roomPresence.values()).filter((presence) => presence.roomId === roomId).map((presence) => presence.userId));
    pool = pool.filter((entry) => roomUserIds.has(entry.id));
  }
  if (requirePresence) {
    const presentIds = new Set(Array.from(roomPresence.values()).map((presence) => presence.userId));
    pool = pool.filter((entry) => presentIds.has(entry.id));
  }
  const exact = pool.find((entry) => String(entry.username || '').toLowerCase() === queryLower);
  if (exact) return exact;
  const exactNorm = pool.find((entry) => normaliseLookup(entry.username) === queryNorm);
  if (exactNorm) return exactNorm;
  const starts = pool.filter((entry) => String(entry.username || '').toLowerCase().startsWith(queryLower) || normaliseLookup(entry.username).startsWith(queryNorm));
  if (starts.length === 1) return starts[0];
  return null;
}

function resolveRoomByQuery(rawQuery = '') {
  const query = String(rawQuery || '').trim();
  if (!query) return null;
  const queryLower = query.toLowerCase();
  const queryNorm = normaliseLookup(query);
  const rooms = ROOM_PUBLIC_CONFIG.maps || [];
  return rooms.find((room) => room.id === queryLower)
    || rooms.find((room) => room.name.toLowerCase() === queryLower)
    || rooms.find((room) => normaliseLookup(room.name) === queryNorm)
    || rooms.find((room) => room.name.toLowerCase().includes(queryLower) || room.id.includes(queryLower) || normaliseLookup(room.name).includes(queryNorm))
    || null;
}

function plainTextToHtml(raw = '') {
  const value = String(raw || '').replace(/\r/g, '').trim();
  if (!value) return '';
  return value
    .split(/\n{2,}/)
    .map((paragraph) => `<p>${escapeHtmlText(paragraph).replace(/\n/g, '<br>')}</p>`)
    .join('\n');
}

function buildMirrorPostFromForm(form, currentUserView) {
  const title = String(form.get('title') || '').trim().slice(0, 140);
  const intro = String(form.get('intro') || '').trim().slice(0, 1200);
  const body = String(form.get('body') || '').trim().slice(0, 20000);
  const author = String(form.get('author') || '').trim().slice(0, 80) || currentUserView.username;
  const thumbnail = String(form.get('thumbnail') || '').trim().slice(0, 500);
  const sourceUrl = String(form.get('sourceUrl') || '').trim().slice(0, 500);
  const originLabel = String(form.get('originLabel') || '').trim().slice(0, 80) || 'Project update';
  const requestedDate = String(form.get('publishedAt') || '').trim();
  const publishedAt = /^\d{4}-\d{2}-\d{2}$/.test(requestedDate) ? requestedDate : new Date().toISOString().slice(0, 10);
  if (!title) return { ok: false, error: 'Give the post a title first.' };
  if (!intro) return { ok: false, error: 'Add a short intro for the feed card.' };
  if (!body) return { ok: false, error: 'Add the full post body first.' };
  return {
    ok: true,
    post: {
      slug: createSlug(title),
      title,
      author,
      publishedAt,
      originalDateText: publishedAt.split('-').reverse().join('/'),
      introHtml: plainTextToHtml(intro),
      thumbnail,
      contentHtml: `<div class="mirror-post-body">
${plainTextToHtml(body)}
</div>`,
      sourceUrl,
      originLabel,
      type: 'mirror'
    }
  };
}

function createFind4ChallengeForUsers({ fromUser, toUser, roomId }) {
  const challenge = {
    roomId: roomId || ROOM_PUBLIC_CONFIG.defaultRoomId,
    id: crypto.randomUUID(),
    fromUserId: fromUser.id,
    fromUsername: fromUser.username,
    toUserId: toUser.id,
    toUsername: toUser.username,
    createdAt: new Date().toISOString(),
    createdAtMs: Date.now()
  };
  find4Challenges.push(challenge);
  pushRoomFeed({ roomId: challenge.roomId, type: 'game', username: fromUser.username, text: `${fromUser.username} challenged ${toUser.username} to Find4.` });
  broadcastRoom();
  return challenge;
}

const server = http.createServer(async (req, res) => {
  try {
    const url = parseUrl(req);
    const pathname = decodeURIComponent(url.pathname);
    const currentUser = getCurrentUser(ROOT_DIR, req);

    if (pathname.startsWith('/css/')) {
      return serveStatic(res, path.join(ROOT_DIR, 'public', pathname.slice(1)));
    }

    if (pathname.startsWith('/js/')) {
      return serveStatic(res, path.join(ROOT_DIR, 'public', pathname.slice(1)));
    }

    if (pathname === '/weevil-creator' || pathname.startsWith('/weevil-creator/')) {
      const relative = pathname === '/weevil-creator' ? 'index.html' : pathname.slice('/weevil-creator/'.length);
      const safePath = path.normalize(relative).replace(/^(\.\.[/\\])+/, '');
      return serveStatic(res, path.join(ROOT_DIR, 'public', 'weevil-creator', safePath));
    }

    if (pathname.startsWith('/img/')) {
      return serveStatic(res, path.join(ROOT_DIR, 'public', pathname.slice(1)));
    }

    if (pathname.startsWith('/mirror-src/')) {
      const unsafe = pathname.replace('/mirror-src/', '');
      const safePath = path.normalize(unsafe).replace(/^(\.\.[/\\])+/, '');
      return serveStatic(res, path.join(ROOT_DIR, 'vendor', safePath));
    }

    if (req.method === 'GET' && pathname === '/robots.txt') {
      return serveStatic(res, path.join(ROOT_DIR, 'public', 'robots.txt'));
    }

    if (req.method === 'GET' && pathname === '/security.txt') {
      return serveStatic(res, path.join(ROOT_DIR, 'public', 'security.txt'));
    }

    if (req.method === 'GET' && pathname === '/.well-known/security.txt') {
      return serveStatic(res, path.join(ROOT_DIR, 'public', '.well-known', 'security.txt'));
    }

    const { posts, comments, users, site } = loadSiteState();
    const activeUser = currentUser ? users.find((entry) => entry.id === currentUser.id) || currentUser : null;
    const currentUserView = decorateUser(activeUser, site);

    if (currentUserView?.isBanned && pathname !== '/logout') {
      destroySession(ROOT_DIR, req, res);
      return redirect(res, withFlash('/login', { error: 'This account has been banned from Bin Weevils Rewritten.' }));
    }

    if (req.method === 'GET' && pathname === '/') {
      return send(res, 200, renderHome({ user: currentUserView, posts }));
    }

    if (req.method === 'GET' && pathname === '/login') {
      const nextPath = parseNext(url, DEFAULT_POST_LOGIN_PATH);
      const formHtml = `
      <form action="/login" id="login-form" method="POST">
        <input type="hidden" name="next" value="${nextPath}">
        <div class="formContainer">
          <div class="nameLabel"><img src="/mirror-src/official-mirror/binweevils.app/assets/register/images/username.png" alt=""></div>
          <div class="nameText"><input autocomplete="off" class="userInput" id="username" name="username" type="text" value=""></div>
          <div class="passLabel"><img src="/mirror-src/official-mirror/binweevils.app/assets/register/images/password.png" alt=""></div>
          <div class="passText"><input class="passInput" id="password" name="password" type="password" value=""></div>
          <div class="rememberMeContainer"><div class="rememberMeText">Website account login · creator, profile and comments</div></div>
          <div class="loginBtn"><button class="mirror-submit" type="submit">Sign in</button></div>
        </div>
      </form>`;
      return send(res, 200, renderAuth({ mode: 'login', user: currentUserView, message: parseMessage(url), error: parseError(url), formHtml }));
    }

    if (req.method === 'POST' && pathname === '/login') {
      if (!enforceSameOrigin(req, res, { redirectPath: '/login', message: 'This sign-in request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!rateLimitRedirect(req, res, 'login', '/login', 'Too many sign-in attempts. Slow down and try again shortly.', 10, 10 * 60_000)) return;
      const form = await readBody(req);
      const username = String(form.get('username') || '').trim();
      const password = String(form.get('password') || '');
      const nextPath = safeNextPath(form.get('next'), DEFAULT_POST_LOGIN_PATH);
      const loginKey = username.toLowerCase();
      const byUsername = users.find((user) => user.username.toLowerCase() === loginKey);
      const emailMatches = users.filter((user) => String(user.email || '').toLowerCase() === loginKey);
      const account = byUsername || (emailMatches.length === 1 ? emailMatches[0] : null);

      if (!account || !verifyPassword(password, account.passwordSalt, account.passwordHash)) {
        return redirect(res, withFlash('/login', {
          error: 'We could not find an account with those details.',
          next: nextPath
        }));
      }
      if (Boolean(account.isBanned)) {
        return redirect(res, withFlash('/login', {
          error: 'That account has been banned from Bin Weevils Rewritten.',
          next: nextPath
        }));
      }

      createSession(ROOT_DIR, account, res);
      const redirectPath = postLoginPathForUser(account, nextPath);
      return redirect(res, withFlash(redirectPath, { message: 'You are now signed in.' }));
    }

    if (req.method === 'GET' && pathname === '/register') {
      if (currentUserView) return redirect(res, withFlash('/weevil-studio', { message: 'You are already signed in. Open the creator to edit your existing weevil instead.', next: parseNext(url, DEFAULT_POST_LOGIN_PATH) }));
      return send(res, 200, renderWeevilStudio({
        user: null,
        message: parseMessage(url),
        error: parseError(url),
        nextPath: parseNext(url, DEFAULT_POST_LOGIN_PATH),
        mode: 'register'
      }));
    }

    if (req.method === 'POST' && pathname === '/register') {
      return redirect(res, withFlash('/register', { error: 'Registration now happens through the HTML5 creator on this page.' }));
    }

    if (req.method === 'GET' && pathname === '/logout') {
      if (currentUser) destroySession(ROOT_DIR, req, res);
      return redirect(res, '/?message=Signed+out+successfully');
    }

    if (req.method === 'GET' && pathname === '/downloads') {
      return send(res, 200, renderDownloads({ user: currentUserView, site }));
    }

    if (req.method === 'GET' && pathname === '/community') {
      return send(res, 200, renderCommunity({ user: currentUserView }));
    }

    if (req.method === 'GET' && (pathname === '/hall-of-shame' || pathname === '/hall')) {
      const entries = readJson(dataFile('hall-of-shame.json'), []);
      return send(res, 200, renderHallOfShame({ user: currentUserView, entries }));
    }

    if (req.method === 'GET' && pathname === '/about') {
      return send(res, 200, renderAbout({ user: currentUserView }));
    }

    if (req.method === 'GET' && pathname === '/rules') {
      return send(res, 200, renderRules({ user: currentUserView }));
    }

    if (req.method === 'GET' && pathname === '/profile') {
      if (!currentUserView) return redirect(res, withFlash('/login', { error: 'Sign in to open your account page.', next: '/profile' }));
      const recentComments = comments
        .filter((comment) => comment.userId === currentUserView.id)
        .sort((a, b) => b.createdAt.localeCompare(a.createdAt))
        .map((comment) => {
          const post = posts.find((entry) => entry.slug === comment.postSlug);
          return { ...comment, postTitle: post?.title || comment.postSlug };
        });
      return send(res, 200, renderProfile({ user: currentUserView, comments: recentComments, message: parseMessage(url), error: parseError(url) }));
    }

    if (req.method === 'POST' && pathname === '/profile') {
      if (!currentUserView) return redirect(res, '/login?error=Sign+in+to+edit+your+account+page.');
      if (!enforceSameOrigin(req, res, { redirectPath: '/profile', message: 'Profile updates must come from the Bin Weevils Rewritten site.' })) return;
      if (!rateLimitRedirect(req, res, 'profile', '/profile', 'You are updating your profile too quickly. Please wait a moment.', 20, 10 * 60_000)) return;
      const form = await readBody(req);
      const bio = String(form.get('bio') || '').trim().slice(0, 500);
      const nextUsers = users.map((user) => user.id === currentUserView.id ? { ...user, bio } : user);
      writeJson(dataFile('users.json'), nextUsers);
      return redirect(res, '/profile?message=Profile+saved+successfully.');
    }


    if (req.method === 'GET' && pathname === '/weevil-studio') {
      if (!currentUserView) return redirect(res, withFlash('/login', { error: 'Sign in to open the HTML5 creator.', next: '/weevil-studio' }));
      return send(res, 200, renderWeevilStudio({
        user: currentUserView,
        message: parseMessage(url),
        error: parseError(url),
        nextPath: parseNext(url, '/profile'),
        mode: 'edit'
      }));
    }

    if (req.method === 'GET' && (pathname === '/room' || pathname === '/the-peel')) {
      if (!currentUserView) return redirect(res, withFlash('/login', { error: 'Sign in to open the chatroom.', next: '/room' }));
      if (!hasCustomAvatarSetup(currentUserView)) {
        return redirect(res, withFlash('/weevil-studio', {
          message: 'Save your HTML5 weevil first so your room avatar is ready to use.',
          next: '/room'
        }));
      }
      return send(res, 200, renderRoom({ user: currentUserView, message: parseMessage(url), error: parseError(url) }));
    }

    if (req.method === 'GET' && pathname === '/api/room/stream') {
      if (!currentUserView) {
        res.writeHead(401, { 'Content-Type': 'text/plain; charset=utf-8' });
        return res.end('Sign in first.');
      }
      markRoomPresence(currentUserView);
      bumpRoomConnection(currentUserView.id, 1);
      res.writeHead(200, {
        'Content-Type': 'text/event-stream; charset=utf-8',
        'Cache-Control': 'no-cache, no-transform',
        Connection: 'keep-alive'
      });
      res.write(`data: ${JSON.stringify(snapshotRoom(currentUserView.id))}\n\n`);
      const client = { res, userId: currentUserView.id };
      roomClients.add(client);
      broadcastRoom();
      const keepAlive = setInterval(() => {
        try {
          res.write(': keep-alive\n\n');
        } catch {}
      }, 25000);
      req.on('close', () => {
        clearInterval(keepAlive);
        roomClients.delete(client);
        const remaining = bumpRoomConnection(currentUserView.id, -1);
        const presence = roomPresence.get(currentUserView.id);
        if (presence) presence.lastSeenAt = Date.now();
        if (remaining <= 0) {
          setTimeout(() => {
            if ((roomConnections.get(currentUserView.id) || 0) <= 0) {
              removeRoomPresence(currentUserView.id);
              broadcastRoom();
            }
          }, 3000).unref?.();
        }
      });
      return;
    }

    if (req.method === 'POST' && pathname === '/api/room/move') {
      if (!currentUserView) return sendJson(res, 401, { ok: false, error: 'Sign in first.' });
      if (!enforceSameOrigin(req, res, { asJson: true, message: 'This request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!enforceRateLimit(req, res, 'room-move', { limit: 180, windowMs: 15 * 1000, message: 'Movement is being rate-limited for a moment.', asJson: true })) return;
      const form = await readBody(req);
      const existing = markRoomPresence(currentUserView);
      const coords = clampRoomPosition(existing.roomId, form.get('x'), form.get('y'));
      const previousX = Number.parseInt(String(form.get('previousX') || existing.x), 10);
      existing.x = coords.x;
      existing.y = coords.y;
      if (!Number.isNaN(previousX)) {
        existing.facing = coords.x < previousX ? 'left' : coords.x > previousX ? 'right' : existing.facing;
      }
      existing.lastSeenAt = Date.now();
      roomPresence.set(currentUserView.id, existing);
      broadcastRoom();
      return sendJson(res, 200, { ok: true, player: existing });
    }

    if (req.method === 'POST' && pathname === '/api/room/map') {
      if (!currentUserView) return sendJson(res, 401, { ok: false, error: 'Sign in first.' });
      if (!enforceSameOrigin(req, res, { asJson: true, message: 'This request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!enforceRateLimit(req, res, 'room-map', { limit: 20, windowMs: 2 * 60_000, message: 'Room switching is being rate-limited for a moment.', asJson: true })) return;
      const activeMatch = getFind4MatchByUserId(currentUserView.id);
      const pendingChallenge = find4Challenges.find((entry) => entry.fromUserId === currentUserView.id || entry.toUserId === currentUserView.id);
      if (activeMatch || pendingChallenge) return sendJson(res, 409, { ok: false, error: 'Finish the current Find4 flow before switching rooms.' });
      const form = await readBody(req);
      const roomId = getRoomDefinition(String(form.get('roomId') || '')).id;
      const presence = markRoomPresence(currentUserView, { roomId });
      const nextUsers = users.map((entry) => entry.id === currentUserView.id ? { ...entry, lastRoomId: roomId } : entry);
      writeJson(dataFile('users.json'), nextUsers);
      broadcastRoom();
      return sendJson(res, 200, { ok: true, roomId: presence.roomId, roomName: getRoomDefinition(presence.roomId).name });
    }

    if (req.method === 'POST' && pathname === '/api/room/chat') {
      if (!currentUserView) return sendJson(res, 401, { ok: false, error: 'Sign in first.' });
      if (!enforceSameOrigin(req, res, { asJson: true, message: 'This request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!enforceRateLimit(req, res, 'room-chat', { limit: 12, windowMs: 30 * 1000, message: 'You are sending chat too quickly. Slow down for a moment.', asJson: true })) return;
      const form = await readBody(req);
      const rawMessage = String(form.get('message') || '').replace(/\s+/g, ' ').trim().slice(0, 160);
      if (!rawMessage) return sendJson(res, 400, { ok: false, error: 'Type a message first.' });
      const existing = markRoomPresence(currentUserView);

      if (rawMessage.startsWith('/')) {
        const [commandNameRaw, ...argParts] = rawMessage.slice(1).split(' ');
        const commandName = String(commandNameRaw || '').trim().toLowerCase();
        const args = argParts.join(' ').trim();
        const roomId = existing.roomId;
        const roomName = getRoomDefinition(roomId).name;
        const pendingChallenge = find4Challenges.find((entry) => entry.fromUserId === currentUserView.id || entry.toUserId === currentUserView.id);
        const activeMatch = getFind4MatchByUserId(currentUserView.id);
        const currentPresence = roomPresence.get(currentUserView.id) || existing;
        const isAdmin = isAdminUser(currentUserView, site);

        if (commandName === 'help') {
          const base = ['/help', '/who', '/rooms', '/go <room>', '/me <action>', '/find4 <username>'];
          if (isAdmin) base.push('/announce <text>', '/mute <user>', '/unmute <user>', '/ban <user>', '/unban <user>', '/kick <user>', '/summon <user>', '/goto <user>');
          return sendJson(res, 200, { ok: true, notice: `Commands: ${base.join(' · ')}` });
        }

        if (commandName === 'who') {
          const names = Array.from(roomPresence.values()).filter((presence) => presence.roomId === roomId).map((presence) => presence.username).sort((a, b) => a.localeCompare(b));
          return sendJson(res, 200, { ok: true, notice: `${roomName}: ${names.length ? names.join(', ') : 'nobody here right now'}.` });
        }

        if (commandName === 'rooms') {
          const rooms = (ROOM_PUBLIC_CONFIG.maps || []).map((room) => room.name).join(', ');
          return sendJson(res, 200, { ok: true, notice: `Rooms: ${rooms}` });
        }

        if (commandName === 'go') {
          if (!args) return sendJson(res, 400, { ok: false, error: 'Usage: /go <room name>' });
          if (activeMatch || pendingChallenge) return sendJson(res, 409, { ok: false, error: 'Finish the current Find4 flow before switching rooms.' });
          const targetRoom = resolveRoomByQuery(args);
          if (!targetRoom) return sendJson(res, 404, { ok: false, error: 'That room was not found.' });
          const presence = markRoomPresence(currentUserView, { roomId: targetRoom.id });
          const nextUsers = users.map((entry) => entry.id === currentUserView.id ? { ...entry, lastRoomId: targetRoom.id } : entry);
          writeJson(dataFile('users.json'), nextUsers);
          broadcastRoom();
          return sendJson(res, 200, { ok: true, notice: `Moved to ${targetRoom.name}.`, roomId: presence.roomId, roomName: targetRoom.name });
        }

        if (commandName === 'find4') {
          if (!args) return sendJson(res, 400, { ok: false, error: 'Usage: /find4 <username>' });
          const targetUser = resolveUserByName(users, args, { roomId });
          if (!targetUser || targetUser.id === currentUserView.id) return sendJson(res, 404, { ok: false, error: 'That room user could not be found.' });
          const targetPresence = roomPresence.get(targetUser.id);
          if (!targetPresence || targetPresence.roomId !== roomId) return sendJson(res, 404, { ok: false, error: 'That player is not available in this room.' });
          if (getFind4MatchByUserId(currentUserView.id) || getFind4MatchByUserId(targetUser.id)) return sendJson(res, 409, { ok: false, error: 'One of you is already in a Find4 match.' });
          const duplicate = find4Challenges.find((challenge) => challenge.fromUserId === currentUserView.id || challenge.toUserId === currentUserView.id || challenge.fromUserId === targetUser.id || challenge.toUserId === targetUser.id);
          if (duplicate) return sendJson(res, 409, { ok: false, error: 'One of you already has a pending Find4 challenge.' });
          createFind4ChallengeForUsers({ fromUser: currentUserView, toUser: targetUser, roomId });
          return sendJson(res, 200, { ok: true, notice: `Find4 challenge sent to ${targetUser.username}.` });
        }

        if (commandName === 'me') {
          if (currentUserView?.isMuted) return sendJson(res, 403, { ok: false, error: 'Your account is muted, so chat is disabled.' });
          if (!args) return sendJson(res, 400, { ok: false, error: 'Usage: /me <action>' });
          existing.chatText = `* ${args.slice(0, 120)} *`;
          existing.chatExpiresAt = Date.now() + 9000;
          existing.lastSeenAt = Date.now();
          roomPresence.set(currentUserView.id, existing);
          pushRoomFeed({ roomId: existing.roomId, type: 'emote', username: currentUserView.username, text: `* ${currentUserView.username} ${args.slice(0, 120)}` });
          broadcastRoom();
          return sendJson(res, 200, { ok: true, notice: 'Action sent.' });
        }

        if (!isAdmin) return sendJson(res, 400, { ok: false, error: 'Unknown command. Try /help.' });

        const targetUser = ['mute', 'unmute', 'ban', 'unban', 'kick', 'summon', 'goto'].includes(commandName) ? resolveUserByName(users, args, { requirePresence: ['kick', 'summon', 'goto'].includes(commandName) }) : null;

        if (commandName === 'announce') {
          if (!args) return sendJson(res, 400, { ok: false, error: 'Usage: /announce <text>' });
          pushRoomFeed({ roomId, type: 'system', username: 'Admin', text: `[Announcement] ${args.slice(0, 140)}` });
          broadcastRoom();
          return sendJson(res, 200, { ok: true, notice: 'Announcement sent to the room.' });
        }

        if (['mute', 'unmute', 'ban', 'unban'].includes(commandName)) {
          if (!targetUser || targetUser.id === currentUserView.id) return sendJson(res, 404, { ok: false, error: 'Pick another user.' });
          const nextUsers = users.map((entry) => {
            if (entry.id !== targetUser.id) return entry;
            if (commandName === 'mute') return { ...entry, isMuted: true };
            if (commandName === 'unmute') return { ...entry, isMuted: false };
            if (commandName === 'ban') return { ...entry, isBanned: true };
            return { ...entry, isBanned: false };
          });
          writeJson(dataFile('users.json'), nextUsers);
          if (commandName === 'ban') removeRoomPresence(targetUser.id, 'silent');
          pushRoomFeed({ roomId, type: 'system', username: 'Admin', text: `${currentUserView.username} ${commandName}d ${targetUser.username}.` });
          broadcastRoom();
          return sendJson(res, 200, { ok: true, notice: `${targetUser.username} updated.` });
        }

        if (commandName === 'kick') {
          if (!targetUser || targetUser.id === currentUserView.id) return sendJson(res, 404, { ok: false, error: 'Pick another room user.' });
          removeRoomPresence(targetUser.id);
          broadcastRoom();
          return sendJson(res, 200, { ok: true, notice: `${targetUser.username} was kicked from the room.` });
        }

        if (commandName === 'summon') {
          if (!targetUser || targetUser.id === currentUserView.id) return sendJson(res, 404, { ok: false, error: 'Pick another online user.' });
          const targetPresence = roomPresence.get(targetUser.id);
          if (!targetPresence) return sendJson(res, 404, { ok: false, error: 'That user is not online right now.' });
          const nextX = currentPresence.x + (currentPresence.facing === 'left' ? -36 : 36);
          const nextY = currentPresence.y + 16;
          markRoomPresence(targetUser, { roomId, x: nextX, y: nextY, facing: targetPresence.facing || 'right' });
          const nextUsers = users.map((entry) => entry.id === targetUser.id ? { ...entry, lastRoomId: roomId } : entry);
          writeJson(dataFile('users.json'), nextUsers);
          pushRoomFeed({ roomId, type: 'system', username: 'Admin', text: `${currentUserView.username} summoned ${targetUser.username}.` });
          broadcastRoom();
          return sendJson(res, 200, { ok: true, notice: `${targetUser.username} moved to your room.` });
        }

        if (commandName === 'goto') {
          if (!targetUser || targetUser.id === currentUserView.id) return sendJson(res, 404, { ok: false, error: 'Pick another online user.' });
          const targetPresence = roomPresence.get(targetUser.id);
          if (!targetPresence) return sendJson(res, 404, { ok: false, error: 'That user is not online right now.' });
          const gotoX = targetPresence.x + (targetPresence.facing === 'left' ? -42 : 42);
          const gotoY = targetPresence.y + 12;
          markRoomPresence(currentUserView, { roomId: targetPresence.roomId, x: gotoX, y: gotoY, facing: targetPresence.facing === 'left' ? 'right' : 'left' });
          const nextUsers = users.map((entry) => entry.id === currentUserView.id ? { ...entry, lastRoomId: targetPresence.roomId } : entry);
          writeJson(dataFile('users.json'), nextUsers);
          broadcastRoom();
          return sendJson(res, 200, { ok: true, notice: `Moved to ${targetUser.username}.` });
        }

        return sendJson(res, 400, { ok: false, error: 'Unknown admin command. Try /help.' });
      }

      if (currentUserView?.isMuted) return sendJson(res, 403, { ok: false, error: 'Your account is muted, so chat is disabled.' });
      existing.chatText = rawMessage;
      existing.chatExpiresAt = Date.now() + 9000;
      existing.lastSeenAt = Date.now();
      roomPresence.set(currentUserView.id, existing);
      pushRoomFeed({ roomId: existing.roomId, type: 'chat', username: currentUserView.username, text: rawMessage });
      broadcastRoom();
      return sendJson(res, 200, { ok: true });
    }

    if (req.method === 'POST' && pathname === '/api/find4/challenge') {
      if (!currentUserView) return sendJson(res, 401, { ok: false, error: 'Sign in first.' });
      if (!enforceSameOrigin(req, res, { asJson: true, message: 'This request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!enforceRateLimit(req, res, 'find4-challenge', { limit: 12, windowMs: 5 * 60_000, message: 'Find4 challenges are being rate-limited for a moment.', asJson: true })) return;
      const form = await readBody(req);
      const targetUserId = String(form.get('targetUserId') || '').trim();
      if (!targetUserId || targetUserId === currentUserView.id) return sendJson(res, 400, { ok: false, error: 'Pick another room user first.' });
      const currentPresence = markRoomPresence(currentUserView);
      const targetPresence = roomPresence.get(targetUserId);
      const targetUser = users.find((entry) => entry.id === targetUserId);
      if (!targetUser || !targetPresence || targetPresence.roomId !== currentPresence.roomId) return sendJson(res, 404, { ok: false, error: 'That player is not available in this room.' });
      if (getFind4MatchByUserId(currentUserView.id) || getFind4MatchByUserId(targetUserId)) {
        return sendJson(res, 409, { ok: false, error: 'One of you is already in a Find4 match.' });
      }
      const duplicate = find4Challenges.find((challenge) => (
        challenge.fromUserId === currentUserView.id
        || challenge.toUserId === currentUserView.id
        || challenge.fromUserId === targetUserId
        || challenge.toUserId === targetUserId
      ));
      if (duplicate) return sendJson(res, 409, { ok: false, error: 'One of you already has a pending Find4 challenge.' });
      const challenge = {
        roomId: currentPresence.roomId,
        id: crypto.randomUUID(),
        fromUserId: currentUserView.id,
        fromUsername: currentUserView.username,
        toUserId: targetUser.id,
        toUsername: targetUser.username,
        createdAt: new Date().toISOString(),
        createdAtMs: Date.now()
      };
      find4Challenges.push(challenge);
      pushRoomFeed({ roomId: currentPresence.roomId, type: 'game', username: currentUserView.username, text: `${currentUserView.username} challenged ${targetUser.username} to Find4.` });
      broadcastRoom();
      return sendJson(res, 200, { ok: true, challengeId: challenge.id });
    }


    if (req.method === 'POST' && /^\/api\/find4\/challenge\/[^/]+\/cancel$/.test(pathname)) {
      if (!currentUserView) return sendJson(res, 401, { ok: false, error: 'Sign in first.' });
      if (!enforceSameOrigin(req, res, { asJson: true, message: 'This request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!enforceRateLimit(req, res, 'find4-cancel', { limit: 20, windowMs: 5 * 60_000, message: 'Find4 actions are being rate-limited for a moment.', asJson: true })) return;
      const challengeId = pathname.split('/')[4];
      const challengeIndex = find4Challenges.findIndex((entry) => entry.id === challengeId && entry.fromUserId === currentUserView.id);
      if (challengeIndex < 0) return sendJson(res, 404, { ok: false, error: 'That Find4 challenge is no longer available.' });
      const challenge = find4Challenges[challengeIndex];
      find4Challenges.splice(challengeIndex, 1);
      pushRoomFeed({ roomId: challenge.roomId || ROOM_PUBLIC_CONFIG.defaultRoomId, type: 'game', username: currentUserView.username, text: `${currentUserView.username} cancelled a Find4 challenge.` });
      broadcastRoom();
      return sendJson(res, 200, { ok: true, cancelled: true });
    }

    if (req.method === 'POST' && /^\/api\/find4\/challenge\/[^/]+\/respond$/.test(pathname)) {
      if (!currentUserView) return sendJson(res, 401, { ok: false, error: 'Sign in first.' });
      if (!enforceSameOrigin(req, res, { asJson: true, message: 'This request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!enforceRateLimit(req, res, 'find4-respond', { limit: 20, windowMs: 5 * 60_000, message: 'Find4 actions are being rate-limited for a moment.', asJson: true })) return;
      const challengeId = pathname.split('/')[4];
      const challengeIndex = find4Challenges.findIndex((entry) => entry.id === challengeId && entry.toUserId === currentUserView.id);
      if (challengeIndex < 0) return sendJson(res, 404, { ok: false, error: 'That Find4 challenge is no longer available.' });
      const challenge = find4Challenges[challengeIndex];
      const form = await readBody(req);
      const decision = String(form.get('decision') || '').trim().toLowerCase();
      find4Challenges.splice(challengeIndex, 1);
      if (decision !== 'accept') {
        pushRoomFeed({ roomId: challenge.roomId || ROOM_PUBLIC_CONFIG.defaultRoomId, type: 'game', username: currentUserView.username, text: `${currentUserView.username} declined ${challenge.fromUsername}'s Find4 challenge.` });
        broadcastRoom();
        return sendJson(res, 200, { ok: true, declined: true });
      }
      if (getFind4MatchByUserId(currentUserView.id) || getFind4MatchByUserId(challenge.fromUserId)) {
        broadcastRoom();
        return sendJson(res, 409, { ok: false, error: 'One of you is already in a Find4 match.' });
      }
      for (let index = find4Challenges.length - 1; index >= 0; index -= 1) {
        const entry = find4Challenges[index];
        if (entry.fromUserId === challenge.fromUserId || entry.toUserId === challenge.fromUserId || entry.fromUserId === currentUserView.id || entry.toUserId === currentUserView.id) {
          find4Challenges.splice(index, 1);
        }
      }
      const nowIso = new Date().toISOString();
      const match = {
        roomId: challenge.roomId || ROOM_PUBLIC_CONFIG.defaultRoomId,
        id: crypto.randomUUID(),
        playerIds: [challenge.fromUserId, currentUserView.id],
        playerUsernames: [challenge.fromUsername, currentUserView.username],
        board: find4CreateBoard(),
        starterUserId: challenge.fromUserId,
        turnUserId: challenge.fromUserId,
        winnerUserId: '',
        winningCells: [],
        status: 'active',
        createdAt: nowIso,
        updatedAt: nowIso,
        updatedAtMs: Date.now(),
        lastMove: null,
        rematchRequestedUserIds: []
      };
      find4Matches.set(match.id, match);
      pushRoomFeed({ roomId: match.roomId, type: 'game', username: currentUserView.username, text: `${challenge.fromUsername} and ${currentUserView.username} started a Find4 match.` });
      broadcastRoom();
      return sendJson(res, 200, { ok: true, matchId: match.id });
    }

    if (req.method === 'POST' && pathname === '/api/find4/drop') {
      if (!currentUserView) return sendJson(res, 401, { ok: false, error: 'Sign in first.' });
      if (!enforceSameOrigin(req, res, { asJson: true, message: 'This request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!enforceRateLimit(req, res, 'find4-drop', { limit: 80, windowMs: 2 * 60_000, message: 'Find4 actions are being rate-limited for a moment.', asJson: true })) return;
      const match = getFind4MatchByUserId(currentUserView.id);
      if (!match || match.status !== 'active') return sendJson(res, 404, { ok: false, error: 'No active Find4 match was found.' });
      if (match.turnUserId !== currentUserView.id) return sendJson(res, 409, { ok: false, error: 'It is not your turn yet.' });
      const form = await readBody(req);
      const column = Number.parseInt(String(form.get('column') || '-1'), 10);
      if (!Number.isInteger(column) || column < 0 || column >= FIND4_COLUMNS) {
        return sendJson(res, 400, { ok: false, error: 'Pick a valid Find4 column.' });
      }
      const disc = match.playerIds[0] === currentUserView.id ? 1 : 2;
      const dropped = find4DropDisc(match.board, column, disc);
      if (!dropped) return sendJson(res, 409, { ok: false, error: 'That Find4 column is full.' });
      match.lastMove = { userId: currentUserView.id, column: dropped.column, row: dropped.row, disc };
      const winningCells = find4WinningCells(match.board, dropped.row, dropped.column, disc);
      match.updatedAt = new Date().toISOString();
      match.updatedAtMs = Date.now();
      if (winningCells) {
        match.winnerUserId = currentUserView.id;
        match.winningCells = winningCells;
        match.status = 'finished';
        match.rematchRequestedUserIds = [];
        pushRoomFeed({ roomId: match.roomId, type: 'game', username: currentUserView.username, text: `${currentUserView.username} won a Find4 match.` });
      } else if (find4IsBoardFull(match.board)) {
        match.status = 'finished';
        match.winnerUserId = '';
        match.winningCells = [];
        match.rematchRequestedUserIds = [];
        pushRoomFeed({ roomId: match.roomId, type: 'game', username: currentUserView.username, text: `A Find4 match between ${match.playerUsernames[0]} and ${match.playerUsernames[1]} ended in a draw.` });
      } else {
        match.turnUserId = match.playerIds[0] === currentUserView.id ? match.playerIds[1] : match.playerIds[0];
      }
      find4Matches.set(match.id, match);
      broadcastRoom();
      return sendJson(res, 200, { ok: true, matchId: match.id });
    }


    if (req.method === 'POST' && pathname === '/api/find4/rematch') {
      if (!currentUserView) return sendJson(res, 401, { ok: false, error: 'Sign in first.' });
      if (!enforceSameOrigin(req, res, { asJson: true, message: 'This request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!enforceRateLimit(req, res, 'find4-rematch', { limit: 24, windowMs: 10 * 60_000, message: 'Find4 actions are being rate-limited for a moment.', asJson: true })) return;
      const match = getFind4MatchByUserId(currentUserView.id);
      if (!match) return sendJson(res, 404, { ok: false, error: 'No Find4 match was found.' });
      if (match.status !== 'finished') return sendJson(res, 409, { ok: false, error: 'Finish the current Find4 match first.' });
      const requests = Array.isArray(match.rematchRequestedUserIds) ? match.rematchRequestedUserIds.slice() : [];
      if (!requests.includes(currentUserView.id)) requests.push(currentUserView.id);
      match.rematchRequestedUserIds = requests;
      match.updatedAt = new Date().toISOString();
      match.updatedAtMs = Date.now();
      if (requests.length < 2) {
        find4Matches.set(match.id, match);
        broadcastRoom();
        return sendJson(res, 200, { ok: true, waiting: true });
      }
      const previousStarterUserId = match.starterUserId || match.playerIds[0];
      const nextStarterUserId = match.playerIds[0] === previousStarterUserId ? match.playerIds[1] : match.playerIds[0];
      const nextOtherUserId = match.playerIds.find((entry) => entry !== nextStarterUserId) || match.playerIds[1];
      const nextStarterUsername = users.find((entry) => entry.id === nextStarterUserId)?.username || match.playerUsernames[match.playerIds.indexOf(nextStarterUserId)] || 'Player 1';
      const nextOtherUsername = users.find((entry) => entry.id === nextOtherUserId)?.username || match.playerUsernames[match.playerIds.indexOf(nextOtherUserId)] || 'Player 2';
      find4Matches.delete(match.id);
      const nowIso = new Date().toISOString();
      const nextMatch = {
        roomId: match.roomId,
        id: crypto.randomUUID(),
        playerIds: [nextStarterUserId, nextOtherUserId],
        playerUsernames: [nextStarterUsername, nextOtherUsername],
        board: find4CreateBoard(),
        starterUserId: nextStarterUserId,
        turnUserId: nextStarterUserId,
        winnerUserId: '',
        winningCells: [],
        status: 'active',
        createdAt: nowIso,
        updatedAt: nowIso,
        updatedAtMs: Date.now(),
        lastMove: null,
        rematchRequestedUserIds: []
      };
      find4Matches.set(nextMatch.id, nextMatch);
      pushRoomFeed({ roomId: nextMatch.roomId, type: 'game', username: currentUserView.username, text: `${nextStarterUsername} and ${nextOtherUsername} started a Find4 rematch.` });
      broadcastRoom();
      return sendJson(res, 200, { ok: true, rematchStarted: true, matchId: nextMatch.id });
    }

    if (req.method === 'POST' && pathname === '/api/find4/forfeit') {
      if (!currentUserView) return sendJson(res, 401, { ok: false, error: 'Sign in first.' });
      if (!enforceSameOrigin(req, res, { asJson: true, message: 'This request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!enforceRateLimit(req, res, 'find4-forfeit', { limit: 20, windowMs: 5 * 60_000, message: 'Find4 actions are being rate-limited for a moment.', asJson: true })) return;
      const match = getFind4MatchByUserId(currentUserView.id);
      if (!match) return sendJson(res, 404, { ok: false, error: 'No Find4 match was found.' });
      if (match.status !== 'active') {
        find4Matches.delete(match.id);
        broadcastRoom();
        return sendJson(res, 200, { ok: true, closed: true });
      }
      match.status = 'finished';
      match.winnerUserId = match.playerIds[0] === currentUserView.id ? match.playerIds[1] : match.playerIds[0];
      match.winningCells = [];
      match.rematchRequestedUserIds = [];
      match.updatedAt = new Date().toISOString();
      match.updatedAtMs = Date.now();
      find4Matches.set(match.id, match);
      pushRoomFeed({ roomId: match.roomId, type: 'game', username: currentUserView.username, text: `${currentUserView.username} forfeited a Find4 match.` });
      broadcastRoom();
      return sendJson(res, 200, { ok: true, winnerUserId: match.winnerUserId });
    }

    if (req.method === 'GET' && pathname === '/api/session') {
      return sendJson(res, 200, buildSessionState({
        user: currentUserView,
        mode: String(url.searchParams.get('mode') || 'view').trim() || 'view',
        nextPath: parseNext(url, DEFAULT_POST_LOGIN_PATH)
      }));
    }

    if (req.method === 'POST' && pathname === '/api/register-with-creator') {
      if (currentUserView) return sendJson(res, 409, { ok: false, error: 'You are already signed in. Open edit mode instead.' });
      if (!enforceSameOrigin(req, res, { asJson: true, message: 'This sign-up request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!enforceRateLimit(req, res, 'register-creator', { limit: 5, windowMs: 15 * 60_000, message: 'Too many sign-up attempts were made from this browser. Please try again in a few minutes.', asJson: true })) return;
      const form = await readBody(req);
      const username = String(form.get('username') || '').trim();
      const email = String(form.get('email') || '').trim().toLowerCase();
      const password = String(form.get('password') || '');
      const passwordConfirm = String(form.get('passwordConfirm') || '');
      const nextPath = safeNextPath(form.get('nextPath'), DEFAULT_POST_LOGIN_PATH);
      const registrationError = validateRegistration({ username, email, password, passwordConfirm });
      if (registrationError) return sendJson(res, 400, { ok: false, error: registrationError });
      if (users.some((user) => user.username.toLowerCase() === username.toLowerCase())) {
        return sendJson(res, 409, { ok: false, error: 'That weevil name is already taken on Bin Weevils Rewritten.' });
      }
      const avatar = avatarPayloadFromForm(form, DEFAULT_AVATAR);
      const avatarError = validateAvatarPayload(avatar);
      if (avatarError) return sendJson(res, 400, { ok: false, error: avatarError });
      const passwordBits = hashPassword(password);
      const bootstrapAdmin = ensureAdminBootstrapForNewUser({ users, site, username });
      const createdAt = new Date().toISOString();
      const created = {
        id: crypto.randomUUID(),
        username,
        email,
        role: bootstrapAdmin ? 'admin' : 'user',
        isMuted: false,
        isBanned: false,
        passwordSalt: passwordBits.salt,
        passwordHash: passwordBits.hash,
        bio: '',
        avatar,
        avatarConfigured: true,
        avatarUpdatedAt: createdAt,
        createdAt
      };
      writeJson(dataFile('users.json'), [...users, created]);
      createSession(ROOT_DIR, created, res);
      const redirectPath = withFlash(nextPath || '/profile', { message: bootstrapAdmin ? 'Your account and weevil have been created. You are the first admin on this site.' : 'Your account and weevil have been created.' });
      return sendJson(res, 200, { ok: true, redirectPath, userId: created.id });
    }

    if (req.method === 'GET' && pathname === '/api/me/avatar') {
      if (!currentUserView) return sendJson(res, 401, { ok: false, error: 'Sign in first.' });
      return sendJson(res, 200, {
        ok: true,
        avatar: normaliseAvatar(currentUserView.avatar || {}, DEFAULT_AVATAR),
        avatarConfigured: hasCustomAvatarSetup(currentUserView)
      });
    }

    if (req.method === 'POST' && pathname === '/api/me/avatar') {
      if (!currentUserView) return sendJson(res, 401, { ok: false, error: 'Sign in first.' });
      if (!enforceSameOrigin(req, res, { asJson: true, message: 'This request did not come from the Bin Weevils Rewritten site.' })) return;
      if (!enforceRateLimit(req, res, 'avatar-save', { limit: 25, windowMs: 5 * 60_000, message: 'Avatar saves are being rate-limited for a moment.', asJson: true })) return;
      const form = await readBody(req);
      const nextPath = safeNextPath(form.get('nextPath'), '/profile');
      const avatar = avatarPayloadFromForm(form, currentUserView.avatar || DEFAULT_AVATAR);
      const avatarError = validateAvatarPayload(avatar);
      if (avatarError) {
        return sendJson(res, 400, { ok: false, error: avatarError });
      }
      const updatedAt = new Date().toISOString();
      const nextUsers = users.map((user) => user.id === currentUserView.id ? {
        ...user,
        avatar,
        avatarConfigured: true,
        avatarUpdatedAt: updatedAt
      } : user);
      writeJson(dataFile('users.json'), nextUsers);
      const activePresence = roomPresence.get(currentUserView.id);
      if (activePresence) {
        activePresence.avatar = compactRoomAvatar(avatar);
        activePresence.lastSeenAt = Date.now();
        roomPresence.set(currentUserView.id, activePresence);
        broadcastRoom();
      }
      peelRoomService.updateAvatar({ ...currentUserView, avatar }, avatar);
      return sendJson(res, 200, {
        ok: true,
        avatar,
        avatarConfigured: true,
        avatarUpdatedAt: updatedAt,
        redirectPath: withFlash(nextPath || '/profile', { message: 'Weevil saved.' })
      });
    }

    if (req.method === 'GET' && pathname === '/admin') {
      if (!requireAdminOrRedirect(currentUserView, site, req, res)) return;
      const adminView = collectAdminView({ users, comments, posts }, currentUserView, site);
      return send(res, 200, renderAdmin({
        user: currentUserView,
        stats: adminView.stats,
        users: adminView.users,
        comments: adminView.comments,
        room: adminView.room,
        posts: adminView.posts,
        message: parseMessage(url),
        error: parseError(url)
      }));
    }

    if (req.method === 'POST' && /^\/admin\/users\/[^/]+\/role$/.test(pathname)) {
      if (!requireAdminOrRedirect(currentUserView, site, req, res)) return;
      if (!enforceSameOrigin(req, res, { redirectPath: '/admin', message: 'Admin changes must come from the Bin Weevils Rewritten website.' })) return;
      if (!rateLimitRedirect(req, res, 'admin-action', '/admin', 'Too many admin actions from this connection. Please slow down.', 60, 10 * 60_000)) return;
      const userId = pathname.split('/')[3];
      if (userId === currentUserView.id) return redirect(res, withFlash('/admin', { error: 'Do not demote your own admin account from the panel.' }));
      const target = users.find((entry) => entry.id === userId);
      if (!target) return redirect(res, withFlash('/admin', { error: 'User not found.' }));
      const nextRole = isAdminUser(target, site) ? 'user' : 'admin';
      const nextUsers = users.map((entry) => entry.id === userId ? { ...entry, role: nextRole } : entry);
      writeJson(dataFile('users.json'), nextUsers);
      return redirect(res, withFlash('/admin', { message: `${target.username} is now ${nextRole}.` }));
    }

    if (req.method === 'POST' && /^\/admin\/users\/[^/]+\/mute$/.test(pathname)) {
      if (!requireAdminOrRedirect(currentUserView, site, req, res)) return;
      if (!enforceSameOrigin(req, res, { redirectPath: '/admin', message: 'Admin changes must come from the Bin Weevils Rewritten website.' })) return;
      if (!rateLimitRedirect(req, res, 'admin-action', '/admin', 'Too many admin actions from this connection. Please slow down.', 60, 10 * 60_000)) return;
      const userId = pathname.split('/')[3];
      if (userId === currentUserView.id) return redirect(res, withFlash('/admin', { error: 'Do not mute your own admin account from the panel.' }));
      const target = users.find((entry) => entry.id === userId);
      if (!target) return redirect(res, withFlash('/admin', { error: 'User not found.' }));
      const nextUsers = users.map((entry) => entry.id === userId ? { ...entry, isMuted: !Boolean(entry.isMuted) } : entry);
      writeJson(dataFile('users.json'), nextUsers);
      return redirect(res, withFlash('/admin', { message: `${target.username} ${target.isMuted ? 'was unmuted' : 'was muted'}.` }));
    }

    if (req.method === 'POST' && /^\/admin\/users\/[^/]+\/ban$/.test(pathname)) {
      if (!requireAdminOrRedirect(currentUserView, site, req, res)) return;
      if (!enforceSameOrigin(req, res, { redirectPath: '/admin', message: 'Admin changes must come from the Bin Weevils Rewritten website.' })) return;
      if (!rateLimitRedirect(req, res, 'admin-action', '/admin', 'Too many admin actions from this connection. Please slow down.', 60, 10 * 60_000)) return;
      const userId = pathname.split('/')[3];
      if (userId === currentUserView.id) return redirect(res, withFlash('/admin', { error: 'Do not ban your own admin account from the panel.' }));
      const target = users.find((entry) => entry.id === userId);
      if (!target) return redirect(res, withFlash('/admin', { error: 'User not found.' }));
      const nextUsers = users.map((entry) => entry.id === userId ? { ...entry, isBanned: !Boolean(entry.isBanned) } : entry);
      writeJson(dataFile('users.json'), nextUsers);
      if (!target.isBanned) {
        removeRoomPresence(userId, 'silent');
        broadcastRoom();
      }
      return redirect(res, withFlash('/admin', { message: `${target.username} ${target.isBanned ? 'was unbanned' : 'was banned'}.` }));
    }

    if (req.method === 'POST' && /^\/admin\/comments\/[^/]+\/delete$/.test(pathname)) {
      if (!requireAdminOrRedirect(currentUserView, site, req, res)) return;
      if (!enforceSameOrigin(req, res, { redirectPath: '/admin', message: 'Admin changes must come from the Bin Weevils Rewritten website.' })) return;
      if (!rateLimitRedirect(req, res, 'admin-action', '/admin', 'Too many admin actions from this connection. Please slow down.', 60, 10 * 60_000)) return;
      const commentId = pathname.split('/')[3];
      const nextComments = comments.filter((entry) => entry.id !== commentId);
      if (nextComments.length === comments.length) return redirect(res, withFlash('/admin', { error: 'Comment not found.' }));
      writeJson(dataFile('comments.json'), nextComments);
      return redirect(res, withFlash('/admin', { message: 'Comment deleted.' }));
    }

    if (req.method === 'POST' && pathname === '/admin/posts/create') {
      if (!requireAdminOrRedirect(currentUserView, site, req, res)) return;
      if (!enforceSameOrigin(req, res, { redirectPath: '/admin', message: 'Admin changes must come from the Bin Weevils Rewritten website.' })) return;
      if (!rateLimitRedirect(req, res, 'admin-action', '/admin', 'Too many admin actions from this connection. Please slow down.', 60, 10 * 60_000)) return;
      const form = await readBody(req);
      const built = buildMirrorPostFromForm(form, currentUserView);
      if (!built.ok) return redirect(res, withFlash('/admin', { error: built.error }));
      const mirrorPosts = readJson(dataFile('mirror-posts.json'), []);
      let slug = built.post.slug;
      let counter = 2;
      const usedSlugs = new Set([...mirrorPosts, ...posts].map((entry) => entry.slug));
      while (usedSlugs.has(slug)) {
        slug = `${built.post.slug}-${counter}`;
        counter += 1;
      }
      const nextPost = { ...built.post, slug };
      writeJson(dataFile('mirror-posts.json'), [nextPost, ...mirrorPosts]);
      return redirect(res, withFlash('/admin', { message: `Project post “${nextPost.title}” published.` }));
    }

    if (req.method === 'POST' && /^\/admin\/posts\/[^/]+\/delete$/.test(pathname)) {
      if (!requireAdminOrRedirect(currentUserView, site, req, res)) return;
      if (!enforceSameOrigin(req, res, { redirectPath: '/admin', message: 'Admin changes must come from the Bin Weevils Rewritten website.' })) return;
      if (!rateLimitRedirect(req, res, 'admin-action', '/admin', 'Too many admin actions from this connection. Please slow down.', 60, 10 * 60_000)) return;
      const slug = pathname.split('/')[3];
      const mirrorPosts = readJson(dataFile('mirror-posts.json'), []);
      const target = mirrorPosts.find((entry) => entry.slug === slug);
      if (!target) return redirect(res, withFlash('/admin', { error: 'Project post not found.' }));
      writeJson(dataFile('mirror-posts.json'), mirrorPosts.filter((entry) => entry.slug !== slug));
      const nextComments = comments.filter((comment) => comment.postSlug !== slug);
      if (nextComments.length !== comments.length) writeJson(dataFile('comments.json'), nextComments);
      return redirect(res, withFlash('/admin', { message: `Deleted project post “${target.title}”.` }));
    }

    if (req.method === 'POST' && /^\/admin\/users\/[^/]+\/kick$/.test(pathname)) {
      if (!requireAdminOrRedirect(currentUserView, site, req, res)) return;
      if (!enforceSameOrigin(req, res, { redirectPath: '/admin', message: 'Admin changes must come from the Bin Weevils Rewritten website.' })) return;
      if (!rateLimitRedirect(req, res, 'admin-action', '/admin', 'Too many admin actions from this connection. Please slow down.', 60, 10 * 60_000)) return;
      const userId = pathname.split('/')[3];
      if (userId === currentUserView.id) return redirect(res, withFlash('/admin', { error: 'Do not kick yourself from the room panel.' }));
      const target = users.find((entry) => entry.id === userId);
      const presence = roomPresence.get(userId);
      if (!target || !presence) return redirect(res, withFlash('/admin', { error: 'That room user is no longer online.' }));
      removeRoomPresence(userId);
      broadcastRoom();
      return redirect(res, withFlash('/admin', { message: `${target.username} was kicked from the room.` }));
    }

    if (req.method === 'POST' && /^\/admin\/users\/[^/]+\/summon$/.test(pathname)) {
      if (!requireAdminOrRedirect(currentUserView, site, req, res)) return;
      if (!enforceSameOrigin(req, res, { redirectPath: '/admin', message: 'Admin changes must come from the Bin Weevils Rewritten website.' })) return;
      if (!rateLimitRedirect(req, res, 'admin-action', '/admin', 'Too many admin actions from this connection. Please slow down.', 60, 10 * 60_000)) return;
      const userId = pathname.split('/')[3];
      if (userId === currentUserView.id) return redirect(res, withFlash('/admin', { error: 'Do not summon yourself.' }));
      const target = users.find((entry) => entry.id === userId);
      const adminPresence = markRoomPresence(currentUserView);
      const targetPresence = roomPresence.get(userId);
      if (!target || !targetPresence) return redirect(res, withFlash('/admin', { error: 'That user must be online before you can summon them.' }));
      markRoomPresence(target, { roomId: adminPresence.roomId, x: adminPresence.x + 40, y: adminPresence.y + 16, facing: targetPresence.facing || 'right' });
      const nextUsers = users.map((entry) => entry.id === userId ? { ...entry, lastRoomId: adminPresence.roomId } : entry);
      writeJson(dataFile('users.json'), nextUsers);
      broadcastRoom();
      return redirect(res, withFlash('/admin', { message: `${target.username} was moved to your room.` }));
    }

    if (req.method === 'GET' && pathname === '/news') {
      return send(res, 200, renderNewsFeed({ user: currentUserView, posts }));
    }

    if (req.method === 'GET' && pathname.startsWith('/news/')) {
      const slug = pathname.replace(/^\/news\//, '').replace(/\/$/, '');
      const post = posts.find((entry) => entry.slug === slug);
      if (!post) return send(res, 404, '<h1>Post not found</h1>');
      const postComments = getPostComments(slug, comments, users, posts);
      return send(res, 200, renderNewsPost({ user: currentUserView, post, comments: postComments, message: parseMessage(url), error: parseError(url) }));
    }

    if (req.method === 'POST' && pathname.startsWith('/news/') && pathname.endsWith('/comment')) {
      if (!currentUserView) {
        return redirect(res, '/login?error=Sign+in+with+your+Bin+Weevils+Rewritten+account+to+comment.');
      }
      if (!enforceSameOrigin(req, res, { redirectPath: pathname.replace(/\/comment$/, ''), message: 'Comments must be posted from the Bin Weevils Rewritten website.' })) return;
      if (!rateLimitRedirect(req, res, 'news-comment', pathname.replace(/\/comment$/, ''), 'Too many comments from this connection. Please wait a moment.', 6, 10 * 60_000)) return;
      const slug = pathname.replace(/^\/news\//, '').replace(/\/comment$/, '').replace(/\/$/, '');
      const post = posts.find((entry) => entry.slug === slug);
      if (!post) return send(res, 404, '<h1>Post not found</h1>');
      const form = await readBody(req);
      if (currentUserView?.isMuted) {
        return redirect(res, `${slugPath(slug)}?error=Your+account+is+muted,+so+comments+are+disabled.`);
      }
      const body = String(form.get('body') || '').trim();
      if (!body) {
        return redirect(res, `${slugPath(slug)}?error=Write+something+before+posting.`);
      }
      if (body.length > 1200) {
        return redirect(res, `${slugPath(slug)}?error=Keep+comments+under+1200+characters.`);
      }
      const nextComments = [...comments, {
        id: crypto.randomUUID(),
        postSlug: slug,
        userId: currentUserView.id,
        username: currentUserView.username,
        body,
        createdAt: new Date().toISOString()
      }];
      writeJson(dataFile('comments.json'), nextComments);
      return redirect(res, `${slugPath(slug)}?message=Comment+posted.#comments`);
    }

    return send(res, 404, '<h1>Not found</h1>');
  } catch (error) {
    console.error(error);
    return send(res, 500, `<h1>Server error</h1><pre>${String(error.message || error)}</pre>`);
  }
});

server.on('upgrade', (req, socket, head) => {
  let pathname = '';
  try {
    pathname = new URL(req.url || '/', `http://${req.headers.host || 'localhost'}`).pathname;
  } catch {
    socket.destroy();
    return;
  }

  if (pathname !== '/ws/the-peel') {
    socket.destroy();
    return;
  }

  const currentUser = getCurrentUser(ROOT_DIR, req);
  peelRoomService.handleUpgrade(req, socket, head, currentUser);
});

server.listen(PORT, () => {
  console.log(`Bin Weevils Rewritten running on http://localhost:${PORT}`);
});
