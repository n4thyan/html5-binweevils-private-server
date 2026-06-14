// Source-backed target map for core5.swf gameplay HUD/UI sprites.
//
// This registry separates visual source leads from the currently rendered pass.
// The active UI pass is intentionally tiny: only the user-confirmed Level icon
// and XP bar candidates are enabled. Other HUD items stay documented until they
// are matched 1:1 against the gameplay reference.

export const CORE5_UI_SOURCE_SWF = 'reference/decompiled-dumpassets/dumpassets/core5.swf';
export const CORE5_UI_SPRITE_BASE_PATH = `${CORE5_UI_SOURCE_SWF}/sprites`;

export function getCore5UiSpritePath(defineSpriteId, folderName = null) {
  const folder = folderName || `DefineSprite_${defineSpriteId}`;
  return `${CORE5_UI_SPRITE_BASE_PATH}/${folder}/1.svg`;
}

export const CORE5_UI_SPRITE_GROUPS = Object.freeze({
  level: Object.freeze({
    label: 'Level / XP HUD',
    priority: 1,
    candidates: Object.freeze([
      Object.freeze({ key: 'levelMeterBarEmpty', defineSpriteId: 1680, role: 'empty level meter bar source lead', firstPassVerified: false }),
      Object.freeze({ key: 'levelXpBarPreviewLead', defineSpriteId: 1681, role: 'JPEXS preview looked like an XP bar, but the exported SVG is not the usable XP bar', firstPassVerified: false }),
      Object.freeze({ key: 'levelStarPlain', defineSpriteId: 1682, role: 'plain level star source lead', firstPassVerified: false }),
      Object.freeze({ key: 'levelStarNumber', defineSpriteId: 1684, role: 'level star with digits source lead', firstPassVerified: false }),
      Object.freeze({ key: 'levelIcon', defineSpriteId: 1704, role: 'user-confirmed first-pass level icon candidate', firstPassVerified: true }),
      Object.freeze({ key: 'levelBadgeComposite', defineSpriteId: 1685, role: 'full level badge with star and bar source lead; not active for this pass', firstPassVerified: false }),
      Object.freeze({
        key: 'levelXpBar',
        defineSpriteId: 1699,
        folderName: 'DefineSprite_1699_core390_fla.levelBar_110',
        role: 'user-confirmed exported XP bar that sits under the level icon',
        firstPassVerified: true
      })
    ])
  }),

  mulch: Object.freeze({
    label: 'Mulch counter',
    priority: 2,
    candidates: Object.freeze([
      Object.freeze({ key: 'mulchCoinStack', defineSpriteId: 1686, role: 'large mulch coin stack source lead', firstPassVerified: false }),
      Object.freeze({ key: 'mulchCounterComposite', defineSpriteId: 1688, role: 'small mulch counter with digits source lead', firstPassVerified: false })
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
      Object.freeze({ key: 'hungerCutlery', defineSpriteId: 1697, role: 'fork and knife icon source lead', firstPassVerified: false })
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
  'level'
]);

function enrichCandidate(groupKey, group, candidate) {
  return Object.freeze({
    ...candidate,
    groupKey,
    groupLabel: group.label,
    sourceSwf: CORE5_UI_SOURCE_SWF,
    path: getCore5UiSpritePath(candidate.defineSpriteId, candidate.folderName)
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
