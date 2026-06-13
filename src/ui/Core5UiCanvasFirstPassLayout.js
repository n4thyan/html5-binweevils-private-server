import { getCore5UiSpriteCandidateByKey } from './Core5UiSpriteIds.js';

// Debug-only first-pass positions for bringing the source-backed gameplay HUD
// candidates into the clean Nest UI canvas. These are not final pixel-perfect
// Flash layout values; they are a staging layout so the real exported sprites
// can be placed and compared in-browser before exact coordinates are locked.
export const CORE5_UI_CANVAS_SIZE = Object.freeze({
  width: 960,
  height: 640
});

export const CORE5_UI_FIRST_PASS_LAYOUT = Object.freeze([
  Object.freeze({
    key: 'levelBadgeComposite',
    label: 'Level',
    x: 24,
    y: 18,
    width: 118,
    height: 70
  }),
  Object.freeze({
    key: 'mulchCounterComposite',
    label: 'Mulch',
    x: 642,
    y: 18,
    width: 110,
    height: 54
  }),
  Object.freeze({
    key: 'doshCounterComposite',
    label: 'Dosh',
    x: 760,
    y: 18,
    width: 118,
    height: 54
  }),
  Object.freeze({
    key: 'hungerMeterComposite',
    label: 'Hunger',
    x: 32,
    y: 542,
    width: 120,
    height: 48
  }),
  Object.freeze({
    key: 'chatInputBar',
    label: 'Chatbar',
    x: 242,
    y: 578,
    width: 480,
    height: 34
  }),
  Object.freeze({
    key: 'mapPanelLandscape',
    label: 'Map',
    x: 812,
    y: 520,
    width: 120,
    height: 70
  })
]);

export function getCore5UiCanvasFirstPassLayout() {
  return CORE5_UI_FIRST_PASS_LAYOUT.map((layoutItem) => {
    const candidate = getCore5UiSpriteCandidateByKey(layoutItem.key);

    if (!candidate) {
      return {
        ...layoutItem,
        candidate: null,
        path: null,
        defineSpriteId: null
      };
    }

    return {
      ...layoutItem,
      candidate,
      path: candidate.path,
      defineSpriteId: candidate.defineSpriteId,
      groupKey: candidate.groupKey,
      role: candidate.role
    };
  });
}
