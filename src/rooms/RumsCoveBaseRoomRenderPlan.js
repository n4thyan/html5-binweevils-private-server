// First playable-shell render plan for RumsCove exterior.
// This intentionally defers planes, fireworks, ad/VOD behaviour and unmapped
// collision objects. The goal is a stable XML-placed base room scene.

import { RUMS_COVE_XML_NAMED_PLACEMENTS } from './RumsCoveXmlPlacementMap.js';

export const RUMS_COVE_BASE_ROOM_INCLUDE_NAMES = Object.freeze([
  'buildings',
  'remoteBack',
  'remoteDoorOverlay',
  'door7_mc',
  'door1_mc',
  'door2_mc',
  'door3_mc',
  'door4_mc',
  'door6_mc',
  'door5_mc'
]);

export const RUMS_COVE_BASE_ROOM_DEFER_NAMES = Object.freeze([
  'floorClickArea_btn',
  'plane1',
  'plane2',
  'fence',
  'mulchtasticBooth'
]);

export const RUMS_COVE_BASE_ROOM_REASONING = Object.freeze({
  included: 'static/exterior room shell and door visuals for first room render',
  deferred: 'animation, collision, ads, props or unmapped symbols are handled after the base scene is stable',
  comparisonFrame: 'allowed as visual comparison only, never as final render'
});

export const RUMS_COVE_BASE_ROOM_PLACEMENTS = Object.freeze(
  RUMS_COVE_XML_NAMED_PLACEMENTS.filter((placement) => RUMS_COVE_BASE_ROOM_INCLUDE_NAMES.includes(placement.name))
    .sort((a, b) => a.depth - b.depth)
);

export const RUMS_COVE_BASE_ROOM_DEFERRED_PLACEMENTS = Object.freeze(
  RUMS_COVE_XML_NAMED_PLACEMENTS.filter((placement) => RUMS_COVE_BASE_ROOM_DEFER_NAMES.includes(placement.name))
    .sort((a, b) => a.depth - b.depth)
);

export function getRumsCoveBaseRoomRenderSummary() {
  return Object.freeze({
    includeCount: RUMS_COVE_BASE_ROOM_PLACEMENTS.length,
    deferredCount: RUMS_COVE_BASE_ROOM_DEFERRED_PLACEMENTS.length,
    firstIncluded: RUMS_COVE_BASE_ROOM_PLACEMENTS[0]?.name || '',
    lastIncluded: RUMS_COVE_BASE_ROOM_PLACEMENTS.at(-1)?.name || '',
    nextAction: 'base-room-xml-render-probe'
  });
}
