// Source-backed Nest room manifest.
//
// Built from the uploaded `nest dump.zip` inspection and intended as the next
// simpler FixedCamera room family after the Rums Cove/Rums Airport research.
// Nest Hall is recorded but deferred because its export is much larger and more
// complex than the simple nest rooms.

export const NEST_DUMP_SOURCE = Object.freeze({
  uploadedArchive: 'nest dump.zip',
  extractedRoot: 'reference/rooms/nest-dump',
  xmlRoot: 'reference/rooms/nest-dump/SWF XML',
  status: 'uploaded/examined-in-session; copy into reference/rooms/nest-dump before browser probes rely on asset paths'
});

export const NEST_ROOM_VIEWPORT = Object.freeze({
  width: 614,
  height: 366,
  swfBoundsTwips: Object.freeze([12280, 7320])
});

export const NEST_SIMPLE_ROOMS = Object.freeze([
  Object.freeze({
    key: 'nestRoom1',
    swfFolder: 'nestRoom1.swf',
    xmlFile: 'nestRoom1.xml',
    frame: 'frames/1.png',
    frameBytes: 134175,
    fileCount: 22,
    shapeCount: 7,
    spriteCount: 4,
    buttonCount: 1,
    scriptCount: 2,
    mainTimelineVars: Object.freeze(['door1_mc', 'roomBG_spr']),
    doorSprites: Object.freeze(['door_side_3']),
    firstPassCandidate: true,
    note: 'small side-door nest room; ideal first render/navigation test'
  }),
  Object.freeze({
    key: 'nestRoom2',
    swfFolder: 'nestRoom2.swf',
    xmlFile: 'nestRoom2.xml',
    frame: 'frames/1.png',
    frameBytes: 133452,
    fileCount: 20,
    shapeCount: 6,
    spriteCount: 3,
    buttonCount: 1,
    scriptCount: 2,
    mainTimelineVars: Object.freeze(['door1_mc', 'roomBG_spr']),
    doorSprites: Object.freeze(['door_front_3']),
    firstPassCandidate: true,
    note: 'small front-door nest room; useful second room for navigation loop'
  }),
  Object.freeze({
    key: 'nestRoom3',
    swfFolder: 'nestRoom3.swf',
    xmlFile: 'nestRoom3.xml',
    frame: 'frames/1.png',
    frameBytes: 134135,
    fileCount: 22,
    shapeCount: 7,
    spriteCount: 4,
    buttonCount: 1,
    scriptCount: 2,
    mainTimelineVars: Object.freeze(['door1_mc', 'roomBG_spr']),
    doorSprites: Object.freeze(['door_side_3']),
    firstPassCandidate: true,
    note: 'small side-door nest room variant'
  }),
  Object.freeze({
    key: 'nestRoom4',
    swfFolder: 'nestRoom4.swf',
    xmlFile: 'nestRoom4.xml',
    frame: 'frames/1.png',
    frameBytes: 135260,
    fileCount: 28,
    shapeCount: 10,
    spriteCount: 5,
    buttonCount: 2,
    scriptCount: 3,
    mainTimelineVars: Object.freeze(['door1_mc', 'roomBG_spr', 'door2_mc']),
    doorSprites: Object.freeze(['door_side_3', 'door_front_6']),
    firstPassCandidate: false,
    note: 'two-door nest room; use after one-door rooms are stable'
  }),
  Object.freeze({
    key: 'nestRoom6',
    swfFolder: 'nestRoom6.swf',
    xmlFile: 'nestRoom6.xml',
    frame: 'frames/1.png',
    frameBytes: 136993,
    fileCount: 28,
    shapeCount: 10,
    spriteCount: 5,
    buttonCount: 2,
    scriptCount: 3,
    mainTimelineVars: Object.freeze(['door1_mc', 'roomBG_spr', 'door2_mc']),
    doorSprites: Object.freeze(['door_side_3', 'door_front_6']),
    firstPassCandidate: false,
    note: 'two-door nest room variant'
  }),
  Object.freeze({
    key: 'nestRoom7',
    swfFolder: 'nestRoom7.swf',
    xmlFile: 'nestRoom7.xml',
    frame: 'frames/1.png',
    frameBytes: 136342,
    fileCount: 30,
    shapeCount: 11,
    spriteCount: 6,
    buttonCount: 2,
    scriptCount: 3,
    mainTimelineVars: Object.freeze(['door1_mc', 'roomBG_spr', 'door2_mc']),
    doorSprites: Object.freeze(['door_side_3', 'door_back_6']),
    firstPassCandidate: false,
    note: 'two-door/back-door nest room variant'
  }),
  Object.freeze({
    key: 'nestRoom8',
    swfFolder: 'nestRoom8.swf',
    xmlFile: 'nestRoom8.xml',
    frame: 'frames/1.png',
    frameBytes: 136232,
    fileCount: 22,
    shapeCount: 7,
    spriteCount: 4,
    buttonCount: 1,
    scriptCount: 2,
    mainTimelineVars: Object.freeze(['door1_mc', 'roomBG_spr']),
    doorSprites: Object.freeze(['door_back_3']),
    firstPassCandidate: true,
    note: 'small back-door nest room; useful once side/front orientation is understood'
  }),
  Object.freeze({
    key: 'nestRoom9',
    swfFolder: 'nestRoom9.swf',
    xmlFile: 'nestRoom9.xml',
    frame: 'frames/1.png',
    frameBytes: 136900,
    fileCount: 30,
    shapeCount: 11,
    spriteCount: 6,
    buttonCount: 2,
    scriptCount: 3,
    mainTimelineVars: Object.freeze(['door1_mc', 'roomBG_spr', 'door2_mc']),
    doorSprites: Object.freeze(['door_side_3', 'door_back_6']),
    firstPassCandidate: false,
    note: 'two-door/back-door nest room variant'
  })
]);

export const NEST_COMPLEX_ROOMS = Object.freeze([
  Object.freeze({
    key: 'nestHall_03_06_11',
    swfFolder: 'nestHall_03_06_11.swf',
    xmlFile: 'nestHall_03_06_11.xml',
    frame: 'frames/1.png',
    frameBytes: 524588,
    fileCount: 2683,
    shapeCount: 247,
    spriteCount: 126,
    buttonCount: 13,
    scriptCount: 41,
    deferred: true,
    note: 'Nest Hall / Nest Hell export is much larger; defer until simple nest rooms and movement are working.'
  })
]);

export const NEST_ROOM_PORT_ORDER = Object.freeze([
  'nestRoom1',
  'nestRoom2',
  'movement-coordinate-sandbox',
  'two-room-navigation-smoke',
  'nestRoom3-or-nestRoom8',
  'two-door rooms',
  'nestHall_03_06_11'
]);

export function getNestRoomByKey(key) {
  return NEST_SIMPLE_ROOMS.find((room) => room.key === String(key))
    || NEST_COMPLEX_ROOMS.find((room) => room.key === String(key))
    || null;
}

export function summariseNestRoomManifest() {
  return Object.freeze({
    simpleRoomCount: NEST_SIMPLE_ROOMS.length,
    complexRoomCount: NEST_COMPLEX_ROOMS.length,
    firstPassCandidates: NEST_SIMPLE_ROOMS.filter((room) => room.firstPassCandidate).map((room) => room.key),
    recommendedFirstRoom: 'nestRoom1',
    recommendedSecondRoom: 'nestRoom2',
    viewport: NEST_ROOM_VIEWPORT,
    source: NEST_DUMP_SOURCE
  });
}
