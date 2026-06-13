import {
  DEFAULT_VIEWPORT,
  createCore5Camera,
  getFloorClickCoords,
  getNestProjectionConfig,
  isWithinCore5Viewport,
  legaliseNestCore5Point,
  projectCore5PointToScreen
} from "../src/movement/Core5FloorProjection.js";

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function assertNear(actual, expected, tolerance, message) {
  if (Math.abs(actual - expected) > tolerance) {
    throw new Error(`${message}. Expected ${expected}, got ${actual}`);
  }
}

const normalRoom = getNestProjectionConfig(1);
const normalCamera = createCore5Camera(normalRoom.camera);

assert(normalRoom.boundType === "rect", "normal nest room should use rect bounds");
assert(normalRoom.weevilScale === 0.5, "normal nest room scale should be 0.5");

const stageCentre = {
  x: DEFAULT_VIEWPORT.xOffset + DEFAULT_VIEWPORT.x0,
  y: DEFAULT_VIEWPORT.yOffset + DEFAULT_VIEWPORT.y0
};

assert(isWithinCore5Viewport(stageCentre.x, stageCentre.y), "stage centre should be inside Core5 viewport");

const normalFloor = getFloorClickCoords(stageCentre.x, stageCentre.y, {
  projectionConfig: normalRoom,
  camera: normalCamera
});

assert(normalFloor, "normal room centre click should project to floor");
assert(Number.isFinite(normalFloor.x), "normal projected x should be finite");
assert(Number.isFinite(normalFloor.z), "normal projected z should be finite");

const normalScreen = projectCore5PointToScreen(normalFloor.x, 0, normalFloor.z, {
  projectionConfig: normalRoom,
  camera: normalCamera
});

assertNear(normalScreen.x, stageCentre.x, 2, "normal room reverse projected x should match");
assertNear(normalScreen.y, stageCentre.y, 2, "normal room reverse projected y should match");

const legalNormal = legaliseNestCore5Point(175, 375, {
  projectionConfig: normalRoom,
  weevilScale: 0.5
});

assert(legalNormal, "near rect edge should legalise");
assert(legalNormal.x === 170, "rect x should clamp to right edge");
assert(legalNormal.z === 370, "rect z should clamp to bottom edge");

const illegalNormal = legaliseNestCore5Point(999, 999, {
  projectionConfig: normalRoom,
  weevilScale: 0.5
});

assert(illegalNormal === null, "far outside rect should be rejected");

const hall = getNestProjectionConfig(5);
const hallCamera = createCore5Camera(hall.camera);

assert(hall.boundType === "rad", "hall should use radial bounds");
assert(hall.weevilScale === 0.45, "hall scale should be 0.45");

const hallFloor = getFloorClickCoords(stageCentre.x, stageCentre.y, {
  projectionConfig: hall,
  camera: hallCamera
});

assert(hallFloor, "hall centre click should project to floor");

const legalHall = legaliseNestCore5Point(0, 500, {
  projectionConfig: hall
});

assert(legalHall, "hall radial point should legalise");
assertNear(legalHall.x, 0, 1, "hall radial clamp x should stay near centre x");
assertNear(legalHall.z, 353, 1, "hall radial clamp z should clamp to centre plus radius");

const outsideViewport = getFloorClickCoords(10, 10, {
  projectionConfig: hall,
  camera: hallCamera
});

assert(outsideViewport === null, "outside viewport click should return null");

console.log("Core5 floor projection smoke test passed");
console.log("normal centre floor:", JSON.stringify(normalFloor));
console.log("hall centre floor:", JSON.stringify(hallFloor));
