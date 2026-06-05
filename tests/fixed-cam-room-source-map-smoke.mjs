import assert from 'node:assert/strict';

import {
  FIXED_CAM_LAYER_MODEL,
  FIXED_CAM_OPTIONAL_LOC_ATTRIBUTES,
  FIXED_CAM_PORT_ORDER,
  FIXED_CAM_REQUIRED_LOC_ATTRIBUTES,
  FIXED_CAM_RUNTIME_OBJECTS,
  FIXED_CAM_XML_CHILD_GROUPS,
  LOC_TYPE_IDS,
  isFixedCamLocType,
  summariseFixedCamRoomSourceMap
} from '../src/rooms/FixedCamRoomSourceMap.js';

assert.equal(LOC_TYPE_IDS.STANDARD, 1);
assert.equal(LOC_TYPE_IDS.FIXEDCAM, 2);
assert.equal(LOC_TYPE_IDS.NEST, 3);
assert.equal(isFixedCamLocType(2), true);
assert.equal(isFixedCamLocType('2'), true);
assert.equal(isFixedCamLocType(1), false);

for (const required of [
  'id',
  'name',
  'type',
  'weevilScale',
  'camPos',
  'camAim',
  'entryPos',
  'entryDir',
  'boundType',
  'boundary'
]) {
  assert.ok(FIXED_CAM_REQUIRED_LOC_ATTRIBUTES.includes(required), `missing required loc attribute: ${required}`);
}

for (const optional of ['clickAnywhere', 'slippery', 'roomEvents', 'noZoom']) {
  assert.ok(FIXED_CAM_OPTIONAL_LOC_ATTRIBUTES.includes(optional), `missing optional loc attribute: ${optional}`);
}

assert.deepEqual(FIXED_CAM_XML_CHILD_GROUPS.fixedCamSpecific, ['object', 'target', 'character']);
assert.ok(FIXED_CAM_XML_CHILD_GROUPS.shared.includes('door'));
assert.ok(FIXED_CAM_XML_CHILD_GROUPS.shared.includes('walkMask'));
assert.ok(FIXED_CAM_XML_CHILD_GROUPS.shared.includes('noGoArea'));

assert.deepEqual(FIXED_CAM_LAYER_MODEL.map((layer) => layer.name), ['bgHolder_spr', 'content_spr', 'GUI_spr']);
assert.ok(FIXED_CAM_RUNTIME_OBJECTS.some((entry) => entry.field === 'floorClickArea'));
assert.ok(FIXED_CAM_RUNTIME_OBJECTS.some((entry) => entry.field === 'bg_spr'));
assert.ok(FIXED_CAM_RUNTIME_OBJECTS.some((entry) => entry.field === 'objectList'));
assert.ok(FIXED_CAM_PORT_ORDER.some((step) => step.id === 'resolve-floor-click-area'));
assert.ok(FIXED_CAM_PORT_ORDER.some((step) => step.id === 'place-local-weevil'));

const summary = summariseFixedCamRoomSourceMap();
assert.equal(summary.locType, 2);
assert.equal(summary.layers, 3);
assert.ok(summary.runtimeObjects >= 10);
assert.ok(summary.portSteps >= 10);

console.log('fixed-cam room source map smoke test passed');
console.log(summary.summary);
