// Prototype-derived mapping from the old HTML5 renderer audit.
//
// Status: reference only until matched against original source/asset evidence.
// Do not treat this file as final authenticity proof.

export const BODY_ATLAS_BY_TYPE = {
  1: 'body_spheroid',
  2: 'body_cone',
  3: 'body_cone_narrow_inv',
  4: 'body_cuboid'
};

export const HEAD_ATLAS_BY_TYPE = {
  1: 'head_spheroid',
  2: 'head_cone',
  3: 'head_cone_inv',
  4: 'head_cuboid'
};

export const MOUTH_ATLAS_ORDER = [
  'mouth_Mouth2_mc',
  'mouth_Mouth1_mc',
  'mouth_Mouth3_mc',
  'mouth_Mouth4_mc',
  'mouth_Mouth5_mc',
  'mouth_Mouth6_mc',
  'mouth_Mouth7_mc'
];

export const EYE_ATLAS_SET_BY_TYPE = {
  1: 'set1',
  2: 'set1',
  3: 'set1',
  4: 'set2',
  5: 'set2',
  6: 'set2'
};

export const LEG_LOWER_FRAME_BY_TYPE = {
  0: 'lower_leg.png',
  1: 'lower_leg_stripy.png'
};

export function getBodyAtlas(bodyType) {
  return BODY_ATLAS_BY_TYPE[Number(bodyType)] ?? BODY_ATLAS_BY_TYPE[1];
}

export function getHeadAtlas(headType) {
  return HEAD_ATLAS_BY_TYPE[Number(headType)] ?? HEAD_ATLAS_BY_TYPE[1];
}

export function getMouthAtlas(expressionIndex = 0) {
  return MOUTH_ATLAS_ORDER[Number(expressionIndex)] ?? MOUTH_ATLAS_ORDER[0];
}

export function getEyeAtlasSet(eyeType) {
  return EYE_ATLAS_SET_BY_TYPE[Number(eyeType)] ?? 'set1';
}

export function getLowerLegFrame(legType) {
  return LEG_LOWER_FRAME_BY_TYPE[Number(legType)] ?? 'lower_leg.png';
}
