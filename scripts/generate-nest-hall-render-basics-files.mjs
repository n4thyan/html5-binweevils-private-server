import fs from "node:fs";
import path from "node:path";

const repoRoot = process.cwd();
const roomName = "nestHall_03_06_11";
const scenePath = path.join(repoRoot, `public/generated/${roomName}-xml-scene.json`);
const outputPlanPath = path.join(repoRoot, "src/rooms/NestHallRenderBasicsLayerPlan.js");
const outputProbePath = path.join(repoRoot, "public/probes/nestHall_03_06_11-render-basics.html");
const templateProbePath = path.join(repoRoot, "public/probes/nestRoom2-render-basics.html");

if (!fs.existsSync(scenePath)) {
  throw new Error(`Missing generated scene JSON: ${scenePath}. Run scripts/build-nest-room-xml-scene-json.mjs first.`);
}

const scene = JSON.parse(fs.readFileSync(scenePath, "utf8"));
const placements = (scene.placements || [])
  .filter((placement) => placement.mapped && placement.spritePath)
  .sort((a, b) => a.depth - b.depth || a.tagIndex - b.tagIndex);

const layers = placements.map((placement) => ({
  key: placement.name || `${placement.className || "symbol"}_${placement.characterId}`,
  name: placement.name || "",
  className: placement.className || "",
  characterId: placement.characterId,
  depth: placement.depth,
  group: placement.name === "roomBG_spr" ? "base" : "doors",
  registration: deriveRegistration(placement),
  note:
    placement.name === "roomBG_spr"
      ? "main Nest Hall background sprite from SWF XML"
      : `${placement.name || placement.className} visual / future Nest Hall interaction layer`
}));

writeLayerPlan(layers);
writeProbe();

console.log(`Nest Hall render basics generated with ${layers.length} mapped layers`);
for (const layer of layers) {
  console.log(`${layer.key}: cid=${layer.characterId} depth=${layer.depth} reg=${layer.registration.x},${layer.registration.y}`);
}

function deriveRegistration(placement) {
  if (placement.name === "roomBG_spr") {
    return {
      x: round2(-Number(placement.matrix.x)),
      y: round2(-Number(placement.matrix.y)),
      source: "derived from roomBG_spr SWF XML matrix x/y"
    };
  }

  const svgPath = path.join(repoRoot, placement.spritePath);

  if (!fs.existsSync(svgPath)) {
    throw new Error(`Missing SVG for ${placement.name || placement.className}: ${svgPath}`);
  }

  const svg = fs.readFileSync(svgPath, "utf8");
  const match = svg.match(/<g\s+transform="matrix\(([^)]+)\)"/);

  if (!match) {
    return {
      x: 0,
      y: 0,
      source: "no exported SVG root transform found; defaulted to 0/0"
    };
  }

  const values = match[1].split(",").map((value) => Number(value.trim()));

  if (values.length !== 6 || values.some(Number.isNaN)) {
    throw new Error(`Could not parse SVG root transform: ${match[1]}`);
  }

  return {
    x: round2(-values[4]),
    y: round2(-values[5]),
    source: `derived from exported SVG root transform ${values[4]}/${values[5]}`
  };
}

function writeLayerPlan(layers) {
  const layerText = layers.map((layer) => {
    const classNameLine = layer.className ? `\n    className: ${JSON.stringify(layer.className)},` : "";

    return `  Object.freeze({
    key: ${JSON.stringify(layer.key)},
    name: ${JSON.stringify(layer.name)},${classNameLine}
    characterId: ${layer.characterId},
    depth: ${layer.depth},
    group: ${JSON.stringify(layer.group)},
    registration: Object.freeze({
      x: ${layer.registration.x},
      y: ${layer.registration.y},
      source: ${JSON.stringify(layer.registration.source)}
    }),
    note: ${JSON.stringify(layer.note)}
  })`;
  }).join(",\n\n");

  const content = `export const NEST_HALL_RENDER_BASICS_LAYER_PLAN = Object.freeze([
${layerText}
]);

export function getNestHallRenderBasicsLayerSummary() {
  const groups = NEST_HALL_RENDER_BASICS_LAYER_PLAN.reduce((acc, layer) => {
    acc[layer.group] = (acc[layer.group] || 0) + 1;
    return acc;
  }, {});

  return Object.freeze({
    layerCount: NEST_HALL_RENDER_BASICS_LAYER_PLAN.length,
    groups: Object.freeze(groups),
    baseLayer: "roomBG_spr",
    objectLayers: Object.freeze(
      NEST_HALL_RENDER_BASICS_LAYER_PLAN
        .filter((layer) => layer.group !== "base")
        .map((layer) => layer.key)
    ),
    nextAction: "verify-nest-hall-render-basics-before-behaviour-port"
  });
}
`;

  fs.writeFileSync(outputPlanPath, content, "utf8");
}

function writeProbe() {
  let html = fs.readFileSync(templateProbePath, "utf8");

  html = html.replaceAll("nestRoom2 Render Basics", "Nest Hall Render Basics");
  html = html.replaceAll("nestRoom2 render basics", "Nest Hall render basics");
  html = html.replaceAll("nestRoom2", "nestHall_03_06_11");
  html = html.replaceAll("NestRoom2RenderBasicsLayerPlan.js", "NestHallRenderBasicsLayerPlan.js");
  html = html.replaceAll("NEST_ROOM_2_RENDER_BASICS_LAYER_PLAN", "NEST_HALL_RENDER_BASICS_LAYER_PLAN");
  html = html.replaceAll("base room", "base room");
  html = html.replaceAll("doors", "hall objects");

  html = html.replace(
    "front-door click/collision is nested inside door1_mc",
    "Nest Hall first-pass visual render: mapped SWF XML placements only. Buttons and behaviours are handled later."
  );

  fs.writeFileSync(outputProbePath, html, "utf8");
}

function round2(value) {
  return Math.round(value * 100) / 100;
}
