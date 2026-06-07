import { RUMS_COVE_EXPORT_ROOT } from './RumsCoveExportAudit.js';

export const RUMS_COVE_SOURCE_CANDIDATE_FILES = Object.freeze([
  'symbolClass/symbols.csv',
  'scripts/RumsAirport_dynamAds.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/Door_002_71.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/Door_animated2_26.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/door1_76.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/door3_78.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/door4_80.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/door6_82.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/cafedooropenanim_18.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/plane_runway_anim_5.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/plane_takeoff_3.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/buildings_12.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/airport_23.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/remoteBack_31.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/remoteOverlay_74.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/overlay_70.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/podText_66.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/t_67.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/pipes_86.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/adBoard_right_16.as',
  'scripts/RumsAirport_dynamAds_videoPodv2_fla/yoghurtpot_tums_13.as'
]);

export const RUMS_COVE_SOURCE_CANDIDATE_SYMBOL_HINTS = Object.freeze([
  'RumsAirport_dynamAds_videoPodv2_fla.buildings_12',
  'RumsAirport_dynamAds_videoPodv2_fla.overlay_70',
  'RumsAirport_dynamAds_videoPodv2_fla.remoteBack_31',
  'RumsAirport_dynamAds_videoPodv2_fla.airport_23',
  'RumsAirport_dynamAds_videoPodv2_fla.yoghurtpot_tums_13',
  'RumsAirport_dynamAds_videoPodv2_fla.Door_002_71',
  'RumsAirport_dynamAds_videoPodv2_fla.Door_animated2_26',
  'RumsAirport_dynamAds_videoPodv2_fla.door1_76',
  'RumsAirport_dynamAds_videoPodv2_fla.door3_78',
  'RumsAirport_dynamAds_videoPodv2_fla.door4_80',
  'RumsAirport_dynamAds_videoPodv2_fla.door6_82',
  'RumsAirport_dynamAds_videoPodv2_fla.plane_runway_anim_5',
  'RumsAirport_dynamAds_videoPodv2_fla.plane_takeoff_3',
  'RumsAirport_dynamAds_videoPodv2_fla.podText_66',
  'RumsAirport_dynamAds_videoPodv2_fla.t_67'
]);

export function inspectActionScriptSource(relativePath, content) {
  const text = String(content || '');
  const lines = text.split(/\r?\n/);

  const packageMatch = text.match(/package\s+([^\s{]+)?/);
  const classMatch = text.match(/public\s+(?:dynamic\s+)?class\s+([A-Za-z0-9_]+)(?:\s+extends\s+([A-Za-z0-9_\.]+))?/);
  const imports = [...text.matchAll(/^\s*import\s+([^;]+);/gm)].map((match) => match[1]);
  const functions = [...text.matchAll(/(?:public|private|protected)?\s*function\s+([A-Za-z0-9_]+)\s*\(/g)].map((match) => match[1]);
  const timelineCalls = [...text.matchAll(/\b(stop|play|gotoAndStop|gotoAndPlay|addFrameScript|addEventListener|removeEventListener)\b/g)]
    .map((match) => match[1]);
  const childRefs = [...text.matchAll(/\b([A-Za-z_][A-Za-z0-9_]*)_(?:mc|btn|spr|txt)\b/g)]
    .map((match) => match[0]);

  return Object.freeze({
    path: relativePath,
    lineCount: lines.length,
    packageName: packageMatch?.[1] || '',
    className: classMatch?.[1] || '',
    extendsName: classMatch?.[2] || '',
    imports: Object.freeze(unique(imports)),
    functions: Object.freeze(unique(functions)),
    timelineCalls: Object.freeze(unique(timelineCalls)),
    childRefs: Object.freeze(unique(childRefs).slice(0, 30)),
    preview: Object.freeze(lines.slice(0, 18))
  });
}

export function inspectSymbolClassCsv(content, symbolHints = RUMS_COVE_SOURCE_CANDIDATE_SYMBOL_HINTS) {
  const text = String(content || '');
  const lines = text.split(/\r?\n/).filter(Boolean);
  const lowerHints = symbolHints.map((hint) => hint.toLowerCase());

  const matches = lines.filter((line) => {
    const lower = line.toLowerCase();
    return lowerHints.some((hint) => lower.includes(hint));
  });

  return Object.freeze({
    lineCount: lines.length,
    matchedLineCount: matches.length,
    matches: Object.freeze(matches)
  });
}

export function formatActionScriptInspection(inspection) {
  const lines = [];
  lines.push(`--- ${inspection.path} ---`);
  lines.push(`lines: ${inspection.lineCount}`);
  lines.push(`package: ${inspection.packageName || '(none)'}`);
  lines.push(`class: ${inspection.className || '(none)'}`);
  lines.push(`extends: ${inspection.extendsName || '(none)'}`);
  lines.push(`imports: ${inspection.imports.join(', ') || '(none)'}`);
  lines.push(`functions: ${inspection.functions.join(', ') || '(none)'}`);
  lines.push(`timelineCalls: ${inspection.timelineCalls.join(', ') || '(none)'}`);
  lines.push(`childRefs: ${inspection.childRefs.join(', ') || '(none)'}`);
  lines.push('preview:');
  for (const previewLine of inspection.preview) {
    lines.push(`  ${previewLine}`);
  }
  return lines.join('\n');
}

export function formatSymbolClassInspection(inspection) {
  const lines = [];
  lines.push('--- symbolClass/symbols.csv ---');
  lines.push(`lines: ${inspection.lineCount}`);
  lines.push(`matched candidate lines: ${inspection.matchedLineCount}`);
  for (const match of inspection.matches) {
    lines.push(`  ${match}`);
  }
  return lines.join('\n');
}

export function getRumsCoveSourceCandidateInspectSummary() {
  return Object.freeze({
    exportRoot: RUMS_COVE_EXPORT_ROOT,
    candidateFileCount: RUMS_COVE_SOURCE_CANDIDATE_FILES.length,
    symbolHintCount: RUMS_COVE_SOURCE_CANDIDATE_SYMBOL_HINTS.length,
    nextAction: 'read-candidate-source-files'
  });
}

function unique(values) {
  return [...new Set(values.filter(Boolean))];
}
