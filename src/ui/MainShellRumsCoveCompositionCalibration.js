import {
  RUMS_COVE_DEBUG_WEEVIL_PLACEMENT,
  RUMS_COVE_PREVIEW_IMAGE
} from '../rooms/RumsCovePreviewCalibration.js';
import { VIEWPORT_SLIME_FRAME_MAIN_CANDIDATES } from './ViewportSlimeFrameSourceMap.js';

// Debug-only calibration from the first successful main shell + Rums Cove probe.
//
// This records the current proof that the Rums room can sit behind/inside the
// mainDEV661 slime shell while retaining the proven Rums weevil scale. It is not
// the final source-backed UI shell, and it must be replaced with exact main
// symbols/layers/masks before the milestone is considered complete.

export const MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES = Object.freeze({
  system: 'main shell + RumsCove debug composition',
  status: 'debug-composition-proof',
  mayUseFullFramePngAsFinalShell: false,
  mayUseFullFramePngAsTemporaryProbe: true,
  finalShellMustUseSourceSpritesAndMasks: true,
  roomMustRenderBehindSlimeFrame: true,
  playercardAssetsAreSeparateCoreTarget: true
});

export const MAIN_SHELL_RUMS_COVE_ASSETS = Object.freeze({
  shellFramePreview: 'reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/frames/1.png',
  roomPreview: 'reference/rooms/RumsAirport_dynamAds_videoPodv2_release/RumsAirport_dynamAds_videoPodv2_release/frames/1.png',
  shellSourceCandidateKeys: Object.freeze(VIEWPORT_SLIME_FRAME_MAIN_CANDIDATES.map((candidate) => candidate.key))
});

export const MAIN_SHELL_RUMS_COVE_CANVAS = Object.freeze({
  shellWidth: 940,
  shellHeight: 653,
  roomSourceWidth: RUMS_COVE_PREVIEW_IMAGE.width,
  roomSourceHeight: RUMS_COVE_PREVIEW_IMAGE.height
});

export const MAIN_SHELL_RUMS_COVE_VIEWPORT_CALIBRATION = Object.freeze({
  source: 'manual visual calibration from /probes/main-shell-rums-cove.html',
  x: 89,
  y: 52,
  width: 757,
  height: 486,
  note: 'larger temporary viewport to prove room-behind-shell relationship; not final mask'
});

export const MAIN_SHELL_RUMS_COVE_WEEVIL_MAPPING = Object.freeze({
  source: 'mapped from proven standalone RumsCove calibration',
  rumsProbeX: RUMS_COVE_DEBUG_WEEVIL_PLACEMENT.screenX,
  rumsProbeY: RUMS_COVE_DEBUG_WEEVIL_PLACEMENT.screenY,
  rumsProbeDisplayWidth: RUMS_COVE_DEBUG_WEEVIL_PLACEMENT.displayWidth,
  rumsProbeDisplayHeight: RUMS_COVE_DEBUG_WEEVIL_PLACEMENT.displayHeight,
  sourceWeevilScale: RUMS_COVE_DEBUG_WEEVIL_PLACEMENT.weevilScale,
  note: 'weevil should scale with the room image in this temporary composition proof'
});

export function getMainShellRumsCoveCompositionSummary() {
  return Object.freeze({
    system: MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.system,
    status: MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.status,
    shellFramePreview: MAIN_SHELL_RUMS_COVE_ASSETS.shellFramePreview,
    roomPreview: MAIN_SHELL_RUMS_COVE_ASSETS.roomPreview,
    viewport: MAIN_SHELL_RUMS_COVE_VIEWPORT_CALIBRATION,
    weevilMapping: MAIN_SHELL_RUMS_COVE_WEEVIL_MAPPING,
    nextAction: 'replace full-frame PNG proof with exact main shell symbols/layers/masks'
  });
}

export function assertMainShellRumsCoveCompositionPolicy() {
  if (MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.mayUseFullFramePngAsFinalShell) {
    throw new Error('Composition policy violation: full frame PNG cannot be the final shell');
  }

  if (!MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.finalShellMustUseSourceSpritesAndMasks) {
    throw new Error('Composition policy violation: final shell must use source sprites/layers/masks');
  }

  if (!MAIN_SHELL_RUMS_COVE_COMPOSITION_RULES.roomMustRenderBehindSlimeFrame) {
    throw new Error('Composition policy violation: room must render behind the slime frame');
  }

  return true;
}
