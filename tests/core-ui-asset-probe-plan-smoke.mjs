import assert from 'node:assert/strict';

import {
  CORE_UI_ASSET_PROBE_PLAN,
  summariseCoreUiAssetProbePlan
} from '../src/assets/CoreUiAssetProbePlan.js';

const expected = new Map([
  ['weevil-profile', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2502_core390_fla.weevilProfile_467/1.svg'],
  ['control-tab', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2359_core390_fla.controlTab_450/1.svg'],
  ['alert-box', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2832_core390_fla.alertBox_1370/1.svg'],
  ['dialogue-box', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2803_core390_fla.dialogueBox_1357/1.svg'],
  ['side-buttons', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2548_core390_fla.sidebtnsflipout_549/1.svg'],
  ['actions-button', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_1761_core390_fla.actionsBtn_134/1.svg'],
  ['action-icons', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2018_core390_fla.actionIcons_246/1.svg'],
  ['mouth-icons', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_1926_core390_fla.mouthIcons_213/1.svg'],
  ['pet-profile', 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_1685_core390_fla.petProfile_3/1.svg']
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
assert.ok(summary.paths.every((path) => path.includes('/DefineSprite_')));

console.log('core UI asset probe plan smoke test passed');
console.log(summary.paths.join('\n'));
