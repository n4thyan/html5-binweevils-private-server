export const NEST_ROOM_8_RENDER_BASICS_LAYER_PLAN = Object.freeze([
  Object.freeze({
    key: "roomBG_spr",
    name: "roomBG_spr",
    characterId: 5,
    depth: 1,
    group: "base",
    registration: Object.freeze({
      x: -304.5,
      y: -205.55,
      source: "derived from roomBG_spr SWF XML matrix x/y"
    }),
    note: "main Nest room background sprite from SWF XML; requires Flash registration correction"
  }),

  Object.freeze({
    key: "door1_mc",
    name: "door1_mc",
    className: "nestRoom8_fla.door_back_3",
    characterId: 12,
    depth: 10,
    group: "doors",
    registration: Object.freeze({
      x: -33.5,
      y: -3.55,
      source: "derived from exported SVG root transform 33.5/3.55"
    }),
    note: "nestRoom8_fla.door_back_3 visual / future traversal hotspot"
  })
]);

export function getNestRoom8RenderBasicsLayerSummary() {
  const groups = NEST_ROOM_8_RENDER_BASICS_LAYER_PLAN.reduce((acc, layer) => {
    acc[layer.group] = (acc[layer.group] || 0) + 1;
    return acc;
  }, {});

  return Object.freeze({
    layerCount: NEST_ROOM_8_RENDER_BASICS_LAYER_PLAN.length,
    groups: Object.freeze(groups),
    baseLayer: "roomBG_spr",
    doorLayers: Object.freeze(
      NEST_ROOM_8_RENDER_BASICS_LAYER_PLAN
        .filter((layer) => layer.group === "doors")
        .map((layer) => layer.key)
    ),
    nextAction: "verify-nest-room8-render-basics-before-navigation"
  });
}
