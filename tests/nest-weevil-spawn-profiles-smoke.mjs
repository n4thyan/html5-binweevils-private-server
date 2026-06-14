import assert from "node:assert/strict";

import {
  DEFAULT_NEST_WEEVIL_SPAWN,
  NEST_WEEVIL_SPAWN_BY_LOCATION,
  getNestWeevilSpawnProfile
} from "../src/rooms/NestWeevilSpawnProfiles.js";

assert.deepEqual(
  getNestWeevilSpawnProfile(5),
  {
    locationId: 5,
    x: 304,
    y: 283,
    method: "hall-clicked-floor-spawn"
  }
);

for (const locationId of [1, 2, 3, 4, 6, 7, 8, 9]) {
  assert.deepEqual(
    getNestWeevilSpawnProfile(locationId),
    {
      locationId,
      x: 300,
      y: 293,
      method: "room2-clicked-floor-spawn-used-as-simple-room-baseline"
    }
  );
}

assert.deepEqual(
  getNestWeevilSpawnProfile(9999),
  {
    locationId: 9999,
    x: DEFAULT_NEST_WEEVIL_SPAWN.x,
    y: DEFAULT_NEST_WEEVIL_SPAWN.y,
    method: DEFAULT_NEST_WEEVIL_SPAWN.method
  }
);

assert.ok(Object.isFrozen(NEST_WEEVIL_SPAWN_BY_LOCATION));

console.log("Nest weevil spawn profiles smoke test passed");
