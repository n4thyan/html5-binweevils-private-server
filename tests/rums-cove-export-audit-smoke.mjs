import assert from 'node:assert/strict';

import {
  RUMS_COVE_EXPECTED_EXPORT_FOLDERS,
  RUMS_COVE_EXPORT_ROOT,
  RUMS_COVE_REBUILD_FOLDER_ROLES,
  auditRumsCoveExportRelativeFiles,
  createEmptyRumsCoveExportAudit,
  formatRumsCoveExportAudit,
  getRumsCoveExpectedExportFolders,
  getTopLevelExportFolder,
  normaliseExportRelativePath
} from '../src/rooms/RumsCoveExportAudit.js';

assert.equal(RUMS_COVE_EXPORT_ROOT, 'reference/rooms/RumsAirport_dynamAds_videoPodv2_release/RumsAirport_dynamAds_videoPodv2_release');
assert.ok(RUMS_COVE_EXPECTED_EXPORT_FOLDERS.includes('frames'));
assert.ok(RUMS_COVE_EXPECTED_EXPORT_FOLDERS.includes('sprites'));
assert.ok(RUMS_COVE_EXPECTED_EXPORT_FOLDERS.includes('shapes'));
assert.ok(RUMS_COVE_EXPECTED_EXPORT_FOLDERS.includes('images'));
assert.ok(RUMS_COVE_REBUILD_FOLDER_ROLES.frames.includes('debug/comparison'));
assert.ok(RUMS_COVE_REBUILD_FOLDER_ROLES.sprites.includes('final room layer rebuild'));

assert.equal(normaliseExportRelativePath('.\\frames\\1.png'), 'frames/1.png');
assert.equal(getTopLevelExportFolder('sprites/DefineSprite_1/1.svg'), 'sprites');
assert.deepEqual(getRumsCoveExpectedExportFolders(), [...RUMS_COVE_EXPECTED_EXPORT_FOLDERS]);

const emptyAudit = createEmptyRumsCoveExportAudit();
assert.equal(emptyAudit.totalFiles, 0);
assert.equal(emptyAudit.hasFramePreview, false);
assert.equal(emptyAudit.missingExpectedFolders.length, RUMS_COVE_EXPECTED_EXPORT_FOLDERS.length);
assert.equal(emptyAudit.recommendedNextStep, 'extract or locate the room export folder before rebuilding layers');

const audit = auditRumsCoveExportRelativeFiles([
  'frames/1.png',
  'sprites/DefineSprite_1/1.svg',
  'sprites/DefineSprite_2/1.svg',
  'shapes/1.svg',
  'images/1.png',
  'scripts/Room.as',
  'symbolClass/symbols.csv',
  'unknownFolder/example.txt'
]);

assert.equal(audit.totalFiles, 8);
assert.equal(audit.folderCounts.frames, 1);
assert.equal(audit.folderCounts.sprites, 2);
assert.equal(audit.folderCounts.shapes, 1);
assert.equal(audit.folderCounts.images, 1);
assert.equal(audit.folderCounts.scripts, 1);
assert.equal(audit.folderCounts.symbolClass, 1);
assert.equal(audit.hasFramePreview, true);
assert.equal(audit.hasSprites, true);
assert.equal(audit.hasShapes, true);
assert.equal(audit.hasImages, true);
assert.equal(audit.hasScripts, true);
assert.ok(audit.extraTopLevelFolders.includes('unknownFolder'));
assert.equal(audit.recommendedNextStep, 'list-symbols-and-frame-elements');

const formatted = formatRumsCoveExportAudit(audit);
assert.ok(formatted.includes('RumsCove export audit'));
assert.ok(formatted.includes('frames: 1'));
assert.ok(formatted.includes('sprites: 2'));
assert.ok(formatted.includes('recommendedNextStep: list-symbols-and-frame-elements'));

console.log('rums-cove export audit smoke test passed');
console.log(`${audit.totalFiles} sample files / next=${audit.recommendedNextStep}`);
