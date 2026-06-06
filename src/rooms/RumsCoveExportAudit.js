import { RUMS_COVE_EXPORT_FAMILY } from './RumsCoveSourceRebuildPlan.js';

export const RUMS_COVE_EXPORT_ROOT = 'reference/rooms/RumsAirport_dynamAds_videoPodv2_release/RumsAirport_dynamAds_videoPodv2_release';

export const RUMS_COVE_EXPECTED_EXPORT_FOLDERS = Object.freeze([
  'buttons',
  'fonts',
  'frames',
  'images',
  'morphshapes',
  'scripts',
  'shapes',
  'sounds',
  'sprites',
  'symbolClass',
  'texts'
]);

export const RUMS_COVE_REBUILD_FOLDER_ROLES = Object.freeze({
  frames: 'debug/comparison renders only; not final room structure',
  images: 'original bitmap exports if the SWF used embedded bitmaps',
  shapes: 'source vector shapes for final room layer rebuild',
  sprites: 'source display objects/composites for final room layer rebuild',
  morphshapes: 'source vector morphs if used by room animations',
  scripts: 'room class/timeline behaviour and symbol class names where available',
  symbolClass: 'symbol id to class/name mapping where exported',
  sounds: 'original room sounds if present',
  texts: 'source text fields if present',
  buttons: 'interactive button symbols if present',
  fonts: 'embedded font exports if present'
});

export function normaliseExportRelativePath(path) {
  return String(path || '').replaceAll('\\', '/').replace(/^\.\//, '');
}

export function getTopLevelExportFolder(path) {
  const normalised = normaliseExportRelativePath(path);
  return normalised.split('/').filter(Boolean)[0] || '';
}

export function getRumsCoveExpectedExportFolders() {
  return [...RUMS_COVE_EXPECTED_EXPORT_FOLDERS];
}

export function createEmptyRumsCoveExportAudit() {
  const folderCounts = Object.fromEntries(RUMS_COVE_EXPECTED_EXPORT_FOLDERS.map((folder) => [folder, 0]));

  return {
    exportRoot: RUMS_COVE_EXPORT_ROOT,
    locDefinitionRoomBg: RUMS_COVE_EXPORT_FAMILY.locDefinitionRoomBg,
    uploadedExportFamily: RUMS_COVE_EXPORT_FAMILY.uploadedExportFamily,
    totalFiles: 0,
    folderCounts,
    missingExpectedFolders: [...RUMS_COVE_EXPECTED_EXPORT_FOLDERS],
    presentExpectedFolders: [],
    extraTopLevelFolders: [],
    hasFramePreview: false,
    hasSprites: false,
    hasShapes: false,
    hasImages: false,
    hasScripts: false,
    recommendedNextStep: 'extract or locate the room export folder before rebuilding layers'
  };
}

export function auditRumsCoveExportRelativeFiles(relativeFilePaths) {
  const audit = createEmptyRumsCoveExportAudit();
  const topLevelFolders = new Set();

  for (const rawPath of relativeFilePaths || []) {
    const path = normaliseExportRelativePath(rawPath);
    if (!path) continue;

    audit.totalFiles += 1;

    const topFolder = getTopLevelExportFolder(path);
    if (topFolder) topLevelFolders.add(topFolder);

    if (Object.prototype.hasOwnProperty.call(audit.folderCounts, topFolder)) {
      audit.folderCounts[topFolder] += 1;
    }

    if (path === 'frames/1.png') {
      audit.hasFramePreview = true;
    }
  }

  audit.presentExpectedFolders = RUMS_COVE_EXPECTED_EXPORT_FOLDERS.filter((folder) => audit.folderCounts[folder] > 0);
  audit.missingExpectedFolders = RUMS_COVE_EXPECTED_EXPORT_FOLDERS.filter((folder) => audit.folderCounts[folder] === 0);
  audit.extraTopLevelFolders = [...topLevelFolders]
    .filter((folder) => !RUMS_COVE_EXPECTED_EXPORT_FOLDERS.includes(folder))
    .sort();

  audit.hasSprites = audit.folderCounts.sprites > 0;
  audit.hasShapes = audit.folderCounts.shapes > 0;
  audit.hasImages = audit.folderCounts.images > 0;
  audit.hasScripts = audit.folderCounts.scripts > 0;

  if (audit.hasSprites || audit.hasShapes || audit.hasImages) {
    audit.recommendedNextStep = 'list-symbols-and-frame-elements';
  } else if (audit.hasFramePreview) {
    audit.recommendedNextStep = 'frame preview exists, but source folders still need locating for final rebuild';
  }

  return Object.freeze({
    ...audit,
    folderCounts: Object.freeze({ ...audit.folderCounts }),
    missingExpectedFolders: Object.freeze([...audit.missingExpectedFolders]),
    presentExpectedFolders: Object.freeze([...audit.presentExpectedFolders]),
    extraTopLevelFolders: Object.freeze([...audit.extraTopLevelFolders])
  });
}

export function formatRumsCoveExportAudit(audit) {
  const lines = [];
  lines.push('RumsCove export audit');
  lines.push(`exportRoot: ${audit.exportRoot}`);
  lines.push(`locDefinitionRoomBg: ${audit.locDefinitionRoomBg}`);
  lines.push(`uploadedExportFamily: ${audit.uploadedExportFamily}`);
  lines.push(`totalFiles: ${audit.totalFiles}`);
  lines.push('folderCounts:');

  for (const folder of RUMS_COVE_EXPECTED_EXPORT_FOLDERS) {
    const role = RUMS_COVE_REBUILD_FOLDER_ROLES[folder] || 'unmapped role';
    lines.push(`  ${folder}: ${audit.folderCounts[folder]} - ${role}`);
  }

  lines.push(`hasFramePreview: ${audit.hasFramePreview}`);
  lines.push(`presentExpectedFolders: ${audit.presentExpectedFolders.join(', ') || '(none)'}`);
  lines.push(`missingExpectedFolders: ${audit.missingExpectedFolders.join(', ') || '(none)'}`);
  lines.push(`extraTopLevelFolders: ${audit.extraTopLevelFolders.join(', ') || '(none)'}`);
  lines.push(`recommendedNextStep: ${audit.recommendedNextStep}`);
  return lines.join('\n');
}
