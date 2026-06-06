import { readdir, stat } from 'node:fs/promises';
import path from 'node:path';

import { RUMS_COVE_EXPORT_ROOT } from '../src/rooms/RumsCoveExportAudit.js';
import {
  createRumsCoveSymbolFrameAudit,
  formatRumsCoveSymbolFrameAudit
} from '../src/rooms/RumsCoveSymbolFrameAudit.js';

const repoRoot = process.cwd();
const exportRoot = path.resolve(repoRoot, RUMS_COVE_EXPORT_ROOT);

const fileEntries = await collectFileEntries(exportRoot);
const audit = createRumsCoveSymbolFrameAudit(fileEntries);

console.log(formatRumsCoveSymbolFrameAudit(audit));

async function collectFileEntries(root) {
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
        const fileStat = await stat(fullPath);
        files.push({
          path: path.relative(root, fullPath).replaceAll(path.sep, '/'),
          size: fileStat.size
        });
      }
    }
  }

  await walk(root);
  return files.sort((a, b) => a.path.localeCompare(b.path));
}
