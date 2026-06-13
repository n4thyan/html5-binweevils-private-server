import {
  CORE5_UI_CANVAS_SIZE,
  CORE5_UI_FIRST_PASS_LAYOUT,
  getCore5UiCanvasFirstPassLayout
} from '../src/ui/Core5UiCanvasFirstPassLayout.js';

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

const layout = getCore5UiCanvasFirstPassLayout();

assert(CORE5_UI_CANVAS_SIZE.width === 960, 'canvas width should be 960');
assert(CORE5_UI_CANVAS_SIZE.height === 640, 'canvas height should be 640');
assert(layout.length === CORE5_UI_FIRST_PASS_LAYOUT.length, 'resolved layout length should match source layout length');

const requiredKeys = ['levelBadgeComposite', 'mulchCounterComposite', 'doshCounterComposite', 'hungerMeterComposite', 'chatInputBar', 'mapPanelLandscape'];

for (const key of requiredKeys) {
  const item = layout.find((candidate) => candidate.key === key);
  assert(item, `${key} should be present in first-pass UI layout`);
  assert(item.candidate, `${key} should resolve a registry candidate`);
  assert(Number.isInteger(item.defineSpriteId), `${key} should resolve a DefineSprite id`);
  assert(typeof item.path === 'string' && item.path.includes(`DefineSprite_${item.defineSpriteId}`), `${key} should resolve a source path`);
  assert(item.x >= 0 && item.y >= 0, `${key} should have non-negative layout coordinates`);
  assert(item.width > 0 && item.height > 0, `${key} should have a positive layout size`);
}

console.log('Core5 UI canvas first-pass layout smoke test passed');
console.log('layout entries:', layout.length);
