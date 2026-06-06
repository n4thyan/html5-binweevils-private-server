// Project-wide policy for using exported assets during the faithful HTML5 port.
//
// The short version:
// - baked full-frame PNGs are allowed for debug/probe calibration only.
// - baked full-frame PNGs are not acceptable as final replacements for rooms or UI.
// - original bitmap assets exported from SWFs are allowed when the original SWF used bitmaps.
// - final room/UI systems should rebuild from source-backed sprites, SVGs, bitmaps,
//   layers, masks, data and behaviour wherever those are available.

export const ASSET_USE_CONTEXTS = Object.freeze({
  DEBUG_PROBE: 'debug-probe',
  CALIBRATION: 'calibration',
  FINAL_PORT: 'final-port'
});

export const ASSET_SOURCE_TYPES = Object.freeze({
  BAKED_FRAME_PNG: 'baked-frame-png',
  ORIGINAL_BITMAP_EXPORT: 'original-bitmap-export',
  ORIGINAL_SVG_EXPORT: 'original-svg-export',
  ORIGINAL_SHAPE_OR_SPRITE: 'original-shape-or-sprite',
  SOURCE_DATA: 'source-data',
  SOURCE_BEHAVIOUR: 'source-behaviour',
  SCREENSHOT_REFERENCE: 'screenshot-reference',
  INVENTED_PLACEHOLDER: 'invented-placeholder'
});

export const SOURCE_ASSET_USE_POLICY = Object.freeze({
  bakedFramePngsAllowedForDebug: true,
  bakedFramePngsAllowedForFinalRooms: false,
  bakedFramePngsAllowedForFinalUiShell: false,
  originalBitmapExportsAllowedForFinal: true,
  originalSvgExportsAllowedForFinal: true,
  originalSpritesShapesMasksAllowedForFinal: true,
  screenshotsAllowedAsLayoutReference: true,
  screenshotsAllowedAsAssetSource: false,
  inventedPermanentAssetsAllowed: false,
  finalRoomsMustPreferSourceStructure: true,
  finalUiMustPreferSourceStructure: true
});

export const SOURCE_ASSET_USE_RULES = Object.freeze([
  Object.freeze({
    id: 'debug-frame-pngs-are-temporary',
    summary: 'Full exported frame PNGs may be used for probes, visual checks and calibration only.',
    appliesTo: ['rooms', 'ui-shell', 'boot-shell']
  }),
  Object.freeze({
    id: 'final-port-rebuilds-source-structure',
    summary: 'Final ported systems must rebuild from source-backed sprites, layers, masks, bitmaps, data and ActionScript behaviour wherever available.',
    appliesTo: ['rooms', 'ui-shell', 'playercard', 'chat', 'movement']
  }),
  Object.freeze({
    id: 'original-bitmaps-are-real-assets',
    summary: 'If the original SWF used bitmap assets, their exported PNG/JPEG files are valid final assets.',
    appliesTo: ['rooms', 'ui-shell', 'objects', 'backgrounds']
  }),
  Object.freeze({
    id: 'screenshots-are-reference-only',
    summary: 'Screenshots can guide layout and visual comparison, but cannot become final assets.',
    appliesTo: ['rooms', 'ui-shell', 'playercard', 'reference']
  }),
  Object.freeze({
    id: 'placeholders-must-be-labelled',
    summary: 'Temporary invented placeholders must be labelled and cannot count as milestone-complete final work.',
    appliesTo: ['debug', 'missing-assets']
  })
]);

export function classifyAssetUse({ context, sourceType, sourceBacked = false }) {
  if (sourceType === ASSET_SOURCE_TYPES.SCREENSHOT_REFERENCE) {
    return Object.freeze({
      allowed: context !== ASSET_USE_CONTEXTS.FINAL_PORT,
      finalAllowed: false,
      reason: 'screenshots are layout/reference only and must not become final assets'
    });
  }

  if (sourceType === ASSET_SOURCE_TYPES.BAKED_FRAME_PNG) {
    return Object.freeze({
      allowed: context !== ASSET_USE_CONTEXTS.FINAL_PORT,
      finalAllowed: false,
      reason: 'baked full-frame PNGs are temporary probe/calibration assets only'
    });
  }

  if (sourceType === ASSET_SOURCE_TYPES.INVENTED_PLACEHOLDER) {
    return Object.freeze({
      allowed: context !== ASSET_USE_CONTEXTS.FINAL_PORT,
      finalAllowed: false,
      reason: 'invented placeholders are temporary only and must be labelled'
    });
  }

  if (sourceBacked) {
    return Object.freeze({
      allowed: true,
      finalAllowed: true,
      reason: 'source-backed exported asset/data/behaviour is valid for the final port'
    });
  }

  return Object.freeze({
    allowed: false,
    finalAllowed: false,
    reason: 'asset use is not source-backed enough for this port'
  });
}

export function assertSourceAssetUsePolicy() {
  if (SOURCE_ASSET_USE_POLICY.bakedFramePngsAllowedForFinalRooms) {
    throw new Error('Asset policy violation: baked frame PNGs cannot be final room renders');
  }

  if (SOURCE_ASSET_USE_POLICY.bakedFramePngsAllowedForFinalUiShell) {
    throw new Error('Asset policy violation: baked frame PNGs cannot be the final UI shell');
  }

  if (!SOURCE_ASSET_USE_POLICY.originalBitmapExportsAllowedForFinal) {
    throw new Error('Asset policy violation: original SWF bitmap exports must remain valid final assets');
  }

  if (SOURCE_ASSET_USE_POLICY.screenshotsAllowedAsAssetSource) {
    throw new Error('Asset policy violation: screenshots cannot be asset sources');
  }

  if (SOURCE_ASSET_USE_POLICY.inventedPermanentAssetsAllowed) {
    throw new Error('Asset policy violation: invented permanent assets are not allowed');
  }

  return true;
}
