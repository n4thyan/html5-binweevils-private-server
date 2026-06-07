import assert from 'node:assert/strict';

import {
  RUMS_COVE_DEFERRED_ANIMATION_CANDIDATES,
  RUMS_COVE_DOOR_CANDIDATES,
  RUMS_COVE_DYNAMIC_TEXT_AD_CANDIDATES,
  RUMS_COVE_MAJOR_VISUAL_CANDIDATES,
  RUMS_COVE_REBUILD_PASS_ORDER,
  RUMS_COVE_ROOT_CANDIDATE,
  RUMS_COVE_SYMBOL_CLASS_CANDIDATES,
  getRumsCoveCandidateRoleSummary
} from '../src/rooms/RumsCoveCandidateRoleMap.js';

assert.equal(RUMS_COVE_ROOT_CANDIDATE.className, 'RumsAirport_dynamAds');
assert.equal(RUMS_COVE_ROOT_CANDIDATE.extendsName, 'MovieClip');
assert.ok(RUMS_COVE_ROOT_CANDIDATE.childRefs.includes('floorClickArea_btn'));
assert.ok(RUMS_COVE_ROOT_CANDIDATE.childRefs.includes('door6_mc'));
assert.ok(RUMS_COVE_ROOT_CANDIDATE.functions.includes('onPodClick'));
assert.ok(RUMS_COVE_ROOT_CANDIDATE.timelineCalls.includes('gotoAndPlay'));

assert.equal(RUMS_COVE_SYMBOL_CLASS_CANDIDATES.length, 15);
assert.ok(RUMS_COVE_SYMBOL_CLASS_CANDIDATES.some((candidate) => candidate.symbolId === 361 && candidate.className.endsWith('buildings_12')));
assert.ok(RUMS_COVE_SYMBOL_CLASS_CANDIDATES.some((candidate) => candidate.symbolId === 179 && candidate.className.endsWith('Door_002_71')));

assert.ok(RUMS_COVE_MAJOR_VISUAL_CANDIDATES.some((candidate) => candidate.key === 'buildings' && candidate.childRefs.includes('airport')));
assert.ok(RUMS_COVE_MAJOR_VISUAL_CANDIDATES.some((candidate) => candidate.key === 'overlay' && candidate.childRefs.includes('remoteBack')));
assert.ok(RUMS_COVE_MAJOR_VISUAL_CANDIDATES.every((candidate) => candidate.spritePath.startsWith('sprites/DefineSprite_')));

assert.equal(RUMS_COVE_DOOR_CANDIDATES.length, 6);
assert.ok(RUMS_COVE_DOOR_CANDIDATES.every((candidate) => candidate.role.includes('door')));
assert.ok(RUMS_COVE_DOOR_CANDIDATES.some((candidate) => candidate.key === 'door6' && candidate.childRefs.includes('boothOverlay')));
assert.ok(RUMS_COVE_DOOR_CANDIDATES.some((candidate) => candidate.key === 'door002' && candidate.frameScripts.includes(7)));

assert.ok(RUMS_COVE_DYNAMIC_TEXT_AD_CANDIDATES.some((candidate) => candidate.key === 't' && candidate.childRefs.includes('message')));
assert.ok(RUMS_COVE_DYNAMIC_TEXT_AD_CANDIDATES.some((candidate) => candidate.key === 'adBoardRight' && candidate.childRefs.includes('adHolder_spr')));

assert.equal(RUMS_COVE_DEFERRED_ANIMATION_CANDIDATES.length, 3);
assert.ok(RUMS_COVE_DEFERRED_ANIMATION_CANDIDATES.some((candidate) => candidate.key === 'planeTakeoff'));
assert.ok(RUMS_COVE_REBUILD_PASS_ORDER.includes('replace-frame-preview-with-layered-source-room'));

const summary = getRumsCoveCandidateRoleSummary();
assert.equal(summary.rootClass, 'RumsAirport_dynamAds');
assert.equal(summary.symbolClassCandidateCount, 15);
assert.equal(summary.majorVisualCount, RUMS_COVE_MAJOR_VISUAL_CANDIDATES.length);
assert.equal(summary.doorCount, 6);
assert.equal(summary.nextAction, 'major-static-visual-layer-probe');

console.log('rums-cove candidate role map smoke test passed');
console.log(`${summary.rootClass} / ${summary.majorVisualCount} major visuals / ${summary.doorCount} doors / next=${summary.nextAction}`);
