import { readFile } from 'node:fs/promises';
import path from 'node:path';

import { RUMS_COVE_EXPORT_ROOT } from '../src/rooms/RumsCoveExportAudit.js';
import {
  RUMS_COVE_SOURCE_CANDIDATE_FILES,
  formatActionScriptInspection,
  formatSymbolClassInspection,
  inspectActionScriptSource,
  inspectSymbolClassCsv
} from '../src/rooms/RumsCoveSourceCandidateInspect.js';

const repoRoot = process.cwd();
const exportRoot = path.resolve(repoRoot, RUMS_COVE_EXPORT_ROOT);

const sections = [];

for (const relativePath of RUMS_COVE_SOURCE_CANDIDATE_FILES) {
  const absolutePath = path.join(exportRoot, relativePath);
  let content;
  try {
    content = await readFile(absolutePath, 'utf8');
  } catch (error) {
    sections.push(`--- ${relativePath} ---\nmissing: ${error.code || error.message}`);
    continue;
  }

  if (relativePath.endsWith('symbols.csv')) {
    sections.push(formatSymbolClassInspection(inspectSymbolClassCsv(content)));
  } else if (relativePath.endsWith('.as')) {
    sections.push(formatActionScriptInspection(inspectActionScriptSource(relativePath, content)));
  } else {
    sections.push(`--- ${relativePath} ---\nread ${content.length} chars`);
  }
}

console.log(sections.join('\n\n'));
