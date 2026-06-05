import assert from 'node:assert/strict';

import {
  CAM_UI_BUTTON_BINDINGS,
  CAM_UI_JOYSTICKS,
  CAM_UI_MODE_BUTTONS,
  CAM_UI_ROOT_CHILDREN,
  CAM_UI_VISIBILITY_RULES,
  findCamUiButtonByAxis,
  listCamUiChildPaths,
  summariseCamUiSourceMap
} from '../src/ui/CamUiSourceMap.js';

const paths = listCamUiChildPaths();

for (const requiredPath of [
  'zoomRotate_spr',
  'elevation_spr',
  'resetCamBtn_mc',
  'closeUpCamBtn_mc',
  'aimFollowCamBtn_mc',
  'weevilCamBtn_mc',
  'help_sign',
  'zoomRotate_spr.joy1_spr',
  'elevation_spr.joy2_spr',
  'zoomRotate_spr.left_btn',
  'zoomRotate_spr.right_btn',
  'zoomRotate_spr.forward_btn',
  'zoomRotate_spr.backward_btn',
  'elevation_spr.up_btn',
  'elevation_spr.down_btn',
  'resetCamBtn_mc.bg_mc',
  'closeUpCamBtn_mc.bg_mc',
  'aimFollowCamBtn_mc.bg_mc',
  'weevilCamBtn_mc.bg_mc'
]) {
  assert.ok(paths.includes(requiredPath), `missing CamUI path: ${requiredPath}`);
}

assert.equal(CAM_UI_ROOT_CHILDREN.length, 7);
assert.equal(CAM_UI_JOYSTICKS.length, 2);
assert.deepEqual(CAM_UI_JOYSTICKS[0].bounds, { x: -36, y: -36, width: 72, height: 72 });
assert.deepEqual(CAM_UI_JOYSTICKS[1].bounds, { x: 0, y: -36, width: 0, height: 72 });
assert.equal(CAM_UI_BUTTON_BINDINGS.length, 6);
assert.equal(findCamUiButtonByAxis('vx').length, 2);
assert.equal(findCamUiButtonByAxis('vz').length, 2);
assert.equal(findCamUiButtonByAxis('vy').length, 2);
assert.ok(CAM_UI_BUTTON_BINDINGS.some((binding) => binding.childPath === 'zoomRotate_spr.left_btn' && binding.pressValue === -10 && binding.keyboardCode === 37));
assert.ok(CAM_UI_BUTTON_BINDINGS.some((binding) => binding.childPath === 'zoomRotate_spr.forward_btn' && binding.pressValue === 10 && binding.keyboardCode === 38));
assert.ok(CAM_UI_BUTTON_BINDINGS.some((binding) => binding.childPath === 'elevation_spr.up_btn' && binding.pressValue === 5));
assert.equal(CAM_UI_MODE_BUTTONS.length, 4);
assert.ok(CAM_UI_MODE_BUTTONS.some((button) => button.handler === 'activateWeevilCam' && button.mode === 2));
assert.equal(CAM_UI_VISIBILITY_RULES.initiallyVisible, false);
assert.equal(CAM_UI_VISIBILITY_RULES.helpSignVisibleLocID, 190);
assert.deepEqual(CAM_UI_VISIBILITY_RULES.disableResetsVelocity, { vx: 0, vy: 0, vz: 0 });

const summary = summariseCamUiSourceMap();
assert.equal(summary.rootChildren, 7);
assert.equal(summary.joysticks, 2);
assert.equal(summary.movementButtons, 6);
assert.equal(summary.modeButtons, 4);

console.log('cam-ui source map smoke test passed');
console.log(summary.summary);
