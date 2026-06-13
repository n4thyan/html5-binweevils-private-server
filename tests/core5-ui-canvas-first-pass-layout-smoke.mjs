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
assert(CORE5_UI_ROOM_VIEWPORT_SLOT.x === 55, 'room viewport should leave space for left HUD column');
assert(layout.length === CORE5_UI_FIRST_PASS_LAYOUT.length, 'resolved layout length should match source layout length');

const requiredSourceKeys = [
  'levelBadgeComposite',
  'mulchCounterComposite',
  'doshCounterComposite',
  'hungerMeterComposite',
  'chatRoundedInput',
  'chatInputBar'
];

for (const key of requiredSourceKeys) {
  const item = layout.find((candidate) => candidate.key === key);
  assert(item, `${key} should be present in first-pass UI layout`);
  assert(item.kind === 'source', `${key} should be a source sprite layout item`);
  assert(item.candidate, `${key} should resolve a registry candidate`);
  assert(Number.isInteger(item.defineSpriteId), `${key} should resolve a DefineSprite id`);
  assert(typeof item.path === 'string' && item.path.includes(`DefineSprite_${item.defineSpriteId}`), `${key} should resolve a source path`);
  assert(item.x >= 0 && item.y >= 0, `${key} should have non-negative layout coordinates`);
  assert(item.width > 0 && item.height > 0, `${key} should have a positive layout size`);
}

const mapPending = layout.find((candidate) => candidate.key === 'mapButtonPending');
assert(mapPending, 'map pending slot should be present');
assert(mapPending.kind === 'pending', 'map sidebar button should stay pending until the correct DefineSprite id is verified');
assert(mapPending.candidate === null, 'map pending slot should not resolve a wrong source candidate');

console.log('Core5 UI canvas first-pass layout smoke test passed');
console.log('layout entries:', layout.length);
