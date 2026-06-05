import assert from 'node:assert/strict';

import { AvatarState } from '../src/avatar/AvatarState.js';
import { SAMPLE_WEEVIL_DEF } from '../src/avatar/WeevilDefSamples.js';
import { summariseRenderPlan, validateRenderPlan } from '../src/avatar/WeevilRendererDiagnostics.js';

const cases = [
  {
    id: 'default-sample',
    weevilDef: SAMPLE_WEEVIL_DEF,
    ps: 0,
    ex: 0,
    r: 0,
    expected: {
      bodyType: 1,
      headType: 1,
      eyeType: 1,
      expression: 0,
      poseName: 'default',
      bodyLabel: 'spheroid',
      headLabel: 'spheroid'
    }
  },
  {
    id: 'sitting-yaw-left',
    weevilDef: '202203405112080101',
    ps: 6,
    ex: 1,
    r: -25,
    expected: {
      bodyType: 2,
      headType: 2,
      eyeType: 4,
      expression: 1,
      poseName: 'sitting',
      bodyLabel: 'cone',
      headLabel: 'cone'
    }
  },
  {
    id: 'standing-yaw-right',
    weevilDef: '404401609010150000',
    ps: 7,
    ex: 2,
    r: 25,
    expected: {
      bodyType: 4,
      headType: 4,
      eyeType: 6,
      expression: 2,
      poseName: 'standing',
      bodyLabel: 'cuboid',
      headLabel: 'cuboid'
    }
  }
];

for (const testCase of cases) {
  const avatar = AvatarState.fromUserVars({
    userId: testCase.id,
    idx: 1,
    name: testCase.id,
    weevilDef: testCase.weevilDef,
    x: 420,
    y: 0,
    z: 260,
    r: testCase.r,
    ps: testCase.ps,
    ex: testCase.ex,
    apparel: '|null:-140,-140,-140',
    doorID: 0,
    locID: 0
  });

  const plan = avatar.createRenderPlan();
  const diagnostics = validateRenderPlan(plan);
  const summary = summariseRenderPlan(plan);

  assert.equal(diagnostics.ok, true, `${testCase.id}: ${diagnostics.issues.join('\n')}`);
  assert.equal(summary.ok, true, `${testCase.id}: ${summary.summary}`);
  assert.equal(plan.validation.ok, true, `${testCase.id}: weevil definition should validate`);
  assert.equal(plan.parts.body.type, testCase.expected.bodyType, `${testCase.id}: body type`);
  assert.equal(plan.parts.head.type, testCase.expected.headType, `${testCase.id}: head type`);
  assert.equal(plan.parts.eyes.type, testCase.expected.eyeType, `${testCase.id}: eye type`);
  assert.equal(plan.parts.mouth.expression, testCase.expected.expression, `${testCase.id}: expression`);
  assert.equal(plan.pose.poseName, testCase.expected.poseName, `${testCase.id}: pose name`);
  assert.equal(plan.visuals.body.label, testCase.expected.bodyLabel, `${testCase.id}: body label`);
  assert.equal(plan.visuals.head.label, testCase.expected.headLabel, `${testCase.id}: head label`);
  assert.ok(plan.parts.eyes.position.dx > 0, `${testCase.id}: eye position should include spacing`);
  assert.ok(Number.isFinite(plan.yaw.yawFactor), `${testCase.id}: yaw factor should be finite`);

  console.log(`render-plan smoke test passed: ${testCase.id}`);
  console.log(summary.summary);
}
