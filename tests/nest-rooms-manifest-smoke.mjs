import assert from 'node:assert/strict';

import {
  NEST_DUMP_EXPECTED_ROOT,
  NEST_HALL_DEFERRED,
  NEST_ROOM_MANIFEST,
  getFirstNestRoomCandidates,
  getNestRoomByKey,
  summariseNestRoomsManifest
} from '../src/rooms/NestRoomsManifest.js';

assert.equal(NEST_DUMP_EXPECTED_ROOT, 'reference/rooms/nest-dump');
assert.equal(NEST_ROOM_MANIFEST.length, 8);
assert.deepEqual(getFirstNestRoomCandidates().map((room) => room.key), ['nestRoom1', 'nestRoom2']);

for (const room of NEST_ROOM_MANIFEST) {
  assert.equal(room.size[0], 614, `${room.key} width`);
  assert.equal(room.size[1], 366, `${room.key} height`);
  assert.ok(room.frame.endsWith('/frames/1.png'), `${room.key} frame path`);
  assert.ok(room.xml.startsWith('SWF XML/'), `${room.key} xml path`);
}

assert.equal(getNestRoomByKey('nestRoom1').symbols[0], 'nestRoom1_fla.door_side_3');
assert.equal(getNestRoomByKey('nestRoom2').symbols[0], 'nestRoom2_fla.door_front_3');
assert.equal(NEST_HALL_DEFERRED.size[0], 825);
assert.equal(NEST_HALL_DEFERRED.size[1], 490);

const summary = summariseNestRoomsManifest();
assert.equal(summary.roomCount, 8);
assert.equal(summary.deferred, 'nestHall_03_06_11');

console.log('nest rooms manifest smoke test passed');
console.log(`${summary.roomCount} rooms / first pass ${summary.firstPassRooms.join(' -> ')} / deferred ${summary.deferred}`);
