import assert from 'node:assert/strict';

import {
  MAIN_SHELL_RUMS_COVE_ASSETS,
  MAIN_SHELL_RUMS_COVE_CANVAS,
  MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES,
  MAIN_SHELL_RUMS_COVE_VIEWPORT_CALIBRATION,
  MAIN_SHELL_RUMS_COVE_WEEVIL_MAPPING,
  assertMainShellRumsCoveCompositionPolicy,
  getMainShellRumsCoveCompositionSummary
} from '../src/ui/MainShellRumsCoveCompositionCalibration.js';

assert.equal(MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.system, 'main shell + RumsCove debug composition');
assert.equal(MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.status, 'debug-composition-proof');
assert.equal(MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.mayUseFullFramePngAsFinalShell, false);
assert.equal(MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.mayUseFullFramePngAsTemporaryProbe, true);
assert.equal(MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.finalShellMustUseSourceSpritesAndMasks, true);
assert.equal(MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.roomMustRenderBehindSlimeFrame, true);
assert.equal(MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.playercardAssetsAreSeparateCoreTarget, true);
assert.equal(assertMainShellRumsCoveCompositionPolicy(), true);

assert.ok(MAIN_SHELL_RUMS_COVE_ASSETS.shellFramePreview.endsWith('mainDEV661.swf/frames/1.png'));
assert.ok(MAIN_SHELL_RUMS_COVE_ASSETS.roomPreview.endsWith('RumsAirport_dynamAds_videoPodv2_release/frames/1.png'));
assert.ok(MAIN_SHELL_RUMS_COVE_ASSETS.shellSourceCandidateKeys.includes('fullMainAlreadyOpenFrame'));
assert.ok(MAIN_SHELL_RUMS_COVE_ASSETS.shellSourceCandidateKeys.includes('fullMainShellSprite'));

assert.equal(MAIN_SHELL_RUMS_COVE_CANVAS.shellWidth, 940);
assert.equal(MAIN_SHELL_RUMS_COVE_CANVAS.shellHeight, 653);
assert.equal(MAIN_SHELL_RUMS_COVE_CANVAS.roomSourceWidth, 614);
assert.equal(MAIN_SHELL_RUMS_COVE_CANVAS.roomSourceHeight, 366);

assert.equal(MAIN_SHELL_RUMS_COVE_VIEWPORT_CALIBRATION.x, 89);
assert.equal(MAIN_SHELL_RUMS_COVE_VIEWPORT_CALIBRATION.y, 52);
assert.equal(MAIN_SHELL_RUMS_COVE_VIEWPORT_CALIBRATION.width, 757);
assert.equal(MAIN_SHELL_RUMS_COVE_VIEWPORT_CALIBRATION.height, 486);
assert.ok(MAIN_SHELL_RUMS_COVE_VIEWPORT_CALIBRATION.note.includes('not final mask'));

assert.equal(MAIN_SHELL_RUMS_COVE_WEEVIL_MAPPING.rumsProbeX, 292);
assert.equal(MAIN_SHELL_RUMS_COVE_WEEVIL_MAPPING.rumsProbeY, 314);
assert.equal(MAIN_SHELL_RUMS_COVE_WEEVIL_MAPPING.rumsProbeDisplayWidth, 66);
assert.equal(MAIN_SHELL_RUMS_COVE_WEEVIL_MAPPING.rumsProbeDisplayHeight, 66);
assert.equal(MAIN_SHELL_RUMS_COVE_WEEVIL_MAPPING.sourceWeevilScale, 0.18);

const summary = getMainShellRumsCoveCompositionSummary();
assert.equal(summary.system, MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.system);
assert.equal(summary.status, 'debug-composition-proof');
assert.equal(summary.viewport.width, 757);
assert.ok(summary.nextAction.includes('exact main shell symbols'));

console.log('main shell Rums Cove composition smoke test passed');
console.log(`${summary.system} / ${summary.status} / viewport ${summary.viewport.width}x${summary.viewport.height}`);
