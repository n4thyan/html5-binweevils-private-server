// Source-backed target map for the Bin Weevils game viewport slime frame.
//
// This intentionally does not draw a placeholder slime border. The frame must be
// ported from original/decompiled assets, not recreated by hand.
//
// Important separation:
// - the green slime/canvas shell belongs to the decompiled main/root shell assets.
// - playercard icons/assets belong to the playercard/core UI track and must not be
//   confused with the viewport slime frame target.
// - screenshots are reference notes only, never an asset source.

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
    reason: 'main/root shell is expected to contain the green slime/canvas shell and viewport border assets'
  }),
  Object.freeze({
    priority: 2,
    source: 'source/knowyourknot-binweevils/game-full',
    reason: 'verified extracted original site/game assets can confirm filenames and runtime paths'
  }),
  Object.freeze({
    priority: 3,
    source: 'reference/decompiled-dumpassets/dumpassets/core5.swf',
    reason: 'core UI can confirm adjacent controls/panels, but playercard icons are a separate UI target'
  }),
  Object.freeze({
    priority: 4,
    source: 'full client UI screenshot supplied by Nathan',
    reason: 'layout reference only; not an asset source'
  })
]);

export const VIEWPORT_SLIME_FRAME_KNOWN_NOT_SOURCES = Object.freeze([
  Object.freeze({
    item: 'DefineShape4 2474/2475/2476 screenshot',
    reason: 'belongs to playercard UI/icon reference, not the green slime viewport shell'
  }),
  Object.freeze({
    item: 'playercard correct icons in core5.swf',
    reason: 'valid future playercard source target, but not the viewport slime frame'
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
  'locate-source-symbols-in-main',
  'prove-main-symbols-load-in-browser',
  'create-debug-shell-probe',
  'place-room-preview-behind-frame',
  'place-real-weevil-behind/within-frame',
  'replace-debug-probe-with-source-backed-ui-shell'
]);

export const VIEWPORT_SLIME_FRAME_NON_GOALS_NOW = Object.freeze([
  'playercard icons',
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
    knownNotSourceCount: VIEWPORT_SLIME_FRAME_KNOWN_NOT_SOURCES.length,
    portOrderCount: VIEWPORT_SLIME_FRAME_PORT_ORDER.length,
    nonGoalCount: VIEWPORT_SLIME_FRAME_NON_GOALS_NOW.length,
    nextAction: 'locate-source-symbols-in-main'
  });
}

export function assertViewportSlimeFrameSourcePolicy() {
  if (VIEWPORT_SLIME_FRAME_RULES.mayInventPermanentArt) {
    throw new Error('Viewport slime frame policy violation: permanent invented art is not allowed');
  }

  if (VIEWPORT_SLIME_FRAME_RULES.mayUseScreenshotAsAssetSource) {
    throw new Error('Viewport slime frame policy violation: screenshot cannot be used as an asset source');
  }

  const confusedPlayercardSource = VIEWPORT_SLIME_FRAME_KNOWN_NOT_SOURCES.some((entry) =>
    entry.item.toLowerCase().includes('playerslime')
  );

  if (confusedPlayercardSource) {
    throw new Error('Viewport slime frame policy violation: playercard references must not be treated as slime-frame sources');
  }

  return true;
}
