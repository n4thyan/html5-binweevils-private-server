import assert from 'node:assert/strict';

import {
  VIEWPORT_SLIME_FRAME_EXPECTED_PARTS,
  VIEWPORT_SLIME_FRAME_KNOWN_NOT_SOURCES,
  VIEWPORT_SLIME_FRAME_MAIN_CANDIDATES,
  VIEWPORT_SLIME_FRAME_NON_GOALS_NOW,
  VIEWPORT_SLIME_FRAME_PORT_ORDER,
  VIEWPORT_SLIME_FRAME_RULES,
  VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY,
  assertViewportSlimeFrameSourcePolicy,
  getViewportSlimeFrameStatus,
  getViewportSlimeMainCandidatePaths
} from '../src/ui/ViewportSlimeFrameSourceMap.js';

assert.equal(VIEWPORT_SLIME_FRAME_RULES.system, 'game viewport slime frame / canvas shell');
assert.equal(VIEWPORT_SLIME_FRAME_RULES.status, 'main-candidates-identified');
assert.equal(VIEWPORT_SLIME_FRAME_RULES.mayUseScreenshotAsLayoutReference, true);
assert.equal(VIEWPORT_SLIME_FRAME_RULES.mayUseScreenshotAsAssetSource, false);
assert.equal(VIEWPORT_SLIME_FRAME_RULES.mayInventPermanentArt, false);
assert.equal(VIEWPORT_SLIME_FRAME_RULES.mayUseTemporaryDebugOutline, true);
assert.equal(VIEWPORT_SLIME_FRAME_RULES.temporaryDebugOutlineMustBeLabelled, true);

assert.equal(assertViewportSlimeFrameSourcePolicy(), true);

assert.ok(VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY.length >= 3);
assert.equal(VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY[0].source, 'reference/decompiled-dumpassets/dumpassets/mainDEV661.swf');
assert.ok(VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY[0].reason.includes('green slime/canvas shell'));
assert.equal(VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY[2].source, 'reference/decompiled-dumpassets/dumpassets/core5.swf');
assert.ok(VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY[2].reason.includes('playercard icons are a separate UI target'));
assert.equal(VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY.at(-1).reason, 'layout reference only; not an asset source');

assert.equal(VIEWPORT_SLIME_FRAME_MAIN_CANDIDATES.length, 4);
assert.ok(VIEWPORT_SLIME_FRAME_MAIN_CANDIDATES.some((candidate) => candidate.path === 'reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/frames/1.png'));
assert.ok(VIEWPORT_SLIME_FRAME_MAIN_CANDIDATES.some((candidate) => candidate.path === 'reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_4/1.svg'));
assert.ok(VIEWPORT_SLIME_FRAME_MAIN_CANDIDATES.some((candidate) => candidate.path === 'reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_96/1.svg'));
assert.ok(VIEWPORT_SLIME_FRAME_MAIN_CANDIDATES.some((candidate) => candidate.path === 'reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/sprites/DefineSprite_113/1.svg'));

const candidatePaths = getViewportSlimeMainCandidatePaths();
assert.equal(candidatePaths.length, VIEWPORT_SLIME_FRAME_MAIN_CANDIDATES.length);
assert.ok(candidatePaths.every((path) => path.includes('mainDEV661.swf')));

assert.ok(VIEWPORT_SLIME_FRAME_KNOWN_NOT_SOURCES.some((entry) => entry.item === 'DefineShape4 2474/2475/2476 screenshot'));
assert.ok(VIEWPORT_SLIME_FRAME_KNOWN_NOT_SOURCES.some((entry) => entry.reason.includes('not the green slime viewport shell')));

assert.ok(VIEWPORT_SLIME_FRAME_EXPECTED_PARTS.some((part) => part.key === 'topSlimeRail' && part.required));
assert.ok(VIEWPORT_SLIME_FRAME_EXPECTED_PARTS.some((part) => part.key === 'viewportMask' && part.required));
assert.ok(VIEWPORT_SLIME_FRAME_EXPECTED_PARTS.some((part) => part.key === 'contentLayerBehindFrame' && part.required));

assert.deepEqual(VIEWPORT_SLIME_FRAME_PORT_ORDER.slice(0, 2), [
  'prove-main-frame-preview-loads-in-browser',
  'prove-main-symbol-candidates-load-in-browser'
]);
assert.ok(VIEWPORT_SLIME_FRAME_NON_GOALS_NOW.includes('playercard icons'));
assert.ok(VIEWPORT_SLIME_FRAME_NON_GOALS_NOW.includes('3D camera controls for fixed-camera rooms'));
assert.ok(VIEWPORT_SLIME_FRAME_NON_GOALS_NOW.includes('backend/session UI state'));

const status = getViewportSlimeFrameStatus();
assert.equal(status.system, VIEWPORT_SLIME_FRAME_RULES.system);
assert.equal(status.status, 'main-candidates-identified');
assert.equal(status.expectedParts, VIEWPORT_SLIME_FRAME_EXPECTED_PARTS.length);
assert.equal(status.mainCandidateCount, 4);
assert.equal(status.nextAction, 'prove-main-frame-preview-loads-in-browser');

console.log('viewport slime frame source map smoke test passed');
console.log(`${status.system} / ${status.status} / next=${status.nextAction}`);
