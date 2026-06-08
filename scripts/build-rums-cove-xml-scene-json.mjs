import { mkdir, readdir, readFile, writeFile } from 'node:fs/promises';
import path from 'node:path';

import { extractRumsCoveXmlPlacement } from '../src/rooms/RumsCoveXmlPlacementExtract.js';

const inputPath = process.argv[2] || 'xml/RumsAirport_dynamAds_videoPodv2.xml';
const outputPath = process.argv[3] || 'public/generated/rums-cove-xml-scene.json';
const exportRoot = 'reference/rooms/RumsAirport_dynamAds_videoPodv2_release/RumsAirport_dynamAds_videoPodv2_release';

const repoRoot = process.cwd();
const xmlText = await readFile(path.resolve(repoRoot, inputPath), 'utf8');
const result = extractRumsCoveXmlPlacement(xmlText);
const spriteIndex = await buildSpriteIndex(path.resolve(repoRoot, exportRoot, 'sprites'));

const placements = result.placements
  .filter((placement) => placement.characterId > 0)
  .map((placement) => {
    const sprite = spriteIndex.get(placement.characterId) || null;
    return {
      tagIndex: placement.tagIndex,
      type: placement.type,
      depth: placement.depth,
      characterId: placement.characterId,
      name: placement.name,
      className: placement.className,
      spritePath: sprite ? `${exportRoot}/sprites/${sprite}/1.svg`.replaceAll('\\', '/') : '',
      mapped: Boolean(sprite),
      matrix: placement.matrix
    };
  })
  .sort((a, b) => a.depth - b.depth || a.tagIndex - b.tagIndex);

const payload = {
  generatedBy: 'scripts/build-rums-cove-xml-scene-json.mjs',
  sourceXml: inputPath.replaceAll('\\', '/'),
  exportRoot,
  stats: {
    rootItemCount: result.rootItemCount,
    placementCount: result.placementCount,
    namedPlacementCount: result.namedPlacementCount,
    characterPlacementCount: placements.length,
    mappedPlacementCount: placements.filter((placement) => placement.mapped).length,
    unmappedPlacementCount: placements.filter((placement) => !placement.mapped).length
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
console.log('next: open /probes/rums-cove-all-xml-placements.html');

async function buildSpriteIndex(spritesRoot) {
  const entries = await readdir(spritesRoot, { withFileTypes: true });
  const index = new Map();

  for (const entry of entries) {
    if (!entry.isDirectory()) continue;
    const match = entry.name.match(/^DefineSprite_(\d+)_/);
    if (!match) continue;
    index.set(Number(match[1]), entry.name);
  }

  return index;
}
