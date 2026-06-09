import { readdir, readFile } from 'node:fs/promises';
import path from 'node:path';

const exportRoot = process.argv[2] || 'reference/rooms/RumsAirport_dynamAds_videoPodv2_release/RumsAirport_dynamAds_videoPodv2_release';
const repoRoot = process.cwd();
const absoluteRoot = path.resolve(repoRoot, exportRoot);

const candidates = [];
await scanFolder(path.join(absoluteRoot, 'shapes'), 'shape');
await scanFolder(path.join(absoluteRoot, 'sprites'), 'sprite');

const ranked = candidates
  .filter((item) => item.score > 0 || item.width > 450 || item.height > 180)
  .sort((a, b) => b.score - a.score || b.area - a.area)
  .slice(0, 80);

console.log('RumsCove ground/backdrop candidate audit');
console.log(`exportRoot: ${exportRoot}`);
console.log(`scanned SVGs: ${candidates.length}`);
console.log('');
console.log('Top candidates, ranked by ground/backdrop colour and size:');

for (const item of ranked) {
  console.log([
    `score=${item.score}`,
    `kind=${item.kind}`,
    `size=${round(item.width)}x${round(item.height)}`,
    `area=${round(item.area)}`,
    `brown=${item.brown}`,
    `green=${item.green}`,
    `blue=${item.blue}`,
    `yellow=${item.yellow}`,
    `path=${item.relativePath}`,
    `sample=${item.sampleColours.slice(0, 8).join(',')}`
  ].join(' | '));
}

console.log('');
console.log('Tip: brown/green large candidates are likely visible ground/grass; blue large candidates are likely sky/backdrop; tiny high-colour files are usually details, masks, or buttons.');

async function scanFolder(folder, kind) {
  let entries = [];
  try {
    entries = await readdir(folder, { withFileTypes: true });
  } catch (error) {
    return;
  }

  for (const entry of entries) {
    const fullPath = path.join(folder, entry.name);
    if (entry.isDirectory()) {
      await scanFolder(fullPath, kind);
      continue;
    }
    if (!entry.isFile() || !entry.name.endsWith('.svg')) continue;

    const svg = await readFile(fullPath, 'utf8').catch(() => '');
    const size = extractSvgSize(svg);
    const colours = extractColours(svg);
    const counts = classifyColours(colours);
    const area = size.width * size.height;
    const score = Math.round(
      counts.brown * 5 +
      counts.green * 3 +
      counts.yellow * 2 +
      Math.min(area / 20000, 30) +
      (size.width > 500 ? 10 : 0) +
      (size.height > 250 ? 10 : 0) -
      counts.blue
    );

    candidates.push({
      kind,
      relativePath: path.relative(repoRoot, fullPath).replaceAll('\\', '/'),
      width: size.width,
      height: size.height,
      area,
      score,
      brown: counts.brown,
      green: counts.green,
      blue: counts.blue,
      yellow: counts.yellow,
      sampleColours: [...colours].slice(0, 12)
    });
  }
}

function extractSvgSize(svg) {
  const tag = String(svg || '').match(/<svg\b[^>]*>/)?.[0] || '';
  const width = parseSvgLength(tag.match(/\bwidth="([^"]+)"/)?.[1]);
  const height = parseSvgLength(tag.match(/\bheight="([^"]+)"/)?.[1]);
  const viewBox = tag.match(/\bviewBox="([^"]+)"/)?.[1];

  if ((!width || !height) && viewBox) {
    const parts = viewBox.trim().split(/[\s,]+/).map(Number);
    if (parts.length === 4) return { width: width || parts[2], height: height || parts[3] };
  }
  return { width: width || 0, height: height || 0 };
}

function parseSvgLength(value) {
  if (!value) return 0;
  const number = Number(String(value).replace(/px$/i, ''));
  return Number.isFinite(number) ? number : 0;
}

function extractColours(svg) {
  const colours = new Set();
  const text = String(svg || '');

  for (const match of text.matchAll(/#[0-9a-fA-F]{3,8}\b/g)) {
    colours.add(normaliseHex(match[0]));
  }

  for (const match of text.matchAll(/rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)/g)) {
    colours.add(rgbToHex(Number(match[1]), Number(match[2]), Number(match[3])));
  }

  return colours;
}

function classifyColours(colours) {
  const counts = { brown: 0, green: 0, blue: 0, yellow: 0 };
  for (const colour of colours) {
    const rgb = hexToRgb(colour);
    if (!rgb) continue;
    const { r, g, b } = rgb;
    if (r >= 90 && r <= 210 && g >= 45 && g <= 170 && b <= 110 && r > b + 35) counts.brown += 1;
    if (g >= 90 && g > r * 0.75 && g > b * 1.1) counts.green += 1;
    if (b >= 120 && g >= 100 && r <= 140) counts.blue += 1;
    if (r >= 160 && g >= 120 && b <= 90) counts.yellow += 1;
  }
  return counts;
}

function normaliseHex(hex) {
  const raw = hex.replace('#', '');
  if (raw.length === 3) return '#' + raw.split('').map((c) => c + c).join('').toLowerCase();
  return '#' + raw.slice(0, 6).toLowerCase();
}

function hexToRgb(hex) {
  const raw = normaliseHex(hex).slice(1);
  if (raw.length !== 6) return null;
  return { r: parseInt(raw.slice(0, 2), 16), g: parseInt(raw.slice(2, 4), 16), b: parseInt(raw.slice(4, 6), 16) };
}

function rgbToHex(r, g, b) {
  return '#' + [r, g, b].map((value) => Math.max(0, Math.min(255, value)).toString(16).padStart(2, '0')).join('');
}

function round(value) {
  return Number.isFinite(value) ? Number(value.toFixed(2)) : value;
}
