import assert from "node:assert/strict";
import {
  NEST_ROOM_6_RENDER_BASICS_LAYER_PLAN,
  getNestRoom6RenderBasicsLayerSummary
} from "../src/rooms/NestRoom6RenderBasicsLayerPlan.js";

assert.equal(NEST_ROOM_6_RENDER_BASICS_LAYER_PLAN.length, 3);

const roomBG_spr = NEST_ROOM_6_RENDER_BASICS_LAYER_PLAN.find((layer) => layer.key === "roomBG_spr");
assert.ok(roomBG_spr, "roomBG_spr layer is missing");
assert.equal(roomBG_spr.characterId, 5);
assert.equal(roomBG_spr.depth, 1);
assert.equal(roomBG_spr.registration.x, -304.5);
assert.equal(roomBG_spr.registration.y, -205.55);

const door1_mc = NEST_ROOM_6_RENDER_BASICS_LAYER_PLAN.find((layer) => layer.key === "door1_mc");
assert.ok(door1_mc, "door1_mc layer is missing");
assert.equal(door1_mc.characterId, 12);
assert.equal(door1_mc.depth, 10);
assert.equal(door1_mc.registration.x, -41.15);
assert.equal(door1_mc.registration.y, -59.75);

const door2_mc = NEST_ROOM_6_RENDER_BASICS_LAYER_PLAN.find((layer) => layer.key === "door2_mc");
assert.ok(door2_mc, "door2_mc layer is missing");
assert.equal(door2_mc.characterId, 17);
assert.equal(door2_mc.depth, 20);
assert.equal(door2_mc.registration.x, -0.8);
assert.equal(door2_mc.registration.y, -2.9);

const summary = getNestRoom6RenderBasicsLayerSummary();
assert.equal(summary.layerCount, 3);
assert.equal(summary.baseLayer, "roomBG_spr");

console.log("nestRoom6 render layer plan smoke test passed");
console.log(
  NEST_ROOM_6_RENDER_BASICS_LAYER_PLAN
    .map((layer) => `${layer.key}: ${layer.registration.x}, ${layer.registration.y}`)
    .join("\n")
);
