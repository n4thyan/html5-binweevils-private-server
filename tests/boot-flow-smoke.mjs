import assert from 'node:assert/strict';

import {
  BOOT_STEP_IDS,
  buildBootTimeline,
  createBootContext,
  resolveCoreSwfName,
  summariseBootFlow
} from '../src/boot/BinBootFlow.js';

const expectedOrder = [
  BOOT_STEP_IDS.READ_ROOT_PARAMS,
  BOOT_STEP_IDS.SET_STAGE,
  BOOT_STEP_IDS.LOAD_CONFIG,
  BOOT_STEP_IDS.APPLY_CONFIG,
  BOOT_STEP_IDS.CHECK_VERSION,
  BOOT_STEP_IDS.RESOLVE_DEFAULT_LOC,
  BOOT_STEP_IDS.LOAD_LOADER_CONTENT,
  BOOT_STEP_IDS.LOAD_CORE,
  BOOT_STEP_IDS.CORE_INIT_HANDOFF
];

const defaultContext = createBootContext();
assert.equal(defaultContext.cluster, 'uk');
assert.equal(defaultContext.loginPath, null);
assert.equal(defaultContext.loginPageURL, 'index.php');
assert.equal(defaultContext.defaultLocID, 5);
assert.equal(defaultContext.coreSwfName, 'core.swf');

const loggedInContext = createBootContext({ loginPath: 'abc123', coreVersion: 390, defaultLocID: 12 });
assert.equal(loggedInContext.loginPath, 'abc123');
assert.equal(loggedInContext.loginPageURL, 'https://play.binweevils.com/');
assert.equal(loggedInContext.coreSwfName, 'core390.swf');
assert.equal(loggedInContext.defaultLocID, 12);

assert.equal(resolveCoreSwfName(0), 'core.swf');
assert.equal(resolveCoreSwfName(390), 'core390.swf');

const timeline = buildBootTimeline({ loginPath: 'abc123', coreVersion: 390, defaultLocID: 12 });
assert.deepEqual(timeline.map((step) => step.id), expectedOrder);
assert.equal(timeline.at(-1).context.defaultLocID, 12);
assert.deepEqual(timeline.at(-1).context.holders, ['contentHolderU_spr', 'contentHolderL_spr']);

const summary = summariseBootFlow({ coreVersion: 390 });
assert.equal(summary.steps, expectedOrder.length);
assert.equal(summary.coreSwfName, 'core390.swf');
assert.equal(summary.firstStep, BOOT_STEP_IDS.READ_ROOT_PARAMS);
assert.equal(summary.finalStep, BOOT_STEP_IDS.CORE_INIT_HANDOFF);
assert.ok(summary.summary.includes('loadCore'));

console.log('boot-flow smoke test passed');
console.log(summary.summary);
