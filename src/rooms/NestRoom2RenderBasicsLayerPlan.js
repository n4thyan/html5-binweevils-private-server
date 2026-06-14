export const NEST_ROOM_2_RENDER_BASICS_LAYER_PLAN = Object.freeze([
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
    characterId: 10,
    depth: 11,
    group: "doors",
    registration: Object.freeze({
      x: -9.95,
      y: -1.85,
      source: "derived from door_front_3 exported SVG root transform 9.95/1.85"
    }),
    note: "front door visual / future traversal hotspot"
  })
]);

export function getNestRoom2RenderBasicsLayerSummary() {
  const groups = NEST_ROOM_2_RENDER_BASICS_LAYER_PLAN.reduce((acc, layer) => {
    acc[layer.group] = (acc[layer.group] || 0) + 1;
    return acc;
  }, {});

  return Object.freeze({
    layerCount: NEST_ROOM_2_RENDER_BASICS_LAYER_PLAN.length,
    groups: Object.freeze(groups),
    baseLayer: "roomBG_spr",
    doorLayer: "door1_mc",
    nextAction: "verify-nest-room2-render-basics-before-navigation"
  });
}
