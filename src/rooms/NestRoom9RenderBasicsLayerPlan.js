export const NEST_ROOM_9_RENDER_BASICS_LAYER_PLAN = Object.freeze([
  Object.freeze({
    key: "roomBG_spr",
    name: "roomBG_spr",
    characterId: 5,
    depth: 1,
    group: "base",
    registration: Object.freeze({
      x: -312.4,
      y: -205.05,
      source: "derived from roomBG_spr SWF XML matrix x/y"
    }),
    note: "main Nest room background sprite from SWF XML; requires Flash registration correction"
  }),

  Object.freeze({
    key: "door2_mc",
    name: "door2_mc",
    className: "nestRoom9_fla.door_side_3",
    characterId: 12,
    depth: 10,
    group: "doors",
    registration: Object.freeze({
      x: -41.15,
      y: -59.75,
      source: "derived from exported SVG root transform 41.15/59.75"
    }),
    note: "nestRoom9_fla.door_side_3 visual / future traversal hotspot"
  }),

  Object.freeze({
    key: "door1_mc",
    name: "door1_mc",
    className: "nestRoom9_fla.door_back_6",
    characterId: 19,
    depth: 19,
    group: "doors",
    registration: Object.freeze({
      x: -64.75,
      y: -3.55,
      source: "derived from exported SVG root transform 64.75/3.55"
    }),
    note: "nestRoom9_fla.door_back_6 visual / future traversal hotspot"
  })
]);

export function getNestRoom9RenderBasicsLayerSummary() {
  const groups = NEST_ROOM_9_RENDER_BASICS_LAYER_PLAN.reduce((acc, layer) => {
    acc[layer.group] = (acc[layer.group] || 0) + 1;
    return acc;
  }, {});

  return Object.freeze({
    layerCount: NEST_ROOM_9_RENDER_BASICS_LAYER_PLAN.length,
    groups: Object.freeze(groups),
    baseLayer: "roomBG_spr",
    doorLayers: Object.freeze(
      NEST_ROOM_9_RENDER_BASICS_LAYER_PLAN
        .filter((layer) => layer.group === "doors")
        .map((layer) => layer.key)
    ),
    nextAction: "verify-nest-room9-render-basics-before-navigation"
  });
}
