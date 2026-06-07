// Source-backed candidate role map for rebuilding RumsCove from the room SWF export.
//
// This map is based on local inspection output from:
//   node scripts/audit-rums-cove-symbols.mjs
//   node scripts/inspect-rums-cove-candidates.mjs
//
// It is not the final renderer yet. It gives the next implementation pass a
// source-backed checklist of room root, major visual layers, door symbols,
// dynamic text/ad symbols, and deferred animations.

export const RUMS_COVE_ROOT_CANDIDATE = Object.freeze({
  className: 'RumsAirport_dynamAds',
  scriptPath: 'scripts/RumsAirport_dynamAds.as',
  extendsName: 'MovieClip',
  lineCount: 240,
  role: 'root room MovieClip / timeline controller',
  childRefs: Object.freeze([
    'door1_mc',
    'door4_mc',
    'door7_mc',
    'door2_mc',
    'door5_mc',
    'floorClickArea_btn',
    'door3_mc',
    'adBoard_mc',
    'door6_mc',
    'adHolder_spr'
  ]),
  functions: Object.freeze([
    'RumsAirport_dynamAds',
    'onRemovedFromStage',
    'ad1Loaded',
    'getPodText',
    'onAd1Clicked',
    'unloadAds',
    'loadAd1',
    'onAddedToStage',
    'onPodClick',
    'adPathsReceived',
    'getAdPaths'
  ]),
  timelineCalls: Object.freeze(['addEventListener', 'gotoAndStop', 'play', 'gotoAndPlay'])
});

export const RUMS_COVE_SYMBOL_CLASS_CANDIDATES = Object.freeze([
  Object.freeze({ symbolId: 373, className: 'RumsAirport_dynamAds_videoPodv2_fla.plane_takeoff_3', role: 'deferred animation' }),
  Object.freeze({ symbolId: 370, className: 'RumsAirport_dynamAds_videoPodv2_fla.plane_runway_anim_5', role: 'deferred animation' }),
  Object.freeze({ symbolId: 361, className: 'RumsAirport_dynamAds_videoPodv2_fla.buildings_12', role: 'major visual layer/composite' }),
  Object.freeze({ symbolId: 358, className: 'RumsAirport_dynamAds_videoPodv2_fla.yoghurtpot_tums_13', role: 'major visual/commercial pod composite' }),
  Object.freeze({ symbolId: 293, className: 'RumsAirport_dynamAds_videoPodv2_fla.airport_23', role: 'airport building sub-layer' }),
  Object.freeze({ symbolId: 269, className: 'RumsAirport_dynamAds_videoPodv2_fla.Door_animated2_26', role: 'stopped door animation' }),
  Object.freeze({ symbolId: 266, className: 'RumsAirport_dynamAds_videoPodv2_fla.overlay_70', role: 'foreground/overlay composite' }),
  Object.freeze({ symbolId: 265, className: 'RumsAirport_dynamAds_videoPodv2_fla.remoteBack_31', role: 'remote/pod background composite' }),
  Object.freeze({ symbolId: 264, className: 'RumsAirport_dynamAds_videoPodv2_fla.podText_66', role: 'dynamic pod text wrapper' }),
  Object.freeze({ symbolId: 263, className: 'RumsAirport_dynamAds_videoPodv2_fla.t_67', role: 'dynamic text field wrapper' }),
  Object.freeze({ symbolId: 179, className: 'RumsAirport_dynamAds_videoPodv2_fla.Door_002_71', role: 'animated/clickable door' }),
  Object.freeze({ symbolId: 149, className: 'RumsAirport_dynamAds_videoPodv2_fla.door1_76', role: 'clickable door' }),
  Object.freeze({ symbolId: 144, className: 'RumsAirport_dynamAds_videoPodv2_fla.door3_78', role: 'clickable door' }),
  Object.freeze({ symbolId: 142, className: 'RumsAirport_dynamAds_videoPodv2_fla.door4_80', role: 'clickable door' }),
  Object.freeze({ symbolId: 139, className: 'RumsAirport_dynamAds_videoPodv2_fla.door6_82', role: 'clickable booth/door' })
]);

export const RUMS_COVE_MAJOR_VISUAL_CANDIDATES = Object.freeze([
  Object.freeze({
    key: 'buildings',
    symbolId: 361,
    className: 'buildings_12',
    scriptPath: 'scripts/RumsAirport_dynamAds_videoPodv2_fla/buildings_12.as',
    spritePath: 'sprites/DefineSprite_361_RumsAirport_dynamAds_videoPodv2_fla.buildings_12/1.svg',
    role: 'major background/building composite',
    childRefs: Object.freeze(['airport', 'diner'])
  }),
  Object.freeze({
    key: 'airport',
    symbolId: 293,
    className: 'airport_23',
    scriptPath: 'scripts/RumsAirport_dynamAds_videoPodv2_fla/airport_23.as',
    spritePath: 'sprites/DefineSprite_293_RumsAirport_dynamAds_videoPodv2_fla.airport_23/1.svg',
    role: 'airport building sub-layer',
    childRefs: Object.freeze(['slidingDoors_mc'])
  }),
  Object.freeze({
    key: 'remoteBack',
    symbolId: 265,
    className: 'remoteBack_31',
    scriptPath: 'scripts/RumsAirport_dynamAds_videoPodv2_fla/remoteBack_31.as',
    spritePath: 'sprites/DefineSprite_265_RumsAirport_dynamAds_videoPodv2_fla.remoteBack_31/1.svg',
    role: 'video pod / remote background composite',
    childRefs: Object.freeze(['podText'])
  }),
  Object.freeze({
    key: 'overlay',
    symbolId: 266,
    className: 'overlay_70',
    scriptPath: 'scripts/RumsAirport_dynamAds_videoPodv2_fla/overlay_70.as',
    spritePath: 'sprites/DefineSprite_266_RumsAirport_dynamAds_videoPodv2_fla.overlay_70/1.svg',
    role: 'foreground overlay composite',
    childRefs: Object.freeze(['remoteBack'])
  }),
  Object.freeze({
    key: 'yoghurtpotTums',
    symbolId: 358,
    className: 'yoghurtpot_tums_13',
    scriptPath: 'scripts/RumsAirport_dynamAds_videoPodv2_fla/yoghurtpot_tums_13.as',
    spritePath: 'sprites/DefineSprite_358_RumsAirport_dynamAds_videoPodv2_fla.yoghurtpot_tums_13/1.svg',
    role: 'commercial pod/ad-board composite with many frames',
    childRefs: Object.freeze(['adBoard_mc', 'slidingDoors_mc'])
  })
]);

export const RUMS_COVE_DOOR_CANDIDATES = Object.freeze([
  Object.freeze({ key: 'door002', symbolId: 179, className: 'Door_002_71', scriptPath: 'scripts/RumsAirport_dynamAds_videoPodv2_fla/Door_002_71.as', role: 'animated clickable door', childRefs: Object.freeze(['clickArea_btn']), frameScripts: Object.freeze([1, 7]) }),
  Object.freeze({ key: 'doorAnimated2', symbolId: 269, className: 'Door_animated2_26', scriptPath: 'scripts/RumsAirport_dynamAds_videoPodv2_fla/Door_animated2_26.as', role: 'stopped door animation', childRefs: Object.freeze([]), frameScripts: Object.freeze([1, 20]) }),
  Object.freeze({ key: 'door1', symbolId: 149, className: 'door1_76', scriptPath: 'scripts/RumsAirport_dynamAds_videoPodv2_fla/door1_76.as', role: 'static clickable door', childRefs: Object.freeze(['clickArea_btn']), frameScripts: Object.freeze([]) }),
  Object.freeze({ key: 'door3', symbolId: 144, className: 'door3_78', scriptPath: 'scripts/RumsAirport_dynamAds_videoPodv2_fla/door3_78.as', role: 'static clickable door', childRefs: Object.freeze(['clickArea_btn']), frameScripts: Object.freeze([]) }),
  Object.freeze({ key: 'door4', symbolId: 142, className: 'door4_80', scriptPath: 'scripts/RumsAirport_dynamAds_videoPodv2_fla/door4_80.as', role: 'static clickable door', childRefs: Object.freeze(['clickArea_btn']), frameScripts: Object.freeze([]) }),
  Object.freeze({ key: 'door6', symbolId: 139, className: 'door6_82', scriptPath: 'scripts/RumsAirport_dynamAds_videoPodv2_fla/door6_82.as', role: 'static clickable booth/door with overlay', childRefs: Object.freeze(['clickArea_btn', 'boothOverlay']), frameScripts: Object.freeze([]) })
]);

export const RUMS_COVE_DYNAMIC_TEXT_AD_CANDIDATES = Object.freeze([
  Object.freeze({ key: 'podText', symbolId: 264, className: 'podText_66', role: 'pod text wrapper', childRefs: Object.freeze(['t']) }),
  Object.freeze({ key: 't', symbolId: 263, className: 't_67', role: 'text field wrapper', childRefs: Object.freeze(['message']) }),
  Object.freeze({ key: 'adBoardRight', symbolId: 300, className: 'adBoard_right_16', role: 'ad holder display object', childRefs: Object.freeze(['adHolder_spr']) })
]);

export const RUMS_COVE_DEFERRED_ANIMATION_CANDIDATES = Object.freeze([
  Object.freeze({ key: 'planeTakeoff', symbolId: 373, className: 'plane_takeoff_3', role: 'plane animation stopped on frame 1 for now' }),
  Object.freeze({ key: 'planeRunway', symbolId: 370, className: 'plane_runway_anim_5', role: 'runway plane animation stopped on frame 1 for now' }),
  Object.freeze({ key: 'cafeDoorOpen', symbolId: 297, className: 'cafedooropenanim_18', role: 'door open animation stopped on frame 1 for now' })
]);

export const RUMS_COVE_REBUILD_PASS_ORDER = Object.freeze([
  'root-room-script-behaviour-map',
  'major-static-visual-layer-probe',
  'foreground-overlay-probe',
  'door-click-area-probe',
  'dynamic-text/ad-placeholder-probe',
  'deferred-animation-frame1-probe',
  'compare-composite-against-frames-1-png',
  'replace-frame-preview-with-layered-source-room'
]);

export function getRumsCoveCandidateRoleSummary() {
  return Object.freeze({
    rootClass: RUMS_COVE_ROOT_CANDIDATE.className,
    symbolClassCandidateCount: RUMS_COVE_SYMBOL_CLASS_CANDIDATES.length,
    majorVisualCount: RUMS_COVE_MAJOR_VISUAL_CANDIDATES.length,
    doorCount: RUMS_COVE_DOOR_CANDIDATES.length,
    dynamicTextAdCount: RUMS_COVE_DYNAMIC_TEXT_AD_CANDIDATES.length,
    deferredAnimationCount: RUMS_COVE_DEFERRED_ANIMATION_CANDIDATES.length,
    nextAction: RUMS_COVE_REBUILD_PASS_ORDER[1]
  });
}
