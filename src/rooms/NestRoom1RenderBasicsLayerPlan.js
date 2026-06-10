export const NEST_ROOM_1_RENDER_BASICS_LAYER_PLAN = Object.freeze([
  Object.freeze({
    key: "roomBG_spr",
    name: "roomBG_spr",
    characterId: 5,
    depth: 1,
    group: "base",
    registration: Object.freeze({
      x: -308.5,
      y: -205.55,
      source: "derived from SWF XML roomBG_spr matrix translate 6170/4111 twips and exported 617x391 asset bounds"
    }),
    note: "main Nest room background sprite from SWF XML; requires Flash registration correction"
  }),

  Object.freeze({
    key: "door1_mc",
    name: "door1_mc",
    characterId: 12,
    depth: 11,
    group: "doors",
    registration: Object.freeze({
      x: -97,
      y: 0,
      source: "temporary source-backed horizontal centre correction from exported 194px door asset width; verify against nested bounds next"
    }),
    note: "side door visual / future traversal hotspot"
  }),

  Object.freeze({
    key: "clickArea_btn",
    name: "clickArea_btn",
    characterId: 11,
    depth: 9,
    group: "debug-collision",
    note: "click/movement area candidate; currently nested inside roomBG_spr so may not appear as a root placement"
  })
]);

export function getNestRoom1RenderBasicsLayerSummary() {
  const groups = NEST_ROOM_1_RENDER_BASICS_LAYER_PLAN.reduce((acc, layer) => {
    acc[layer.group] = (acc[layer.group] || 0) + 1;
    return acc;
  }, {});

  return Object.freeze({
    layerCount: NEST_ROOM_1_RENDER_BASICS_LAYER_PLAN.length,
    groups: Object.freeze(groups),
    baseLayer: "roomBG_spr",
    debugCollisionLayer: "clickArea_btn",
    nextAction: "verify-nest-room1-render-basics-before-navigation"
  });
}
