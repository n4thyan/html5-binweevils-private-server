// Source-backed target map for the Bin Weevils game viewport slime frame.
//
// This intentionally does not draw a placeholder slime border. The frame must be
// ported from original/decompiled assets, not recreated by hand. The public UI
// screenshot Nathan supplied is layout reference only.

export const VIEWPORT_SLIME_FRAME_RULES = Object.freeze({
  system: 'game viewport slime frame / canvas shell',
  status: 'source-map-target-only',
  mayUseScreenshotAsLayoutReference: true,
  mayUseScreenshotAsAssetSource: false,
  mayInventPermanentArt: false,
  mayUseTemporaryDebugOutline: true,
  temporaryDebugOutlineMustBeLabelled: true
});

export const VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY = Object.freeze([
  Object.freeze({
    priority: 1,
    source: 'reference/decompiled-dumpassets/dumpassets/mainDEV661.swf',
    reason: 'main/root shell is expected to contain stage, loader and viewport shell assets'
  }),
  Object.freeze({
    priority: 2,
    source: 'reference/decompiled-dumpassets/dumpassets/core5.swf',
    reason: 'core UI contains lower controls, panels and gameplay UI attachments'
  }),
  Object.freeze({
    priority: 3,
    source: 'source/knowyourknot-binweevils/game-full',
    reason: 'verified extracted original site/game assets can confirm filenames and runtime paths'
  }),
  Object.freeze({
    priority: 4,
    source: 'Bin Weevils Rewritten screenshot supplied by Nathan',
    reason: 'layout reference only; not an asset source'
  })
]);

export const VIEWPORT_SLIME_FRAME_EXPECTED_PARTS = Object.freeze([
  Object.freeze({ key: 'topSlimeRail', required: true, description: 'green/slime top edge of the play viewport' }),
  Object.freeze({ key: 'leftSlimeRail', required: true, description: 'left vertical slime/vine viewport edge' }),
  Object.freeze({ key: 'rightSlimeRail', required: true, description: 'right vertical slime/vine viewport edge' }),
  Object.freeze({ key: 'bottomSlimeRail', required: true, description: 'bottom slime rail separating room content from lower controls' }),
  Object.freeze({ key: 'viewportMask', required: true, description: 'clip/mask that keeps the room visible inside the frame' }),
  Object.freeze({ key: 'contentLayerBehindFrame', required: true, description: 'room/canvas content must draw behind the slime frame' }),
  Object.freeze({ key: 'uiLayerAboveRoom', required: true, description: 'controls and overlays must draw above room content where source does so' })
]);

export const VIEWPORT_SLIME_FRAME_PORT_ORDER = Object.freeze([
  'locate-source-symbols',
  'prove-symbols-load-in-browser',
  'create-debug-shell-probe',
  'place-room-preview-behind-frame',
  'place-real-weevil-behind/within-frame',
  'replace-debug-probe-with-source-backed-ui-shell'
]);

export const VIEWPORT_SLIME_FRAME_NON_GOALS_NOW = Object.freeze([
  'full buddy tablet',
  'pet profile internals',
  'shop/inventory panels',
  '3D camera controls for fixed-camera rooms',
  'dynamic ads',
  'backend/session UI state'
]);

export function getViewportSlimeFrameStatus() {
  return Object.freeze({
    system: VIEWPORT_SLIME_FRAME_RULES.system,
    status: VIEWPORT_SLIME_FRAME_RULES.status,
    expectedParts: VIEWPORT_SLIME_FRAME_EXPECTED_PARTS.length,
    sourcePriorityCount: VIEWPORT_SLIME_FRAME_SOURCE_PRIORITY.length,
    portOrderCount: VIEWPORT_SLIME_FRAME_PORT_ORDER.length,
    nonGoalCount: VIEWPORT_SLIME_FRAME_NON_GOALS_NOW.length,
    nextAction: 'locate-source-symbols'
  });
}

export function assertViewportSlimeFrameSourcePolicy() {
  if (VIEWPORT_SLIME_FRAME_RULES.mayInventPermanentArt) {
    throw new Error('Viewport slime frame policy violation: permanent invented art is not allowed');
  }

  if (VIEWPORT_SLIME_FRAME_RULES.mayUseScreenshotAsAssetSource) {
    throw new Error('Viewport slime frame policy violation: screenshot cannot be used as an asset source');
  }

  return true;
}
