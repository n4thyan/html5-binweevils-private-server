// Compatibility wrapper around WeevilVisualConfig.
//
// Older milestone-002 code imports from this file. The actual renderer-facing
// visual mappings now live in WeevilVisualConfig.js so the cleaned renderer has
// one central config source.

import {
  BODY_VISUALS,
  EYE_VISUALS,
  HEAD_VISUALS,
  LEG_VISUALS,
  MOUTH_VISUALS,
  getBodyVisual,
  getEyeVisual,
  getHeadVisual,
  getLegVisual,
  getMouthVisual
} from './WeevilVisualConfig.js';

export const BODY_ATLAS_BY_TYPE = Object.fromEntries(
  Object.entries(BODY_VISUALS).map(([type, visual]) => [type, visual.atlas])
);

export const HEAD_ATLAS_BY_TYPE = Object.fromEntries(
  Object.entries(HEAD_VISUALS).map(([type, visual]) => [type, visual.atlas])
);

export const MOUTH_ATLAS_ORDER = MOUTH_VISUALS.map((visual) => visual.atlas);

export const EYE_ATLAS_SET_BY_TYPE = Object.fromEntries(
  Object.entries(EYE_VISUALS).map(([type, visual]) => [type, visual.set])
);

export const LEG_LOWER_FRAME_BY_TYPE = Object.fromEntries(
  Object.entries(LEG_VISUALS).map(([type, visual]) => [type, visual.lowerFrame])
);

export function getBodyAtlas(bodyType) {
  return getBodyVisual(bodyType).atlas;
}

export function getHeadAtlas(headType) {
  return getHeadVisual(headType).atlas;
}

export function getMouthAtlas(expressionIndex = 0) {
  return getMouthVisual(expressionIndex).atlas;
}

export function getEyeAtlasSet(eyeType) {
  return getEyeVisual(eyeType).set;
}

export function getLowerLegFrame(legType) {
  return getLegVisual(legType).lowerFrame;
}
