import assert from 'node:assert/strict';

import {
  UI_MAIN_CONSTRUCTOR_FLOW,
  UI_MAIN_SYMBOLS,
  UI_ROOT_ARGS,
  findUIMainChildPath,
  listUIMainChildPaths,
  summariseUIMainSourceMap
} from '../src/ui/UIMainSourceMap.js';

const paths = listUIMainChildPaths();

assert.deepEqual(UI_ROOT_ARGS, [
  'UI_mc',
  'contentHolderU_spr',
  'contentHolderL_spr',
  'inventoryHolder_spr',
  'questHelpHolder_spr',
  'questExtUiHelpHolder_spr'
]);

for (const requiredPath of [
  'controls_mc.map_btn',
  'controls_mc.shop_btn',
  'controls_mc.nest_btn',
  'controls_mc.chat_spr',
  'controls_mc.camUI_spr',
  'weevilProfile_mc',
  'weevilProfile_mc.profileContent_spr',
  'petProfile_mc',
  'alertBox_mc',
  'warningBox_mc',
  'dialogueBox_mc',
  'invitation_mc',
  'newsAndMessages_spr',
  'binBadges_mc'
]) {
  assert.ok(paths.includes(requiredPath), `missing UImain path: ${requiredPath}`);
}

assert.ok(findUIMainChildPath('buddy').length >= 5, 'buddy-related child paths should be mapped');
assert.ok(findUIMainChildPath('hit_btn').length >= 8, 'level-lock hit areas should be mapped');
assert.ok(UI_MAIN_SYMBOLS.some((entry) => entry.symbol === 'core390_fla.weevilProfile_467'));
assert.ok(UI_MAIN_SYMBOLS.some((entry) => entry.symbol === 'core390_fla.alertBox_1370'));
assert.ok(UI_MAIN_SYMBOLS.some((entry) => entry.symbol === 'core390_fla.sidebtnsflipout_549'));
assert.ok(UI_MAIN_CONSTRUCTOR_FLOW.some((step) => step.id === 'wire-news-and-badges'));

const summary = summariseUIMainSourceMap();
assert.ok(summary.childPaths >= 50);
assert.ok(summary.symbols >= 10);
assert.ok(summary.constructorSteps >= 10);

console.log('ui-main source map smoke test passed');
console.log(summary.summary);
