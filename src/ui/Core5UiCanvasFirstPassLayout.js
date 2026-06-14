import { getCore5UiSpriteCandidateByKey } from './Core5UiSpriteIds.js';

// Gameplay-reference canvas for the clean Nest UI page.
//
// This pass intentionally renders only the user-selected static Level HUD pieces:
// DefineSprite_1704 for the level icon and DefineSprite_1681 for the XP bar.
// Mulch, Dosh, hunger, chatbar and map stay parked until the level placement is
// visually confirmed against the gameplay reference screenshot.
export const CORE5_UI_CANVAS_SIZE = Object.freeze({
  width: 946,
  height: 653
});

export const CORE5_UI_ROOM_VIEWPORT_SLOT = Object.freeze({
  x: 166,
  y: 78,
  width: 614,
  height: 366,
  sourceWidth: 614,
  sourceHeight: 366
});

export const CORE5_UI_FIRST_PASS_LAYOUT = Object.freeze([
  Object.freeze({
    key: 'levelIcon',
    kind: 'source',
    label: 'Level icon',
    defineSpriteId: 1704,
    x: 12,
    y: 80,
    width: 48,
    height: 48
  }),
  Object.freeze({
    key: 'levelXpBar',
    kind: 'source',
    label: 'Level XP bar',
    defineSpriteId: 1681,
    x: 10,
    y: 127,
    width: 62,
    height: 14
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
        groupKey: null,
        role: null
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
