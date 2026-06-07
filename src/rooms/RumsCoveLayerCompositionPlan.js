import {
  RUMS_COVE_DOOR_CANDIDATES,
  RUMS_COVE_MAJOR_VISUAL_CANDIDATES,
  RUMS_COVE_ROOT_CANDIDATE
} from './RumsCoveCandidateRoleMap.js';
import { RUMS_COVE_SOURCE_REBUILD_RULES } from './RumsCoveSourceRebuildPlan.js';

// First-pass source-layer composition plan for RumsCove.
// This is not a final renderer. It records the candidate order we will test next.

export const RUMS_COVE_LAYER_COMPOSITION_RULES = Object.freeze({
  system: 'RumsCove source layer composition',
  status: 'candidate-order-plan',
  finalRoomMayUseFramePngAsRender: false,
  framePngMayBeUsedForComparison: true,
  sourceSpritesMustBeUsedForRoomLayers: true,
  exactTransformsKnown: false,
  exactDepthOrderKnown: false,
  safeToUseForFinalRender: false
});

export const RUMS_COVE_COMPARISON_FRAME = Object.freeze({
  key: 'framePreviewComparisonOnly',
  path: 'reference/rooms/RumsAirport_dynamAds_videoPodv2_release/RumsAirport_dynamAds_videoPodv2_release/frames/1.png',
  role: 'comparison/calibration only; not final room render'
});

export const RUMS_COVE_FIRST_PASS_LAYER_ORDER = Object.freeze([
  Object.freeze({ order: 10, key: 'buildings', sourceCandidateKey: 'buildings', depthStatus: 'candidate-background', transformStatus: 'unknown' }),
  Object.freeze({ order: 20, key: 'airport', sourceCandidateKey: 'airport', depthStatus: 'candidate-background-nested', transformStatus: 'unknown' }),
  Object.freeze({ order: 30, key: 'yoghurtpotTums', sourceCandidateKey: 'yoghurtpotTums', depthStatus: 'candidate-midground', transformStatus: 'unknown' }),
  Object.freeze({ order: 40, key: 'remoteBack', sourceCandidateKey: 'remoteBack', depthStatus: 'candidate-midground', transformStatus: 'unknown' }),
  Object.freeze({ order: 50, key: 'overlay', sourceCandidateKey: 'overlay', depthStatus: 'candidate-foreground', transformStatus: 'unknown' })
]);

export const RUMS_COVE_LAYER_COMPOSITION_GAPS = Object.freeze([
  'root timeline child placement order',
  'transform matrices for major sprite instances',
  'nested versus root-level instances',
  'foreground occluder masks for weevil depth',
  'walk mask and floorClickArea placement',
  'door instance coordinates and destination mapping',
  'dynamic ad/text layer behaviour'
]);

export const RUMS_COVE_LAYER_COMPOSITION_NEXT_STEPS = Object.freeze([
  'major-visuals-individual-browser-probe',
  'layer-toggle-composition-probe',
  'extract-root-timeline-placement-order',
  'map-door-instance-placement',
  'map-floorClickArea-and-walk-mask',
  'compare-source-layer-composite-against-frame-preview',
  'promote-source-layer-composite-to-room-scene'
]);

export function getRumsCoveLayerCompositionSummary() {
  return Object.freeze({
    system: RUMS_COVE_LAYER_COMPOSITION_RULES.system,
    status: RUMS_COVE_LAYER_COMPOSITION_RULES.status,
    rootClass: RUMS_COVE_ROOT_CANDIDATE.className,
    locId: RUMS_COVE_SOURCE_REBUILD_RULES.locId,
    locName: RUMS_COVE_SOURCE_REBUILD_RULES.locName,
    majorVisualCandidateCount: RUMS_COVE_MAJOR_VISUAL_CANDIDATES.length,
    doorCandidateCount: RUMS_COVE_DOOR_CANDIDATES.length,
    firstPassLayerCount: RUMS_COVE_FIRST_PASS_LAYER_ORDER.length,
    gapCount: RUMS_COVE_LAYER_COMPOSITION_GAPS.length,
    nextAction: RUMS_COVE_LAYER_COMPOSITION_NEXT_STEPS[1]
  });
}

export function assertRumsCoveLayerCompositionPolicy() {
  if (RUMS_COVE_LAYER_COMPOSITION_RULES.finalRoomMayUseFramePngAsRender) {
    throw new Error('RumsCove layer policy violation: frame PNG cannot be final room render');
  }

  if (!RUMS_COVE_LAYER_COMPOSITION_RULES.sourceSpritesMustBeUsedForRoomLayers) {
    throw new Error('RumsCove layer policy violation: source sprites must be used for room layers');
  }

  if (RUMS_COVE_LAYER_COMPOSITION_RULES.safeToUseForFinalRender) {
    throw new Error('RumsCove layer policy violation: candidate plan is not final render yet');
  }

  return true;
}
