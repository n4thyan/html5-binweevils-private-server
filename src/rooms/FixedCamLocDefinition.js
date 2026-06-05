import {
  FIXED_CAM_OPTIONAL_LOC_ATTRIBUTES,
  FIXED_CAM_REQUIRED_LOC_ATTRIBUTES,
  FIXED_CAM_XML_CHILD_GROUPS,
  LOC_TYPE_IDS,
  isFixedCamLocType
} from './FixedCamRoomSourceMap.js';

export function parseLocAttributes(xmlText) {
  const source = String(xmlText ?? '');
  const openTag = source.match(/<\s*(?:loc|location)\b([^>]*)>/i);
  if (!openTag) {
    return Object.freeze({ ok: false, issues: Object.freeze(['No <loc> or <location> opening tag found.']), attributes: Object.freeze({}) });
  }

  const attributes = {};
  const attrText = openTag[1];
  const attrPattern = /([:\w-]+)\s*=\s*("([^"]*)"|'([^']*)')/g;
  let match;
  while ((match = attrPattern.exec(attrText)) != null) {
    attributes[match[1]] = match[3] ?? match[4] ?? '';
  }

  return Object.freeze({ ok: true, issues: Object.freeze([]), attributes: Object.freeze(attributes) });
}

export function parseNumberList(value) {
  if (value == null || String(value).trim() === '') return Object.freeze([]);
  return Object.freeze(String(value).split(',').map((part) => Number(part.trim())));
}

export function parseBoolFlag(value) {
  return String(value ?? '').toLowerCase() === 'yes' || String(value ?? '').toLowerCase() === 'true';
}

export function countLocChildGroups(xmlText) {
  const source = String(xmlText ?? '');
  const names = [
    ...FIXED_CAM_XML_CHILD_GROUPS.fixedCamSpecific,
    ...FIXED_CAM_XML_CHILD_GROUPS.shared
  ];
  const counts = {};

  for (const name of names) {
    const pattern = new RegExp(`<\\s*${escapeRegExp(name)}\\b`, 'gi');
    counts[name] = (source.match(pattern) ?? []).length;
  }

  return Object.freeze(counts);
}

export function normaliseFixedCamLocDefinition(xmlText) {
  const parsed = parseLocAttributes(xmlText);
  if (!parsed.ok) {
    return Object.freeze({ ok: false, issues: parsed.issues, definition: null, childCounts: Object.freeze({}) });
  }

  const attr = parsed.attributes;
  const issues = [];

  for (const required of FIXED_CAM_REQUIRED_LOC_ATTRIBUTES) {
    if (!(required in attr) || String(attr[required]).trim() === '') {
      issues.push(`Missing required FixedCam loc attribute: ${required}`);
    }
  }

  if ('type' in attr && !isFixedCamLocType(attr.type)) {
    issues.push(`Location type is ${attr.type}, expected FixedCam type ${LOC_TYPE_IDS.FIXEDCAM}.`);
  }

  const childCounts = countLocChildGroups(xmlText);

  const definition = Object.freeze({
    id: Number(attr.id),
    name: attr.name ?? '',
    type: Number(attr.type),
    isFixedCam: isFixedCamLocType(attr.type),
    weevilScale: Number(attr.weevilScale),
    camPos: parseNumberList(attr.camPos),
    camAim: parseNumberList(attr.camAim),
    entryPos: parseNumberList(attr.entryPos),
    entryDir: Number(attr.entryDir),
    boundType: attr.boundType ?? '',
    boundary: parseNumberList(attr.boundary),
    inventory: attr.inventory === '' ? null : attr.inventory ?? null,
    playList: attr.playList === '' ? null : attr.playList ?? null,
    flags: Object.freeze({
      clickAnywhere: parseBoolFlag(attr.clickAnywhere),
      slippery: parseBoolFlag(attr.slippery),
      upSideDown: parseBoolFlag(attr.upSideDown),
      specialColours: parseBoolFlag(attr.specialColours),
      maintainY: parseBoolFlag(attr.maintainY),
      roomEvents: parseBoolFlag(attr.roomEvents),
      noZoom: parseBoolFlag(attr.noZoom)
    }),
    timerID: Number(attr.timerID ?? 0) || 0,
    rawAttributes: attr
  });

  return Object.freeze({
    ok: issues.length === 0,
    issues: Object.freeze(issues),
    definition,
    childCounts,
    audit: Object.freeze({
      hasObjects: childCounts.object > 0,
      hasDoors: childCounts.door > 0,
      hasWalkMasks: childCounts.walkMask > 0,
      hasNoGoAreas: childCounts.noGoArea > 0,
      hasCtas: childCounts.cta > 0,
      optionalAttributesPresent: Object.freeze(FIXED_CAM_OPTIONAL_LOC_ATTRIBUTES.filter((name) => name in attr))
    })
  });
}

export function scoreFixedCamFirstRoomCandidate(auditResult) {
  if (!auditResult?.ok || !auditResult.definition?.isFixedCam) return 0;

  let score = 0;
  const childCounts = auditResult.childCounts;
  const flags = auditResult.definition.flags;

  score += 20;
  if (childCounts.object > 0) score += 10;
  if (childCounts.door > 0) score += 8;
  if (childCounts.walkMask > 0) score += 8;
  if (childCounts.noGoArea > 0) score += 6;
  if (childCounts.cta > 0) score += 4;
  if (!flags.upSideDown) score += 4;
  if (!flags.slippery) score += 4;
  if (!flags.roomEvents) score += 4;
  if (auditResult.definition.boundType === 'rect') score += 3;

  return score;
}

export function createFixedCamCandidateSummary(xmlText) {
  const audit = normaliseFixedCamLocDefinition(xmlText);
  return Object.freeze({
    ...audit,
    score: scoreFixedCamFirstRoomCandidate(audit)
  });
}

function escapeRegExp(value) {
  return String(value).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
