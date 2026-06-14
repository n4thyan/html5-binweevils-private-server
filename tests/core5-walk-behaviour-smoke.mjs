import assert from "node:assert/strict";

import {
  core5GetDir,
  core5WeevilSpeed,
  createCore5WalkBehaviour
} from "../src/movement/Core5WalkBehaviour.js";

import {
  Core5MovementModel
} from "../src/movement/Core5MovementModel.js";

function makeLeg() {
  return {
    pose: 4,
    setPose(value) {
      this.pose = value;
    }
  };
}

assert.equal(core5WeevilSpeed(1), 8);
assert.equal(core5WeevilSpeed(0.75), 6);
assert.equal(core5GetDir({ x: 0, z: 0, rotY: 17.9 }, 0, 0), 17);
assert.equal(core5GetDir({ x: 0, z: 0, rotY: 0 }, 24, 0), -90);

{
  const weevil = {
    x: 0,
    y: 0,
    z: 0,
    rotY: -90,
    mine: false,
    pose: 0,
    walking: false,
    crntLoc: {
      maintainY: false,
      isForbidden() {
        return false;
      },
      teleportCheck() {
        return false;
      }
    },
    stopActionByID() {},
    maskIfNeeded() {}
  };

  const creature = { y: 0, rotY: 0 };
  const head = { rotY: 0 };
  const legs = Array.from({ length: 6 }, makeLeg);
  let arrivals = 0;

  const walk = createCore5WalkBehaviour({
    weevil,
    creature,
    head,
    legs,
    onArrived() {
      arrivals += 1;
    }
  });

  walk.init([24, 0, -90, 8, false, false]);

  assert.equal(walk.xIncr, 8);
  assert.equal(walk.zIncr, 0);
  assert.equal(walk.xCheck, true);
  assert.equal(walk.pos, true);

  walk.setPose();
  assert.equal(weevil.x, 8);
  assert.equal(arrivals, 0);

  walk.setPose();
  assert.equal(weevil.x, 16);
  assert.equal(arrivals, 0);

  walk.setPose();
  assert.equal(weevil.x, 24);
  assert.equal(arrivals, 0);

  walk.setPose();
  assert.equal(weevil.x, 24);
  assert.equal(arrivals, 1);
  assert.equal(weevil.walking, false);
  assert.equal(creature.rotY, 0);

  for (const leg of legs) {
    assert.equal(leg.pose, 4);
  }
}

{
  const weevil = {
    x: 0,
    y: 0,
    z: 0,
    rotY: -90,
    mine: false,
    pose: 0,
    walking: false,
    crntLoc: {
      maintainY: false,
      isForbidden() {
        return false;
      },
      teleportCheck() {
        return false;
      }
    },
    stopActionByID() {},
    maskIfNeeded() {}
  };

  let arrivals = 0;

  const walk = createCore5WalkBehaviour({
    weevil,
    creature: { y: 0, rotY: 0 },
    head: { rotY: 0 },
    legs: Array.from({ length: 6 }, makeLeg),
    onArrived() {
      arrivals += 1;
    }
  });

  walk.init([25.9, 0, -90, 10, false, false]);

  while (!walk.arrived) {
    walk.setPose();
  }

  walk.setPose();

  assert.equal(weevil.x, 25);
  assert.equal(weevil.z, 0);
  assert.equal(arrivals, 1);
}

{
  const model = new Core5MovementModel({
    x: 0,
    z: 0,
    rotY: -90,
    weevilScale: 1,
    mine: false
  });

  model.queueMove(16, 0);
  const firstMove = model.moveMyWeevil(8, 0, { direction: -90 });

  assert.deepEqual(firstMove, {
    x: 8,
    z: 0,
    r: -90,
    speed: 8
  });

  model.update();
  assert.equal(model.weevil.x, 8);
  assert.equal(model.events.length, 0);

  model.update();
  assert.equal(model.events.at(-1).type, "WEEVIL_ARRIVED");
  assert.equal(model.weevil.walking, true);

  model.update();
  model.update();

  const arrivedEvents = model.events.filter((event) => event.type === "WEEVIL_ARRIVED");
  assert.equal(arrivedEvents.length, 2);
  assert.equal(model.weevil.x, 16);
}

{
  const model = new Core5MovementModel({
    x: 0,
    z: 0,
    rotY: -90,
    weevilScale: 1,
    mine: false
  });

  const door = { id: 5, x1: 8, z1: 0, x2: 20, z2: 10, toLoc: 1, toDoor: 1 };

  model.moveMyWeevil(door.x1, door.z1, {
    direction: -90,
    exitDoor: door
  });

  model.update();
  model.update();

  assert.equal(model.events[0].type, "exitDoor");
  assert.equal(model.events[0].doorID, 5);
  assert.equal(model.events[1].type, "WEEVIL_ARRIVED");
}

console.log("Core5 walk behaviour smoke test passed");
