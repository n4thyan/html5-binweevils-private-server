import { Core5MovementModel } from "../src/movement/Core5MovementModel.js";

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

const model = new Core5MovementModel({
  x: 0,
  y: 0,
  z: 0,
  rotY: 0,
  weevilScale: 0.5
});

const move = model.moveMyWeevil(120, 0);

assert(move.speed === 4, "speed should be 8 * weevilScale");
assert(model.getLegPoses().join(",") === "4,4,4,4,4,4", "legs should start from neutral pose 4");

const startSnapshot = model.getSnapshot();

assert(startSnapshot.walker, "snapshot should expose active walker");
assert(startSnapshot.walker.legPoses.length === 6, "walker should expose six leg poses");
assert(startSnapshot.walker.behaviourId === 0, "walker behaviour id should be WALK");
assert(startSnapshot.weevil.walking, "weevil should be walking after moveMyWeevil");

model.update(1);

const movingSnapshot = model.getSnapshot();

assert(movingSnapshot.walker, "moving snapshot should still expose walker");
assert(movingSnapshot.walker.legPoses.length === 6, "moving walker should expose six leg poses");
assert(Number.isFinite(movingSnapshot.weevil.rotY), "moving snapshot should expose numeric rotY");

assert(
  movingSnapshot.walker.legPoses.join(",") !== "4,4,4,4,4,4",
  "leg poses should change after one movement frame"
);

let guard = 0;

while (model.weevil.walking && guard < 240) {
  model.update(1);
  guard += 1;
}

const finalSnapshot = model.getSnapshot();

assert(guard < 240, "walk should complete before guard limit");
assert(!finalSnapshot.weevil.walking, "weevil should stop walking after arrival");
assert(finalSnapshot.legPoses.join(",") === "4,4,4,4,4,4", "legs should return to neutral pose 4 after halt");

console.log("Core5 walk snapshot smoke test passed");
console.log("final:", JSON.stringify({
  x: finalSnapshot.weevil.x,
  z: finalSnapshot.weevil.z,
  rotY: finalSnapshot.weevil.rotY,
  legPoses: finalSnapshot.legPoses
}));
