import assert from 'node:assert/strict';

import {
  CORE_UI_ASSET_PROBE_PLAN,
  summariseCoreUiAssetProbePlan
} from '../src/assets/CoreUiAssetProbePlan.js';

const expected = new Map([
  ['weevil-profile', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/2502.svg'],
  ['control-tab', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/2359.svg'],
  ['alert-box', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/2832.svg'],
  ['dialogue-box', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/2803.svg'],
  ['side-buttons', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/2548.svg'],
  ['actions-button', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/1761.svg'],
  ['action-icons', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/2018.svg'],
  ['mouth-icons', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/1926.svg'],
  ['pet-profile', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/1685.svg']
]);

assert.equal(CORE_UI_ASSET_PROBE_PLAN.length, expected.size);

for (const entry of CORE_UI_ASSET_PROBE_PLAN) {
  assert.equal(entry.expectedPath, expected.get(entry.key), `bad probe path for ${entry.key}`);
  assert.ok(entry.className.startsWith('core390_fla.'), `bad class name for ${entry.key}`);
}

const summary = summariseCoreUiAssetProbePlan();
assert.equal(summary.count, expected.size);
assert.ok(summary.labels.includes('weevil-profile'));
assert.ok(summary.labels.includes('control-tab'));
assert.ok(summary.paths.every((path) => path.endsWith('.svg')));

console.log('core UI asset probe plan smoke test passed');
console.log(summary.paths.join('\n'));
