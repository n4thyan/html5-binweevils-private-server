import assert from "node:assert/strict";

import {
  NEST_LOCATIONS,
  getNestDoorTarget
} from "../src/rooms/NestNavigationManifest.js";

import {
  RENDERED_NEST_LOCATION_IDS,
  getAllNestDoorVisualTargets,
  getNestDoorVisualTarget,
  getNestLocationDoorVisualTargets
} from "../src/rooms/NestDoorVisualTargets.js";

const targets = getAllNestDoorVisualTargets();

assert.ok(targets.length > 0, "expected at least one door visual target");

for (const locationId of RENDERED_NEST_LOCATION_IDS) {
  const location = NEST_LOCATIONS[locationId];

  assert.ok(location, `missing location ${locationId}`);

  const visualTargets = getNestLocationDoorVisualTargets(locationId);

  assert.equal(
    visualTargets.length,
    location.doors.length,
    `loc ${locationId} should have one visual target per source door`
  );

  for (const door of location.doors) {
    const target = getNestDoorVisualTarget(locationId, door.id);
    const navTarget = getNestDoorTarget(locationId, door.id);

    assert.ok(target, `missing visual target for loc ${locationId} door ${door.id}`);
    assert.ok(navTarget, `missing nav target for loc ${locationId} door ${door.id}`);

    assert.equal(target.locationId, locationId);
    assert.equal(target.doorId, door.id);
    assert.equal(target.targetLocationId, door.toLoc);
    assert.equal(target.targetDoorId, door.toDoor);

    assert.equal(target.source.x, door.x1);
    assert.equal(target.source.z, door.z1);
    assert.equal(target.arrivalSource.x, door.x2);
    assert.equal(target.arrivalSource.z, door.z2);

    assert.equal(Number.isFinite(target.stage.x), true, `stage x should be finite for loc ${locationId} door ${door.id}`);
    assert.equal(Number.isFinite(target.stage.y), true, `stage y should be finite for loc ${locationId} door ${door.id}`);

    assert.ok(
      target.stage.x > -80 && target.stage.x < 700,
      `stage x looks out of range for loc ${locationId} door ${door.id}: ${target.stage.x}`
    );

    assert.ok(
      target.stage.y > -80 && target.stage.y < 460,
      `stage y looks out of range for loc ${locationId} door ${door.id}: ${target.stage.y}`
    );

    assert.ok(
      target.stage.method,
      `target method should be labelled for loc ${locationId} door ${door.id}`
    );
  }
}

const hallDoor1 = getNestDoorVisualTarget(5, 1);
assert.equal(hallDoor1.stage.method, "hall-visual-hitbox-foot-target");
assert.deepEqual(
  { x: hallDoor1.source.x, z: hallDoor1.source.z },
  { x: -160, z: 190 }
);

console.log("Nest door visual targets smoke test passed");
console.log("targets:", targets.length);
