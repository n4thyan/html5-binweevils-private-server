import { readdir, readFile } from 'node:fs/promises';
import path from 'node:path';

const repoRoot = process.cwd();
const defaultRoots = [
  'source/knowyourknot-binweevils/game-full/binConfig',
  'source/knowyourknot-binweevils/game-full/cdn.binw.net'
];

const roots = process.argv.slice(2).length ? process.argv.slice(2) : defaultRoots;
const xmlFiles = [];

for (const root of roots) {
  await collectXmlFiles(path.resolve(repoRoot, root));
}

const locations = [];
for (const file of xmlFiles) {
  const text = await readFile(file, 'utf8').catch(() => '');
  if (!text.includes('<location')) continue;
  for (const match of text.matchAll(/<location\b([\s\S]*?)(?:>([\s\S]*?)<\/location>|\/\s*>)/g)) {
    const attrs = parseAttrs(match[1] || '');
    const body = match[2] || '';
    if (!attrs.id) continue;
    const roomBG = body.match(/<roomBG\b[^>]*\bpath=(['"])(.*?)\1/)?.[2] || '';
    locations.push({
      source: path.relative(repoRoot, file).replaceAll('\\', '/'),
      id: toNumber(attrs.id),
      name: attrs.name || '',
      type: toNumber(attrs.type),
      boundType: attrs.boundType || '',
      boundary: parseNumberList(attrs.boundary),
      camPos: parseNumberList(attrs.camPos),
      camAim: parseNumberList(attrs.camAim),
      entryPos: parseNumberList(attrs.entryPos),
      entryDir: toNumber(attrs.entryDir),
      weevilScale: toNumber(attrs.weevilScale),
      maintainY: attrs.maintainY || '',
      noZoom: attrs.noZoom || '',
      roomBG,
      doorCount: countTags(body, 'door'),
      objectCount: countTags(body, 'object'),
      interactiveCount: countTags(body, 'interactive'),
      noGoAreaCount: countTags(body, 'noGoArea')
    });
  }
}

const withScale = locations.filter((loc) => Number.isFinite(loc.weevilScale));
const scaleBuckets = bucketScales(withScale);
const commonMovementCandidates = withScale
  .filter((loc) => loc.type === 2 && loc.roomBG && loc.roomBG.includes('fixedCam/'))
  .filter((loc) => loc.weevilScale >= 0.24 && loc.weevilScale <= 0.5)
  .sort((a, b) => b.weevilScale - a.weevilScale || a.id - b.id);

console.log('Movement source data audit');
console.log(`roots: ${roots.join(', ')}`);
console.log(`xmlFiles: ${xmlFiles.length}`);
console.log(`locations: ${locations.length}`);
console.log(`locationsWithWeevilScale: ${withScale.length}`);
console.log('');
console.log('weevilScale buckets:');
for (const [bucket, count] of Object.entries(scaleBuckets)) {
  console.log(`  ${bucket}: ${count}`);
}
console.log('');
console.log('Common fixedCam movement candidates with normal-ish scale 0.24..0.50:');
for (const loc of commonMovementCandidates.slice(0, 80)) {
  console.log(formatLoc(loc));
}
console.log('');
console.log('Known Rums Cove-like entries:');
for (const loc of locations.filter((loc) => loc.id === 129 || /Rums|Airport|Cove/i.test(loc.name) || /RumsAirport/i.test(loc.roomBG))) {
  console.log(formatLoc(loc));
}
console.log('');
console.log('Recommendation: use this audit to choose a normal-scale blank sandbox baseline, then keep room-specific scale for each real room render. Do not hard-code Rums Cove 0.18 as the global movement scale.');

async function collectXmlFiles(folder) {
  let entries = [];
  try {
    entries = await readdir(folder, { withFileTypes: true });
  } catch (error) {
    return;
  }
  for (const entry of entries) {
    const full = path.join(folder, entry.name);
    if (entry.isDirectory()) {
      await collectXmlFiles(full);
    } else if (entry.isFile() && entry.name.toLowerCase().endsWith('.xml')) {
      xmlFiles.push(full);
    }
  }
}

function parseAttrs(raw) {
  const attrs = {};
  for (const match of String(raw).matchAll(/([\w:-]+)\s*=\s*(['"])(.*?)\2/g)) {
    attrs[match[1]] = match[3];
  }
  return attrs;
}

function parseNumberList(value) {
  if (!value) return [];
  return String(value).split(',').map((part) => Number(part.trim())).filter((value) => Number.isFinite(value));
}

function toNumber(value) {
  if (value === undefined || value === null || value === '') return null;
  const number = Number(value);
  return Number.isFinite(number) ? number : null;
}

function countTags(body, tag) {
  const re = new RegExp(`<${tag}\\b`, 'g');
  return [...String(body).matchAll(re)].length;
}

function bucketScales(locs) {
  const buckets = {
    '<0.16': 0,
    '0.16..0.199': 0,
    '0.20..0.239': 0,
    '0.24..0.299': 0,
    '0.30..0.399': 0,
    '0.40..0.50': 0,
    '>0.50': 0
  };
  for (const loc of locs) {
    const scale = loc.weevilScale;
    if (scale < 0.16) buckets['<0.16'] += 1;
    else if (scale < 0.2) buckets['0.16..0.199'] += 1;
    else if (scale < 0.24) buckets['0.20..0.239'] += 1;
    else if (scale < 0.3) buckets['0.24..0.299'] += 1;
    else if (scale < 0.4) buckets['0.30..0.399'] += 1;
    else if (scale <= 0.5) buckets['0.40..0.50'] += 1;
    else buckets['>0.50'] += 1;
  }
  return buckets;
}

function formatLoc(loc) {
  return [
    `id=${loc.id}`,
    `name=${loc.name || '(none)'}`,
    `scale=${loc.weevilScale}`,
    `entry=${loc.entryPos.join(',') || '(none)'}`,
    `dir=${loc.entryDir ?? '(none)'}`,
    `boundary=${loc.boundary.join(',') || '(none)'}`,
    `maintainY=${loc.maintainY || '(none)'}`,
    `doors=${loc.doorCount}`,
    `objects=${loc.objectCount}`,
    `interactives=${loc.interactiveCount}`,
    `roomBG=${loc.roomBG || '(none)'}`,
    `source=${loc.source}`
  ].join(' | ');
}
