// Source-backed Nest room manifest.
//
// The Nest rooms are the next focused movement/rendering target after the Rums
// Cove checkpoint. They are deliberately simpler than the airport/Rums Cove
// exterior and give us a safer way to connect room rendering, x/y/z/r movement,
// entry positions and room-to-room navigation.
//
// The binary/vector exports are not committed by this manifest. They should be
// extracted locally from the uploaded/decompiled nest dump into:
// reference/rooms/nest-dump/

export const NEST_DUMP_EXPECTED_ROOT = 'reference/rooms/nest-dump';
export const NEST_DUMP_UPLOAD_NAME = 'nest dump.zip';

export const NEST_ROOM_SOURCE_SET = Object.freeze({
  uploadName: NEST_DUMP_UPLOAD_NAME,
  expectedRoot: NEST_DUMP_EXPECTED_ROOT,
  sourceKind: 'JPEXS/FFDec decompiled SWF exports plus XML',
  status: 'uploaded-and-audited; local extraction required before browser probes can load art',
  note: 'Nest Hall is included in the dump but intentionally deferred because it is larger and more complex.'
});

export const NEST_ROOM_ORDER = Object.freeze([
  'nestRoom1',
  'nestRoom2',
  'nestRoom3',
  'nestRoom4',
  'nestRoom6',
  'nestRoom7',
  'nestRoom8',
  'nestRoom9'
]);

export const NEST_ROOM_MANIFEST = Object.freeze([
  Object.freeze({ key: 'nestRoom1', swfFolder: 'nestRoom1.swf', xml: 'SWF XML/nestRoom1.xml', frame: 'nestRoom1.swf/frames/1.png', size: Object.freeze([614, 366]), symbols: Object.freeze(['nestRoom1_fla.door_side_3']), firstPass: true, note: 'recommended first Nest test room: small export, one side-door class, simple 614x366 frame' }),
  Object.freeze({ key: 'nestRoom2', swfFolder: 'nestRoom2.swf', xml: 'SWF XML/nestRoom2.xml', frame: 'nestRoom2.swf/frames/1.png', size: Object.freeze([614, 366]), symbols: Object.freeze(['nestRoom2_fla.door_front_3']), firstPass: true, note: 'good second room: one front-door class, simple 614x366 frame' }),
  Object.freeze({ key: 'nestRoom3', swfFolder: 'nestRoom3.swf', xml: 'SWF XML/nestRoom3.xml', frame: 'nestRoom3.swf/frames/1.png', size: Object.freeze([614, 366]), symbols: Object.freeze(['nestRoom3_fla.door_side_3']), firstPass: false, note: 'similar shape to nestRoom1; useful for confirming repeatable side-door handling' }),
  Object.freeze({ key: 'nestRoom4', swfFolder: 'nestRoom4.swf', xml: 'SWF XML/nestRoom4.xml', frame: 'nestRoom4.swf/frames/1.png', size: Object.freeze([614, 366]), symbols: Object.freeze(['nestRoom4_fla.door_side_3', 'nestRoom4_fla.door_front_6']), firstPass: false, note: 'two door classes; useful after one-door rooms work' }),
  Object.freeze({ key: 'nestRoom6', swfFolder: 'nestRoom6.swf', xml: 'SWF XML/nestRoom6.xml', frame: 'nestRoom6.swf/frames/1.png', size: Object.freeze([614, 366]), symbols: Object.freeze(['nestRoom6_fla.door_side_3', 'nestRoom6_fla.door_front_6']), firstPass: false, note: 'two door classes; similar complexity to nestRoom4' }),
  Object.freeze({ key: 'nestRoom7', swfFolder: 'nestRoom7.swf', xml: 'SWF XML/nestRoom7.xml', frame: 'nestRoom7.swf/frames/1.png', size: Object.freeze([614, 366]), symbols: Object.freeze(['nestRoom7_fla.door_side_3', 'nestRoom7_fla.door_back_6']), firstPass: false, note: 'side + back door classes; defer until simple two-room traversal works' }),
  Object.freeze({ key: 'nestRoom8', swfFolder: 'nestRoom8.swf', xml: 'SWF XML/nestRoom8.xml', frame: 'nestRoom8.swf/frames/1.png', size: Object.freeze([614, 366]), symbols: Object.freeze(['nestRoom8_fla.door_back_3']), firstPass: false, note: 'back-door class; good for validating direction/facing once movement exists' }),
  Object.freeze({ key: 'nestRoom9', swfFolder: 'nestRoom9.swf', xml: 'SWF XML/nestRoom9.xml', frame: 'nestRoom9.swf/frames/1.png', size: Object.freeze([614, 366]), symbols: Object.freeze(['nestRoom9_fla.door_side_3', 'nestRoom9_fla.door_back_6']), firstPass: false, note: 'side + back door classes; later traversal candidate' })
]);

export const NEST_HALL_DEFERRED = Object.freeze({
  key: 'nestHall_03_06_11',
  swfFolder: 'nestHall_03_06_11.swf',
  xml: 'SWF XML/nestHall_03_06_11.xml',
  frame: 'nestHall_03_06_11.swf/frames/1.png',
  size: Object.freeze([825, 490]),
  reason: 'larger export, many morphshapes/buttons/scripts, and different frame size; keep for later after normal rooms render/move correctly'
});

export function getNestRoomByKey(key) {
  return NEST_ROOM_MANIFEST.find((room) => room.key === String(key)) ?? null;
}

export function getFirstNestRoomCandidates() {
  return NEST_ROOM_MANIFEST.filter((room) => room.firstPass);
}

export function summariseNestRoomsManifest() {
  return Object.freeze({
    uploadName: NEST_DUMP_UPLOAD_NAME,
    expectedRoot: NEST_DUMP_EXPECTED_ROOT,
    roomCount: NEST_ROOM_MANIFEST.length,
    firstPassRooms: getFirstNestRoomCandidates().map((room) => room.key),
    deferred: NEST_HALL_DEFERRED.key,
    summary: 'Use nestRoom1 -> nestRoom2 as the first small source-backed render/movement/navigation path.'
  });
}
