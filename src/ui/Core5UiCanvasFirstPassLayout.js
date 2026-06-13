import { getCore5UiSpriteCandidateByKey } from './Core5UiSpriteIds.js';

// Gameplay-reference canvas for the clean Nest UI page.
//
// This pass intentionally renders only the first two confirmed static HUD
// pieces: the Level badge and Mulch counter. The room/background composition is
// left alone and the HUD sprites overlay the gameplay frame, matching the
// workflow of building the UI 1:1 one element at a time.
export const CORE5_UI_CANVAS_SIZE = Object.freeze({
  width: 640,
  height: 360
});

export const CORE5_UI_ROOM_VIEWPORT_SLOT = Object.freeze({
  x: 0,
  y: 0,
  width: 640,
  height: 360,
  sourceWidth: 614,
  sourceHeight: 366
});

export const CORE5_UI_FIRST_PASS_LAYOUT = Object.freeze([
  Object.freeze({
    key: 'levelBadgeComposite',
    kind: 'source',
    label: 'Level badge',
    x: 4,
    y: 43,
    width: 50,
    height: 58
  }),
  Object.freeze({
    key: 'mulchCounterComposite',
    kind: 'source',
    label: 'Mulch counter',
    x: 4,
    y: 106,
    width: 55,
    height: 34
  })
]);

export function getCore5UiCanvasFirstPassLayout() {
  return CORE5_UI_FIRST_PASS_LAYOUT.map((layoutItem) => {
    const candidate = getCore5UiSpriteCandidateByKey(layoutItem.key);

    if (!candidate || candidate.firstPassVerified !== true) {
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
