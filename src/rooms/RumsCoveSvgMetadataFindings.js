// Findings from `node scripts/audit-rums-cove-svg-metadata.mjs`.
//
// These findings mean the major SVG exports are useful source rebuild pieces:
// they already contain many internal SWF placement transforms and vector paths.
// The remaining missing piece is root/timeline placement between the major sprites.

export const RUMS_COVE_SVG_METADATA_FINDINGS = Object.freeze({
  system: 'RumsCove major source SVG metadata',
  status: 'source-svg-candidates-validated',
  allMajorCandidatesLoadedAsSvg: true,
  allMajorCandidatesAreVectorOnly: true,
  allMajorCandidatesHaveInternalTransforms: true,
  noMajorCandidateUsesBitmapImages: true,
  clipPathsPresent: true,
  masksPresent: false,
  remainingProblem: 'root room timeline placement and source-layer depth composition'
});

export const RUMS_COVE_MAJOR_SVG_METADATA_SUMMARY = Object.freeze([
  Object.freeze({ key: 'buildings', width: '948.75px', height: '490.55px', groups: 80, paths: 199, uses: 114, transforms: 175, clipPaths: 5, images: 0 }),
  Object.freeze({ key: 'airport', width: '336.85px', height: '219.5px', groups: 37, paths: 55, uses: 59, transforms: 83, clipPaths: 4, images: 0 }),
  Object.freeze({ key: 'remoteBack', width: '2545.1px', height: '680.55px', groups: 147, paths: 194, uses: 203, transforms: 349, clipPaths: 1, images: 0 }),
  Object.freeze({ key: 'overlay', width: '908.0px', height: '283.4px', groups: 150, paths: 202, uses: 204, transforms: 353, clipPaths: 1, images: 0 }),
  Object.freeze({ key: 'yoghurtpotTums', width: '421.8px', height: '395.0px', groups: 36, paths: 93, uses: 47, transforms: 77, clipPaths: 1, images: 0 })
]);

export const RUMS_COVE_SVG_METADATA_NEXT_STEPS = Object.freeze([
  'treat-major-svg-exports-as-source-layer-candidates',
  'extract-root-timeline-placement-for-major-symbols',
  'identify-nested-versus-root-level-major-symbols',
  'compare-source-layer-composite-to-frame-preview',
  'replace-frame-preview-render-with-source-layer-render'
]);

export function getRumsCoveSvgMetadataFindingsSummary() {
  return Object.freeze({
    system: RUMS_COVE_SVG_METADATA_FINDINGS.system,
    status: RUMS_COVE_SVG_METADATA_FINDINGS.status,
    majorCandidateCount: RUMS_COVE_MAJOR_SVG_METADATA_SUMMARY.length,
    vectorOnly: RUMS_COVE_SVG_METADATA_FINDINGS.allMajorCandidatesAreVectorOnly,
    internalTransforms: RUMS_COVE_SVG_METADATA_FINDINGS.allMajorCandidatesHaveInternalTransforms,
    remainingProblem: RUMS_COVE_SVG_METADATA_FINDINGS.remainingProblem,
    nextAction: RUMS_COVE_SVG_METADATA_NEXT_STEPS[1]
  });
}

export function assertRumsCoveSvgMetadataFindings() {
  if (!RUMS_COVE_SVG_METADATA_FINDINGS.allMajorCandidatesLoadedAsSvg) {
    throw new Error('RumsCove SVG findings violation: major candidates must load as SVG');
  }

  if (!RUMS_COVE_SVG_METADATA_FINDINGS.allMajorCandidatesHaveInternalTransforms) {
    throw new Error('RumsCove SVG findings violation: major candidates should contain internal transforms');
  }

  if (!RUMS_COVE_SVG_METADATA_FINDINGS.noMajorCandidateUsesBitmapImages) {
    throw new Error('RumsCove SVG findings violation: unexpected bitmap dependency in major SVG candidates');
  }

  return true;
}
