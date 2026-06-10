import assert from "node:assert/strict";
import {
  NEST_HALL_RENDER_BASICS_LAYER_PLAN,
  getNestHallRenderBasicsLayerSummary
} from "../src/rooms/NestHallRenderBasicsLayerPlan.js";

assert.equal(NEST_HALL_RENDER_BASICS_LAYER_PLAN.length, 20);

const requiredLayers = [
  "roomBG_spr",
  "door1_mc",
  "door2_mc",
  "door3_mc",
  "door5_mc",
  "door6_mc",
  "door9_mc",
  "powerGen_mc",
  "portal_mc",
  "portalFront_mc",
  "newsRoll_mc",
  "swsAnim_mc",
  "door4_mc",
  "door7_mc",
  "door8_mc",
  "door10_mc",
  "msgBox",
  "levelupSignAnim_mc"
];

for (const key of requiredLayers) {
  const layer = NEST_HALL_RENDER_BASICS_LAYER_PLAN.find((candidate) => candidate.key === key);
  assert.ok(layer, `${key} layer is missing`);
  assert.equal(typeof layer.characterId, "number");
  assert.equal(typeof layer.depth, "number");
  assert.equal(typeof layer.registration.x, "number");
  assert.equal(typeof layer.registration.y, "number");
}

const summary = getNestHallRenderBasicsLayerSummary();
assert.equal(summary.layerCount, 20);
assert.equal(summary.baseLayer, "roomBG_spr");
assert.ok(summary.objectLayers.length >= 19);

console.log("Nest Hall render layer plan smoke test passed");
console.log(`layers: ${summary.layerCount}`);
