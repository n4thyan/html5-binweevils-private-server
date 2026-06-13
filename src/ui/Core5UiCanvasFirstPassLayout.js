import { getCore5UiSpriteCandidateByKey } from './Core5UiSpriteIds.js';

// Gameplay-reference first-pass layout for the clean Nest UI canvas.
// Coordinates target a 640x360 capture-style canvas using the official HUD
// structure from the user-provided gameplay reference: left vertical status
// stack, shop/map button column, and bottom chatbar strip.
export const CORE5_UI_CANVAS_SIZE = Object.freeze({
  width: 640,
  height: 360
});

export const CORE5_UI_ROOM_VIEWPORT_SLOT = Object.freeze({
  x: 55,
  y: 0,
  width: 585,
  height: 306,
  sourceWidth: 614,
  sourceHeight: 366
});

export const CORE5_UI_FIRST_PASS_LAYOUT = Object.freeze([
  Object.freeze({
    key: 'levelBadgeComposite',
    kind: 'source',
    label: 'Level',
    x: 4,
    y: 53,
    width: 48,
    height: 56
  }),
  Object.freeze({
    key: 'mulchCounterComposite',
    kind: 'source',
    label: 'Mulch',
    x: 4,
    y: 112,
    width: 52,
    height: 38
  }),
  Object.freeze({
    key: 'doshCounterComposite',
    kind: 'source',
    label: 'Dosh',
    x: 4,
    y: 145,
    width: 52,
    height: 38
  }),
  Object.freeze({
    key: 'hungerMeterComposite',
    kind: 'source',
    label: 'Hunger',
    x: 5,
    y: 180,
    width: 48,
    height: 34
  }),
  Object.freeze({
    key: 'chatRoundedInput',
    kind: 'source',
    label: 'Chat left button',
    x: 66,
    y: 321,
    width: 70,
    height: 26
  }),
  Object.freeze({
    key: 'chatInputBar',
    kind: 'source',
    label: 'Chatbar',
    x: 142,
    y: 322,
    width: 250,
    height: 24
  }),
  Object.freeze({
    key: 'mapButtonPending',
    kind: 'pending',
    label: 'Map button source ID pending',
    x: 5,
    y: 253,
    width: 48,
    height: 48,
    note: 'Do not render DefineSprite_1757 here; it is the wrong map-panel candidate.'
  })
]);

export function getCore5UiCanvasFirstPassLayout() {
  return CORE5_UI_FIRST_PASS_LAYOUT.map((layoutItem) => {
    if (layoutItem.kind === 'pending') {
      return {
        ...layoutItem,
        candidate: null,
        path: null,
        defineSpriteId: null,
        groupKey: 'map',
        role: layoutItem.note
      };
    }

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
