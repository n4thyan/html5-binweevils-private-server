import { readdir, readFile } from 'node:fs/promises';
import path from 'node:path';

import { RUMS_COVE_EXPORT_ROOT } from '../src/rooms/RumsCoveExportAudit.js';
import {
  RUMS_COVE_ROOT_PLACEMENT_FILES,
  formatRootPlacementAudit,
  inspectRootPlacementSource
} from '../src/rooms/RumsCoveRootPlacementAudit.js';

const repoRoot = process.cwd();
const exportRoot = path.resolve(repoRoot, RUMS_COVE_EXPORT_ROOT);

const rootScriptText = await readText(path.join(exportRoot, RUMS_COVE_ROOT_PLACEMENT_FILES.rootScript));
const symbolClassText = await readText(path.join(exportRoot, RUMS_COVE_ROOT_PLACEMENT_FILES.symbolClass));
const frameFileNames = await readFrameFileNames(path.join(exportRoot, 'frames'));

const audit = inspectRootPlacementSource({
  rootScriptText,
  symbolClassText,
  frameFileNames
});

console.log(formatRootPlacementAudit(audit));

async function readText(filePath) {
  try {
    return await readFile(filePath, 'utf8');
  } catch (error) {
    return `/* missing ${error.code || error.message} */`;
  }
}

async function readFrameFileNames(folderPath) {
  try {
    return (await readdir(folderPath, { withFileTypes: true }))
      .filter((entry) => entry.isFile())
      .map((entry) => entry.name)
      .sort();
  } catch (error) {
    return [];
  }
}
