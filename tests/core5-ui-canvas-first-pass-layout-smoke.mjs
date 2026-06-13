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

assert(CORE5_UI_CANVAS_SIZE.width === 640, 'canvas width should match gameplay reference width');
assert(CORE5_UI_CANVAS_SIZE.height === 360, 'canvas height should match gameplay reference height');
assert(CORE5_UI_ROOM_VIEWPORT_SLOT.x === 0, 'room viewport should fill the gameplay canvas during the 1:1 UI pass');
assert(CORE5_UI_ROOM_VIEWPORT_SLOT.y === 0, 'room viewport should start at the top of the gameplay canvas');
assert(CORE5_UI_ROOM_VIEWPORT_SLOT.width === 640, 'room viewport should fill the canvas width');
assert(CORE5_UI_ROOM_VIEWPORT_SLOT.height === 360, 'room viewport should fill the canvas height');
assert(layout.length === CORE5_UI_FIRST_PASS_LAYOUT.length, 'resolved layout length should match source layout length');
assert(layout.length === 2, 'current tiny first pass should render only level and mulch');

const requiredSourceKeys = [
  'levelBadgeComposite',
  'mulchCounterComposite'
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

for (const key of ['doshCounterComposite', 'hungerMeterComposite', 'chatRoundedInput', 'chatInputBar', 'mapButtonPending']) {
  assert(!layout.some((item) => item.key === key), `${key} should not render during the level/mulch-only pass`);
}

console.log('Core5 UI canvas first-pass layout smoke test passed');
console.log('layout entries:', layout.length);
