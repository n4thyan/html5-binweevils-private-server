// Baseline samples for checking the restored asset-backed weevil renderer.
//
// These are local visual test samples only. They are not account defaults and
// they should not drive gameplay behaviour.

export const RENDERER_BASELINE_SAMPLES = Object.freeze([
  Object.freeze({
    id: 'baseline-a',
    label: 'Default renderer baseline',
    weevilDef: '101102103001040501',
    ps: 0,
    ex: 0,
    r: 0
  }),
  Object.freeze({
    id: 'baseline-b',
    label: 'Cone / sitting / left yaw',
    weevilDef: '202203405112080101',
    ps: 6,
    ex: 1,
    r: -25
  }),
  Object.freeze({
    id: 'baseline-c',
    label: 'Cuboid / standing / right yaw',
    weevilDef: '404401609010150000',
    ps: 7,
    ex: 2,
    r: 25
  })
]);

export function createBaselineUserVars(sample, index = 1) {
  return {
    userId: index,
    idx: index,
    name: sample.id,
    weevilDef: sample.weevilDef,
    x: 420,
    y: 0,
    z: 260,
    r: sample.r,
    ps: sample.ps,
    ex: sample.ex,
    apparel: '|null:-140,-140,-140',
    doorID: 0,
    locID: 0
  };
}
