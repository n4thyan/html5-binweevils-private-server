import { readFile } from 'node:fs/promises';
import path from 'node:path';

import { RUMS_COVE_EXPORT_ROOT } from '../src/rooms/RumsCoveExportAudit.js';
import {
  RUMS_COVE_SVG_METADATA_TARGETS,
  formatSvgMetadata,
  inspectSvgMetadata
} from '../src/rooms/RumsCoveSvgMetadataAudit.js';

const repoRoot = process.cwd();
const exportRoot = path.resolve(repoRoot, RUMS_COVE_EXPORT_ROOT);
const sections = [];

for (const target of RUMS_COVE_SVG_METADATA_TARGETS) {
  const absolutePath = path.join(exportRoot, target.svgPath);
  let svgText;
  try {
    svgText = await readFile(absolutePath, 'utf8');
  } catch (error) {
    sections.push(`--- ${target.svgPath} ---\nmissing: ${error.code || error.message}`);
    continue;
  }

  sections.push([
    `${target.key} / ${target.className} / symbol ${target.symbolId}`,
    formatSvgMetadata(inspectSvgMetadata(target.svgPath, svgText))
  ].join('\n'));
}

console.log(sections.join('\n\n'));
