import assert from 'node:assert/strict';

import { AvatarState } from '../src/avatar/AvatarState.js';
import { WeevilCanvasRenderer } from '../src/avatar/WeevilCanvasRenderer.js';
import { SAMPLE_WEEVIL_DEF } from '../src/avatar/WeevilDefSamples.js';

const calls = [];
const ctx = createMockCanvasContext(calls);
const avatar = AvatarState.fromUserVars({
  userId: 1,
  idx: 1,
  name: 'renderer-smoke',
  weevilDef: SAMPLE_WEEVIL_DEF,
  x: 0,
  y: 0,
  z: 0,
  r: 0,
  ps: 0,
  ex: 0
});

const plan = avatar.createRenderPlan();
const renderer = new WeevilCanvasRenderer({ mode: 'prototype' });
const result = renderer.render(ctx, plan, 0, 0, { mode: 'prototype' });

assert.equal(result.mode, 'prototype');
assert.equal(result.drawn, true);
assert.ok(calls.includes('save'), 'renderer should save canvas state');
assert.ok(calls.includes('restore'), 'renderer should restore canvas state');
assert.ok(calls.includes('ellipse'), 'renderer should draw ellipse-based prototype shapes');
assert.ok(calls.includes('fillText'), 'renderer should draw prototype labels');

console.log('prototype renderer smoke test passed');

function createMockCanvasContext(callLog) {
  return {
    fillStyle: '#000000',
    strokeStyle: '#000000',
    font: '10px sans-serif',
    lineWidth: 1,
    globalAlpha: 1,
    save: () => callLog.push('save'),
    restore: () => callLog.push('restore'),
    translate: () => callLog.push('translate'),
    beginPath: () => callLog.push('beginPath'),
    closePath: () => callLog.push('closePath'),
    fill: () => callLog.push('fill'),
    stroke: () => callLog.push('stroke'),
    fillRect: () => callLog.push('fillRect'),
    strokeRect: () => callLog.push('strokeRect'),
    moveTo: () => callLog.push('moveTo'),
    lineTo: () => callLog.push('lineTo'),
    arc: () => callLog.push('arc'),
    ellipse: () => callLog.push('ellipse'),
    fillText: () => callLog.push('fillText')
  };
}
