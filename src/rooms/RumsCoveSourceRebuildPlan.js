import { ASSET_SOURCE_TYPES, ASSET_USE_CONTEXTS, classifyAssetUse } from '../port/AssetUsePolicy.js';
import { RUMS_COVE_LOC } from './RumsCoveManifest.js';

// Source rebuild plan for the first FixedCamera room target.
//
// The current Rums probes intentionally use frames/1.png for fast visual proof.
// That is not the final room renderer. The final RumsCove scene should rebuild
// from the room SWF export/source structure wherever available: sprites, shapes,
// bitmaps, layer order, masks, doors, interactives, walk masks and LocFixedCam
// behaviour.

export const RUMS_COVE_SOURCE_REBUILD_RULES = Object.freeze({
  system: 'RumsCove FixedCamera room source rebuild',
  status: 'rebuild-plan',
  locId: RUMS_COVE_LOC.id,
  locName: RUMS_COVE_LOC.name,
  currentFramePngUse: 'debug/calibration only',
  finalRoomMayUseBakedFramePng: false,
  finalRoomMayUseOriginalBitmapExports: true,
  finalRoomMustUseSourceSpritesLayersMasksWhereAvailable: true,
  finalRoomMustKeepLocFixedCamData: true,
  finalRoomMustKeepDoorAndInteractiveData: true
});

export const RUMS_COVE_EXPORT_FAMILY = Object.freeze({
  locDefinitionRoomBg: 'fixedCam/RumsAirport_180321.swf',
  uploadedExportFamily: 'RumsAirport_dynamAds_videoPodv2_release',
  caution: 'same room family/variant is suspected but exact equivalence must be proven before claiming it'
});

export const RUMS_COVE_SOURCE_REBUILD_INPUTS = Object.freeze([
  Object.freeze({
    key: 'loc-definition',
    path: 'source/knowyourknot-binweevils/game-full/binConfig/getFile/7/uk/locationDefinitions.xml',
    sourceType: ASSET_SOURCE_TYPES.SOURCE_DATA,
    finalUse: 'room id, type, camera, boundary, entry, scale, doors, objects and interactives'
  }),
  Object.freeze({
    key: 'loc-fixed-cam-source',
    path: 'reference/decompiled-dumpassets/dumpassets/core5.swf/scripts/com/binweevils/engine3D/visuals/LocFixedCam.as',
    sourceType: ASSET_SOURCE_TYPES.SOURCE_BEHAVIOUR,
    finalUse: 'FixedCamera placement, click area, doors, walk masks, no-go areas and depth behaviour'
  }),
  Object.freeze({
    key: 'room-export-folder',
    path: 'reference/rooms/RumsAirport_dynamAds_videoPodv2_release/RumsAirport_dynamAds_videoPodv2_release',
    sourceType: ASSET_SOURCE_TYPES.ORIGINAL_SHAPE_OR_SPRITE,
    finalUse: 'source room export folders such as sprites, shapes, images, morphshapes, frames and scripts where available'
  }),
  Object.freeze({
    key: 'room-frame-preview',
    path: 'reference/rooms/RumsAirport_dynamAds_videoPodv2_release/RumsAirport_dynamAds_videoPodv2_release/frames/1.png',
    sourceType: ASSET_SOURCE_TYPES.BAKED_FRAME_PNG,
    finalUse: 'visual proof/calibration only; not final room render'
  })
]);

export const RUMS_COVE_SOURCE_REBUILD_STEPS = Object.freeze([
  'audit-room-export-folders',
  'list-symbols-and-frame-elements',
  'identify-background-layers',
  'identify-foreground/occluder-layers',
  'identify-door-symbols-and-hit areas',
  'identify-interactives-and-static objects',
  'identify-walk masks-and-no-go areas',
  'rebuild-layered-room-scene',
  'compare-layered-scene-against-frame-preview',
  'remove-frame-preview-from-final-render-path'
]);

export const RUMS_COVE_DEBUG_PROOFS_TO_KEEP = Object.freeze([
  '/probes/rums-cove-preview.html',
  '/probes/rums-cove-canvas.html',
  '/probes/rums-cove-weevil.html',
  '/probes/main-shell-rums-cove.html'
]);

export function getRumsCoveSourceRebuildSummary() {
  return Object.freeze({
    system: RUMS_COVE_SOURCE_REBUILD_RULES.system,
    status: RUMS_COVE_SOURCE_REBUILD_RULES.status,
    locId: RUMS_COVE_SOURCE_REBUILD_RULES.locId,
    locName: RUMS_COVE_SOURCE_REBUILD_RULES.locName,
    currentFramePngUse: RUMS_COVE_SOURCE_REBUILD_RULES.currentFramePngUse,
    finalRoomMayUseBakedFramePng: RUMS_COVE_SOURCE_REBUILD_RULES.finalRoomMayUseBakedFramePng,
    inputCount: RUMS_COVE_SOURCE_REBUILD_INPUTS.length,
    stepCount: RUMS_COVE_SOURCE_REBUILD_STEPS.length,
    nextAction: RUMS_COVE_SOURCE_REBUILD_STEPS[0]
  });
}

export function assertRumsCoveSourceRebuildPolicy() {
  if (RUMS_COVE_SOURCE_REBUILD_RULES.finalRoomMayUseBakedFramePng) {
    throw new Error('RumsCove policy violation: final room may not use baked frame PNG as render');
  }

  const framePreviewUse = classifyAssetUse({
    context: ASSET_USE_CONTEXTS.FINAL_PORT,
    sourceType: ASSET_SOURCE_TYPES.BAKED_FRAME_PNG
  });

  if (framePreviewUse.finalAllowed) {
    throw new Error('RumsCove policy violation: frame preview unexpectedly allowed for final port');
  }

  const originalRoomAssetsUse = classifyAssetUse({
    context: ASSET_USE_CONTEXTS.FINAL_PORT,
    sourceType: ASSET_SOURCE_TYPES.ORIGINAL_SHAPE_OR_SPRITE,
    sourceBacked: true
  });

  if (!originalRoomAssetsUse.finalAllowed) {
    throw new Error('RumsCove policy violation: original room sprites/shapes must be valid final assets');
  }

  return true;
}
