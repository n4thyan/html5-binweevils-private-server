import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ROOT = path.join(__dirname, '..');
const renderFile = path.join(ROOT, 'lib', 'render.mjs');
const source = fs.readFileSync(renderFile, 'utf8');
const assetRefs = [...source.matchAll(/asset\('([^']+)'\)/g)].map((match) => match[1]);
const uniqueRefs = [...new Set(assetRefs)].sort();

function looksLikeHtml(buffer) {
  const head = buffer.toString('utf8', 0, Math.min(buffer.length, 256)).trimStart().toLowerCase();
  return head.startsWith('<!doctype html') || head.startsWith('<html');
}

let bad = 0;
for (const ref of uniqueRefs) {
  const fullPath = path.join(ROOT, 'vendor', 'official-mirror', ref);
  if (!fs.existsSync(fullPath)) {
    console.log(`MISSING ${ref}`);
    bad += 1;
    continue;
  }
  const stat = fs.statSync(fullPath);
  if (!stat.isFile()) {
    console.log(`NOT A FILE ${ref}`);
    bad += 1;
    continue;
  }
  const ext = path.extname(fullPath).toLowerCase();
  if (['.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp', '.ico'].includes(ext)) {
    const buffer = fs.readFileSync(fullPath);
    if (ext !== '.svg' && looksLikeHtml(buffer)) {
      console.log(`BAD IMAGE PAYLOAD ${ref}`);
      bad += 1;
      continue;
    }
  }
}

const routes = ['/', '/login', '/register', '/downloads', '/community', '/hall-of-shame', '/about', '/rules', '/news'];
console.log(`Checked ${uniqueRefs.length} asset references from lib/render.mjs.`);
console.log(`Suggested route smoke test: ${routes.join(' ')}`);
if (bad) {
  console.log(`Found ${bad} path issue(s).`);
  process.exitCode = 1;
} else {
  console.log('All referenced asset paths exist and the raster image payloads look sane.');
}
