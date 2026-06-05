import assert from 'node:assert/strict';

import { AvatarState } from '../src/avatar/AvatarState.js';
import { SAMPLE_WEEVIL_DEF } from '../src/avatar/WeevilDefSamples.js';
import { summariseRenderPlan, validateRenderPlan } from '../src/avatar/WeevilRendererDiagnostics.js';

const avatar = AvatarState.fromUserVars({
  userId: 1,
  idx: 1,
  name: 'smoke_test_weevil',
  weevilDef: SAMPLE_WEEVIL_DEF,
  x: 420,
  y: 0,
  z: 260,
  r: 0,
  ps: 0,
  ex: 0,
  apparel: '|null:-140,-140,-140',
  doorID: 0,
  locID: 0
});

const plan = avatar.createRenderPlan();
const diagnostics = validateRenderPlan(plan);
const summary = summariseRenderPlan(plan);

assert.equal(diagnostics.ok, true, diagnostics.issues.join('\n'));
assert.equal(summary.ok, true, summary.summary);
assert.equal(plan.validation.ok, true, 'sample weevil definition should validate');
assert.equal(plan.parts.body.type, 1);
assert.equal(plan.parts.head.type, 1);
assert.equal(plan.parts.eyes.type, 3);
assert.equal(plan.parts.mouth.expression, 0);
assert.equal(plan.pose.poseName, 'default');
assert.equal(plan.visuals.body.label, 'spheroid');
assert.equal(plan.visuals.head.label, 'spheroid');
assert.ok(plan.parts.eyes.position.dx > 0, 'eye position should include spacing');

console.log('render-plan smoke test passed');
console.log(summary.summary);
