import crypto from 'crypto';
import path from 'path';
import { readJson, writeJson } from './store.mjs';

const COOKIE_NAME = ['1', 'true', 'yes', 'on'].includes(String(process.env.SESSION_COOKIE_SECURE || (String(process.env.NODE_ENV || '').toLowerCase() === 'production' ? 'true' : 'false')).toLowerCase()) ? '__Host-bwr_mirror_sid' : 'bwr_mirror_sid';
const SESSION_AGE_DAYS = 14;
const USE_SECURE_COOKIE = ['1', 'true', 'yes', 'on'].includes(String(process.env.SESSION_COOKIE_SECURE || (String(process.env.NODE_ENV || '').toLowerCase() === 'production' ? 'true' : 'false')).toLowerCase());

function dataPath(rootDir, name) {
  return path.join(rootDir, 'data', name);
}

export function hashPassword(password) {
  const salt = crypto.randomBytes(16).toString('hex');
  const hash = crypto.scryptSync(password, salt, 64).toString('hex');
  return { salt, hash };
}

export function verifyPassword(password, salt, hash) {
  const check = crypto.scryptSync(password, salt, 64).toString('hex');
  return crypto.timingSafeEqual(Buffer.from(check, 'hex'), Buffer.from(hash, 'hex'));
}

export function parseCookies(req) {
  const header = req.headers.cookie || '';
  const out = {};
  header.split(';').forEach((part) => {
    const idx = part.indexOf('=');
    if (idx === -1) return;
    const key = part.slice(0, idx).trim();
    const value = decodeURIComponent(part.slice(idx + 1).trim());
    if (key) out[key] = value;
  });
  return out;
}

export function loadSession(rootDir, req) {
  const cookies = parseCookies(req);
  const sid = cookies[COOKIE_NAME];
  if (!sid) return null;
  const sessions = readJson(dataPath(rootDir, 'sessions.json'), []);
  const now = Date.now();
  const active = sessions.find((entry) => entry.id === sid && new Date(entry.expiresAt).getTime() > now);
  return active || null;
}

export function getCurrentUser(rootDir, req) {
  const session = loadSession(rootDir, req);
  if (!session) return null;
  const users = readJson(dataPath(rootDir, 'users.json'), []);
  return users.find((user) => user.id === session.userId) || null;
}

function buildCookie(value, maxAge) {
  return `${COOKIE_NAME}=${encodeURIComponent(value)}; Path=/; HttpOnly; SameSite=Lax; Max-Age=${maxAge}${USE_SECURE_COOKIE ? '; Secure' : ''}`;
}

export function createSession(rootDir, user, res) {
  const sessions = readJson(dataPath(rootDir, 'sessions.json'), []);
  const expiresAt = new Date(Date.now() + SESSION_AGE_DAYS * 24 * 60 * 60 * 1000).toISOString();
  const session = {
    id: crypto.randomUUID(),
    userId: user.id,
    username: user.username,
    expiresAt
  };
  const filtered = sessions.filter((entry) => new Date(entry.expiresAt).getTime() > Date.now());
  filtered.push(session);
  writeJson(dataPath(rootDir, 'sessions.json'), filtered);
  res.setHeader('Set-Cookie', buildCookie(session.id, SESSION_AGE_DAYS * 24 * 60 * 60));
}

export function destroySession(rootDir, req, res) {
  const cookies = parseCookies(req);
  const sid = cookies[COOKIE_NAME];
  const sessions = readJson(dataPath(rootDir, 'sessions.json'), []);
  const filtered = sessions.filter((entry) => entry.id !== sid && new Date(entry.expiresAt).getTime() > Date.now());
  writeJson(dataPath(rootDir, 'sessions.json'), filtered);
  res.setHeader('Set-Cookie', buildCookie('', 0));
}
