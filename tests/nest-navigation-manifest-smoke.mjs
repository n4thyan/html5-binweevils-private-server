import assert from "node:assert/strict";
import {
  NEST_LOCATIONS,
  getNestDoorTarget,
  getNestHallDoorLayerKey
} from "../src/rooms/NestNavigationManifest.js";

assert.equal(NEST_LOCATIONS[5].key, "nestHall");

const expectedHallDoors = new Map([
  [1, 4],
  [2, 6],
  [3, 2],
  [4, 8],
  [5, 1],
  [6, 3],
  [7, 7],
  [8, 9],
  [9, 20],
  [10, 10]
]);

for (const [doorId, expectedToLoc] of expectedHallDoors) {
  const target = getNestDoorTarget(5, doorId);
  assert.ok(target, `Hall door ${doorId} target is missing`);
  assert.equal(target.toLoc, expectedToLoc);
  assert.equal(getNestHallDoorLayerKey(doorId), `door${doorId}_mc`);
}

assert.equal(getNestDoorTarget(1, 1).toLoc, 5);
assert.equal(getNestDoorTarget(2, 1).toLoc, 5);
assert.equal(getNestDoorTarget(3, 1).toLoc, 5);
assert.equal(getNestDoorTarget(4, 1).toLoc, 5);
assert.equal(getNestDoorTarget(6, 1).toLoc, 5);
assert.equal(getNestDoorTarget(7, 2).toLoc, 5);
assert.equal(getNestDoorTarget(8, 1).toLoc, 5);
assert.equal(getNestDoorTarget(9, 2).toLoc, 5);

assert.equal(getNestDoorTarget(4, 2).toLoc, 7);
assert.equal(getNestDoorTarget(6, 2).toLoc, 9);
assert.equal(getNestDoorTarget(7, 1).toLoc, 4);
assert.equal(getNestDoorTarget(9, 1).toLoc, 6);

console.log("Nest navigation manifest smoke test passed");
console.log("Hall door targets:", [...expectedHallDoors].map(([door, loc]) => `${door}->${loc}`).join(", "));
