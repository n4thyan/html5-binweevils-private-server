// Source-backed blank movement coordinate sandbox.
//
// This is not final gameplay movement and it is not a fake platformer model. It
// exists to test the Bin Weevils-style x/y/z/r coordinate state, using audited
// locationDefinitions baselines, before the movement code is attached to real
// room renders.

import { MOVEMENT_SANDBOX_BASELINE } from './MovementScaleBaselines.js';

export const MOVEMENT_SANDBOX_VIEWPORT = Object.freeze({
  width: 614,
  height: 366,
  originScreenX: 307,
  originScreenY: 236,
  unitsPerPixelX: 1.35,
  unitsPerPixelZ: 1.35
});

export const MOVEMENT_SANDBOX_RULES = Object.freeze({
  storesFlashState: 'x/y/z/r',
  sourceBaseline: MOVEMENT_SANDBOX_BASELINE.key,
  clickTargetIsConvertedToWorldXZ: true,
  clampsToSourceBoundary: true,
  roomArt: 'none',
  physicsStatus: 'placeholder-stepper-until-original-Walk-logic-is-ported'
});

export function createMovementSandboxState(overrides = {}) {
  const entryX = MOVEMENT_SANDBOX_BASELINE.entryPos[0] ?? 0;
  const entryZ = MOVEMENT_SANDBOX_BASELINE.entryPos[1] ?? 80;
  const entryDir = MOVEMENT_SANDBOX_BASELINE.entryDir ?? 180;

  return Object.freeze({
    locID: overrides.locID ?? 'movement-sandbox',
    scale: overrides.scale ?? MOVEMENT_SANDBOX_BASELINE.scale,
    boundary: Object.freeze([...(overrides.boundary ?? MOVEMENT_SANDBOX_BASELINE.boundary)]),
    maintainY: overrides.maintainY ?? MOVEMENT_SANDBOX_BASELINE.maintainY,
    position: Object.freeze({
      x: overrides.x ?? entryX,
      y: overrides.y ?? 0,
      z: overrides.z ?? entryZ,
      r: overrides.r ?? entryDir
    }),
    target: Object.freeze({
      x: overrides.targetX ?? entryX,
      y: overrides.targetY ?? 0,
      z: overrides.targetZ ?? entryZ
    })
  });
}

export function worldToScreen({ x, z }, viewport = MOVEMENT_SANDBOX_VIEWPORT) {
  return Object.freeze({
    x: viewport.originScreenX + Number(x) / viewport.unitsPerPixelX,
    y: viewport.originScreenY - Number(z) / viewport.unitsPerPixelZ
  });
}

export function screenToWorld({ x, y }, viewport = MOVEMENT_SANDBOX_VIEWPORT) {
  return Object.freeze({
    x: (Number(x) - viewport.originScreenX) * viewport.unitsPerPixelX,
    z: (viewport.originScreenY - Number(y)) * viewport.unitsPerPixelZ
  });
}

export function clampWorldToBoundary({ x, z }, boundary = MOVEMENT_SANDBOX_BASELINE.boundary) {
  const [minX, minZ, maxX, maxZ] = boundary.map(Number);
  return Object.freeze({
    x: clamp(Number(x), minX, maxX),
    z: clamp(Number(z), minZ, maxZ)
  });
}

export function createTargetFromScreenClick(screenPoint, state, viewport = MOVEMENT_SANDBOX_VIEWPORT) {
  const world = screenToWorld(screenPoint, viewport);
  const clamped = clampWorldToBoundary(world, state.boundary);
  return Object.freeze({
    x: clamped.x,
    y: state.position.y,
    z: clamped.z
  });
}

export function stepMovementSandbox(state, dtSeconds, speedUnitsPerSecond = 120) {
  const dt = Math.max(0, Number(dtSeconds) || 0);
  const position = state.position;
  const target = state.target;
  const dx = target.x - position.x;
  const dz = target.z - position.z;
  const distance = Math.hypot(dx, dz);

  if (distance < 0.001 || dt === 0) {
    return state;
  }

  const step = Math.min(distance, speedUnitsPerSecond * dt);
  const nx = position.x + (dx / distance) * step;
  const nz = position.z + (dz / distance) * step;
  const r = headingToLegacyRotation(dx, dz);

  return Object.freeze({
    ...state,
    position: Object.freeze({ x: nx, y: position.y, z: nz, r }),
    target
  });
}

export function withTarget(state, target) {
  return Object.freeze({
    ...state,
    target: Object.freeze({ x: Number(target.x), y: Number(target.y ?? state.position.y), z: Number(target.z) })
  });
}

export function headingToLegacyRotation(dx, dz) {
  // Temporary coarse mapping that preserves the existing renderer's r convention.
  // This must be replaced once the original Walk/heading logic is located.
  const angle = Math.atan2(Number(dz), Number(dx)) * 180 / Math.PI;
  if (angle >= 45 && angle < 135) return 0;
  if (angle <= -45 && angle > -135) return 180;
  if (angle >= 135 || angle <= -135) return -25;
  return 25;
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}
