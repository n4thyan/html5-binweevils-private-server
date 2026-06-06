import assert from 'node:assert/strict';

import {
  RUMS_COVE_SYMBOL_AUDIT_KEYWORDS,
  RUMS_COVE_SYMBOL_AUDIT_LIMITS,
  chooseRecommendedNextStep,
  createRumsCoveSymbolFrameAudit,
  findKeywordMatches,
  formatRumsCoveSymbolFrameAudit,
  getTopLevelExportFolder,
  normaliseAuditPath,
  normaliseFileEntry,
  topBySize
} from '../src/rooms/RumsCoveSymbolFrameAudit.js';

assert.ok(RUMS_COVE_SYMBOL_AUDIT_KEYWORDS.includes('door'));
assert.ok(RUMS_COVE_SYMBOL_AUDIT_KEYWORDS.includes('plane'));
assert.ok(RUMS_COVE_SYMBOL_AUDIT_LIMITS.topSprites >= 20);

assert.equal(normaliseAuditPath('.\\sprites\\DefineSprite_1\\1.svg'), 'sprites/DefineSprite_1/1.svg');
assert.deepEqual(normaliseFileEntry('frames/1.png'), { path: 'frames/1.png', size: 0 });
assert.deepEqual(normaliseFileEntry({ path: 'scripts/Room.as', size: 123 }), { path: 'scripts/Room.as', size: 123 });

const sized = topBySize([
  { path: 'sprites/a.svg', size: 10 },
  { path: 'sprites/b.svg', size: 40 },
  { path: 'sprites/c.svg', size: 20 }
], 2);
assert.deepEqual(sized, [
  { path: 'sprites/b.svg', size: 40 },
  { path: 'sprites/c.svg', size: 20 }
]);

const keywordMatches = findKeywordMatches([
  { path: 'scripts/RumsAirport.as', size: 100 },
  { path: 'sprites/door_hit/1.svg', size: 200 },
  { path: 'sprites/random/1.svg', size: 300 }
], ['rums', 'door']);
assert.deepEqual(keywordMatches.map((entry) => entry.path), ['scripts/RumsAirport.as', 'sprites/door_hit/1.svg']);

assert.equal(chooseRecommendedNextStep({ sprites: [1], shapes: [1], scripts: [1], symbolClass: [1], keywordMatches: [1] }), 'inspect-symbolClass-and-room-related-scripts');
assert.equal(chooseRecommendedNextStep({ sprites: [1], shapes: [1], scripts: [], symbolClass: [], keywordMatches: [] }), 'inspect-largest-sprites-and-shapes');

const audit = createRumsCoveSymbolFrameAudit([
  { path: 'frames/1.png', size: 1000 },
  { path: 'sprites/DefineSprite_1/1.svg', size: 100 },
  { path: 'sprites/DefineSprite_2/1.svg', size: 300 },
  { path: 'shapes/DefineShape_1.svg', size: 80 },
  { path: 'scripts/RumsAirport.as', size: 50 },
  { path: 'buttons/doorBtn/1.svg', size: 40 },
  { path: 'images/1.png', size: 500 },
  { path: 'morphshapes/1.svg', size: 25 },
  { path: 'symbolClass/symbols.csv', size: 20 }
]);

assert.equal(audit.totalFiles, 9);
assert.equal(audit.counts.frames, 1);
assert.equal(audit.counts.sprites, 2);
assert.equal(audit.counts.shapes, 1);
assert.equal(audit.counts.scripts, 1);
assert.equal(audit.counts.buttons, 1);
assert.equal(audit.counts.images, 1);
assert.equal(audit.counts.morphshapes, 1);
assert.equal(audit.counts.symbolClass, 1);
assert.equal(audit.topSpritesBySize[0].path, 'sprites/DefineSprite_2/1.svg');
assert.ok(audit.keywordMatches.some((entry) => entry.path === 'buttons/doorBtn/1.svg'));
assert.equal(audit.recommendedNextStep, 'inspect-symbolClass-and-room-related-scripts');

const formatted = formatRumsCoveSymbolFrameAudit(audit);
assert.ok(formatted.includes('RumsCove symbol/frame audit'));
assert.ok(formatted.includes('topSpritesBySize'));
assert.ok(formatted.includes('keywordMatches'));
assert.ok(formatted.includes('recommendedNextStep: inspect-symbolClass-and-room-related-scripts'));

console.log('rums-cove symbol/frame audit smoke test passed');
console.log(`${audit.totalFiles} sample files / next=${audit.recommendedNextStep}`);
