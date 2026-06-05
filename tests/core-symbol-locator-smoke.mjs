import assert from 'node:assert/strict';

import {
  CORE_UI_SYMBOLS,
  buildCoreAssetPath,
  findCoreUISymbol,
  getCoreSymbolAssetDirectory,
  getCoreSymbolAssetPath,
  summariseCoreSymbolLocator
} from '../src/assets/CoreSymbolLocator.js';

assert.ok(CORE_UI_SYMBOLS.length >= 25, 'expected important core UI symbols to be mapped');

assert.equal(
  getCoreSymbolAssetPath('core390_fla.weevilProfile_467'),
  'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2502_core390_fla.weevilProfile_467/1.svg'
);

assert.equal(
  getCoreSymbolAssetPath(2359),
  'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2359_core390_fla.controlTab_450/1.svg'
);

assert.equal(
  getCoreSymbolAssetPath('core390_fla.alertBox_1370'),
  'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2832_core390_fla.alertBox_1370/1.svg'
);

assert.equal(
  getCoreSymbolAssetPath('core390_fla.weevilProfile_467', 3),
  'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2502_core390_fla.weevilProfile_467/3.svg'
);

assert.equal(
  buildCoreAssetPath(7, 'button'),
  'reference/decompiled-dumpassets/dumpassets/core5.swf/buttons/DefineButton_7/1.svg'
);

assert.equal(
  buildCoreAssetPath(5, 'sound'),
  'reference/decompiled-dumpassets/dumpassets/core5.swf/sounds/DefineSound_5/1.mp3'
);

assert.equal(
  getCoreSymbolAssetDirectory('core390_fla.sidebtnsflipout_549'),
  'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2548_core390_fla.sidebtnsflipout_549'
);

assert.equal(findCoreUISymbol('profile')[0].className, 'core390_fla.weevilProfile_467');
assert.ok(findCoreUISymbol('dialogue').some((entry) => entry.className === 'core390_fla.dialogueBox_1357'));
assert.ok(findCoreUISymbol('action').length >= 3);

const summary = summariseCoreSymbolLocator();
assert.equal(summary.samplePaths.weevilProfile, 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2502_core390_fla.weevilProfile_467/1.svg');
assert.equal(summary.samplePaths.controls, 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2359_core390_fla.controlTab_450/1.svg');
assert.equal(summary.samplePaths.alertBox, 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2832_core390_fla.alertBox_1370/1.svg');
assert.equal(summary.samplePaths.sideButtons, 'reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_2548_core390_fla.sidebtnsflipout_549/1.svg');

console.log('core-symbol locator smoke test passed');
console.log(JSON.stringify(summary.samplePaths, null, 2));
