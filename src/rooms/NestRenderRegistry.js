import { NEST_HALL_RENDER_BASICS_LAYER_PLAN } from "./NestHallRenderBasicsLayerPlan.js";
import { NEST_ROOM_1_RENDER_BASICS_LAYER_PLAN } from "./NestRoom1RenderBasicsLayerPlan.js";
import { NEST_ROOM_2_RENDER_BASICS_LAYER_PLAN } from "./NestRoom2RenderBasicsLayerPlan.js";
import { NEST_ROOM_3_RENDER_BASICS_LAYER_PLAN } from "./NestRoom3RenderBasicsLayerPlan.js";
import { NEST_ROOM_4_RENDER_BASICS_LAYER_PLAN } from "./NestRoom4RenderBasicsLayerPlan.js";
import { NEST_ROOM_6_RENDER_BASICS_LAYER_PLAN } from "./NestRoom6RenderBasicsLayerPlan.js";
import { NEST_ROOM_7_RENDER_BASICS_LAYER_PLAN } from "./NestRoom7RenderBasicsLayerPlan.js";
import { NEST_ROOM_8_RENDER_BASICS_LAYER_PLAN } from "./NestRoom8RenderBasicsLayerPlan.js";
import { NEST_ROOM_9_RENDER_BASICS_LAYER_PLAN } from "./NestRoom9RenderBasicsLayerPlan.js";

export const NEST_RENDERABLE_LOCATIONS = Object.freeze({
  5: Object.freeze({
    locationId: 5,
    key: "nestHall",
    label: "Nest Hall",
    sceneJson: "/generated/nestHall_03_06_11-xml-scene.json",
    layerPlan: NEST_HALL_RENDER_BASICS_LAYER_PLAN,
    renderWidth: 825,
    renderHeight: 490,
    stageWidth: 614,
    stageHeight: 366,
    scaleX: 614 / 825,
    scaleY: 366 / 490,
    isHall: true
  }),

  1: Object.freeze({
    locationId: 1,
    key: "nestRoom1",
    label: "Nest Room 1",
    sceneJson: "/generated/nestRoom1-xml-scene.json",
    layerPlan: NEST_ROOM_1_RENDER_BASICS_LAYER_PLAN,
    renderWidth: 614,
    renderHeight: 366,
    stageWidth: 614,
    stageHeight: 366,
    scaleX: 1,
    scaleY: 1
  }),

  2: Object.freeze({
    locationId: 2,
    key: "nestRoom2",
    label: "Nest Room 2",
    sceneJson: "/generated/nestRoom2-xml-scene.json",
    layerPlan: NEST_ROOM_2_RENDER_BASICS_LAYER_PLAN,
    renderWidth: 614,
    renderHeight: 366,
    stageWidth: 614,
    stageHeight: 366,
    scaleX: 1,
    scaleY: 1
  }),

  3: Object.freeze({
    locationId: 3,
    key: "nestRoom3",
    label: "Nest Room 3",
    sceneJson: "/generated/nestRoom3-xml-scene.json",
    layerPlan: NEST_ROOM_3_RENDER_BASICS_LAYER_PLAN,
    renderWidth: 614,
    renderHeight: 366,
    stageWidth: 614,
    stageHeight: 366,
    scaleX: 1,
    scaleY: 1
  }),

  4: Object.freeze({
    locationId: 4,
    key: "nestRoom4",
    label: "Nest Room 4",
    sceneJson: "/generated/nestRoom4-xml-scene.json",
    layerPlan: NEST_ROOM_4_RENDER_BASICS_LAYER_PLAN,
    renderWidth: 614,
    renderHeight: 366,
    stageWidth: 614,
    stageHeight: 366,
    scaleX: 1,
    scaleY: 1
  }),

  6: Object.freeze({
    locationId: 6,
    key: "nestRoom6",
    label: "Nest Room 6",
    sceneJson: "/generated/nestRoom6-xml-scene.json",
    layerPlan: NEST_ROOM_6_RENDER_BASICS_LAYER_PLAN,
    renderWidth: 614,
    renderHeight: 366,
    stageWidth: 614,
    stageHeight: 366,
    scaleX: 1,
    scaleY: 1
  }),

  7: Object.freeze({
    locationId: 7,
    key: "nestRoom7",
    label: "Nest Room 7",
    sceneJson: "/generated/nestRoom7-xml-scene.json",
    layerPlan: NEST_ROOM_7_RENDER_BASICS_LAYER_PLAN,
    renderWidth: 614,
    renderHeight: 366,
    stageWidth: 614,
    stageHeight: 366,
    scaleX: 1,
    scaleY: 1
  }),

  8: Object.freeze({
    locationId: 8,
    key: "nestRoom8",
    label: "Nest Room 8",
    sceneJson: "/generated/nestRoom8-xml-scene.json",
    layerPlan: NEST_ROOM_8_RENDER_BASICS_LAYER_PLAN,
    renderWidth: 614,
    renderHeight: 366,
    stageWidth: 614,
    stageHeight: 366,
    scaleX: 1,
    scaleY: 1
  }),

  9: Object.freeze({
    locationId: 9,
    key: "nestRoom9",
    label: "Nest Room 9",
    sceneJson: "/generated/nestRoom9-xml-scene.json",
    layerPlan: NEST_ROOM_9_RENDER_BASICS_LAYER_PLAN,
    renderWidth: 614,
    renderHeight: 366,
    stageWidth: 614,
    stageHeight: 366,
    scaleX: 1,
    scaleY: 1
  })
});

export function getNestRenderableLocation(locationId) {
  return NEST_RENDERABLE_LOCATIONS[locationId] || null;
}
