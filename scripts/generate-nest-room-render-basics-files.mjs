import fs from "node:fs";
import path from "node:path";

const rooms = process.argv.slice(2);

if (!rooms.length) {
  console.error("Usage: node scripts/generate-nest-room-render-basics-files.mjs nestRoom3 nestRoom4 ...");
  process.exit(1);
}

const repoRoot = process.cwd();
const templateProbePath = path.join(repoRoot, "public/probes/nestRoom2-render-basics.html");

if (!fs.existsSync(templateProbePath)) {
  throw new Error(`Missing probe template: ${templateProbePath}`);
}

const templateProbe = fs.readFileSync(templateProbePath, "utf8");

for (const roomName of rooms) {
  const roomNumber = roomName.match(/\d+$/)?.[0];

  if (!roomNumber) {
    throw new Error(`Could not extract room number from ${roomName}`);
  }

  const pascalRoom = `NestRoom${roomNumber}`;
  const constPrefix = `NEST_ROOM_${roomNumber}`;
  const scenePath = path.join(repoRoot, `public/generated/${roomName}-xml-scene.json`);

  if (!fs.existsSync(scenePath)) {
    throw new Error(`Missing generated scene JSON for ${roomName}: ${scenePath}`);
  }

  const scene = JSON.parse(fs.readFileSync(scenePath, "utf8"));
  const placements = (scene.placements || []).filter((placement) => placement.mapped);

  const layers = placements.map((placement) => {
    const registration = deriveRegistration(roomName, placement);

    return {
      key: placement.name || `${placement.className || "symbol"}_${placement.characterId}`,
      name: placement.name || "",
      className: placement.className || "",
      characterId: placement.characterId,
      depth: placement.depth,
      group: placement.name === "roomBG_spr" ? "base" : "doors",
      registration,
      note:
        placement.name === "roomBG_spr"
          ? "main Nest room background sprite from SWF XML; requires Flash registration correction"
          : `${placement.className || placement.name} visual / future traversal hotspot`
    };
  });

  writeLayerPlan({ roomName, roomNumber, pascalRoom, constPrefix, layers });
  writeProbe({ roomName, roomNumber, pascalRoom, constPrefix });
  writeSmokeTest({ roomName, roomNumber, pascalRoom, constPrefix, layers });

  console.log(`${roomName}: generated ${layers.length} layers`);
  for (const layer of layers) {
    console.log(
      `  ${layer.key}: cid=${layer.characterId} depth=${layer.depth} reg=${layer.registration.x},${layer.registration.y}`
    );
  }
}

function deriveRegistration(roomName, placement) {
  if (placement.name === "roomBG_spr") {
    return {
      x: round2(-Number(placement.matrix.x)),
      y: round2(-Number(placement.matrix.y)),
      source: "derived from roomBG_spr SWF XML matrix x/y"
    };
  }

  const svgPath = path.join(repoRoot, placement.spritePath);

  if (!fs.existsSync(svgPath)) {
    throw new Error(`Missing SVG for ${roomName} ${placement.name}: ${svgPath}`);
  }

  const svg = fs.readFileSync(svgPath, "utf8");
  const match = svg.match(/<g\s+transform="matrix\(([^)]+)\)"/);

  if (!match) {
    throw new Error(`Could not find root SVG group transform in ${svgPath}`);
  }

  const values = match[1]
    .split(",")
    .map((value) => Number(value.trim()));

  if (values.length !== 6 || values.some(Number.isNaN)) {
    throw new Error(`Could not parse root SVG group matrix in ${svgPath}: ${match[1]}`);
  }

  return {
    x: round2(-values[4]),
    y: round2(-values[5]),
    source: `derived from exported SVG root transform ${values[4]}/${values[5]}`
  };
}

function writeLayerPlan({ roomNumber, pascalRoom, constPrefix, layers }) {
  const layerPlanPath = path.join(repoRoot, `src/rooms/${pascalRoom}RenderBasicsLayerPlan.js`);

  const layerText = layers
    .map((layer) => {
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
    })
    .join(",\n\n");

  const content = `export const ${constPrefix}_RENDER_BASICS_LAYER_PLAN = Object.freeze([
${layerText}
]);

export function get${pascalRoom}RenderBasicsLayerSummary() {
  const groups = ${constPrefix}_RENDER_BASICS_LAYER_PLAN.reduce((acc, layer) => {
    acc[layer.group] = (acc[layer.group] || 0) + 1;
    return acc;
  }, {});

  return Object.freeze({
    layerCount: ${constPrefix}_RENDER_BASICS_LAYER_PLAN.length,
    groups: Object.freeze(groups),
    baseLayer: "roomBG_spr",
    doorLayers: Object.freeze(
      ${constPrefix}_RENDER_BASICS_LAYER_PLAN
        .filter((layer) => layer.group === "doors")
        .map((layer) => layer.key)
    ),
    nextAction: "verify-nest-room${roomNumber}-render-basics-before-navigation"
  });
}
`;

  fs.writeFileSync(layerPlanPath, content, "utf8");
}

function writeProbe({ roomName, roomNumber, pascalRoom, constPrefix }) {
  const probePath = path.join(repoRoot, `public/probes/${roomName}-render-basics.html`);

  let content = templateProbe;
  content = content.replaceAll("nestRoom2", roomName);
  content = content.replaceAll("NestRoom2", pascalRoom);
  content = content.replaceAll("NEST_ROOM_2", constPrefix);
  content = content.replaceAll("nest-room-2", `nest-room-${roomNumber}`);

  fs.writeFileSync(probePath, content, "utf8");
}

function writeSmokeTest({ roomName, roomNumber, pascalRoom, constPrefix, layers }) {
  const testPath = path.join(repoRoot, `tests/nest-room-${roomNumber}-render-layer-plan-smoke.mjs`);

  const asserts = layers
    .map((layer) => {
      const variableName = safeVariableName(layer.key);

      return `const ${variableName} = ${constPrefix}_RENDER_BASICS_LAYER_PLAN.find((layer) => layer.key === ${JSON.stringify(layer.key)});
assert.ok(${variableName}, ${JSON.stringify(`${layer.key} layer is missing`)});
assert.equal(${variableName}.characterId, ${layer.characterId});
assert.equal(${variableName}.depth, ${layer.depth});
assert.equal(${variableName}.registration.x, ${layer.registration.x});
assert.equal(${variableName}.registration.y, ${layer.registration.y});`;
    })
    .join("\n\n");

  const content = `import assert from "node:assert/strict";
import {
  ${constPrefix}_RENDER_BASICS_LAYER_PLAN,
  get${pascalRoom}RenderBasicsLayerSummary
} from "../src/rooms/${pascalRoom}RenderBasicsLayerPlan.js";

assert.equal(${constPrefix}_RENDER_BASICS_LAYER_PLAN.length, ${layers.length});

${asserts}

const summary = get${pascalRoom}RenderBasicsLayerSummary();
assert.equal(summary.layerCount, ${layers.length});
assert.equal(summary.baseLayer, "roomBG_spr");

console.log("${roomName} render layer plan smoke test passed");
console.log(
  ${constPrefix}_RENDER_BASICS_LAYER_PLAN
    .map((layer) => \`\${layer.key}: \${layer.registration.x}, \${layer.registration.y}\`)
    .join("\\n")
);
`;

  fs.writeFileSync(testPath, content, "utf8");
}

function safeVariableName(value) {
  return value.replace(/[^a-zA-Z0-9_$]/g, "_");
}

function round2(value) {
  return Math.round(value * 100) / 100;
}
