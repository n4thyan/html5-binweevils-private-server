import assert from 'node:assert/strict';

import {
  RUMS_COVE_DEBUG_ENTRY_MARKER,
  RUMS_COVE_DEBUG_WEEVIL_PLACEMENT,
  RUMS_COVE_PREVIEW_CANDIDATE_PATHS,
  RUMS_COVE_PREVIEW_IMAGE,
  createRumsCoveProbeRenderConfig,
  getRumsCovePreviewCalibrationSummary,
  getRumsCovePreviewCandidatePaths
} from '../src/rooms/RumsCovePreviewCalibration.js';

assert.equal(RUMS_COVE_PREVIEW_IMAGE.width, 614);
assert.equal(RUMS_COVE_PREVIEW_IMAGE.height, 366);
assert.ok(RUMS_COVE_PREVIEW_IMAGE.expectedPath.endsWith('/frames/1.png'));

assert.ok(RUMS_COVE_PREVIEW_CANDIDATE_PATHS.length >= 2);
assert.ok(RUMS_COVE_PREVIEW_CANDIDATE_PATHS.includes(RUMS_COVE_PREVIEW_IMAGE.expectedPath));
assert.deepEqual(getRumsCovePreviewCandidatePaths(), [...RUMS_COVE_PREVIEW_CANDIDATE_PATHS]);

assert.equal(RUMS_COVE_DEBUG_ENTRY_MARKER.roomX, 0);
assert.equal(RUMS_COVE_DEBUG_ENTRY_MARKER.roomZ, 80);
assert.equal(RUMS_COVE_DEBUG_ENTRY_MARKER.screenX, 238);
assert.equal(RUMS_COVE_DEBUG_ENTRY_MARKER.screenY, 292);

assert.equal(RUMS_COVE_DEBUG_WEEVIL_PLACEMENT.weevilScale, 0.18);
assert.equal(RUMS_COVE_DEBUG_WEEVIL_PLACEMENT.displayWidth, 66);
assert.equal(RUMS_COVE_DEBUG_WEEVIL_PLACEMENT.displayHeight, 66);
assert.equal(RUMS_COVE_DEBUG_WEEVIL_PLACEMENT.visualResult, 'confirmed plausible in local browser probe');

const summary = getRumsCovePreviewCalibrationSummary();
assert.equal(summary.locId, 129);
assert.equal(summary.locName, 'RumsCove');
assert.equal(summary.expectedFrameSize.width, 614);
assert.equal(summary.entryMarker.screenX, 238);
assert.equal(summary.weevilPlacement.screenX, 292);
assert.ok(summary.caveat.includes('debug-only calibration'));

const config = createRumsCoveProbeRenderConfig();
assert.equal(config.loc.id, 129);
assert.equal(config.loc.weevilScale, 0.18);
assert.equal(config.image.width, 614);
assert.equal(config.entryMarker.label, 'rough entryPos [0,80]');
assert.equal(config.weevilPlacement.scaleSource, 'locationDefinitions.xml weevilScale');

console.log('rums-cove preview calibration smoke test passed');
console.log(`${summary.locName} loc ${summary.locId} / ${summary.weevilPlacement.weevilScale} scale / ${summary.expectedFrameSize.width}x${summary.expectedFrameSize.height}`);
