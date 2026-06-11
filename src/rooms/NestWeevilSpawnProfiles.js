export const NEST_WEEVIL_SPAWN_PROFILE_SOURCE = Object.freeze({
  description: "Visual floor spawn points for the rendered Nest weevil overlay. Initial values picked from the navigation demo stage coordinate picker.",
  coordinateSpace: "browser stage x/y",
  note: "These are separate from door visual targets. Door targets are for traversal. Spawn profiles are for normal standing placement after a room loads."
});

const SIMPLE_ROOM_SPAWN = Object.freeze({
  x: 300,
  y: 293,
  method: "room2-clicked-floor-spawn-used-as-simple-room-baseline"
});

export const NEST_WEEVIL_SPAWN_BY_LOCATION = Object.freeze({
  1: SIMPLE_ROOM_SPAWN,
  2: SIMPLE_ROOM_SPAWN,
  3: SIMPLE_ROOM_SPAWN,
  4: SIMPLE_ROOM_SPAWN,
  5: Object.freeze({
    x: 304,
    y: 283,
    method: "hall-clicked-floor-spawn"
  }),
  6: SIMPLE_ROOM_SPAWN,
  7: SIMPLE_ROOM_SPAWN,
  8: SIMPLE_ROOM_SPAWN,
  9: SIMPLE_ROOM_SPAWN
});

export const DEFAULT_NEST_WEEVIL_SPAWN = SIMPLE_ROOM_SPAWN;

export function getNestWeevilSpawnProfile(locationId) {
  const profile = NEST_WEEVIL_SPAWN_BY_LOCATION[locationId] ?? DEFAULT_NEST_WEEVIL_SPAWN;

  return Object.freeze({
    locationId,
    x: profile.x,
    y: profile.y,
    method: profile.method
  });
}
