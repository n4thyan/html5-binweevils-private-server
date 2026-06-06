import assert from 'node:assert/strict';

import {
  RUMS_COVE_ANIMS,
  RUMS_COVE_DEFERRED_FEATURES,
  RUMS_COVE_DOORS,
  RUMS_COVE_INTERACTIVES,
  RUMS_COVE_LOC,
  RUMS_COVE_OBJECTS,
  RUMS_COVE_SYMBOLS,
  getRumsCoveDoorById,
  getRumsCoveObjectByName,
  summariseRumsCoveManifest
} from '../src/rooms/RumsCoveManifest.js';

assert.equal(RUMS_COVE_LOC.id, 129);
assert.equal(RUMS_COVE_LOC.name, 'RumsCove');
assert.equal(RUMS_COVE_LOC.type, 2);
assert.equal(RUMS_COVE_LOC.kind, 'FixedCam');
assert.equal(RUMS_COVE_LOC.boundType, 'rect');
assert.deepEqual(RUMS_COVE_LOC.boundary, [-240, 60, 680, 90]);
assert.deepEqual(RUMS_COVE_LOC.camPos, [0, 190, -330]);
assert.deepEqual(RUMS_COVE_LOC.camAim, [0, 90, 260]);
assert.deepEqual(RUMS_COVE_LOC.entryPos, [0, 80]);
assert.equal(RUMS_COVE_LOC.entryDir, 180);
assert.equal(RUMS_COVE_LOC.weevilScale, 0.18);
assert.equal(RUMS_COVE_LOC.roomBG, 'fixedCam/RumsAirport_180321.swf');
assert.equal(RUMS_COVE_LOC.uploadedExport, 'RumsAirport_dynamAds_videoPodv2_release');

assert.equal(RUMS_COVE_DOORS.length, 5);
assert.deepEqual(getRumsCoveDoorById(1), { id: 1, toLoc: 107, toDoor: 1, x1: -190, z1: 125, x2: -260, z2: 125, entryDir: 180 });
assert.deepEqual(getRumsCoveDoorById(5), { id: 5, toLoc: 104, toDoor: 4, x1: 100, z1: 130, x2: 326, z2: 132, y2: 1500, entryDir: 0 });
assert.equal(getRumsCoveDoorById(99), null);

assert.equal(RUMS_COVE_OBJECTS.length, 8);
assert.deepEqual(getRumsCoveObjectByName('buildings'), { name: 'buildings', x: -150, y: 0, z: 198 });
assert.deepEqual(getRumsCoveObjectByName('bobbleOverlay_mc'), { name: 'bobbleOverlay_mc', x: 0, y: 0, z: 335 });
assert.equal(getRumsCoveObjectByName('missing'), null);

assert.equal(RUMS_COVE_INTERACTIVES.length, 2);
assert.ok(RUMS_COVE_INTERACTIVES.some((interactive) => interactive.path === 'buildings.airport.slidingDoors_mc'));
assert.ok(RUMS_COVE_INTERACTIVES.some((interactive) => interactive.path === 'buildings.diner.slidingDoors_mc'));
assert.deepEqual(RUMS_COVE_ANIMS, ['plane1', 'plane2']);
assert.ok(RUMS_COVE_SYMBOLS.some((symbol) => symbol.className === 'RumsAirport_dynamAds'));
assert.ok(RUMS_COVE_SYMBOLS.some((symbol) => symbol.className === 'RumsAirport_dynamAds_videoPodv2_fla.buildings_12'));
assert.ok(RUMS_COVE_DEFERRED_FEATURES.includes('dynamic ads'));
assert.ok(RUMS_COVE_DEFERRED_FEATURES.includes('unproven videoPod1 navigation'));

const summary = summariseRumsCoveManifest();
assert.equal(summary.doors, 5);
assert.equal(summary.objects, 8);
assert.equal(summary.interactives, 2);
assert.equal(summary.anims, 2);
assert.ok(summary.summary.includes('RumsCove loc 129'));

console.log('rums-cove manifest smoke test passed');
console.log(summary.summary);
