// Source-backed first-pass target map for core5.swf HUD/UI sprites.
//
// These are DefineSprite ids Nathan identified in JPEXS for the first clean UI
// reconstruction pass. Keep this as a registry/verification layer: final UI work
// should render the original exported symbols, not hand-drawn replacement art.

export const CORE5_UI_SOURCE_SWF = 'reference/decompiled-dumpassets/dumpassets/core5.swf';
export const CORE5_UI_SPRITE_BASE_PATH = `${CORE5_UI_SOURCE_SWF}/sprites`;

export function getCore5UiSpritePath(defineSpriteId) {
  return `${CORE5_UI_SPRITE_BASE_PATH}/DefineSprite_${defineSpriteId}/1.svg`;
}

export const CORE5_UI_SPRITE_GROUPS = Object.freeze({
  level: Object.freeze({
    label: 'Level badge',
    priority: 1,
    candidates: Object.freeze([
      Object.freeze({ key: 'levelMeterBarEmpty', defineSpriteId: 1680, role: 'level meter empty bar' }),
      Object.freeze({ key: 'levelMeterBarFill', defineSpriteId: 1681, role: 'level meter filled bar' }),
      Object.freeze({ key: 'levelStarPlain', defineSpriteId: 1682, role: 'plain level star' }),
      Object.freeze({ key: 'levelStarNumber', defineSpriteId: 1684, role: 'level star with number text' }),
      Object.freeze({ key: 'levelBadgeComposite', defineSpriteId: 1685, role: 'composite level badge with bar' })
    ])
  }),

  mulch: Object.freeze({
    label: 'Mulch counter',
    priority: 2,
    candidates: Object.freeze([
      Object.freeze({ key: 'mulchCoinStack', defineSpriteId: 1686, role: 'mulch coin stack' }),
      Object.freeze({ key: 'mulchCounterComposite', defineSpriteId: 1688, role: 'mulch counter with digits' })
    ])
  }),

  dosh: Object.freeze({
    label: 'Dosh counter',
    priority: 3,
    candidates: Object.freeze([
      Object.freeze({ key: 'doshLargeCoin', defineSpriteId: 1701, role: 'large Dosh coin medallion' }),
      Object.freeze({ key: 'doshCoinStack', defineSpriteId: 1706, role: 'Dosh coin stack' }),
      Object.freeze({ key: 'doshCounterComposite', defineSpriteId: 1708, role: 'Dosh counter with digits' })
    ])
  }),

  hunger: Object.freeze({
    label: 'Hunger / food meter',
    priority: 4,
    candidates: Object.freeze([
      Object.freeze({ key: 'hungerCutlery', defineSpriteId: 1697, role: 'fork and knife icon' }),
      Object.freeze({ key: 'hungerMeterComposite', defineSpriteId: 1699, role: 'fork and knife with green meter' })
    ])
  }),

  chatbar: Object.freeze({
    label: 'Chat bar',
    priority: 5,
    candidates: Object.freeze([
      Object.freeze({ key: 'chatInputBar', defineSpriteId: 1716, role: 'long chat input bar' }),
      Object.freeze({ key: 'chatDisabledText', defineSpriteId: 1718, role: 'chat disabled text' }),
      Object.freeze({ key: 'chatPanelDarkFill', defineSpriteId: 1721, role: 'dark chat panel fill' }),
      Object.freeze({ key: 'chatPanelGreenFill', defineSpriteId: 1723, role: 'green chat panel fill' }),
      Object.freeze({ key: 'chatRoundedInput', defineSpriteId: 1724, role: 'rounded chat input/button shell' }),
      Object.freeze({ key: 'chatSmileLine', defineSpriteId: 1725, role: 'black curved chat/smile line' })
    ])
  }),

  map: Object.freeze({
    label: 'Map button / map UI',
    priority: 6,
    candidates: Object.freeze([
      Object.freeze({ key: 'mapPanelLandscape', defineSpriteId: 1757, role: 'map landscape panel candidate' }),
      Object.freeze({ key: 'mapLargeParchment', defineSpriteId: 1761, role: 'rolled parchment candidate' }),
      Object.freeze({ key: 'mapWhitePathLine', defineSpriteId: 1786, role: 'white map path line candidate' }),
      Object.freeze({ key: 'mapBluePathLine', defineSpriteId: 1790, role: 'blue map path line candidate' }),
      Object.freeze({ key: 'mapIslandComposite', defineSpriteId: 1795, role: 'island/map composite candidate' })
    ])
  })
});

export const CORE5_UI_FIRST_PASS_GROUP_KEYS = Object.freeze([
  'level',
  'mulch',
  'dosh',
  'hunger',
  'chatbar',
  'map'
]);

export const CORE5_UI_FIRST_PASS_CANDIDATES = Object.freeze(
  CORE5_UI_FIRST_PASS_GROUP_KEYS.flatMap((groupKey) => {
    const group = CORE5_UI_SPRITE_GROUPS[groupKey];

    return group.candidates.map((candidate) => Object.freeze({
      ...candidate,
      groupKey,
      groupLabel: group.label,
      sourceSwf: CORE5_UI_SOURCE_SWF,
      path: getCore5UiSpritePath(candidate.defineSpriteId)
    }));
  })
);

export function getCore5UiSpriteCandidateByKey(key) {
  return CORE5_UI_FIRST_PASS_CANDIDATES.find((candidate) => candidate.key === key) || null;
}

export function getCore5UiSpriteCandidatesByGroup(groupKey) {
  const group = CORE5_UI_SPRITE_GROUPS[groupKey];

  if (!group) {
    return [];
  }

  return group.candidates.map((candidate) => ({
    ...candidate,
    groupKey,
    groupLabel: group.label,
    sourceSwf: CORE5_UI_SOURCE_SWF,
    path: getCore5UiSpritePath(candidate.defineSpriteId)
  }));
}
