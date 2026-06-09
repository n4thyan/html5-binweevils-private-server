// Source-backed movement scale baselines.
//
// These values come from locationDefinitions audits, not hand-picked visual
// guesses. They are used to separate the global movement sandbox from specific
// room scale values.

export const MOVEMENT_SCALE_AUDIT_SUMMARY = Object.freeze({
  totalLocationsWithWeevilScale: 5464,
  buckets: Object.freeze({
    '<0.16': 640,
    '0.16..0.199': 339,
    '0.20..0.239': 994,
    '0.24..0.299': 1955,
    '0.30..0.399': 1060,
    '0.40..0.50': 404,
    '>0.50': 72
  }),
  conclusion: '0.18 is valid for some room-specific exteriors such as Rums Cove, but 0.24..0.299 is the most common normal movement range in the audited source data.'
});

export const MOVEMENT_SANDBOX_BASELINE = Object.freeze({
  key: 'normal-fixedcam-0-28',
  purpose: 'blank movement sandbox baseline; not tied to Rums Cove exterior camera scale',
  sourceKind: 'locationDefinitions-derived',
  scale: 0.28,
  entryPos: Object.freeze([0, 80]),
  entryDir: 180,
  boundary: Object.freeze([-185, 0, 351, 177]),
  maintainY: false,
  note: '0.28 sits inside the most common audited scale bucket and matches several source fixedCam rooms, including Rums Cove Interior / Shopping Mall-style entries.'
});

export const ROOM_SPECIFIC_SCALE_BASELINES = Object.freeze([
  Object.freeze({
    key: 'rums-cove-exterior-current',
    locID: 129,
    name: 'RumsCove',
    scale: 0.18,
    entryPos: Object.freeze([0, 80]),
    entryDir: 180,
    boundary: Object.freeze([-240, 60, 680, 90]),
    roomBG: 'fixedCam/RumsAirport_180321.swf',
    note: 'Use only when testing the current Rums Cove exterior. Do not use as global movement scale.'
  }),
  Object.freeze({
    key: 'rums-cove-exterior-legacy',
    locID: 129,
    name: 'RumsCove',
    scale: 0.22,
    entryPos: Object.freeze([0, 80]),
    entryDir: 180,
    boundary: Object.freeze([-240, 75, 680, 252]),
    roomBG: 'fixedCam/RumsCove_dynamAds.swf',
    note: 'Older Rums Cove exterior data found in source history.'
  }),
  Object.freeze({
    key: 'rums-cove-interior',
    locID: 132,
    name: 'RumsCoveInterior',
    scale: 0.28,
    entryPos: Object.freeze([0, 80]),
    entryDir: 180,
    boundary: Object.freeze([-170, 70, 320, 150]),
    roomBG: 'play/fixedCam/RumsCoveInterior.swf',
    note: 'Useful linked-room baseline for movement sandbox because it uses a normal 0.28 scale.'
  })
]);

export function getMovementScaleBaselineSummary() {
  return Object.freeze({
    sandboxScale: MOVEMENT_SANDBOX_BASELINE.scale,
    dominantBucket: '0.24..0.299',
    dominantBucketCount: MOVEMENT_SCALE_AUDIT_SUMMARY.buckets['0.24..0.299'],
    rumsExteriorScale: ROOM_SPECIFIC_SCALE_BASELINES.find((item) => item.key === 'rums-cove-exterior-current')?.scale,
    rule: 'use the sandbox baseline for movement system research; use room-specific scale only when testing that exact room'
  });
}
