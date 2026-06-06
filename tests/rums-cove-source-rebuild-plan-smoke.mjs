import assert from 'node:assert/strict';

import {
  RUMS_COVE_DEBUG_PROOFS_TO_KEEP,
  RUMS_COVE_EXPORT_FAMILY,
  RUMS_COVE_SOURCE_REBUILD_INPUTS,
  RUMS_COVE_SOURCE_REBUILD_RULES,
  RUMS_COVE_SOURCE_REBUILD_STEPS,
  assertRumsCoveSourceRebuildPolicy,
  getRumsCoveSourceRebuildSummary
} from '../src/rooms/RumsCoveSourceRebuildPlan.js';

assert.equal(assertRumsCoveSourceRebuildPolicy(), true);

assert.equal(RUMS_COVE_SOURCE_REBUILD_RULES.system, 'RumsCove FixedCamera room source rebuild');
assert.equal(RUMS_COVE_SOURCE_REBUILD_RULES.status, 'rebuild-plan');
assert.equal(RUMS_COVE_SOURCE_REBUILD_RULES.locId, 129);
assert.equal(RUMS_COVE_SOURCE_REBUILD_RULES.locName, 'RumsCove');
assert.equal(RUMS_COVE_SOURCE_REBUILD_RULES.currentFramePngUse, 'debug/calibration only');
assert.equal(RUMS_COVE_SOURCE_REBUILD_RULES.finalRoomMayUseBakedFramePng, false);
assert.equal(RUMS_COVE_SOURCE_REBUILD_RULES.finalRoomMayUseOriginalBitmapExports, true);
assert.equal(RUMS_COVE_SOURCE_REBUILD_RULES.finalRoomMustUseSourceSpritesLayersMasksWhereAvailable, true);
assert.equal(RUMS_COVE_SOURCE_REBUILD_RULES.finalRoomMustKeepLocFixedCamData, true);
assert.equal(RUMS_COVE_SOURCE_REBUILD_RULES.finalRoomMustKeepDoorAndInteractiveData, true);

assert.equal(RUMS_COVE_EXPORT_FAMILY.locDefinitionRoomBg, 'fixedCam/RumsAirport_180321.swf');
assert.equal(RUMS_COVE_EXPORT_FAMILY.uploadedExportFamily, 'RumsAirport_dynamAds_videoPodv2_release');
assert.ok(RUMS_COVE_EXPORT_FAMILY.caution.includes('exact equivalence'));

assert.ok(RUMS_COVE_SOURCE_REBUILD_INPUTS.some((input) => input.key === 'loc-definition'));
assert.ok(RUMS_COVE_SOURCE_REBUILD_INPUTS.some((input) => input.key === 'loc-fixed-cam-source'));
assert.ok(RUMS_COVE_SOURCE_REBUILD_INPUTS.some((input) => input.key === 'room-export-folder'));
assert.ok(RUMS_COVE_SOURCE_REBUILD_INPUTS.some((input) => input.key === 'room-frame-preview' && input.finalUse.includes('not final room render')));

assert.deepEqual(RUMS_COVE_SOURCE_REBUILD_STEPS.slice(0, 3), [
  'audit-room-export-folders',
  'list-symbols-and-frame-elements',
  'identify-background-layers'
]);
assert.ok(RUMS_COVE_SOURCE_REBUILD_STEPS.includes('remove-frame-preview-from-final-render-path'));
assert.ok(RUMS_COVE_DEBUG_PROOFS_TO_KEEP.includes('/probes/rums-cove-weevil.html'));
assert.ok(RUMS_COVE_DEBUG_PROOFS_TO_KEEP.includes('/probes/main-shell-rums-cove.html'));

const summary = getRumsCoveSourceRebuildSummary();
assert.equal(summary.locId, 129);
assert.equal(summary.locName, 'RumsCove');
assert.equal(summary.finalRoomMayUseBakedFramePng, false);
assert.equal(summary.nextAction, 'audit-room-export-folders');

console.log('rums-cove source rebuild plan smoke test passed');
console.log(`${summary.locName} loc ${summary.locId} / ${summary.status} / next=${summary.nextAction}`);
