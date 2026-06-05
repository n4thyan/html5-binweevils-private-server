// Source-backed map of core5.swf/scripts/com/binweevils/CamUI.as.
//
// This records the real Flash child names, control bindings and camera velocity
// values before any HTML5 camera panel UI is implemented.

export const CAM_UI_SOURCE = 'reference/decompiled-dumpassets/dumpassets/core5.swf/scripts/com/binweevils/CamUI.as';

export const CAM_UI_ROOT_CHILDREN = Object.freeze([
  'zoomRotate_spr',
  'elevation_spr',
  'resetCamBtn_mc',
  'closeUpCamBtn_mc',
  'aimFollowCamBtn_mc',
  'weevilCamBtn_mc',
  'help_sign'
]);

export const CAM_UI_NESTED_CHILDREN = Object.freeze({
  zoomRotate_spr: Object.freeze([
    'joy1_spr',
    'left_btn',
    'right_btn',
    'forward_btn',
    'backward_btn'
  ]),
  elevation_spr: Object.freeze([
    'joy2_spr',
    'up_btn',
    'down_btn'
  ]),
  modeButtons: Object.freeze([
    'resetCamBtn_mc.bg_mc',
    'closeUpCamBtn_mc.bg_mc',
    'aimFollowCamBtn_mc.bg_mc',
    'weevilCamBtn_mc.bg_mc'
  ])
});

export const CAM_UI_JOYSTICKS = Object.freeze([
  Object.freeze({
    id: 'zoom-rotate',
    sourceChild: 'zoomRotate_spr.joy1_spr',
    joystickIndex: 1,
    bounds: Object.freeze({ x: -36, y: -36, width: 72, height: 72 }),
    sensitivity: 7
  }),
  Object.freeze({
    id: 'elevation',
    sourceChild: 'elevation_spr.joy2_spr',
    joystickIndex: 2,
    bounds: Object.freeze({ x: 0, y: -36, width: 0, height: 72 }),
    sensitivity: 7
  })
]);

export const CAM_UI_BUTTON_BINDINGS = Object.freeze([
  Object.freeze({ childPath: 'zoomRotate_spr.left_btn', pressMethod: 'onLeftPress', releaseMethod: 'leftRightReleased', cameraAxis: 'vx', pressValue: -10, releaseValue: 0, keyboardCode: 37 }),
  Object.freeze({ childPath: 'zoomRotate_spr.right_btn', pressMethod: 'onRightPress', releaseMethod: 'leftRightReleased', cameraAxis: 'vx', pressValue: 10, releaseValue: 0, keyboardCode: 39 }),
  Object.freeze({ childPath: 'zoomRotate_spr.forward_btn', pressMethod: 'onForwardPress', releaseMethod: 'forBackReleased', cameraAxis: 'vz', pressValue: 10, releaseValue: 0, keyboardCode: 38 }),
  Object.freeze({ childPath: 'zoomRotate_spr.backward_btn', pressMethod: 'onBackwardPress', releaseMethod: 'forBackReleased', cameraAxis: 'vz', pressValue: -10, releaseValue: 0, keyboardCode: 40 }),
  Object.freeze({ childPath: 'elevation_spr.up_btn', pressMethod: 'onUpPress', releaseMethod: 'upDownReleased', cameraAxis: 'vy', pressValue: 5, releaseValue: 0, keyboardCode: null }),
  Object.freeze({ childPath: 'elevation_spr.down_btn', pressMethod: 'onDownPress', releaseMethod: 'upDownReleased', cameraAxis: 'vy', pressValue: -5, releaseValue: 0, keyboardCode: null })
]);

export const CAM_UI_MODE_BUTTONS = Object.freeze([
  Object.freeze({ childPath: 'resetCamBtn_mc', handler: 'resetCam', mode: 0, selectedFrame: 2, action: 'bin.resetBinCam(true)' }),
  Object.freeze({ childPath: 'closeUpCamBtn_mc', handler: 'closeUpCam', mode: 'close-up', selectedFrame: 2, action: 'bin.closeUpCam()' }),
  Object.freeze({ childPath: 'aimFollowCamBtn_mc', handler: 'activateAimFollowCam', mode: 1, selectedFrame: 2, action: 'bin.userSetCamMode(1)' }),
  Object.freeze({ childPath: 'weevilCamBtn_mc', handler: 'activateWeevilCam', mode: 2, selectedFrame: 2, action: 'bin.userSetCamMode(2)' })
]);

export const CAM_UI_VISIBILITY_RULES = Object.freeze({
  initiallyVisible: false,
  enableShowsPanel: true,
  disableHidesPanel: true,
  helpSignVisibleLocID: 190,
  disableResetsVelocity: Object.freeze({ vx: 0, vy: 0, vz: 0 })
});

export function listCamUiChildPaths() {
  return Object.freeze([
    ...CAM_UI_ROOT_CHILDREN,
    ...CAM_UI_NESTED_CHILDREN.zoomRotate_spr.map((child) => `zoomRotate_spr.${child}`),
    ...CAM_UI_NESTED_CHILDREN.elevation_spr.map((child) => `elevation_spr.${child}`),
    ...CAM_UI_NESTED_CHILDREN.modeButtons
  ]);
}

export function findCamUiButtonByAxis(axis) {
  return CAM_UI_BUTTON_BINDINGS.filter((binding) => binding.cameraAxis === axis);
}

export function summariseCamUiSourceMap() {
  return Object.freeze({
    source: CAM_UI_SOURCE,
    rootChildren: CAM_UI_ROOT_CHILDREN.length,
    childPaths: listCamUiChildPaths().length,
    joysticks: CAM_UI_JOYSTICKS.length,
    movementButtons: CAM_UI_BUTTON_BINDINGS.length,
    modeButtons: CAM_UI_MODE_BUTTONS.length,
    helpSignVisibleLocID: CAM_UI_VISIBILITY_RULES.helpSignVisibleLocID,
    summary: [
      'root children: ' + CAM_UI_ROOT_CHILDREN.join(', '),
      'keyboard: left/right/up/down map to vx/vz',
      'elevation buttons map to vy',
      'mode buttons use bg_mc frame 2 as selected state'
    ].join('\n')
  });
}
