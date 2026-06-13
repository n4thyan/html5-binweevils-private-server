import {
  CORE5_UI_FIRST_PASS_CANDIDATES,
  CORE5_UI_FIRST_PASS_GROUP_KEYS,
  CORE5_UI_SOURCE_LEAD_GROUP_KEYS,
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

const sourceLeadGroups = ['level', 'mulch', 'dosh', 'hunger', 'chatbar', 'map'];

for (const groupKey of sourceLeadGroups) {
  assert(CORE5_UI_SOURCE_LEAD_GROUP_KEYS.includes(groupKey), `${groupKey} should be documented as a source lead group`);
  assert(CORE5_UI_SPRITE_GROUPS[groupKey], `${groupKey} group should exist`);
  assert(getCore5UiSpriteCandidatesByGroup(groupKey).length > 0, `${groupKey} should have candidates`);
}

const firstPassGroups = ['level', 'mulch'];

for (const groupKey of firstPassGroups) {
  assert(CORE5_UI_FIRST_PASS_GROUP_KEYS.includes(groupKey), `${groupKey} should be in first-pass group keys`);
}

assert(!CORE5_UI_FIRST_PASS_GROUP_KEYS.includes('dosh'), 'Dosh should not be rendered in the current tiny first pass');
assert(!CORE5_UI_FIRST_PASS_GROUP_KEYS.includes('hunger'), 'Hunger should not be rendered in the current tiny first pass');
assert(!CORE5_UI_FIRST_PASS_GROUP_KEYS.includes('chatbar'), 'Chatbar should not be rendered in the current tiny first pass');
assert(!CORE5_UI_FIRST_PASS_GROUP_KEYS.includes('map'), 'Map should not be rendered in the current tiny first pass');

const requiredFirstPassKeys = [
  'levelBadgeComposite',
  'mulchCounterComposite'
];

for (const key of requiredFirstPassKeys) {
  const candidate = getCore5UiSpriteCandidateByKey(key);
  assert(candidate, `${key} candidate should exist`);
  assert(Number.isInteger(candidate.defineSpriteId), `${key} should have an integer DefineSprite id`);
  assert(candidate.firstPassVerified === true, `${key} should be marked first-pass verified`);
  assert(candidate.path === getCore5UiSpritePath(candidate.defineSpriteId), `${key} should resolve to the expected SVG path`);
}

const knownFirstPassIds = new Set(CORE5_UI_FIRST_PASS_CANDIDATES.map((candidate) => candidate.defineSpriteId));

for (const id of [1685, 1688]) {
  assert(knownFirstPassIds.has(id), `first-pass UI sprite ids should include DefineSprite_${id}`);
}

for (const id of [1708, 1699, 1716, 1724, 1786, 1790]) {
  assert(!knownFirstPassIds.has(id), `DefineSprite_${id} should remain a later source lead, not a rendered first-pass sprite`);
}

const mapButtonCandidate = getCore5UiSpriteCandidateByKey('mapButtonCandidate');
assert(mapButtonCandidate, 'map button source-grid lead should remain documented');
assert(mapButtonCandidate.defineSpriteId === 1786, 'DefineSprite_1786 should be tracked as a map button source lead');
assert(mapButtonCandidate.firstPassVerified === false, 'map button source lead should not be treated as first-pass verified yet');

const mapPanel = getCore5UiSpriteCandidateByKey('mapPanelLandscape');
assert(mapPanel, 'map panel candidate should remain documented');
assert(mapPanel.firstPassVerified === false, 'DefineSprite_1757 must not be treated as the sidebar Map button');

console.log('Core5 UI sprite id smoke test passed');
console.log('first-pass groups:', CORE5_UI_FIRST_PASS_GROUP_KEYS.join(', '));
console.log('first-pass candidate count:', CORE5_UI_FIRST_PASS_CANDIDATES.length);
