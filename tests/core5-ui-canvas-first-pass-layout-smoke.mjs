import {
  CORE5_UI_CANVAS_SIZE,
  CORE5_UI_FIRST_PASS_LAYOUT,
  CORE5_UI_ROOM_VIEWPORT_SLOT,
  getCore5UiCanvasFirstPassLayout
} from '../src/ui/Core5UiCanvasFirstPassLayout.js';

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

const layout = getCore5UiCanvasFirstPassLayout();

assert(CORE5_UI_CANVAS_SIZE.width === 946, 'canvas width should match the current clean UI canvas shell width');
assert(CORE5_UI_CANVAS_SIZE.height === 653, 'canvas height should match the current clean UI canvas shell height');
assert(CORE5_UI_ROOM_VIEWPORT_SLOT.x === 166, 'room viewport should keep the restored canvas x offset');
assert(CORE5_UI_ROOM_VIEWPORT_SLOT.y === 78, 'room viewport should keep the restored canvas y offset');
assert(CORE5_UI_ROOM_VIEWPORT_SLOT.width === 614, 'room viewport should keep the restored canvas width');
assert(CORE5_UI_ROOM_VIEWPORT_SLOT.height === 366, 'room viewport should keep the restored canvas height');
assert(layout.length === CORE5_UI_FIRST_PASS_LAYOUT.length, 'resolved layout length should match source layout length');
assert(layout.length === 2, 'current tiny first pass should render only level icon and XP bar');

const requiredSourceKeys = [
  'levelIcon',
  'levelXpBar'
];

for (const key of requiredSourceKeys) {
  const item = layout.find((candidate) => candidate.key === key);
  assert(item, `${key} should be present in first-pass UI layout`);
  assert(item.kind === 'source', `${key} should be a source sprite layout item`);
  assert(item.candidate, `${key} should resolve a registry candidate`);
  assert(item.candidate.firstPassVerified === true, `${key} should be first-pass verified`);
  assert(Number.isInteger(item.defineSpriteId), `${key} should resolve a DefineSprite id`);
  assert(typeof item.path === 'string' && item.path.includes(`DefineSprite_${item.defineSpriteId}`), `${key} should resolve a source path`);
  assert(item.x >= 0 && item.y >= 0, `${key} should have non-negative layout coordinates`);
  assert(item.width > 0 && item.height > 0, `${key} should have a positive layout size`);
}

const levelIcon = layout.find((item) => item.key === 'levelIcon');
const xpBar = layout.find((item) => item.key === 'levelXpBar');

assert(levelIcon.defineSpriteId === 1704, 'level icon layout should use DefineSprite_1704');
assert(xpBar.defineSpriteId === 1699, 'XP bar layout should use DefineSprite_1699');
assert(xpBar.path.includes('DefineSprite_1699_core390_fla.levelBar_110'), 'XP bar layout should use the named levelBar export folder');
assert(xpBar.y > levelIcon.y, 'XP bar should sit below the level icon');

for (const key of ['levelBadgeComposite', 'levelXpBarPreviewLead', 'mulchCounterComposite', 'doshCounterComposite', 'hungerMeterComposite', 'chatRoundedInput', 'chatInputBar', 'mapButtonPending']) {
  assert(!layout.some((item) => item.key === key), `${key} should not render during the level-only pass`);
}

console.log('Core5 UI canvas first-pass layout smoke test passed');
console.log('layout entries:', layout.length);
