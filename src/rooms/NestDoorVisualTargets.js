import {
  NEST_LOCATIONS,
  getNestDoorTarget,
  getNestLocation
} from "./NestNavigationManifest.js";

import { NEST_HALL_2011_VISUAL_HITBOXES } from "./NestHall2011VisualHitboxes.js";

export const RENDERED_NEST_LOCATION_IDS = Object.freeze([5, 1, 2, 3, 4, 6, 7, 8, 9]);

const SIMPLE_ROOM_VISUAL_TARGETS = Object.freeze({
  1: Object.freeze({
    1: Object.freeze({ x: 548, y: 287, method: "room1-side-door-visible-target" })
  }),

  2: Object.freeze({
    1: Object.freeze({ x: 92, y: 334, method: "room2-front-door-visible-target" })
  }),

  3: Object.freeze({
    1: Object.freeze({ x: 72, y: 287, method: "room3-side-door-visible-target" })
  }),

  4: Object.freeze({
    1: Object.freeze({ x: 548, y: 287, method: "room4-side-door-visible-target" }),
    2: Object.freeze({ x: 456, y: 334, method: "room4-front-door-visible-target" })
  }),

  6: Object.freeze({
    1: Object.freeze({ x: 72, y: 287, method: "room6-side-door-visible-target" }),
    2: Object.freeze({ x: 160, y: 334, method: "room6-front-door-visible-target" })
  }),

  7: Object.freeze({
    1: Object.freeze({ x: 395, y: 225, method: "room7-back-door-visible-target" }),
    2: Object.freeze({ x: 548, y: 287, method: "room7-side-door-visible-target" })
  }),

  8: Object.freeze({
    1: Object.freeze({ x: 278, y: 225, method: "room8-back-door-visible-target" })
  }),

  9: Object.freeze({
    1: Object.freeze({ x: 219, y: 225, method: "room9-back-door-visible-target" }),
    2: Object.freeze({ x: 72, y: 287, method: "room9-side-door-visible-target" })
  })
});

function hallHitboxToFootTarget(hitbox) {
  return {
    x: Math.round(hitbox.x + hitbox.width / 2),
    y: Math.round(hitbox.y + hitbox.height - 10),
    method: "hall-visual-hitbox-foot-target"
  };
}

function getStageTarget(locationId, doorId) {
  if (locationId === 5) {
    const hitbox = NEST_HALL_2011_VISUAL_HITBOXES[doorId];

    if (!hitbox) {
      return null;
    }

    return hallHitboxToFootTarget(hitbox);
  }

  return SIMPLE_ROOM_VISUAL_TARGETS[locationId]?.[doorId] || null;
}

export function getNestDoorVisualTarget(locationId, doorId) {
  const location = getNestLocation(locationId);
  const door = location?.doors?.find((candidate) => candidate.id === doorId);

  if (!location || !door) {
    return null;
  }

  const stage = getStageTarget(locationId, doorId);

  if (!stage) {
    return null;
  }

  const navTarget = getNestDoorTarget(locationId, doorId);

  return Object.freeze({
    locationId,
    locationLabel: location.label,
    doorId,
    targetLocationId: door.toLoc,
    targetDoorId: door.toDoor,
    targetLocationLabel: navTarget?.targetLocation?.label || null,

    source: Object.freeze({
      x: door.x1,
      y: door.y1 ?? 0,
      z: door.z1
    }),

    arrivalSource: Object.freeze({
      x: door.x2,
      y: door.y2 ?? 0,
      z: door.z2
    }),

    stage: Object.freeze({
      x: stage.x,
      y: stage.y,
      method: stage.method
    })
  });
}

export function getNestLocationDoorVisualTargets(locationId) {
  const location = NEST_LOCATIONS[locationId];

  if (!location) {
    return [];
  }

  return Object.freeze(
    (location.doors || [])
      .map((door) => getNestDoorVisualTarget(locationId, door.id))
      .filter(Boolean)
  );
}

export function getAllNestDoorVisualTargets(locationIds = RENDERED_NEST_LOCATION_IDS) {
  const result = [];

  for (const locationId of locationIds) {
    result.push(...getNestLocationDoorVisualTargets(locationId));
  }

  return Object.freeze(result);
}

export function getNestDoorVisualTargetSummary(locationIds = RENDERED_NEST_LOCATION_IDS) {
  return Object.freeze(
    getAllNestDoorVisualTargets(locationIds).map((target) => Object.freeze({
      locationId: target.locationId,
      doorId: target.doorId,
      source: `${target.source.x}/${target.source.z}`,
      stage: `${target.stage.x}/${target.stage.y}`,
      target: `loc ${target.targetLocationId} door ${target.targetDoorId}`
    }))
  );
}
