// Source-backed pose/expression helpers.
//
// Evidence:
// source/knowyourknot-binweevils/server/Weevil.js
// - user packets carry `ps` and `ex`
// - doAction sets ps = 6 for sitting and ps = 7 for standing
// - other actions generally reset ps = 0
//
// This module does not implement actions yet. It only normalises pose/expression
// values so the avatar renderer can consume them consistently.

export const WEEVIL_POSE = Object.freeze({
  DEFAULT: 0,
  SITTING: 6,
  STANDING: 7
});

export const WEEVIL_POSE_NAME = Object.freeze({
  [WEEVIL_POSE.DEFAULT]: 'default',
  [WEEVIL_POSE.SITTING]: 'sitting',
  [WEEVIL_POSE.STANDING]: 'standing'
});

export function normalisePoseState(value) {
  const pose = Number(value ?? WEEVIL_POSE.DEFAULT);
  return Number.isFinite(pose) ? pose : WEEVIL_POSE.DEFAULT;
}

export function getPoseName(value) {
  const pose = normalisePoseState(value);
  return WEEVIL_POSE_NAME[pose] ?? `action-${pose}`;
}

export function normaliseExpression(value) {
  const expression = Number(value ?? 0);
  if (!Number.isFinite(expression)) return 0;
  return Math.max(0, Math.floor(expression));
}

export function normaliseRotation(value) {
  const rotation = Number(value ?? 0);
  if (!Number.isFinite(rotation)) return 0;
  return rotation;
}

export function createPoseState({ ps = 0, ex = 0, r = 0 } = {}) {
  const pose = normalisePoseState(ps);
  const expression = normaliseExpression(ex);
  const rotation = normaliseRotation(r);

  return {
    ps: pose,
    poseName: getPoseName(pose),
    ex: expression,
    expression,
    r: rotation,
    rotation
  };
}
