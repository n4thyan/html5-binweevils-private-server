import assert from "node:assert/strict";
import {
  NEST_ROOM_2_RENDER_BASICS_LAYER_PLAN,
  getNestRoom2RenderBasicsLayerSummary
} from "../src/rooms/NestRoom2RenderBasicsLayerPlan.js";

assert.equal(NEST_ROOM_2_RENDER_BASICS_LAYER_PLAN.length, 2);

const roomBg = NEST_ROOM_2_RENDER_BASICS_LAYER_PLAN.find((layer) => layer.key === "roomBG_spr");
const door = NEST_ROOM_2_RENDER_BASICS_LAYER_PLAN.find((layer) => layer.key === "door1_mc");

assert.ok(roomBg, "roomBG_spr layer is missing");
assert.ok(door, "door1_mc layer is missing");

assert.equal(roomBg.characterId, 5);
assert.equal(roomBg.depth, 1);
assert.equal(roomBg.registration.x, -308.5);
assert.equal(roomBg.registration.y, -205.55);

assert.equal(door.characterId, 10);
assert.equal(door.depth, 11);
assert.equal(door.registration.x, -9.95);
assert.equal(door.registration.y, -1.85);

const summary = getNestRoom2RenderBasicsLayerSummary();
assert.equal(summary.layerCount, 2);
assert.equal(summary.baseLayer, "roomBG_spr");
assert.equal(summary.doorLayer, "door1_mc");

console.log("nestRoom2 render layer plan smoke test passed");
console.log(`door registration: ${door.registration.x}, ${door.registration.y}`);
