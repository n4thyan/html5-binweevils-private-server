import assert from "node:assert/strict";
import {
  NEST_ROOM_1_RENDER_BASICS_LAYER_PLAN,
  getNestRoom1RenderBasicsLayerSummary
} from "../src/rooms/NestRoom1RenderBasicsLayerPlan.js";

assert.equal(NEST_ROOM_1_RENDER_BASICS_LAYER_PLAN.length, 3);

const roomBg = NEST_ROOM_1_RENDER_BASICS_LAYER_PLAN.find((layer) => layer.key === "roomBG_spr");
const door = NEST_ROOM_1_RENDER_BASICS_LAYER_PLAN.find((layer) => layer.key === "door1_mc");
const clickArea = NEST_ROOM_1_RENDER_BASICS_LAYER_PLAN.find((layer) => layer.key === "clickArea_btn");

assert.ok(roomBg, "roomBG_spr layer is missing");
assert.ok(door, "door1_mc layer is missing");
assert.ok(clickArea, "clickArea_btn layer is missing");

assert.equal(roomBg.characterId, 5);
assert.equal(roomBg.depth, 1);
assert.equal(roomBg.registration.x, -308.5);
assert.equal(roomBg.registration.y, -205.55);

assert.equal(door.characterId, 12);
assert.equal(door.depth, 11);
assert.equal(door.registration.x, -41.15);
assert.equal(door.registration.y, -59.75);

assert.equal(clickArea.characterId, 11);
assert.equal(clickArea.depth, 9);

const summary = getNestRoom1RenderBasicsLayerSummary();
assert.equal(summary.layerCount, 3);
assert.equal(summary.baseLayer, "roomBG_spr");
assert.equal(summary.debugCollisionLayer, "clickArea_btn");

console.log("nestRoom1 render layer plan smoke test passed");
console.log(`door registration: ${door.registration.x}, ${door.registration.y}`);
