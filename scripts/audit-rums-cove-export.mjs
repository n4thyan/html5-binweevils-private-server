import { readdir } from 'node:fs/promises';
import path from 'node:path';

import {
  RUMS_COVE_EXPORT_ROOT,
  auditRumsCoveExportRelativeFiles,
  formatRumsCoveExportAudit
} from '../src/rooms/RumsCoveExportAudit.js';

const repoRoot = process.cwd();
const exportRoot = path.resolve(repoRoot, RUMS_COVE_EXPORT_ROOT);

const relativeFiles = await collectRelativeFiles(exportRoot);
const audit = auditRumsCoveExportRelativeFiles(relativeFiles);

console.log(formatRumsCoveExportAudit(audit));

async function collectRelativeFiles(root) {
  const files = [];

  async function walk(dir) {
    let entries;
    try {
      entries = await readdir(dir, { withFileTypes: true });
    } catch (error) {
      if (error && error.code === 'ENOENT') {
        return;
      }
      throw error;
    }

    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        await walk(fullPath);
      } else if (entry.isFile()) {
        files.push(path.relative(root, fullPath).replaceAll(path.sep, '/'));
      }
    }
  }

  await walk(root);
  return files.sort();
}
