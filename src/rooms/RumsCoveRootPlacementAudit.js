import { RUMS_COVE_EXPORT_ROOT } from './RumsCoveExportAudit.js';
import { RUMS_COVE_ROOT_CANDIDATE } from './RumsCoveCandidateRoleMap.js';

export const RUMS_COVE_ROOT_PLACEMENT_FILES = Object.freeze({
  rootScript: 'scripts/RumsAirport_dynamAds.as',
  symbolClass: 'symbolClass/symbols.csv',
  framePreview: 'frames/1.png'
});

export const RUMS_COVE_ROOT_PLACEMENT_TARGETS = Object.freeze([
  'buildings_12',
  'airport_23',
  'yoghurtpot_tums_13',
  'remoteBack_31',
  'overlay_70',
  'Door_002_71',
  'door1_76',
  'door3_78',
  'door4_80',
  'door6_82',
  'floorClickArea_btn'
]);

export function inspectRootPlacementSource({ rootScriptText = '', symbolClassText = '', frameFileNames = [] } = {}) {
  const rootVars = extractPublicVars(rootScriptText);
  const constructorLines = extractConstructorPreview(rootScriptText, RUMS_COVE_ROOT_CANDIDATE.className, 80);
  const addFrameScriptLines = extractMatchingLines(rootScriptText, 'addFrameScript');
  const timelineCallLines = extractTimelineCallLines(rootScriptText);
  const symbolMatches = findSymbolClassTargets(symbolClassText, RUMS_COVE_ROOT_PLACEMENT_TARGETS);
  const hasOnlyPngFramePreview = frameFileNames.length > 0 && frameFileNames.every((name) => name.endsWith('.png'));

  return Object.freeze({
    exportRoot: RUMS_COVE_EXPORT_ROOT,
    rootClass: RUMS_COVE_ROOT_CANDIDATE.className,
    rootVarCount: rootVars.length,
    rootVars: Object.freeze(rootVars),
    constructorPreview: Object.freeze(constructorLines),
    addFrameScriptLines: Object.freeze(addFrameScriptLines),
    timelineCallLines: Object.freeze(timelineCallLines),
    symbolMatchCount: symbolMatches.length,
    symbolMatches: Object.freeze(symbolMatches),
    frameFileNames: Object.freeze([...frameFileNames]),
    hasOnlyPngFramePreview,
    exactRootPlacementAvailableFromCurrentDump: false,
    recommendedNextStep: 'extract-root-timeline-placeobject-transforms-or-use-ffdec-xml-export'
  });
}

export function extractPublicVars(text) {
  return [...String(text || '').matchAll(/public\s+var\s+([A-Za-z0-9_]+)\s*:\s*([A-Za-z0-9_\.]+)/g)]
    .map((match) => Object.freeze({ name: match[1], type: match[2] }));
}

export function extractConstructorPreview(text, className, maxLines = 80) {
  const lines = String(text || '').split(/\r?\n/);
  const start = lines.findIndex((line) => line.includes(`function ${className}(`));
  if (start < 0) return [];
  return lines.slice(start, Math.min(lines.length, start + maxLines));
}

export function extractMatchingLines(text, needle) {
  return String(text || '').split(/\r?\n/)
    .map((line, index) => Object.freeze({ line: index + 1, text: line.trim() }))
    .filter((entry) => entry.text.includes(needle));
}

export function extractTimelineCallLines(text) {
  const calls = ['gotoAndStop', 'gotoAndPlay', 'play', 'stop', 'addEventListener'];
  return String(text || '').split(/\r?\n/)
    .map((line, index) => Object.freeze({ line: index + 1, text: line.trim() }))
    .filter((entry) => calls.some((call) => entry.text.includes(call)));
}

export function findSymbolClassTargets(symbolClassText, targets) {
  const lowerTargets = targets.map((target) => target.toLowerCase());
  return String(symbolClassText || '').split(/\r?\n/)
    .filter(Boolean)
    .filter((line) => lowerTargets.some((target) => line.toLowerCase().includes(target)))
    .map((line) => Object.freeze({ raw: line }));
}

export function formatRootPlacementAudit(audit) {
  const lines = [];
  lines.push('RumsCove root placement audit');
  lines.push(`exportRoot: ${audit.exportRoot}`);
  lines.push(`rootClass: ${audit.rootClass}`);
  lines.push(`rootVarCount: ${audit.rootVarCount}`);
  lines.push('rootVars:');
  for (const rootVar of audit.rootVars) lines.push(`  ${rootVar.name}: ${rootVar.type}`);
  lines.push('symbolMatches:');
  for (const match of audit.symbolMatches) lines.push(`  ${match.raw}`);
  lines.push('frameFiles:');
  for (const frame of audit.frameFileNames) lines.push(`  ${frame}`);
  lines.push(`hasOnlyPngFramePreview: ${audit.hasOnlyPngFramePreview}`);
  lines.push(`exactRootPlacementAvailableFromCurrentDump: ${audit.exactRootPlacementAvailableFromCurrentDump}`);
  lines.push('constructorPreview:');
  for (const line of audit.constructorPreview) lines.push(`  ${line}`);
  lines.push('timelineCallLines:');
  for (const entry of audit.timelineCallLines) lines.push(`  ${entry.line}: ${entry.text}`);
  lines.push(`recommendedNextStep: ${audit.recommendedNextStep}`);
  return lines.join('\n');
}
