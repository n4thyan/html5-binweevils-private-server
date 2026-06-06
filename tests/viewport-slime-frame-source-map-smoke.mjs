import assert from 'node:assert/strict';

import {
  VIEWPORT_SLIME_FRAME_EXPECTED_PARTS,
  VIEWPORT_SLIME_FRAME_NON_GOALS_NOW,
  VIEWPORT_SLIME_FRAME_PORT_ORDER,
  VIEWPORT_SLIME_FRAME_RULES,
  VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY,
  assertViewportSlimeFrameSourcePolicy,
  getViewportSlimeFrameStatus
} from '../src/ui/ViewportSlimeFrameSourceMap.js';

assert.equal(VIEWPORT_SLIME_FRAME_RULES.system, 'game viewport slime frame / canvas shell');
assert.equal(VIEWPORT_SLIME_FRAME_RULES.status, 'source-map-target-only');
assert.equal(VIEWPORT_SLIME_FRAME_RULES.mayUseScreenshotAsLayoutReference, true);
assert.equal(VIEWPORT_SLIME_FRAME_RULES.mayUseScreenshotAsAssetSource, false);
assert.equal(VIEWPORT_SLIME_FRAME_RULES.mayInventPermanentArt, false);
assert.equal(VIEWPORT_SLIME_FRAME_RULES.mayUseTemporaryDebugOutline, true);
assert.equal(VIEWPORT_SLIME_FRAME_RULES.temporaryDebugOutlineMustBeLabelled, true);

assert.equal(assertViewportSlimeFrameSourcePolicy(), true);

assert.ok(VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY.length >= 3);
assert.equal(VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY[0].source, 'reference/decompiled-dumpassets/dumpassets/mainDEV661.swf');
assert.equal(VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY[1].source, 'reference/decompiled-dumpassets/dumpassets/core5.swf');
assert.equal(VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY.at(-1).reason, 'layout reference only; not an asset source');

assert.ok(VIEWPORT_SLIME_FRAME_EXPECTED_PARTS.some((part) => part.key === 'topSlimeRail' && part.required));
assert.ok(VIEWPORT_SLIME_FRAME_EXPECTED_PARTS.some((part) => part.key === 'viewportMask' && part.required));
assert.ok(VIEWPORT_SLIME_FRAME_EXPECTED_PARTS.some((part) => part.key === 'contentLayerBehindFrame' && part.required));

assert.deepEqual(VIEWPORT_SLIME_FRAME_PORT_ORDER.slice(0, 2), ['locate-source-symbols', 'prove-symbols-load-in-browser']);
assert.ok(VIEWPORT_SLIME_FRAME_NON_GOALS_NOW.includes('3D camera controls for fixed-camera rooms'));
assert.ok(VIEWPORT_SLIME_FRAME_NON_GOALS_NOW.includes('backend/session UI state'));

const status = getViewportSlimeFrameStatus();
assert.equal(status.system, VIEWPORT_SLIME_FRAME_RULES.system);
assert.equal(status.status, 'source-map-target-only');
assert.equal(status.expectedParts, VIEWPORT_SLIME_FRAME_EXPECTED_PARTS.length);
assert.equal(status.nextAction, 'locate-source-symbols');

console.log('viewport slime frame source map smoke test passed');
console.log(`${status.system} / ${status.status} / next=${status.nextAction}`);
