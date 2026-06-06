import assert from 'node:assert/strict';

import {
  ASSET_SOURCE_TYPES,
  ASSET_USE_CONTEXTS,
  SOURCE_ASSET_USE_POLICY,
  SOURCE_ASSET_USE_RULES,
  assertSourceAssetUsePolicy,
  classifyAssetUse
} from '../src/port/AssetUsePolicy.js';

assert.equal(assertSourceAssetUsePolicy(), true);

assert.equal(SOURCE_ASSET_USE_POLICY.bakedFramePngsAllowedForDebug, true);
assert.equal(SOURCE_ASSET_USE_POLICY.bakedFramePngsAllowedForFinalRooms, false);
assert.equal(SOURCE_ASSET_USE_POLICY.bakedFramePngsAllowedForFinalUiShell, false);
assert.equal(SOURCE_ASSET_USE_POLICY.originalBitmapExportsAllowedForFinal, true);
assert.equal(SOURCE_ASSET_USE_POLICY.originalSvgExportsAllowedForFinal, true);
assert.equal(SOURCE_ASSET_USE_POLICY.originalSpritesShapesMasksAllowedForFinal, true);
assert.equal(SOURCE_ASSET_USE_POLICY.screenshotsAllowedAsLayoutReference, true);
assert.equal(SOURCE_ASSET_USE_POLICY.screenshotsAllowedAsAssetSource, false);
assert.equal(SOURCE_ASSET_USE_POLICY.inventedPermanentAssetsAllowed, false);
assert.equal(SOURCE_ASSET_USE_POLICY.finalRoomsMustPreferSourceStructure, true);
assert.equal(SOURCE_ASSET_USE_POLICY.finalUiMustPreferSourceStructure, true);

assert.ok(SOURCE_ASSET_USE_RULES.some((rule) => rule.id === 'debug-frame-pngs-are-temporary'));
assert.ok(SOURCE_ASSET_USE_RULES.some((rule) => rule.id === 'final-port-rebuilds-source-structure'));
assert.ok(SOURCE_ASSET_USE_RULES.some((rule) => rule.id === 'original-bitmaps-are-real-assets'));
assert.ok(SOURCE_ASSET_USE_RULES.some((rule) => rule.id === 'screenshots-are-reference-only'));

const debugFrame = classifyAssetUse({
  context: ASSET_USE_CONTEXTS.DEBUG_PROBE,
  sourceType: ASSET_SOURCE_TYPES.BAKED_FRAME_PNG
});
assert.equal(debugFrame.allowed, true);
assert.equal(debugFrame.finalAllowed, false);

const finalFrame = classifyAssetUse({
  context: ASSET_USE_CONTEXTS.FINAL_PORT,
  sourceType: ASSET_SOURCE_TYPES.BAKED_FRAME_PNG
});
assert.equal(finalFrame.allowed, false);
assert.equal(finalFrame.finalAllowed, false);
assert.ok(finalFrame.reason.includes('temporary'));

const originalBitmap = classifyAssetUse({
  context: ASSET_USE_CONTEXTS.FINAL_PORT,
  sourceType: ASSET_SOURCE_TYPES.ORIGINAL_BITMAP_EXPORT,
  sourceBacked: true
});
assert.equal(originalBitmap.allowed, true);
assert.equal(originalBitmap.finalAllowed, true);

const originalSvg = classifyAssetUse({
  context: ASSET_USE_CONTEXTS.FINAL_PORT,
  sourceType: ASSET_SOURCE_TYPES.ORIGINAL_SVG_EXPORT,
  sourceBacked: true
});
assert.equal(originalSvg.allowed, true);
assert.equal(originalSvg.finalAllowed, true);

const screenshot = classifyAssetUse({
  context: ASSET_USE_CONTEXTS.FINAL_PORT,
  sourceType: ASSET_SOURCE_TYPES.SCREENSHOT_REFERENCE
});
assert.equal(screenshot.allowed, false);
assert.equal(screenshot.finalAllowed, false);

const placeholder = classifyAssetUse({
  context: ASSET_USE_CONTEXTS.FINAL_PORT,
  sourceType: ASSET_SOURCE_TYPES.INVENTED_PLACEHOLDER
});
assert.equal(placeholder.allowed, false);
assert.equal(placeholder.finalAllowed, false);

console.log('source asset use policy smoke test passed');
console.log('debug PNGs allowed, final baked screenshots forbidden, original exported assets allowed');
