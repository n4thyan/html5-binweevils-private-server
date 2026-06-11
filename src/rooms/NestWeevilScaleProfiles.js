export const NEST_WEEVIL_SCALE_SOURCE = Object.freeze({
  description: "Source-backed weevilScale values from nestLocDefs.xml getFile/116 and related archived loc def variants.",
  renderedNestLocDefsBasis: "source/knowyourknot-binweevils/game-full/binConfig/getFile/116/nestLocDefs.xml"
});

export const NEST_WEEVIL_SCALE_BY_LOCATION = Object.freeze({
  1: 0.5,
  2: 0.5,
  3: 0.5,
  4: 0.5,
  5: 0.45,
  6: 0.5,
  7: 0.5,
  8: 0.5,
  9: 0.5,

  10: 0.45,
  20: 0.16,

  50: 0.23,
  51: 0.23,
  52: 0.23,
  53: 0.23,
  54: 0.23,
  55: 0.5
});

export const DEFAULT_NEST_WEEVIL_SCALE = 0.5;

export function getNestWeevilScale(locationId) {
  return NEST_WEEVIL_SCALE_BY_LOCATION[locationId] ?? DEFAULT_NEST_WEEVIL_SCALE;
}

export function getNestWeevilScaleDisplaySize(locationId, {
  baseWidth = 132,
  baseHeight = 132,
  referenceScale = 0.5
} = {}) {
  const sourceScale = getNestWeevilScale(locationId);
  const visualRatio = sourceScale / referenceScale;

  return Object.freeze({
    locationId,
    sourceScale,
    referenceScale,
    visualRatio,
    width: Math.round(baseWidth * visualRatio),
    height: Math.round(baseHeight * visualRatio)
  });
}
