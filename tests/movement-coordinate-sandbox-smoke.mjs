import assert from 'node:assert/strict';

import {
  MOVEMENT_SANDBOX_RULES,
  MOVEMENT_SANDBOX_VIEWPORT,
  clampWorldToBoundary,
  createMovementSandboxState,
  createTargetFromScreenClick,
  screenToWorld,
  stepMovementSandbox,
  withTarget,
  worldToScreen
} from '../src/movement/MovementCoordinateSandbox.js';
import { MOVEMENT_SANDBOX_BASELINE } from '../src/movement/MovementScaleBaselines.js';

assert.equal(MOVEMENT_SANDBOX_RULES.roomArt, 'none');
assert.equal(MOVEMENT_SANDBOX_BASELINE.scale, 0.28);

const state = createMovementSandboxState();
assert.equal(state.scale, 0.28);
assert.deepEqual(state.position, { x: 0, y: 0, z: 80, r: 180 });
assert.deepEqual(state.target, { x: 0, y: 0, z: 80 });

const screen = worldToScreen({ x: 0, z: 80 });
const world = screenToWorld(screen);
assert.equal(Math.round(world.x), 0);
assert.equal(Math.round(world.z), 80);

const target = createTargetFromScreenClick({ x: MOVEMENT_SANDBOX_VIEWPORT.originScreenX + 100, y: MOVEMENT_SANDBOX_VIEWPORT.originScreenY - 40 }, state);
assert.equal(target.y, 0);
assert.ok(target.x > 0);
assert.ok(target.z > 0);

const clamped = clampWorldToBoundary({ x: 9999, z: -9999 }, state.boundary);
assert.equal(clamped.x, state.boundary[2]);
assert.equal(clamped.z, state.boundary[1]);

const moving = withTarget(state, { x: 120, y: 0, z: 120 });
const stepped = stepMovementSandbox(moving, 0.25, 120);
assert.ok(stepped.position.x > state.position.x);
assert.ok(stepped.position.z > state.position.z);
assert.notEqual(stepped.position.r, undefined);

console.log('movement coordinate sandbox smoke test passed');
console.log(`baseline scale ${state.scale} / entry ${state.position.x},${state.position.z} / viewport ${MOVEMENT_SANDBOX_VIEWPORT.width}x${MOVEMENT_SANDBOX_VIEWPORT.height}`);
