import assert from "node:assert/strict";

import {
  DEFAULT_NEST_WEEVIL_SCALE,
  NEST_WEEVIL_SCALE_BY_LOCATION,
  getNestWeevilScale,
  getNestWeevilScaleDisplaySize
} from "../src/rooms/NestWeevilScaleProfiles.js";

assert.equal(DEFAULT_NEST_WEEVIL_SCALE, 0.5);

for (const locationId of [1, 2, 3, 4, 6, 7, 8, 9]) {
  assert.equal(getNestWeevilScale(locationId), 0.5, `simple Nest room ${locationId} should use source weevilScale 0.5`);
}

assert.equal(getNestWeevilScale(5), 0.45, "Nest Hall should use source weevilScale 0.45");
assert.equal(getNestWeevilScale(10), 0.45, "Home Cinema should use source weevilScale 0.45");
assert.equal(getNestWeevilScale(20), 0.16, "Garden should use source weevilScale 0.16");

assert.equal(getNestWeevilScale(9999), DEFAULT_NEST_WEEVIL_SCALE);

assert.deepEqual(
  getNestWeevilScaleDisplaySize(1, { baseWidth: 132, baseHeight: 132 }),
  {
    locationId: 1,
    sourceScale: 0.5,
    referenceScale: 0.5,
    visualRatio: 1,
    width: 132,
    height: 132
  }
);

assert.deepEqual(
  getNestWeevilScaleDisplaySize(5, { baseWidth: 132, baseHeight: 132 }),
  {
    locationId: 5,
    sourceScale: 0.45,
    referenceScale: 0.5,
    visualRatio: 0.9,
    width: 119,
    height: 119
  }
);

assert.ok(Object.isFrozen(NEST_WEEVIL_SCALE_BY_LOCATION));

console.log("Nest weevil scale profiles smoke test passed");
