// Movement port plan for the Bin Weevils HTML5 project.
//
// This is deliberately not a fake movement demo. The goal is to port the Flash
// movement model slowly using source-backed room/location data, then test it in
// a blank shell before attaching it to complicated room renders.

import { RUMS_COVE_LOC, RUMS_COVE_DOORS, RUMS_COVE_OBJECTS, RUMS_COVE_INTERACTIVES } from '../rooms/RumsCoveManifest.js';

export const MOVEMENT_PORT_RULES = Object.freeze({
  noFakeMovement: true,
  useFlashCoordinateModel: true,
  useSourceEntryPositions: true,
  useSourceDoorData: true,
  useSourceWeevilScale: true,
  sandboxAllowed: true,
  sandboxPurpose: 'isolate Flash-style movement and positioning before returning to room rendering'
});

export const MOVEMENT_SOURCE_FIELDS = Object.freeze([
  'locID',
  'entryPos',
  'entryDir',
  'weevilScale',
  'boundary',
  'doors',
  'objects',
  'interactives',
  'floorClickArea',
  'x/y/z/r position state'
]);

export const RUMS_COVE_MOVEMENT_BASELINE = Object.freeze({
  locID: RUMS_COVE_LOC.id,
  name: RUMS_COVE_LOC.name,
  kind: RUMS_COVE_LOC.kind,
  boundary: RUMS_COVE_LOC.boundary,
  entryPos: RUMS_COVE_LOC.entryPos,
  entryDir: RUMS_COVE_LOC.entryDir,
  weevilScale: RUMS_COVE_LOC.weevilScale,
  roomBG: RUMS_COVE_LOC.roomBG,
  doors: RUMS_COVE_DOORS,
  objects: RUMS_COVE_OBJECTS,
  interactives: RUMS_COVE_INTERACTIVES,
  status: 'source-data-baseline-only; do not treat as final movement implementation'
});

export const MOVEMENT_PORT_STEPS = Object.freeze([
  Object.freeze({
    key: 'audit-source-data',
    status: 'next',
    output: 'movement source data report',
    note: 'Find real entry positions, weevil scales, boundaries, doors and floor/click areas from locationDefinitions and room XML.'
  }),
  Object.freeze({
    key: 'blank-coordinate-sandbox',
    status: 'after-audit',
    output: 'blank 614x366 movement probe',
    note: 'Render a blank shell with source entry position, source boundary and x/y/z/r debug state. No fake physics.'
  }),
  Object.freeze({
    key: 'heading-and-facing',
    status: 'after-coordinate-sandbox',
    output: 'Flash-style direction/facing mapping',
    note: 'Port/derive the original heading to r/rotation conventions before adding room art.'
  }),
  Object.freeze({
    key: 'click-target-move',
    status: 'after-heading',
    output: 'click-to-target movement using Flash coordinate space',
    note: 'Clicking should update target state in source coordinate terms, not arbitrary CSS pixels.'
  }),
  Object.freeze({
    key: 'walkable-area-constraint',
    status: 'after-click-target',
    output: 'movement constrained by source floor/click area',
    note: 'Use floorClickArea or room boundary data as the first constraint. Do not invent room collision.'
  }),
  Object.freeze({
    key: 'room-render-integration',
    status: 'defer',
    output: 'movement over a real room render',
    note: 'Only after the sandbox behaviour is stable.'
  })
]);

export function getMovementPortSummary() {
  return Object.freeze({
    rules: MOVEMENT_PORT_RULES,
    sourceFieldCount: MOVEMENT_SOURCE_FIELDS.length,
    baselineLoc: RUMS_COVE_MOVEMENT_BASELINE.locID,
    baselineEntryPos: RUMS_COVE_MOVEMENT_BASELINE.entryPos,
    baselineWeevilScale: RUMS_COVE_MOVEMENT_BASELINE.weevilScale,
    stepCount: MOVEMENT_PORT_STEPS.length,
    nextStep: MOVEMENT_PORT_STEPS.find((step) => step.status === 'next')?.key || ''
  });
}
