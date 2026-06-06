import { RUMS_COVE_LOC } from './RumsCoveManifest.js';

// Debug-only calibration from the first successful Rums Cove room + weevil probe.
//
// This is not the final LocFixedCam projection model. It records the visual proof
// point that locID 129 / weevilScale 0.18 produces a plausible weevil size in the
// exported Rums room preview, and keeps the manual screen offsets out of the
// throwaway HTML probe.

export const RUMS_COVE_PREVIEW_IMAGE = Object.freeze({
  width: 614,
  height: 366,
  expectedPath: '/reference/rooms/RumsAirport_dynamAds_videoPodv2_release/RumsAirport_dynamAds_videoPodv2_release/frames/1.png'
});

export const RUMS_COVE_PREVIEW_CANDIDATE_PATHS = Object.freeze([
  '/reference/rooms/RumsAirport_dynamAds_videoPodv2_release/frames/1.png',
  '/reference/rooms/RumsAirport_dynamAds_videoPodv2_release/RumsAirport_dynamAds_videoPodv2_release/frames/1.png',
  '/reference/decompiled-rooms/RumsAirport_dynamAds_videoPodv2_release/frames/1.png',
  '/public/rooms/RumsAirport_dynamAds_videoPodv2_release/frames/1.png',
  '/rooms/RumsAirport_dynamAds_videoPodv2_release/frames/1.png'
]);

export const RUMS_COVE_DEBUG_ENTRY_MARKER = Object.freeze({
  source: 'manual visual calibration from probe',
  roomX: RUMS_COVE_LOC.entryPos[0],
  roomZ: RUMS_COVE_LOC.entryPos[1],
  screenX: 238,
  screenY: 292,
  label: 'rough entryPos [0,80]'
});

export const RUMS_COVE_DEBUG_WEEVIL_PLACEMENT = Object.freeze({
  source: 'manual visual offset from entry marker onto clear ground',
  screenX: 292,
  screenY: 314,
  displayWidth: 66,
  displayHeight: 66,
  scaleSource: 'locationDefinitions.xml weevilScale',
  weevilScale: RUMS_COVE_LOC.weevilScale,
  visualResult: 'confirmed plausible in local browser probe'
});

export function getRumsCovePreviewCandidatePaths() {
  return [...RUMS_COVE_PREVIEW_CANDIDATE_PATHS];
}

export function getRumsCovePreviewCalibrationSummary() {
  return Object.freeze({
    locId: RUMS_COVE_LOC.id,
    locName: RUMS_COVE_LOC.name,
    expectedFrameSize: Object.freeze({
      width: RUMS_COVE_PREVIEW_IMAGE.width,
      height: RUMS_COVE_PREVIEW_IMAGE.height
    }),
    entryMarker: RUMS_COVE_DEBUG_ENTRY_MARKER,
    weevilPlacement: RUMS_COVE_DEBUG_WEEVIL_PLACEMENT,
    caveat: 'debug-only calibration; replace with source-backed FixedCam projection/depth in real scene'
  });
}

export function createRumsCoveProbeRenderConfig() {
  return Object.freeze({
    image: RUMS_COVE_PREVIEW_IMAGE,
    candidatePaths: RUMS_COVE_PREVIEW_CANDIDATE_PATHS,
    entryMarker: RUMS_COVE_DEBUG_ENTRY_MARKER,
    weevilPlacement: RUMS_COVE_DEBUG_WEEVIL_PLACEMENT,
    loc: RUMS_COVE_LOC
  });
}
