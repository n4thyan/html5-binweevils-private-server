import assert from 'node:assert/strict';

import {
  countLocChildGroups,
  createFixedCamCandidateSummary,
  normaliseFixedCamLocDefinition,
  parseBoolFlag,
  parseLocAttributes,
  parseNumberList,
  scoreFixedCamFirstRoomCandidate
} from '../src/rooms/FixedCamLocDefinition.js';

const sampleFixedCam = `
<loc id="42" name="Debug Fixed Room" type="2" weevilScale="0.14" camPos="-138,230,248" camAim="157,32,582" entryPos="25,350" entryDir="180" boundType="rect" boundary="-240,-160,520,360" inventory="" playList="" clickAnywhere="no" slippery="no" upSideDown="no" specialColours="no" maintainY="no" roomEvents="no" timerID="0" noZoom="yes">
  <asset url="rooms/debug.swf" />
  <object name="table_mc" x="100" y="0" z="220" />
  <door id="1" toLoc="43" toDoor="2" x1="10" z1="20" x2="40" z2="60" y="0" y2="0" entryDir="180" />
  <walkMask name="floorMask_mc" />
  <noGoArea type="rect" x="5" z="6" w="7" h="8" />
  <cta id="1" x="100" z="200" />
</loc>`;

const parsed = parseLocAttributes(sampleFixedCam);
assert.equal(parsed.ok, true);
assert.equal(parsed.attributes.id, '42');
assert.equal(parsed.attributes.name, 'Debug Fixed Room');
assert.equal(parsed.attributes.type, '2');

assert.deepEqual(parseNumberList('-138,230,248'), [-138, 230, 248]);
assert.deepEqual(parseNumberList(''), []);
assert.equal(parseBoolFlag('yes'), true);
assert.equal(parseBoolFlag('true'), true);
assert.equal(parseBoolFlag('no'), false);

const counts = countLocChildGroups(sampleFixedCam);
assert.equal(counts.object, 1);
assert.equal(counts.door, 1);
assert.equal(counts.walkMask, 1);
assert.equal(counts.noGoArea, 1);
assert.equal(counts.cta, 1);

const audit = normaliseFixedCamLocDefinition(sampleFixedCam);
assert.equal(audit.ok, true, audit.issues.join('\n'));
assert.equal(audit.definition.id, 42);
assert.equal(audit.definition.name, 'Debug Fixed Room');
assert.equal(audit.definition.type, 2);
assert.equal(audit.definition.isFixedCam, true);
assert.equal(audit.definition.weevilScale, 0.14);
assert.deepEqual(audit.definition.camPos, [-138, 230, 248]);
assert.deepEqual(audit.definition.camAim, [157, 32, 582]);
assert.deepEqual(audit.definition.entryPos, [25, 350]);
assert.deepEqual(audit.definition.boundary, [-240, -160, 520, 360]);
assert.equal(audit.definition.inventory, null);
assert.equal(audit.definition.flags.noZoom, true);
assert.equal(audit.audit.hasObjects, true);
assert.equal(audit.audit.hasDoors, true);
assert.equal(audit.audit.hasWalkMasks, true);
assert.equal(audit.audit.hasNoGoAreas, true);

assert.ok(scoreFixedCamFirstRoomCandidate(audit) >= 50);

const summary = createFixedCamCandidateSummary(sampleFixedCam);
assert.equal(summary.ok, true);
assert.equal(summary.score, scoreFixedCamFirstRoomCandidate(audit));

const badStandard = sampleFixedCam.replace('type="2"', 'type="1"');
const badAudit = normaliseFixedCamLocDefinition(badStandard);
assert.equal(badAudit.ok, false);
assert.equal(scoreFixedCamFirstRoomCandidate(badAudit), 0);

console.log('fixed-cam loc definition parser smoke test passed');
console.log(`candidate score: ${summary.score}`);
