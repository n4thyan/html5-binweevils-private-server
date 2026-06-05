// Prototype-derived visual configuration for the weevil renderer transplant.
//
// Source: old visually-correct HTML5 demo `app.js` renderer constants.
// Status: renderer reference config. Keep these values stable unless visual
// comparison against the demo or original assets proves a correction is needed.

export const WEEVIL_RENDERER_STATUS = 'prototype-derived-visual-config';

export const WEEVIL_CANVAS_BOUNDS = Object.freeze({
  width: 180,
  height: 220,
  originX: 90,
  originY: 140
});

export const WEEVIL_STAGE_CONFIG = Object.freeze({
  previewWidth: 900,
  previewHeight: 640,
  stageYRatio: 0.68,
  yawMax: 35,
  defaultScale: 1,
  groundShadow: {
    alpha: 0.22,
    x: 0,
    y: 32,
    rx: 142,
    ry: 34
  }
});

export const WEEVIL_DRAW_ORDER = Object.freeze([
  'legs.back',
  'body',
  'legs.front',
  'head',
  'antennae',
  'eyes',
  'proboscis',
  'mouth'
]);

export const BODY_VISUALS = Object.freeze({
  1: { atlas: 'body/spheroid', label: 'spheroid', width: 228, height: 182, shouldersY: -28, rootY: 82 },
  2: { atlas: 'body/cone', label: 'cone', width: 244, height: 192, shouldersY: -36, rootY: 92 },
  3: { atlas: 'body/cone_narrow_inv', label: 'inverse cone', width: 232, height: 200, shouldersY: -18, rootY: 78 },
  4: { atlas: 'body/cuboid', label: 'cuboid', width: 232, height: 190, shouldersY: -24, rootY: 88 }
});

export const HEAD_VISUALS = Object.freeze({
  1: { atlas: 'head/spheroid', label: 'spheroid', width: 218, height: 168, y: -158, mouthY: 26 },
  2: { atlas: 'head/cone', label: 'cone', width: 226, height: 172, y: -166, mouthY: 22 },
  3: { atlas: 'head/cone_inv', label: 'inverse cone', width: 212, height: 176, y: -160, mouthY: 34 },
  4: { atlas: 'head/cuboid', label: 'cuboid', width: 228, height: 184, y: -160, mouthY: 30 }
});

export const EYE_VISUALS = Object.freeze({
  1: { set: 'set1', label: 'round' },
  2: { set: 'set1', label: 'wide' },
  3: { set: 'set1', label: 'raised' },
  4: { set: 'set2', label: 'droopy' },
  5: { set: 'set2', label: 'tall' },
  6: { set: 'set2', label: 'far apart' }
});

export const EYE_POSITION_DATA = Object.freeze({
  1: Object.freeze({
    1: Object.freeze({ x: 27, y: -28, sx: 1.00, sy: 1.00, dx: 72 }),
    2: Object.freeze({ x: 40, y: -30, sx: 1.10, sy: 0.92, dx: 86 }),
    3: Object.freeze({ x: 25, y: -2, sx: 0.90, sy: 1.02, dx: 68 }),
    4: Object.freeze({ x: 30, y: 34, sx: 0.88, sy: 1.04, dx: 70 }),
    5: Object.freeze({ x: 60, y: 40, sx: 0.74, sy: 1.18, dx: 116 }),
    6: Object.freeze({ x: 95, y: -38, sx: 0.72, sy: 1.04, dx: 162 })
  }),
  2: Object.freeze({
    1: Object.freeze({ x: 27, y: -24, sx: 1.00, sy: 1.00, dx: 72 }),
    2: Object.freeze({ x: 40, y: -24, sx: 1.08, sy: 0.90, dx: 86 }),
    3: Object.freeze({ x: 25, y: 3, sx: 0.90, sy: 0.98, dx: 68 }),
    4: Object.freeze({ x: 30, y: 32, sx: 0.86, sy: 1.02, dx: 70 }),
    5: Object.freeze({ x: 70, y: 32, sx: 0.70, sy: 1.18, dx: 126 }),
    6: Object.freeze({ x: 95, y: -34, sx: 0.72, sy: 1.04, dx: 162 })
  }),
  3: Object.freeze({
    1: Object.freeze({ x: 27, y: -20, sx: 1.00, sy: 1.00, dx: 72 }),
    2: Object.freeze({ x: 48, y: -22, sx: 1.02, sy: 0.86, dx: 96 }),
    3: Object.freeze({ x: 27, y: 6, sx: 0.88, sy: 0.94, dx: 72 }),
    4: Object.freeze({ x: 30, y: 36, sx: 0.84, sy: 1.00, dx: 70 }),
    5: Object.freeze({ x: 60, y: 32, sx: 0.74, sy: 1.12, dx: 118 }),
    6: Object.freeze({ x: 100, y: -32, sx: 0.72, sy: 1.00, dx: 170 })
  }),
  4: Object.freeze({
    1: Object.freeze({ x: 27, y: -20, sx: 1.00, sy: 1.00, dx: 72 }),
    2: Object.freeze({ x: 62, y: -22, sx: 1.10, sy: 0.78, dx: 120 }),
    3: Object.freeze({ x: 26, y: 12, sx: 0.82, sy: 0.90, dx: 70 }),
    4: Object.freeze({ x: 30, y: 30, sx: 0.82, sy: 0.98, dx: 70 }),
    5: Object.freeze({ x: 92, y: 36, sx: 0.70, sy: 1.10, dx: 150 }),
    6: Object.freeze({ x: 100, y: -26, sx: 0.72, sy: 1.00, dx: 170 })
  })
});

export const MOUTH_VISUALS = Object.freeze([
  Object.freeze({ expression: 0, atlas: 'mouth/Mouth2_mc' }),
  Object.freeze({ expression: 1, atlas: 'mouth/Mouth1_mc' }),
  Object.freeze({ expression: 2, atlas: 'mouth/Mouth3_mc' }),
  Object.freeze({ expression: 3, atlas: 'mouth/Mouth4_mc' }),
  Object.freeze({ expression: 4, atlas: 'mouth/Mouth5_mc' }),
  Object.freeze({ expression: 5, atlas: 'mouth/Mouth6_mc' }),
  Object.freeze({ expression: 6, atlas: 'mouth/Mouth7_mc' })
]);

export const LEG_VISUALS = Object.freeze({
  0: { lowerFrame: 'lower_leg.png', label: 'normal' },
  1: { lowerFrame: 'lower_leg_stripy.png', label: 'stripy' }
});

export const ANTENNA_NAMES = Object.freeze({
  0: 'None', 1: 'Single Small', 2: 'Single Medium', 3: 'Single Large', 4: 'Double Small', 5: 'Double Medium', 6: 'Double Large',
  7: 'Triple Small', 8: 'Triple Medium', 9: 'Triple Large', 10: 'Super Original', 11: 'Super Purple', 12: 'Super Red/White',
  13: 'Super Purple/Yellow/Blue', 14: 'Super Halloween', 15: 'Super Fire', 16: 'Super Ice', 17: 'Black/White', 18: 'Black/Blue/Black',
  19: 'Beano', 20: 'Monty', 21: 'HD', 22: 'Red/Black', 23: 'Lime Green', 24: 'Pink/Aqua', 25: 'Marie', 26: 'Cabbage', 27: 'Bradaz',
  28: 'BB1', 29: 'BB2', 30: 'Pure Black', 31: 'Grey to Black', 32: 'Black to Grey', 33: 'Springy', 34: 'Doc1', 35: 'Doc2', 36: 'Pale Yellow',
  37: 'Neon1', 38: 'Neon2', 39: 'Bandit', 40: 'Pure White', 41: 'Make Own', 42: 'Comp Winner 1', 43: 'Comp Winner 2', 44: 'Comp Winner 3', 45: 'Comp Winner 4',
  49: 'Alex', 50: 'BrightKOTB', 51: 'Connor1', 52: 'Connor2', 53: 'Gold', 54: 'Icy'
});

export const LEG_NAMES = Object.freeze({
  0: 'Normal', 1: 'Stripy', 2: 'Summer Fair', 3: 'Super Original', 4: 'Purple/Yellow/Blue', 5: 'Halloween', 6: 'Black/White',
  7: 'Black/Blue/Black', 8: 'Fire', 9: 'Ice', 10: 'Disco', 11: 'Beano', 12: 'Monty', 13: 'HD', 14: 'Red/Black', 15: 'Lime Green',
  16: 'Pink/Aqua', 17: 'Marie', 18: 'Cabbage', 19: 'Bradaz', 20: 'BB1', 21: 'BB2', 22: 'Grey to Black', 23: 'Black to Grey', 24: 'Springy',
  25: 'Doc1', 26: 'Doc2', 27: 'Pale Yellow', 28: 'Neon1', 29: 'Neon2', 30: 'Bandit', 31: 'Comp Winner 1', 32: 'Comp Winner 2', 33: 'Comp Winner 3',
  34: 'Comp Winner 4', 35: 'Alex', 36: 'BrightKOTB', 37: 'Connor1', 38: 'Connor2', 39: 'Gold', 40: 'Icy'
});

export const LEG_LAYOUT_STATUS = 'partially-transplanted-from-demo';
export const ANTENNA_LAYOUT_STATUS = 'pending-full-demo-table-transplant';

export function getBodyVisual(type) {
  return BODY_VISUALS[Number(type)] ?? BODY_VISUALS[1];
}

export function getHeadVisual(type) {
  return HEAD_VISUALS[Number(type)] ?? HEAD_VISUALS[1];
}

export function getEyeVisual(type) {
  return EYE_VISUALS[Number(type)] ?? EYE_VISUALS[1];
}

export function getEyePosition(headType, eyeType) {
  return EYE_POSITION_DATA[Number(headType)]?.[Number(eyeType)] ?? EYE_POSITION_DATA[1][1];
}

export function getMouthVisual(expression = 0) {
  return MOUTH_VISUALS[Number(expression)] ?? MOUTH_VISUALS[0];
}

export function getLegVisual(type) {
  return LEG_VISUALS[Number(type)] ?? LEG_VISUALS[0];
}

export function getAntennaName(type) {
  return ANTENNA_NAMES[Number(type)] ?? `Antenna ${type}`;
}

export function getLegName(type) {
  return LEG_NAMES[Number(type)] ?? `Leg ${type}`;
}

export function getYawDerivedValues(yaw, yawMax = WEEVIL_STAGE_CONFIG.yawMax) {
  const yawFactor = yaw / yawMax;
  return {
    yaw,
    yawFactor,
    faceCompress: 1 - Math.abs(yawFactor) * 0.18,
    direction: yaw >= 0 ? 1 : -1
  };
}
