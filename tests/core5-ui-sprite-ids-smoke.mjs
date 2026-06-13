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
  'mapPanelLandscape'
];

for (const key of requiredCandidateKeys) {
  const candidate = getCore5UiSpriteCandidateByKey(key);
  assert(candidate, `${key} candidate should exist`);
  assert(Number.isInteger(candidate.defineSpriteId), `${key} should have an integer DefineSprite id`);
  assert(candidate.path === getCore5UiSpritePath(candidate.defineSpriteId), `${key} should resolve to the expected SVG path`);
}

const knownIds = new Set(CORE5_UI_FIRST_PASS_CANDIDATES.map((candidate) => candidate.defineSpriteId));

for (const id of [1685, 1688, 1708, 1699, 1716, 1757]) {
  assert(knownIds.has(id), `first-pass UI sprite ids should include DefineSprite_${id}`);
}

console.log('Core5 UI sprite id smoke test passed');
console.log('groups:', CORE5_UI_FIRST_PASS_GROUP_KEYS.join(', '));
console.log('candidate count:', CORE5_UI_FIRST_PASS_CANDIDATES.length);
