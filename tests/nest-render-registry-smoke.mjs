import assert from "node:assert/strict";
import { NEST_RENDERABLE_LOCATIONS } from "../src/rooms/NestRenderRegistry.js";
import { getNestDoorTarget } from "../src/rooms/NestNavigationManifest.js";

for (const locationId of [1,2,3,4,5,6,7,8,9]) {
  const config = NEST_RENDERABLE_LOCATIONS[locationId];
  assert.ok(config, `Missing renderable config for loc ${locationId}`);
  assert.ok(config.sceneJson, `Missing scene JSON path for loc ${locationId}`);
  assert.ok(config.layerPlan.length > 0, `Missing layer plan for loc ${locationId}`);
}

assert.equal(getNestDoorTarget(5, 5).toLoc, 1);
assert.equal(getNestDoorTarget(1, 1).toLoc, 5);
assert.equal(getNestDoorTarget(5, 3).toLoc, 2);
assert.equal(getNestDoorTarget(2, 1).toLoc, 5);

console.log("Nest render registry smoke test passed");
console.log(`renderable locations: ${Object.keys(NEST_RENDERABLE_LOCATIONS).join(", ")}`);
