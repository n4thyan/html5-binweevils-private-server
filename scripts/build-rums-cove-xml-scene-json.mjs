import { mkdir, readdir, readFile, writeFile } from 'node:fs/promises';
import path from 'node:path';

import { extractRumsCoveXmlPlacement } from '../src/rooms/RumsCoveXmlPlacementExtract.js';

const inputPath = process.argv[2] || 'xml/RumsAirport_dynamAds_videoPodv2.xml';
const outputPath = process.argv[3] || 'public/generated/rums-cove-xml-scene.json';
const exportRoot = 'reference/rooms/RumsAirport_dynamAds_videoPodv2_release/RumsAirport_dynamAds_videoPodv2_release';

const repoRoot = process.cwd();
const xmlText = await readFile(path.resolve(repoRoot, inputPath), 'utf8');
const result = extractRumsCoveXmlPlacement(xmlText);
const assetIndex = await buildAssetIndex(path.resolve(repoRoot, exportRoot));

const placements = result.placements
  .filter((placement) => placement.characterId > 0)
  .map((placement) => {
    const asset = resolveAsset(placement, assetIndex);
    return {
      tagIndex: placement.tagIndex,
      type: placement.type,
      depth: placement.depth,
      characterId: placement.characterId,
      name: placement.name,
      className: placement.className,
      spritePath: asset?.path || '',
      assetKind: asset?.kind || '',
      assetMatch: asset?.match || '',
      mapped: Boolean(asset),
      matrix: placement.matrix
    };
  })
  .sort((a, b) => a.depth - b.depth || a.tagIndex - b.tagIndex);

const payload = {
  generatedBy: 'scripts/build-rums-cove-xml-scene-json.mjs',
  sourceXml: inputPath.replaceAll('\\', '/'),
  exportRoot,
  mappingStrategy: [
    'className tail -> exported sprite folder',
    'full className slug -> exported sprite folder',
    'characterId -> exported sprite folder',
    'characterId -> exported shape SVG file'
  ],
  stats: {
    rootItemCount: result.rootItemCount,
    placementCount: result.placementCount,
    namedPlacementCount: result.namedPlacementCount,
    characterPlacementCount: placements.length,
    mappedPlacementCount: placements.filter((placement) => placement.mapped).length,
    unmappedPlacementCount: placements.filter((placement) => !placement.mapped).length,
    spriteAssetCount: assetIndex.spriteAssets.length,
    shapeAssetCount: assetIndex.shapeAssets.length
  },
  placements
};

const absoluteOutputPath = path.resolve(repoRoot, outputPath);
await mkdir(path.dirname(absoluteOutputPath), { recursive: true });
await writeFile(absoluteOutputPath, JSON.stringify(payload, null, 2), 'utf8');

console.log('RumsCove XML scene JSON built');
console.log(`input: ${inputPath}`);
console.log(`output: ${outputPath}`);
console.log(`placements: ${payload.stats.characterPlacementCount}`);
console.log(`mapped: ${payload.stats.mappedPlacementCount}`);
console.log(`unmapped: ${payload.stats.unmappedPlacementCount}`);
console.log(`spriteAssets: ${payload.stats.spriteAssetCount}`);
console.log(`shapeAssets: ${payload.stats.shapeAssetCount}`);
console.log('next: open /probes/rums-cove-all-xml-placements.html');

function resolveAsset(placement, assetIndex) {
  if (placement.className) {
    const classTail = placement.className.split('.').at(-1);
    const byTail = assetIndex.byClassTail.get(classTail);
    if (byTail) return { ...byTail, match: 'class-tail' };

    const classSlug = placement.className.replaceAll('.', '_');
    const bySlug = assetIndex.byClassSlug.get(classSlug);
    if (bySlug) return { ...bySlug, match: 'class-slug' };

    const byContains = assetIndex.spriteAssets.find((asset) => asset.folder.includes(classTail));
    if (byContains) return { ...byContains, match: 'class-contains' };
  }

  const bySpriteId = assetIndex.bySpriteId.get(placement.characterId);
  if (bySpriteId) return { ...bySpriteId, match: 'sprite-id' };

  const byShapeId = assetIndex.byShapeId.get(placement.characterId);
  if (byShapeId) return { ...byShapeId, match: 'shape-id' };

  return null;
}

async function buildAssetIndex(root) {
  const spriteAssets = await listSpriteAssets(path.join(root, 'sprites'));
  const shapeAssets = await listShapeAssets(path.join(root, 'shapes'));

  const bySpriteId = new Map();
  const byShapeId = new Map();
  const byClassTail = new Map();
  const byClassSlug = new Map();

  for (const asset of spriteAssets) {
    bySpriteId.set(asset.id, asset);
    if (asset.classTail) byClassTail.set(asset.classTail, asset);
    if (asset.classSlug) byClassSlug.set(asset.classSlug, asset);
  }

  for (const asset of shapeAssets) {
    byShapeId.set(asset.id, asset);
  }

  return { spriteAssets, shapeAssets, bySpriteId, byShapeId, byClassTail, byClassSlug };
}

async function listSpriteAssets(spritesRoot) {
  let entries = [];
  try {
    entries = await readdir(spritesRoot, { withFileTypes: true });
  } catch (error) {
    return [];
  }

  const assets = [];
  for (const entry of entries) {
    if (!entry.isDirectory()) continue;
    const match = entry.name.match(/^DefineSprite_(\d+)_(.+)$/);
    if (!match) continue;
    const classSlug = match[2];
    const classTail = classSlug.split('.').at(-1);
    assets.push({
      kind: 'sprite',
      id: Number(match[1]),
      folder: entry.name,
      classSlug,
      classTail,
      path: `${exportRoot}/sprites/${entry.name}/1.svg`.replaceAll('\\', '/')
    });
  }

  return assets.sort((a, b) => a.id - b.id);
}

async function listShapeAssets(shapesRoot) {
  let entries = [];
  try {
    entries = await readdir(shapesRoot, { withFileTypes: true });
  } catch (error) {
    return [];
  }

  const assets = [];
  for (const entry of entries) {
    if (!entry.isFile()) continue;
    if (!entry.name.endsWith('.svg')) continue;
    const match = entry.name.match(/^DefineShape\w*_(\d+)\.svg$/);
    if (!match) continue;
    assets.push({
      kind: 'shape',
      id: Number(match[1]),
      folder: '',
      classSlug: '',
      classTail: '',
      path: `${exportRoot}/shapes/${entry.name}`.replaceAll('\\', '/')
    });
  }

  return assets.sort((a, b) => a.id - b.id);
}
