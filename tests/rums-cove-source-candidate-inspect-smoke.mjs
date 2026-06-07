import assert from 'node:assert/strict';

import {
  RUMS_COVE_SOURCE_CANDIDATE_FILES,
  RUMS_COVE_SOURCE_CANDIDATE_SYMBOL_HINTS,
  formatActionScriptInspection,
  formatSymbolClassInspection,
  getRumsCoveSourceCandidateInspectSummary,
  inspectActionScriptSource,
  inspectSymbolClassCsv
} from '../src/rooms/RumsCoveSourceCandidateInspect.js';

assert.ok(RUMS_COVE_SOURCE_CANDIDATE_FILES.includes('symbolClass/symbols.csv'));
assert.ok(RUMS_COVE_SOURCE_CANDIDATE_FILES.includes('scripts/RumsAirport_dynamAds.as'));
assert.ok(RUMS_COVE_SOURCE_CANDIDATE_FILES.some((path) => path.includes('Door_002_71.as')));
assert.ok(RUMS_COVE_SOURCE_CANDIDATE_SYMBOL_HINTS.some((hint) => hint.includes('buildings_12')));
assert.ok(RUMS_COVE_SOURCE_CANDIDATE_SYMBOL_HINTS.some((hint) => hint.includes('Door_002_71')));

const actionScriptInspection = inspectActionScriptSource('scripts/Test.as', `package test.pkg {
  import flash.display.MovieClip;
  import flash.events.MouseEvent;
  public dynamic class Door_002_71 extends MovieClip {
    public var door_mc:MovieClip;
    public function Door_002_71() {
      super();
      addFrameScript(0, this.frame1);
      this.stop();
      this.door_mc.addEventListener(MouseEvent.CLICK, this.onClick);
    }
    public function frame1():void {}
    private function onClick(event:MouseEvent):void {
      gotoAndPlay(2);
    }
  }
}`);

assert.equal(actionScriptInspection.path, 'scripts/Test.as');
assert.equal(actionScriptInspection.packageName, 'test.pkg');
assert.equal(actionScriptInspection.className, 'Door_002_71');
assert.equal(actionScriptInspection.extendsName, 'MovieClip');
assert.ok(actionScriptInspection.imports.includes('flash.display.MovieClip'));
assert.ok(actionScriptInspection.functions.includes('Door_002_71'));
assert.ok(actionScriptInspection.functions.includes('frame1'));
assert.ok(actionScriptInspection.timelineCalls.includes('addFrameScript'));
assert.ok(actionScriptInspection.timelineCalls.includes('stop'));
assert.ok(actionScriptInspection.timelineCalls.includes('addEventListener'));
assert.ok(actionScriptInspection.childRefs.includes('door_mc'));

const symbolInspection = inspectSymbolClassCsv(`361,RumsAirport_dynamAds_videoPodv2_fla.buildings_12
266,RumsAirport_dynamAds_videoPodv2_fla.overlay_70
999,OtherSymbol`);
assert.equal(symbolInspection.lineCount, 3);
assert.equal(symbolInspection.matchedLineCount, 2);
assert.ok(symbolInspection.matches[0].includes('buildings_12'));

const formattedScript = formatActionScriptInspection(actionScriptInspection);
assert.ok(formattedScript.includes('class: Door_002_71'));
assert.ok(formattedScript.includes('timelineCalls:'));

const formattedSymbols = formatSymbolClassInspection(symbolInspection);
assert.ok(formattedSymbols.includes('symbolClass/symbols.csv'));
assert.ok(formattedSymbols.includes('matched candidate lines: 2'));

const summary = getRumsCoveSourceCandidateInspectSummary();
assert.equal(summary.candidateFileCount, RUMS_COVE_SOURCE_CANDIDATE_FILES.length);
assert.equal(summary.symbolHintCount, RUMS_COVE_SOURCE_CANDIDATE_SYMBOL_HINTS.length);
assert.equal(summary.nextAction, 'read-candidate-source-files');

console.log('rums-cove source candidate inspection smoke test passed');
console.log(`${summary.candidateFileCount} candidate files / next=${summary.nextAction}`);
