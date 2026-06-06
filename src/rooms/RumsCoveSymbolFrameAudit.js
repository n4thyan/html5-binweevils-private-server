import { RUMS_COVE_EXPORT_ROOT } from './RumsCoveExportAudit.js';

export const RUMS_COVE_SYMBOL_AUDIT_LIMITS = Object.freeze({
  topSprites: 25,
  topShapes: 25,
  topScripts: 50,
  topButtons: 20,
  topImages: 20,
  keywordMatches: 80
});

export const RUMS_COVE_SYMBOL_AUDIT_KEYWORDS = Object.freeze([
  'rums',
  'airport',
  'pod',
  'video',
  'door',
  'exit',
  'entry',
  'walk',
  'mask',
  'hit',
  'click',
  'plane',
  'screen',
  'ad',
  'dynam'
]);

export function normaliseAuditPath(path) {
  return String(path || '').replaceAll('\\', '/').replace(/^\.\//, '');
}

export function createRumsCoveSymbolFrameAudit(fileEntries) {
  const entries = (fileEntries || [])
    .map((entry) => normaliseFileEntry(entry))
    .filter((entry) => entry.path);

  const sprites = entries.filter((entry) => entry.path.startsWith('sprites/'));
  const shapes = entries.filter((entry) => entry.path.startsWith('shapes/'));
  const scripts = entries.filter((entry) => entry.path.startsWith('scripts/'));
  const buttons = entries.filter((entry) => entry.path.startsWith('buttons/'));
  const images = entries.filter((entry) => entry.path.startsWith('images/'));
  const morphshapes = entries.filter((entry) => entry.path.startsWith('morphshapes/'));
  const frames = entries.filter((entry) => entry.path.startsWith('frames/'));
  const symbolClass = entries.filter((entry) => entry.path.startsWith('symbolClass/'));

  const keywordMatches = findKeywordMatches(entries, RUMS_COVE_SYMBOL_AUDIT_KEYWORDS);

  return Object.freeze({
    exportRoot: RUMS_COVE_EXPORT_ROOT,
    totalFiles: entries.length,
    counts: Object.freeze({
      frames: frames.length,
      sprites: sprites.length,
      shapes: shapes.length,
      scripts: scripts.length,
      buttons: buttons.length,
      images: images.length,
      morphshapes: morphshapes.length,
      symbolClass: symbolClass.length
    }),
    topSpritesBySize: Object.freeze(topBySize(sprites, RUMS_COVE_SYMBOL_AUDIT_LIMITS.topSprites)),
    topShapesBySize: Object.freeze(topBySize(shapes, RUMS_COVE_SYMBOL_AUDIT_LIMITS.topShapes)),
    topScriptsBySize: Object.freeze(topBySize(scripts, RUMS_COVE_SYMBOL_AUDIT_LIMITS.topScripts)),
    topButtonsBySize: Object.freeze(topBySize(buttons, RUMS_COVE_SYMBOL_AUDIT_LIMITS.topButtons)),
    topImagesBySize: Object.freeze(topBySize(images, RUMS_COVE_SYMBOL_AUDIT_LIMITS.topImages)),
    frameFiles: Object.freeze(frames.map((entry) => entry.path).sort()),
    symbolClassFiles: Object.freeze(symbolClass.map((entry) => entry.path).sort()),
    keywordMatches: Object.freeze(keywordMatches.slice(0, RUMS_COVE_SYMBOL_AUDIT_LIMITS.keywordMatches)),
    recommendedNextStep: chooseRecommendedNextStep({ sprites, shapes, scripts, symbolClass, keywordMatches })
  });
}

export function normaliseFileEntry(entry) {
  if (typeof entry === 'string') {
    return Object.freeze({ path: normaliseAuditPath(entry), size: 0 });
  }

  return Object.freeze({
    path: normaliseAuditPath(entry?.path),
    size: Number.isFinite(entry?.size) ? entry.size : 0
  });
}

export function topBySize(entries, limit) {
  return [...entries]
    .sort((a, b) => b.size - a.size || a.path.localeCompare(b.path))
    .slice(0, limit)
    .map((entry) => Object.freeze({ path: entry.path, size: entry.size }));
}

export function findKeywordMatches(entries, keywords) {
  const loweredKeywords = (keywords || []).map((keyword) => String(keyword).toLowerCase());

  return entries
    .filter((entry) => loweredKeywords.some((keyword) => entry.path.toLowerCase().includes(keyword)))
    .sort((a, b) => a.path.localeCompare(b.path))
    .map((entry) => Object.freeze({ path: entry.path, size: entry.size }));
}

export function chooseRecommendedNextStep({ sprites, shapes, scripts, symbolClass, keywordMatches }) {
  if (symbolClass.length > 0 && scripts.length > 0 && keywordMatches.length > 0) {
    return 'inspect-symbolClass-and-room-related-scripts';
  }

  if (sprites.length > 0 && shapes.length > 0) {
    return 'inspect-largest-sprites-and-shapes';
  }

  if (scripts.length > 0) {
    return 'inspect-room-scripts';
  }

  return 'collect-more-export-detail';
}

export function formatRumsCoveSymbolFrameAudit(audit) {
  const lines = [];
  lines.push('RumsCove symbol/frame audit');
  lines.push(`exportRoot: ${audit.exportRoot}`);
  lines.push(`totalFiles: ${audit.totalFiles}`);
  lines.push('counts:');

  for (const [key, value] of Object.entries(audit.counts)) {
    lines.push(`  ${key}: ${value}`);
  }

  appendSection(lines, 'frameFiles', audit.frameFiles, formatPathOnly);
  appendSection(lines, 'symbolClassFiles', audit.symbolClassFiles, formatPathOnly);
  appendSection(lines, 'topSpritesBySize', audit.topSpritesBySize, formatPathSize);
  appendSection(lines, 'topShapesBySize', audit.topShapesBySize, formatPathSize);
  appendSection(lines, 'topImagesBySize', audit.topImagesBySize, formatPathSize);
  appendSection(lines, 'topButtonsBySize', audit.topButtonsBySize, formatPathSize);
  appendSection(lines, 'topScriptsBySize', audit.topScriptsBySize, formatPathSize);
  appendSection(lines, 'keywordMatches', audit.keywordMatches, formatPathSize);

  lines.push(`recommendedNextStep: ${audit.recommendedNextStep}`);
  return lines.join('\n');
}

function appendSection(lines, title, values, formatter) {
  lines.push(`${title}:`);
  if (!values || values.length === 0) {
    lines.push('  (none)');
    return;
  }

  for (const value of values) {
    lines.push(`  ${formatter(value)}`);
  }
}

function formatPathOnly(path) {
  return path;
}

function formatPathSize(entry) {
  return `${entry.path} (${entry.size} bytes)`;
}
