import assert from 'node:assert/strict';
import { access, stat } from 'node:fs/promises';

import { CORE_UI_ASSET_PROBE_PLAN } from '../src/assets/CoreUiAssetProbePlan.js';

for (const entry of CORE_UI_ASSET_PROBE_PLAN) {
  await access(entry.expectedPath);
  const info = await stat(entry.expectedPath);
  assert.equal(info.isFile(), true, `${entry.key} should point to a file`);
  assert.ok(info.size > 0, `${entry.key} should not be empty`);
  assert.ok(entry.expectedPath.endsWith('.svg'), `${entry.key} should point to SVG export`);
  console.log(`${entry.key}: ${entry.expectedPath} (${info.size} bytes)`);
}

console.log('core UI asset file existence smoke test passed');
