import {
  CORE5_UI_FIRST_PASS_CANDIDATES,
  CORE5_UI_FIRST_PASS_GROUP_KEYS,
  CORE5_UI_SPRITE_GROUPS,
  getCore5UiSpriteCandidateByKey,
  getCore5UiSpriteCandidatesByGroup,
  getCore5UiSpritePath
} from '../src/ui/Core5UiSpriteIds.js';

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

const requiredGroups = ['level', 'mulch', 'dosh', 'hunger', 'chatbar', 'map'];

for (const groupKey of requiredGroups) {
  assert(CORE5_UI_FIRST_PASS_GROUP_KEYS.includes(groupKey), `${groupKey} should be in first-pass group keys`);
  assert(CORE5_UI_SPRITE_GROUPS[groupKey], `${groupKey} group should exist`);
  assert(getCore5UiSpriteCandidatesByGroup(groupKey).length > 0, `${groupKey} should have candidates`);
}

const requiredCandidateKeys = [
  'levelBadgeComposite',
  'mulchCounterComposite',
  'doshCounterComposite',
  'hungerMeterComposite',
  'chatInputBar',
  'chatRoundedInput'
];

for (const key of requiredCandidateKeys) {
  const candidate = getCore5UiSpriteCandidateByKey(key);
  assert(candidate, `${key} candidate should exist`);
  assert(Number.isInteger(candidate.defineSpriteId), `${key} should have an integer DefineSprite id`);
  assert(candidate.firstPassVerified === true, `${key} should be marked first-pass verified`);
  assert(candidate.path === getCore5UiSpritePath(candidate.defineSpriteId), `${key} should resolve to the expected SVG path`);
}

const knownIds = new Set(CORE5_UI_FIRST_PASS_CANDIDATES.map((candidate) => candidate.defineSpriteId));

for (const id of [1685, 1688, 1708, 1699, 1716, 1724]) {
  assert(knownIds.has(id), `first-pass UI sprite ids should include DefineSprite_${id}`);
}

const mapPanel = getCore5UiSpriteCandidateByKey('mapPanelLandscape');
assert(mapPanel, 'map panel candidate should remain documented');
assert(mapPanel.firstPassVerified === false, 'DefineSprite_1757 must not be treated as the sidebar Map button');

console.log('Core5 UI sprite id smoke test passed');
console.log('groups:', CORE5_UI_FIRST_PASS_GROUP_KEYS.join(', '));
console.log('candidate count:', CORE5_UI_FIRST_PASS_CANDIDATES.length);
