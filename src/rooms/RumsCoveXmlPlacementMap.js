// Source-backed placement map extracted from JPEXS XML:
// xml/RumsAirport_dynamAds_videoPodv2.xml
//
// These values replace manual calibration for root-level room instances.

export const RUMS_COVE_XML_PLACEMENT_SOURCE = Object.freeze({
  generator: 'JPEXS Free Flash Decompiler v.24.0.1',
  frameCount: 1,
  rootItemCount: 348,
  symbolCount: 20,
  placementCount: 101,
  namedPlacementCount: 16
});

export const RUMS_COVE_XML_NAMED_PLACEMENTS = Object.freeze([
  Object.freeze({ name: 'floorClickArea_btn', depth: 2, tag: 10, characterId: 4, className: '', x: 0.05, y: 285.65, scaleX: 0.74399, scaleY: 0.74399, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'plane1', depth: 8, tag: 25, characterId: 17, className: 'RumsAirport_dynamAds_videoPodv2_fla.plane_takeoff_3', x: -97.5, y: 153.2, scaleX: 0.54536, scaleY: 0.54536, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'plane2', depth: 10, tag: 35, characterId: 26, className: 'RumsAirport_dynamAds_videoPodv2_fla.plane_runway_anim_5', x: 401.45, y: 194.9, scaleX: 0.74399, scaleY: 0.74399, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'buildings', depth: 80, tag: 179, characterId: 162, className: 'RumsAirport_dynamAds_videoPodv2_fla.buildings_12', x: -62.55, y: 12.75, scaleX: 0.74399, scaleY: 0.74399, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'fence', depth: 191, tag: 183, characterId: 165, className: '', x: 129.8, y: 284.75, scaleX: 0.74399, scaleY: 0.74399, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'remoteBack', depth: 206, tag: 293, characterId: 271, className: 'RumsAirport_dynamAds_videoPodv2_fla.remoteBack_31', x: 191.75, y: 279.5, scaleX: 0.27167, scaleY: 0.27167, skew0: -0.01324, skew1: 0.01324 }),
  Object.freeze({ name: 'remoteDoorOverlay', depth: 558, tag: 298, characterId: 275, className: '', x: 172.5, y: 162.75, scaleX: 0.77139, scaleY: 0.77139, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'door7_mc', depth: 564, tag: 305, characterId: 281, className: 'RumsAirport_dynamAds_videoPodv2_fla.Door_002_71', x: 191.45, y: 279.3, scaleX: 0.28073, scaleY: 0.2735, skew0: -0.01233, skew1: 0.00504 }),
  Object.freeze({ name: 'remoteDoorOverlay', depth: 593, tag: 308, characterId: 283, className: 'RumsAirport_dynamAds_videoPodv2_fla.remoteOverlay_74', x: 284.8, y: 162.3, scaleX: -0.66339, scaleY: 0.66339, skew0: -0.03203, skew1: -0.03203 }),
  Object.freeze({ name: 'mulchtasticBooth', depth: 625, tag: 311, characterId: 285, className: '', x: 568.2, y: 279.65, scaleX: -0.89978, scaleY: 0.89978, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'door1_mc', depth: 633, tag: 317, characterId: 290, className: 'RumsAirport_dynamAds_videoPodv2_fla.door1_76', x: 15.3, y: 309.85, scaleX: 0.74399, scaleY: 0.74399, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'door2_mc', depth: 635, tag: 318, characterId: 290, className: 'RumsAirport_dynamAds_videoPodv2_fla.door1_76', x: 594.4, y: 323.7, scaleX: -0.59518, scaleY: 0.59518, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'door3_mc', depth: 637, tag: 322, characterId: 293, className: 'RumsAirport_dynamAds_videoPodv2_fla.door3_78', x: 284.9, y: 237.35, scaleX: 0.74399, scaleY: 0.74399, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'door4_mc', depth: 639, tag: 325, characterId: 295, className: 'RumsAirport_dynamAds_videoPodv2_fla.door4_80', x: 70.6, y: 238.1, scaleX: 0.74399, scaleY: 0.74399, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'door6_mc', depth: 641, tag: 337, characterId: 306, className: 'RumsAirport_dynamAds_videoPodv2_fla.door6_82', x: 585.95, y: 279.8, scaleX: -0.81837, scaleY: 0.81837, skew0: 0, skew1: 0 }),
  Object.freeze({ name: 'door5_mc', depth: 648, tag: 346, characterId: 313, className: 'RumsAirport_dynamAds_videoPodv2_fla.pipes_86', x: 295.9, y: -50.35, scaleX: 1.00439, scaleY: 1.00439, skew0: 0, skew1: 0 })
]);

export const RUMS_COVE_XML_PLACEMENTS_BY_NAME = Object.freeze(
  RUMS_COVE_XML_NAMED_PLACEMENTS.reduce((map, placement) => {
    map[placement.name] ||= [];
    map[placement.name].push(placement);
    return map;
  }, {})
);

export const RUMS_COVE_XML_SCENE_LAYER_ORDER = Object.freeze(
  [...RUMS_COVE_XML_NAMED_PLACEMENTS].sort((a, b) => a.depth - b.depth)
);

export function getRumsCoveXmlPlacementSummary() {
  return Object.freeze({
    source: RUMS_COVE_XML_PLACEMENT_SOURCE,
    namedPlacementCount: RUMS_COVE_XML_NAMED_PLACEMENTS.length,
    firstNamedPlacement: RUMS_COVE_XML_SCENE_LAYER_ORDER[0].name,
    lastNamedPlacement: RUMS_COVE_XML_SCENE_LAYER_ORDER.at(-1).name,
    hasBuildings: Boolean(RUMS_COVE_XML_PLACEMENTS_BY_NAME.buildings),
    hasRemoteBack: Boolean(RUMS_COVE_XML_PLACEMENTS_BY_NAME.remoteBack),
    hasFloorClickArea: Boolean(RUMS_COVE_XML_PLACEMENTS_BY_NAME.floorClickArea_btn),
    nextAction: 'render-source-sprites-using-xml-placement'
  });
}

export function toCssMatrix(placement) {
  return `matrix(${placement.scaleX}, ${placement.skew0}, ${placement.skew1}, ${placement.scaleY}, ${placement.x}, ${placement.y})`;
}
