// Current standalone RumsCove render-basics layer plan.
//
// This is deliberately not gameplay. It records the source-backed layers that
// should be used to make the 614x366 Rums Cove exterior look correct before
// returning to walking, slime shell, or room navigation.

export const RUMS_COVE_RENDER_BASICS_LAYER_PLAN = Object.freeze([
  Object.freeze({ key: 'shape-2-base', characterId: 2, depth: 1, path: 'shapes/2.svg', group: 'environment', note: 'base/backdrop candidate' }),
  Object.freeze({ key: 'floorClickArea_btn', characterId: 4, depth: 2, path: 'shapes/4.svg', group: 'floor', note: 'floor/click-area source shape candidate' }),
  Object.freeze({ key: 'shape-14-backdrop', characterId: 14, depth: 4, path: 'shapes/14.svg', group: 'environment', note: 'early backdrop/decor candidate' }),
  Object.freeze({ key: 'shape-59-backdrop', characterId: 59, depth: 42, path: 'shapes/59.svg', group: 'environment', note: 'mid-depth backdrop candidate' }),
  Object.freeze({ key: 'shape-60-backdrop', characterId: 60, depth: 79, path: 'shapes/60.svg', group: 'environment', note: 'mid-depth backdrop candidate' }),
  Object.freeze({ key: 'buildings', name: 'buildings', characterId: 162, depth: 80, path: 'sprites/DefineSprite_361_RumsAirport_dynamAds_videoPodv2_fla.buildings_12/1.svg', group: 'base', note: 'main diner/airport building composite' }),
  Object.freeze({ key: 'fence', name: 'fence', characterId: 165, depth: 191, path: 'shapes/165.svg', group: 'environment', note: 'fence source shape' }),
  Object.freeze({ key: 'remoteBack', name: 'remoteBack', characterId: 271, depth: 206, path: 'sprites/DefineSprite_265_RumsAirport_dynamAds_videoPodv2_fla.remoteBack_31/1.svg', group: 'overlay', note: 'TV pod remote back' }),
  Object.freeze({ key: 'remoteDoorOverlay-shape', name: 'remoteDoorOverlay', characterId: 275, depth: 558, path: 'shapes/275.svg', group: 'overlay', note: 'first remote door overlay shape placement' }),
  Object.freeze({ key: 'door7_mc', name: 'door7_mc', characterId: 281, depth: 564, path: 'sprites/DefineSprite_179_RumsAirport_dynamAds_videoPodv2_fla.Door_002_71/1.svg', group: 'doors', note: 'TV pod door target, later traversal hotspot' }),
  Object.freeze({ key: 'remoteDoorOverlay-sprite', name: 'remoteDoorOverlay', characterId: 283, depth: 593, path: 'sprites/DefineSprite_283_RumsAirport_dynamAds_videoPodv2_fla.remoteOverlay_74/1.svg', group: 'overlay', note: 'second remote overlay sprite placement' }),
  Object.freeze({ key: 'door1_mc', name: 'door1_mc', characterId: 290, depth: 633, path: 'sprites/DefineSprite_149_RumsAirport_dynamAds_videoPodv2_fla.door1_76/1.svg', group: 'doors', note: 'left yellow arrow visual' }),
  Object.freeze({ key: 'door2_mc', name: 'door2_mc', characterId: 290, depth: 635, path: 'sprites/DefineSprite_149_RumsAirport_dynamAds_videoPodv2_fla.door1_76/1.svg', group: 'doors', note: 'right yellow arrow visual, flipped by XML matrix' }),
  Object.freeze({ key: 'door3_mc', name: 'door3_mc', characterId: 293, depth: 637, path: 'sprites/DefineSprite_144_RumsAirport_dynamAds_videoPodv2_fla.door3_78/1.svg', group: 'doors', note: 'airport door visual' }),
  Object.freeze({ key: 'door4_mc', name: 'door4_mc', characterId: 295, depth: 639, path: 'sprites/DefineSprite_142_RumsAirport_dynamAds_videoPodv2_fla.door4_80/1.svg', group: 'doors', note: 'diner/ad board door visual' }),
  Object.freeze({ key: 'door6_mc', name: 'door6_mc', characterId: 306, depth: 641, path: 'sprites/DefineSprite_139_RumsAirport_dynamAds_videoPodv2_fla.door6_82/1.svg', group: 'doors', note: 'right-side door visual' }),
  Object.freeze({ key: 'door5_mc', name: 'door5_mc', characterId: 313, depth: 648, path: 'sprites/DefineSprite_313_RumsAirport_dynamAds_videoPodv2_fla.pipes_86/1.svg', group: 'doors', note: 'pipe/top door visual' })
]);

export function getRumsCoveRenderBasicsLayerSummary() {
  const groups = RUMS_COVE_RENDER_BASICS_LAYER_PLAN.reduce((acc, layer) => {
    acc[layer.group] = (acc[layer.group] || 0) + 1;
    return acc;
  }, {});

  return Object.freeze({
    layerCount: RUMS_COVE_RENDER_BASICS_LAYER_PLAN.length,
    groups: Object.freeze(groups),
    nextAction: 'wire-layer-plan-into-rums-cove-render-basics-page'
  });
}
