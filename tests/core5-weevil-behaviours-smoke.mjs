import {
  CORE5_BASIC_ACTION_IDS,
  CORE5_SPECIAL_MOVE_IDS,
  CORE5_WEEVIL_BEHAVIOURS,
  getCore5BehaviourName,
  isCore5SpecialMove
} from "../src/movement/Core5WeevilBehaviours.js";

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

assert(CORE5_WEEVIL_BEHAVIOURS.WALK === 0, "WALK should match ActionScript id 0");
assert(CORE5_WEEVIL_BEHAVIOURS.JUMP === 1, "JUMP should match ActionScript id 1");
assert(CORE5_WEEVIL_BEHAVIOURS.WAVE1 === 2, "WAVE1 should match ActionScript id 2");
assert(CORE5_WEEVIL_BEHAVIOURS.WAVE2 === 3, "WAVE2 should match ActionScript id 3");
assert(CORE5_WEEVIL_BEHAVIOURS.SHAKE_HEAD === 4, "SHAKE_HEAD should match ActionScript id 4");
assert(CORE5_WEEVIL_BEHAVIOURS.NOD === 5, "NOD should match ActionScript id 5");
assert(CORE5_WEEVIL_BEHAVIOURS.SQUAT === 6, "SQUAT should match ActionScript id 6");
assert(CORE5_WEEVIL_BEHAVIOURS.STAND_TALL === 7, "STAND_TALL should match ActionScript id 7");
assert(CORE5_WEEVIL_BEHAVIOURS.SUPER_SPEED === 33, "SUPER_SPEED should match ActionScript id 33");
assert(CORE5_WEEVIL_BEHAVIOURS.LEVEL_UP === 34, "LEVEL_UP should match ActionScript id 34");
assert(CORE5_WEEVIL_BEHAVIOURS.BECOME_PENGUIN === 66, "BECOME_PENGUIN should match ActionScript id 66");

assert(CORE5_BASIC_ACTION_IDS.WALK === 0, "basic WALK id should be 0");
assert(CORE5_BASIC_ACTION_IDS.JUMP === 1, "basic JUMP id should be 1");
assert(CORE5_BASIC_ACTION_IDS.WAVE1 === 2, "basic WAVE1 id should be 2");
assert(CORE5_BASIC_ACTION_IDS.WAVE2 === 3, "basic WAVE2 id should be 3");
assert(CORE5_BASIC_ACTION_IDS.SHAKE_HEAD === 4, "basic SHAKE_HEAD id should be 4");
assert(CORE5_BASIC_ACTION_IDS.NOD === 5, "basic NOD id should be 5");
assert(CORE5_BASIC_ACTION_IDS.SQUAT === 6, "basic SQUAT id should be 6");
assert(CORE5_BASIC_ACTION_IDS.STAND_TALL === 7, "basic STAND_TALL id should be 7");

assert(getCore5BehaviourName(0) === "WALK", "name lookup for 0 should be WALK");
assert(getCore5BehaviourName(34) === "LEVEL_UP", "name lookup for 34 should be LEVEL_UP");
assert(getCore5BehaviourName(999) === null, "unknown behaviour id should return null");

assert(isCore5SpecialMove(23), "TELEPORT should be a special move");
assert(isCore5SpecialMove(40), "BECOME_GHOST should be a special move");
assert(isCore5SpecialMove(66), "BECOME_PENGUIN should be a special move");
assert(!isCore5SpecialMove(0), "WALK should not be a special move");
assert(CORE5_SPECIAL_MOVE_IDS.length === 25, "special moves list should match ActionScript length");

console.log("Core5 weevil behaviours smoke test passed");
console.log("basic actions:", Object.entries(CORE5_BASIC_ACTION_IDS).map(([name, id]) => `${name}=${id}`).join(", "));
