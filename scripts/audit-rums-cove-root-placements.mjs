import { readFile } from 'node:fs/promises';
import path from 'node:path';

const generatedPath = process.argv[2] || 'public/generated/rums-cove-xml-scene.json';
const repoRoot = process.cwd();
const scene = JSON.parse(await readFile(path.resolve(repoRoot, generatedPath), 'utf8'));

const rows = [];
for (const placement of scene.placements || []) {
  const svgPath = placement.spritePath ? path.resolve(repoRoot, placement.spritePath) : '';
  const svg = svgPath ? await readFile(svgPath, 'utf8').catch(() => '') : '';
  const size = extractSvgSize(svg);
  const colours = extractColours(svg);
  rows.push({
    depth: placement.depth,
    tagIndex: placement.tagIndex,
    characterId: placement.characterId,
    name: placement.name || '(unnamed)',
    className: placement.className || '(none)',
    mapped: placement.mapped,
    assetKind: placement.assetKind || '(none)',
    assetMatch: placement.assetMatch || '(none)',
    width: size.width,
    height: size.height,
    area: size.width * size.height,
    matrix: placement.matrix,
    colours: classifyColours(colours),
    sampleColours: [...colours].slice(0, 10),
    path: placement.spritePath || '(unmapped)'
  });
}

console.log('RumsCove focused root placement audit');
console.log(`source: ${generatedPath}`);
console.log(`placements: ${rows.length}`);
console.log(`mapped: ${rows.filter((row) => row.mapped).length}`);
console.log(`unmapped: ${rows.filter((row) => !row.mapped).length}`);
console.log('');
console.log('Root placements by source depth:');

for (const row of rows.sort((a, b) => a.depth - b.depth || a.tagIndex - b.tagIndex)) {
  console.log([
    `depth=${row.depth}`,
    `tag=${row.tagIndex}`,
    `cid=${row.characterId}`,
    `name=${row.name}`,
    `kind=${row.assetKind}`,
    `match=${row.assetMatch}`,
    `size=${round(row.width)}x${round(row.height)}`,
    `area=${round(row.area)}`,
    `blue=${row.colours.blue}`,
    `green=${row.colours.green}`,
    `brown=${row.colours.brown}`,
    `yellow=${row.colours.yellow}`,
    `matrix=${cssMatrix(row.matrix)}`,
    `path=${row.path}`
  ].join(' | '));
}

console.log('');
console.log('Likely render decisions:');
for (const row of rows.sort((a, b) => a.depth - b.depth || a.tagIndex - b.tagIndex)) {
  console.log(`  ${decisionFor(row)} :: depth=${row.depth} cid=${row.characterId} name=${row.name} path=${row.path}`);
}

function decisionFor(row) {
  if (!row.mapped) return 'UNMAPPED - inspect source export/class map';
  if (row.name === 'floorClickArea_btn') return 'DEBUG/COLLISION - do not render as visible floor';
  if (row.name.includes('door') || row.name.includes('Door')) return 'VISIBLE DOOR/HOTSPOT ART';
  if (row.name === 'fence') return 'VISIBLE ENV DETAIL';
  if (row.name === 'buildings') return 'VISIBLE MAIN COMPOSITE';
  if (row.name === 'remoteBack' || row.name === 'remoteDoorOverlay') return 'VISIBLE POD/REMOTE COMPOSITE';
  if (row.characterId === 2 || row.characterId === 14 || row.characterId === 59 || row.characterId === 60) return 'VISIBLE BACKDROP CANDIDATE';
  if (row.className.includes('plane')) return 'DEFER ANIMATION/PLANE';
  if (row.name === 'mulchtasticBooth') return 'DEFER/OPTIONAL PROP';
  return 'REVIEW MANUALLY';
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
  for (const match of String(svg || '').matchAll(/#[0-9a-fA-F]{3,8}\b/g)) {
    colours.add(normaliseHex(match[0]));
  }
  return colours;
}

function classifyColours(colours) {
  const counts = { brown: 0, green: 0, blue: 0, yellow: 0 };
  for (const colour of colours) {
    const rgb = hexToRgb(colour);
    if (!rgb) continue;
    const { r, g, b } = rgb;
    if (r >= 90 && r <= 215 && g >= 45 && g <= 170 && b <= 125 && r > b + 25) counts.brown += 1;
    if (g >= 90 && g > r * 0.7 && g > b * 1.05) counts.green += 1;
    if (b >= 115 && g >= 90 && r <= 165) counts.blue += 1;
    if (r >= 150 && g >= 115 && b <= 95) counts.yellow += 1;
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

function cssMatrix(matrix) {
  return `matrix(${round(matrix.scaleX)}, ${round(matrix.rotateSkew0)}, ${round(matrix.rotateSkew1)}, ${round(matrix.scaleY)}, ${round(matrix.x)}, ${round(matrix.y)})`;
}

function round(value) {
  return Number.isFinite(value) ? Number(value.toFixed(3)) : value;
}
