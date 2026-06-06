// Source-backed first-room manifest for Rums Cove.
//
// This does not render the room yet. It captures the real locationDefinitions
// entry for locID 129 plus the currently uploaded Rums room-family export notes.

export const RUMS_COVE_LOCATION_SOURCE = 'source/knowyourknot-binweevils/game-full/binConfig/getFile/7/uk/locationDefinitions.xml';
export const RUMS_COVE_UPLOAD_NAME = 'RumsAirport_dynamAds_videoPodv2_release.zip';

export const RUMS_COVE_LOC = Object.freeze({
  id: 129,
  name: 'RumsCove',
  type: 2,
  kind: 'FixedCam',
  boundType: 'rect',
  boundary: Object.freeze([-240, 60, 680, 90]),
  camPos: Object.freeze([0, 190, -330]),
  camAim: Object.freeze([0, 90, 260]),
  entryPos: Object.freeze([0, 80]),
  entryDir: 180,
  weevilScale: 0.18,
  roomBG: 'fixedCam/RumsAirport_180321.swf',
  uploadedExport: 'RumsAirport_dynamAds_videoPodv2_release',
  equivalenceStatus: 'same-room-family-unverified-exact-version'
});

export const RUMS_COVE_DOORS = Object.freeze([
  Object.freeze({ id: 1, toLoc: 107, toDoor: 1, x1: -190, z1: 125, x2: -260, z2: 125, entryDir: 180 }),
  Object.freeze({ id: 2, toLoc: 103, toDoor: 1, x1: 180, z1: 92, x2: 250, z2: 92, entryDir: 180 }),
  Object.freeze({ id: 3, toLoc: 132, toDoor: 1, x1: 15, z1: 155, x2: 15, z2: 260, entryDir: 0 }),
  Object.freeze({ id: 4, toLoc: 154, toDoor: 1, x1: -179, z1: 155, x2: -179, z2: 260, entryDir: 0 }),
  Object.freeze({ id: 5, toLoc: 104, toDoor: 4, x1: 100, z1: 130, x2: 326, z2: 132, y2: 1500, entryDir: 0 })
]);

export const RUMS_COVE_INACTIVE_XML_DOORS = Object.freeze([
  Object.freeze({ id: 6, reason: 'commented-out lotto/extUI door in locationDefinitions.xml; do not treat as active final data yet' })
]);

export const RUMS_COVE_OBJECTS = Object.freeze([
  Object.freeze({ name: 'door6_mc', x: 137, y: 0, z: 115 }),
  Object.freeze({ name: 'mulchtasticBooth', x: 80, y: 0, z: 150 }),
  Object.freeze({ name: 'buildings', x: -150, y: 0, z: 198 }),
  Object.freeze({ name: 'fence', x: 0, y: 0, z: 160 }),
  Object.freeze({ name: 'door3_mc', x: 0, y: 0, z: 190 }),
  Object.freeze({ name: 'door4_mc', x: 0, y: 0, z: 191 }),
  Object.freeze({ name: 'door5_mc', x: 0, y: 0, z: 0 }),
  Object.freeze({ name: 'bobbleOverlay_mc', x: 0, y: 0, z: 335 })
]);

export const RUMS_COVE_INTERACTIVES = Object.freeze([
  Object.freeze({ type: 'door', path: 'buildings.airport.slidingDoors_mc', actRect: Object.freeze([-20, 140, 60, 200]) }),
  Object.freeze({ type: 'door', path: 'buildings.diner.slidingDoors_mc', actRect: Object.freeze([-200, 140, 50, 200]) })
]);

export const RUMS_COVE_ANIMS = Object.freeze([
  'plane1',
  'plane2'
]);

export const RUMS_COVE_SYMBOLS = Object.freeze([
  Object.freeze({ id: 0, className: 'RumsAirport_dynamAds', role: 'main room class' }),
  Object.freeze({ id: 139, className: 'RumsAirport_dynamAds_videoPodv2_fla.door6_82', role: 'door6 visual' }),
  Object.freeze({ id: 142, className: 'RumsAirport_dynamAds_videoPodv2_fla.door4_80', role: 'door4 visual' }),
  Object.freeze({ id: 144, className: 'RumsAirport_dynamAds_videoPodv2_fla.door3_78', role: 'door3 visual' }),
  Object.freeze({ id: 149, className: 'RumsAirport_dynamAds_videoPodv2_fla.door1_76', role: 'door1 visual' }),
  Object.freeze({ id: 293, className: 'RumsAirport_dynamAds_videoPodv2_fla.airport_23', role: 'airport building' }),
  Object.freeze({ id: 297, className: 'RumsAirport_dynamAds_videoPodv2_fla.cafedooropenanim_18', role: 'cafe door animation' }),
  Object.freeze({ id: 361, className: 'RumsAirport_dynamAds_videoPodv2_fla.buildings_12', role: 'buildings container' }),
  Object.freeze({ id: 370, className: 'RumsAirport_dynamAds_videoPodv2_fla.plane_runway_anim_5', role: 'plane runway animation' }),
  Object.freeze({ id: 373, className: 'RumsAirport_dynamAds_videoPodv2_fla.plane_takeoff_3', role: 'plane takeoff animation' })
]);

export const RUMS_COVE_DEFERRED_FEATURES = Object.freeze([
  'dynamic ads',
  'plane animations',
  'fireworks',
  'commented-out lotto/extUI door',
  'unproven videoPod1 navigation'
]);

export function getRumsCoveDoorById(id) {
  return RUMS_COVE_DOORS.find((door) => door.id === Number(id)) ?? null;
}

export function getRumsCoveObjectByName(name) {
  return RUMS_COVE_OBJECTS.find((object) => object.name === String(name)) ?? null;
}

export function summariseRumsCoveManifest() {
  return Object.freeze({
    locationSource: RUMS_COVE_LOCATION_SOURCE,
    uploadName: RUMS_COVE_UPLOAD_NAME,
    loc: RUMS_COVE_LOC,
    doors: RUMS_COVE_DOORS.length,
    objects: RUMS_COVE_OBJECTS.length,
    interactives: RUMS_COVE_INTERACTIVES.length,
    anims: RUMS_COVE_ANIMS.length,
    symbols: RUMS_COVE_SYMBOLS.length,
    deferredFeatures: RUMS_COVE_DEFERRED_FEATURES.length,
    summary: `RumsCove loc ${RUMS_COVE_LOC.id} / ${RUMS_COVE_LOC.kind} / ${RUMS_COVE_LOC.roomBG}`
  });
}
