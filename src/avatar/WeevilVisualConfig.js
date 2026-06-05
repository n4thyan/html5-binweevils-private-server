// Prototype-derived visual configuration for the weevil renderer transplant.
//
// Source: old HTML5 demo `WeevilCanvasRenderer.js` and related runtime files.
// Status: scaffold. The full magic-number tables from the proven demo renderer
// should be copied here gradually rather than buried directly in the renderer.

export const WEEVIL_RENDERER_STATUS = 'prototype-derived-visual-config';

export const WEEVIL_CANVAS_BOUNDS = Object.freeze({
  width: 180,
  height: 220,
  originX: 90,
  originY: 140
});

export const WEEVIL_DRAW_ORDER = Object.freeze([
  'legs.back',
  'body',
  'head',
  'eyes.whites',
  'eyes.irises',
  'eyes.lids',
  'mouth',
  'antennae',
  'legs.front'
]);

export const BODY_VISUALS = Object.freeze({
  1: { atlas: 'body/spheroid', label: 'spheroid' },
  2: { atlas: 'body/cone', label: 'cone' },
  3: { atlas: 'body/cone_narrow_inv', label: 'cone_narrow_inv' },
  4: { atlas: 'body/cuboid', label: 'cuboid' }
});

export const HEAD_VISUALS = Object.freeze({
  1: { atlas: 'head/spheroid', label: 'spheroid' },
  2: { atlas: 'head/cone', label: 'cone' },
  3: { atlas: 'head/cone_inv', label: 'cone_inv' },
  4: { atlas: 'head/cuboid', label: 'cuboid' }
});

export const EYE_VISUALS = Object.freeze({
  1: { set: 'set1' },
  2: { set: 'set1' },
  3: { set: 'set1' },
  4: { set: 'set2' },
  5: { set: 'set2' },
  6: { set: 'set2' }
});

export const MOUTH_VISUALS = Object.freeze([
  { expression: 0, atlas: 'mouth/Mouth2_mc' },
  { expression: 1, atlas: 'mouth/Mouth1_mc' },
  { expression: 2, atlas: 'mouth/Mouth3_mc' },
  { expression: 3, atlas: 'mouth/Mouth4_mc' },
  { expression: 4, atlas: 'mouth/Mouth5_mc' },
  { expression: 5, atlas: 'mouth/Mouth6_mc' },
  { expression: 6, atlas: 'mouth/Mouth7_mc' }
]);

export const LEG_VISUALS = Object.freeze({
  0: { lowerFrame: 'lower_leg.png', label: 'normal' },
  1: { lowerFrame: 'lower_leg_stripy.png', label: 'stripy' }
});

export const ANTENNA_LAYOUT_STATUS = 'pending-full-demo-table-transplant';
export const EYE_POSITION_STATUS = 'pending-full-demo-table-transplant';
export const LEG_LAYOUT_STATUS = 'pending-full-demo-table-transplant';

export function getBodyVisual(type) {
  return BODY_VISUALS[Number(type)] ?? BODY_VISUALS[1];
}

export function getHeadVisual(type) {
  return HEAD_VISUALS[Number(type)] ?? HEAD_VISUALS[1];
}

export function getEyeVisual(type) {
  return EYE_VISUALS[Number(type)] ?? EYE_VISUALS[1];
}

export function getMouthVisual(expression = 0) {
  return MOUTH_VISUALS[Number(expression)] ?? MOUTH_VISUALS[0];
}

export function getLegVisual(type) {
  return LEG_VISUALS[Number(type)] ?? LEG_VISUALS[0];
}
