import fs from 'fs';
import path from 'path';

export function readJson(filePath, fallback = []) {
  try {
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch {
    return fallback;
  }
}

export function writeJson(filePath, data) {
  fs.writeFileSync(filePath, JSON.stringify(data, null, 2), 'utf8');
}

export function ensureFile(filePath, defaultValue) {
  if (!fs.existsSync(filePath)) {
    writeJson(filePath, defaultValue);
  }
}

export function loadAllData(rootDir) {
  const dataDir = path.join(rootDir, 'data');
  const officialPosts = readJson(path.join(dataDir, 'imported-posts.json'), []);
  const mirrorPosts = readJson(path.join(dataDir, 'mirror-posts.json'), []);
  const comments = readJson(path.join(dataDir, 'comments.json'), []);
  const users = readJson(path.join(dataDir, 'users.json'), []);
  const sessions = readJson(path.join(dataDir, 'sessions.json'), []);
  const site = readJson(path.join(dataDir, 'site.json'), {});
  return { dataDir, officialPosts, mirrorPosts, comments, users, sessions, site };
}

export function bootstrapData(rootDir) {
  const dataDir = path.join(rootDir, 'data');
  ensureFile(path.join(dataDir, 'users.json'), []);
  ensureFile(path.join(dataDir, 'comments.json'), []);
  ensureFile(path.join(dataDir, 'sessions.json'), []);
  ensureFile(path.join(dataDir, 'hall-of-shame.json'), []);
}
