// Source-backed target map for core5.swf gameplay HUD/UI sprites.
//
// The registry separates broad source leads from the current canvas pass. The
// active pass is deliberately tiny: only the visually confirmed static level
// badge and mulch counter are rendered. Other ids stay documented as leads and
// must not be stretched into the UI before they are confirmed 1:1.

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
      Object.freeze({ key: 'levelMeterBarEmpty', defineSpriteId: 1680, role: 'empty level meter bar', firstPassVerified: false }),
      Object.freeze({ key: 'levelMeterBarFill', defineSpriteId: 1681, role: 'filled level meter bar', firstPassVerified: false }),
      Object.freeze({ key: 'levelStarPlain', defineSpriteId: 1682, role: 'plain level star', firstPassVerified: false }),
      Object.freeze({ key: 'levelStarNumber', defineSpriteId: 1684, role: 'level star with digits', firstPassVerified: false }),
      Object.freeze({ key: 'levelBadgeComposite', defineSpriteId: 1685, role: 'full level badge with star and bar', firstPassVerified: true })
    ])
  }),

  mulch: Object.freeze({
    label: 'Mulch counter',
    priority: 2,
    candidates: Object.freeze([
      Object.freeze({ key: 'mulchCoinStack', defineSpriteId: 1686, role: 'large mulch coin stack', firstPassVerified: false }),
      Object.freeze({ key: 'mulchCounterComposite', defineSpriteId: 1688, role: 'small mulch counter with digits', firstPassVerified: true })
    ])
  }),

  dosh: Object.freeze({
    label: 'Dosh counter',
    priority: 3,
    candidates: Object.freeze([
      Object.freeze({ key: 'doshLargeCoin', defineSpriteId: 1701, role: 'large Dosh coin medallion', firstPassVerified: false }),
      Object.freeze({ key: 'doshCoinStack', defineSpriteId: 1706, role: 'Dosh coin stack', firstPassVerified: false }),
      Object.freeze({ key: 'doshCounterComposite', defineSpriteId: 1708, role: 'small Dosh counter with digits', firstPassVerified: false })
    ])
  }),

  hunger: Object.freeze({
    label: 'Hunger / food meter',
    priority: 4,
    candidates: Object.freeze([
      Object.freeze({ key: 'hungerCutlery', defineSpriteId: 1697, role: 'fork and knife icon', firstPassVerified: false }),
      Object.freeze({ key: 'hungerMeterComposite', defineSpriteId: 1699, role: 'fork and knife with horizontal meter', firstPassVerified: false })
    ])
  }),

  chatbar: Object.freeze({
    label: 'Chat bar',
    priority: 5,
    candidates: Object.freeze([
      Object.freeze({ key: 'chatInputBar', defineSpriteId: 1716, role: 'long yellow chat input bar', firstPassVerified: false }),
      Object.freeze({ key: 'chatDisabledText', defineSpriteId: 1718, role: 'chat disabled text', firstPassVerified: false }),
      Object.freeze({ key: 'chatRoundedInput', defineSpriteId: 1724, role: 'rounded green/white bottom button shell', firstPassVerified: false }),
      Object.freeze({ key: 'chatSmileLine', defineSpriteId: 1725, role: 'black curved chat/smile line', firstPassVerified: false })
    ])
  }),

  map: Object.freeze({
    label: 'Map button / map UI',
    priority: 6,
    candidates: Object.freeze([
      Object.freeze({ key: 'mapButtonCandidate', defineSpriteId: 1786, role: 'visible Map button source-grid lead; needs dedicated visual pass', firstPassVerified: false }),
      Object.freeze({ key: 'mapButtonFramedCandidate', defineSpriteId: 1790, role: 'framed Map button source-grid lead; needs dedicated visual pass', firstPassVerified: false }),
      Object.freeze({ key: 'mapPanelLandscape', defineSpriteId: 1757, role: 'large map landscape panel candidate; not the sidebar Map button', firstPassVerified: false }),
      Object.freeze({ key: 'mapIslandComposite', defineSpriteId: 1795, role: 'island/map composite candidate; not the sidebar Map button', firstPassVerified: false })
    ])
  })
});

export const CORE5_UI_SOURCE_LEAD_GROUP_KEYS = Object.freeze([
  'level',
  'mulch',
  'dosh',
  'hunger',
  'chatbar',
  'map'
]);

export const CORE5_UI_FIRST_PASS_GROUP_KEYS = Object.freeze([
  'level',
  'mulch'
]);

function enrichCandidate(groupKey, group, candidate) {
  return Object.freeze({
    ...candidate,
    groupKey,
    groupLabel: group.label,
    sourceSwf: CORE5_UI_SOURCE_SWF,
    path: getCore5UiSpritePath(candidate.defineSpriteId)
  });
}

export const CORE5_UI_FIRST_PASS_CANDIDATES = Object.freeze(
  CORE5_UI_SOURCE_LEAD_GROUP_KEYS.flatMap((groupKey) => {
    const group = CORE5_UI_SPRITE_GROUPS[groupKey];

    return group.candidates
      .filter((candidate) => candidate.firstPassVerified === true)
      .map((candidate) => enrichCandidate(groupKey, group, candidate));
  })
);

export function getCore5UiSpriteCandidateByKey(key) {
  for (const groupKey of CORE5_UI_SOURCE_LEAD_GROUP_KEYS) {
    const group = CORE5_UI_SPRITE_GROUPS[groupKey];
    const candidate = group.candidates.find((item) => item.key === key);

    if (candidate) {
      return enrichCandidate(groupKey, group, candidate);
    }
  }

  return null;
}

export function getCore5UiSpriteCandidatesByGroup(groupKey) {
  const group = CORE5_UI_SPRITE_GROUPS[groupKey];

  if (!group) {
    return [];
  }

  return group.candidates.map((candidate) => enrichCandidate(groupKey, group, candidate));
}
