import fs from "node:fs";
import path from "node:path";
import assert from "node:assert/strict";
import { NEST_ROOM_1_SOURCE_MAP } from "../src/rooms/NestRoom1SourceMap.js";

const repoRoot = process.cwd();
const source = NEST_ROOM_1_SOURCE_MAP;

assert.equal(source.id, "nestRoom1");
assert.equal(source.family, "nest");
assert.equal(source.stage.width, 614);
assert.equal(source.stage.height, 366);
assert.equal(source.stage.twipsPerPixel, 20);

assert.equal(source.root.className, "nestRoom1_fla.MainTimeline");
assert.equal(source.root.symbolId, 0);
assert.deepEqual(source.root.exposedChildren, ["door1_mc", "roomBG_spr"]);

assert.equal(source.symbols.roomBG_spr.characterId, 5);
assert.equal(source.symbols.roomBG_spr.depth, 1);
assert.equal(source.symbols.roomBG_spr.matrix.translateXPixels, 308.5);
assert.equal(source.symbols.roomBG_spr.matrix.translateYPixels, 205.55);

assert.equal(source.symbols.door1_mc.characterId, 12);
assert.equal(source.symbols.door1_mc.depth, 11);
assert.equal(source.symbols.door1_mc.className, "nestRoom1_fla.door_side_3");
assert.equal(source.symbols.door1_mc.matrix.translateXPixels, 553.95);
assert.equal(source.symbols.door1_mc.matrix.translateYPixels, 230.4);

assert.equal(source.symbols.clickArea_btn.characterId, 11);
assert.equal(source.symbols.clickArea_btn.depth, 9);

const requiredLocalFiles = [
  "reference/rooms/nest-dump/nestRoom1.swf/frames/1.png",
  "reference/rooms/nest-dump/nestRoom1.swf/scripts/nestRoom1_fla/MainTimeline.as",
  "reference/rooms/nest-dump/nestRoom1.swf/symbolClass/symbols.csv",
  "reference/rooms/nest-dump/SWF XML/nestRoom1.xml"
];

for (const relativePath of requiredLocalFiles) {
  const absolutePath = path.join(repoRoot, relativePath);
  assert.ok(fs.existsSync(absolutePath), `Missing local Nest reference file: ${relativePath}`);
}

console.log("nestRoom1 source map smoke test passed");
console.log(
  `${source.id} / ${source.root.className} / bg=${source.symbols.roomBG_spr.characterId}@${source.symbols.roomBG_spr.depth} / door=${source.symbols.door1_mc.characterId}@${source.symbols.door1_mc.depth}`
);
