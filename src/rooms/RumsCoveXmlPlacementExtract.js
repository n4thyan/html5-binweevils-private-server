// Extract root timeline placement data from a JPEXS/FFDec XML export.
// This is the missing source-backed transform data for the RumsCove room.

export function extractRumsCoveXmlPlacement(xmlText) {
  const text = String(xmlText || '');
  const rootItems = extractRootTagItems(text);
  const symbolMap = extractSymbolClassMap(rootItems);

  const placements = rootItems
    .map((block, tagIndex) => ({ block, tagIndex }))
    .filter(({ block }) => /type="PlaceObject[23]?Tag"/.test(block))
    .map(({ block, tagIndex }) => parsePlaceObjectBlock(block, tagIndex, symbolMap));

  return Object.freeze({
    generator: extractAttribute(text.match(/<swf\b[^>]*>/)?.[0] || '', '_generator'),
    frameCount: Number(extractAttribute(text.match(/<swf\b[^>]*>/)?.[0] || '', 'frameCount') || 0),
    symbolCount: Object.keys(symbolMap).length,
    placementCount: placements.length,
    namedPlacementCount: placements.filter((placement) => placement.name).length,
    placements: Object.freeze(placements),
    namedPlacements: Object.freeze(placements.filter((placement) => placement.name)),
    symbolMap: Object.freeze(symbolMap)
  });
}

export function extractRootTagItems(xmlText) {
  const text = String(xmlText || '');
  const tagsStart = text.indexOf('<tags>');
  if (tagsStart < 0) return [];

  const items = [];
  const tokenPattern = /<item\b[^>]*>|<\/item>/g;
  tokenPattern.lastIndex = tagsStart;

  let depth = 0;
  let itemStart = -1;
  let match;

  while ((match = tokenPattern.exec(text))) {
    const token = match[0];
    if (token.startsWith('<item')) {
      if (depth === 0) itemStart = match.index;
      depth += 1;
    } else {
      depth -= 1;
      if (depth === 0 && itemStart >= 0) {
        items.push(text.slice(itemStart, tokenPattern.lastIndex));
        itemStart = -1;
      }
      if (depth < 0) break;
    }
  }

  return items;
}

export function extractSymbolClassMap(rootItems) {
  const symbolBlock = (rootItems || []).find((block) => block.includes('type="SymbolClassTag"')) || '';
  const tagsText = symbolBlock.match(/<tags>\s*([\s\S]*?)\s*<\/tags>/)?.[1] || '';
  const namesText = symbolBlock.match(/<names>\s*([\s\S]*?)\s*<\/names>/)?.[1] || '';
  const ids = [...tagsText.matchAll(/<item>(.*?)<\/item>/g)].map((match) => Number(match[1]));
  const names = [...namesText.matchAll(/<item>(.*?)<\/item>/g)].map((match) => match[1]);
  const map = {};

  for (let index = 0; index < Math.min(ids.length, names.length); index += 1) {
    map[String(ids[index])] = names[index];
  }

  return map;
}

export function parsePlaceObjectBlock(block, tagIndex, symbolMap) {
  const startTag = block.match(/<item\b[^>]*>/)?.[0] || '';
  const attrs = parseAttributes(startTag);
  const matrixTag = block.match(/<matrix\b[^>]*>/)?.[0] || '';
  const matrixAttrs = parseAttributes(matrixTag);
  const characterId = Number(attrs.characterId || 0);

  return Object.freeze({
    tagIndex,
    type: attrs.type || '',
    depth: Number(attrs.depth || 0),
    characterId,
    className: symbolMap[String(characterId)] || '',
    name: attrs.name || '',
    hasCharacter: attrs.placeFlagHasCharacter === 'true',
    hasName: attrs.placeFlagHasName === 'true',
    hasMatrix: attrs.placeFlagHasMatrix === 'true',
    matrix: Object.freeze(normaliseMatrix(matrixAttrs))
  });
}

export function normaliseMatrix(attrs) {
  const hasScale = attrs.hasScale === 'true';
  const hasRotate = attrs.hasRotate === 'true';
  const translateXTwips = Number(attrs.translateX || 0);
  const translateYTwips = Number(attrs.translateY || 0);

  return Object.freeze({
    hasScale,
    hasRotate,
    scaleX: hasScale ? Number(attrs.scaleX || 0) : 1,
    scaleY: hasScale ? Number(attrs.scaleY || 0) : 1,
    rotateSkew0: hasRotate ? Number(attrs.rotateSkew0 || 0) : 0,
    rotateSkew1: hasRotate ? Number(attrs.rotateSkew1 || 0) : 0,
    translateXTwips,
    translateYTwips,
    x: translateXTwips / 20,
    y: translateYTwips / 20
  });
}

export function parseAttributes(tag) {
  const attrs = {};
  for (const match of String(tag || '').matchAll(/([A-Za-z0-9_:-]+)="([^"]*)"/g)) {
    attrs[match[1]] = match[2];
  }
  return attrs;
}

export function formatPlacementReport(result) {
  const lines = [];
  lines.push('RumsCove XML placement extract');
  lines.push(`generator: ${result.generator || '(unknown)'}`);
  lines.push(`frameCount: ${result.frameCount}`);
  lines.push(`symbolCount: ${result.symbolCount}`);
  lines.push(`placementCount: ${result.placementCount}`);
  lines.push(`namedPlacementCount: ${result.namedPlacementCount}`);
  lines.push('namedPlacements:');

  for (const placement of result.namedPlacements) {
    lines.push(formatPlacementLine(placement));
  }

  return lines.join('\n');
}

export function formatPlacementLine(placement) {
  const matrix = placement.matrix;
  return [
    `  depth=${placement.depth}`,
    `tag=${placement.tagIndex}`,
    `cid=${placement.characterId}`,
    `name=${placement.name || '(none)'}`,
    `class=${placement.className || '(unmapped)'}`,
    `x=${round(matrix.x)}`,
    `y=${round(matrix.y)}`,
    `scaleX=${round(matrix.scaleX)}`,
    `scaleY=${round(matrix.scaleY)}`,
    `skew0=${round(matrix.rotateSkew0)}`,
    `skew1=${round(matrix.rotateSkew1)}`
  ].join(' | ');
}

function extractAttribute(tag, name) {
  return String(tag || '').match(new RegExp(`${name}="([^"]*)"`))?.[1] || '';
}

function round(value) {
  return Number.isFinite(value) ? Number(value.toFixed(5)) : value;
}
