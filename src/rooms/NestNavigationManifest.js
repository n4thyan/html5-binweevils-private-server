export const NEST_NAVIGATION_SOURCE = Object.freeze({
  file: "source/knowyourknot-binweevils/game-full/binConfig/getFile/116/uk/nestLocDefs.xml",
  note: "Manual source-backed extract from nestLocDefs.xml. Location id 5 is the Nest Hall. Simple nest room ids map to nestRoom*.swf exports."
});

export const NEST_LOCATIONS = Object.freeze({
  1: Object.freeze({
    id: 1,
    key: "nestRoom1",
    label: "Nest Room 1",
    swf: "nestRoom1.swf",
    renderProbe: "/probes/nestRoom1-render-basics.html",
    returnDoorId: 1,
    doors: Object.freeze([
      Object.freeze({ id: 1, toLoc: 5, toDoor: 5, x1: 154, z1: 142, x2: 240, z2: 142 })
    ])
  }),

  2: Object.freeze({
    id: 2,
    key: "nestRoom2",
    label: "Nest Room 2",
    swf: "nestRoom2.swf",
    renderProbe: "/probes/nestRoom2-render-basics.html",
    returnDoorId: 1,
    doors: Object.freeze([
      Object.freeze({ id: 1, toLoc: 5, toDoor: 3, x1: -150, z1: 140, x2: -140, z2: -40 })
    ])
  }),

  3: Object.freeze({
    id: 3,
    key: "nestRoom3",
    label: "Nest Room 3",
    swf: "nestRoom3.swf",
    renderProbe: "/probes/nestRoom3-render-basics.html",
    returnDoorId: 1,
    doors: Object.freeze([
      Object.freeze({ id: 1, toLoc: 5, toDoor: 6, x1: -154, z1: 142, x2: -240, z2: 142 })
    ])
  }),

  4: Object.freeze({
    id: 4,
    key: "nestRoom4",
    label: "Nest Room 4",
    swf: "nestRoom4.swf",
    renderProbe: "/probes/nestRoom4-render-basics.html",
    returnDoorId: 1,
    doors: Object.freeze([
      Object.freeze({ id: 1, toLoc: 5, toDoor: 1, x1: 150, z1: 140, x2: 240, z2: 140 }),
      Object.freeze({ id: 2, toLoc: 7, toDoor: 1, x1: 150, z1: 140, x2: 140, z2: -40 })
    ])
  }),

  5: Object.freeze({
    id: 5,
    key: "nestHall",
    label: "Nest Hall",
    swf: "nestHall_03_06_11.swf",
    renderProbe: "/probes/nestHall_03_06_11-render-basics.html",
    doors: Object.freeze([
      Object.freeze({ id: 1, toLoc: 4, toDoor: 1, x1: -160, z1: 190, x2: -240, z2: 190 }),
      Object.freeze({ id: 2, toLoc: 6, toDoor: 1, x1: 160, z1: 190, x2: 240, z2: 190 }),
      Object.freeze({ id: 3, toLoc: 2, toDoor: 1, x1: -15, z1: 360, x2: -15, z2: 480 }),
      Object.freeze({ id: 4, toLoc: 8, toDoor: 1, x1: 0, z1: 160, x2: 0, z2: 10 }),
      Object.freeze({ id: 5, toLoc: 1, toDoor: 1, x1: -131, z1: 266, x2: -235, z2: 325 }),
      Object.freeze({ id: 6, toLoc: 3, toDoor: 1, x1: 155, z1: 245, x2: 240, z2: 262 }),
      Object.freeze({ id: 7, toLoc: 7, toDoor: 2, x1: -64, z1: 150, x2: -157, z2: 10 }),
      Object.freeze({ id: 8, toLoc: 9, toDoor: 2, x1: 50, z1: 150, x2: 140, z2: 10 }),
      Object.freeze({ id: 9, toLoc: 20, toDoor: 1, x1: -100, z1: 220, x2: -101, y2: 500, z2: 220 }),
      Object.freeze({ id: 10, toLoc: 10, toDoor: 1, x1: 155, z1: 130, x2: 155, y2: -150, z2: 130 })
    ])
  }),

  6: Object.freeze({
    id: 6,
    key: "nestRoom6",
    label: "Nest Room 6",
    swf: "nestRoom6.swf",
    renderProbe: "/probes/nestRoom6-render-basics.html",
    returnDoorId: 1,
    doors: Object.freeze([
      Object.freeze({ id: 1, toLoc: 5, toDoor: 2, x1: -150, z1: 140, x2: -240, z2: 140 }),
      Object.freeze({ id: 2, toLoc: 9, toDoor: 1, x1: -150, z1: 140, x2: -140, z2: -40 })
    ])
  }),

  7: Object.freeze({
    id: 7,
    key: "nestRoom7",
    label: "Nest Room 7",
    swf: "nestRoom7.swf",
    renderProbe: "/probes/nestRoom7-render-basics.html",
    returnDoorId: 2,
    doors: Object.freeze([
      Object.freeze({ id: 1, toLoc: 4, toDoor: 2, x1: 150, z1: 360, x2: 150, z2: 490 }),
      Object.freeze({ id: 2, toLoc: 5, toDoor: 7, x1: 154, z1: 142, x2: 240, z2: 142 })
    ])
  }),

  8: Object.freeze({
    id: 8,
    key: "nestRoom8",
    label: "Nest Room 8",
    swf: "nestRoom8.swf",
    renderProbe: "/probes/nestRoom8-render-basics.html",
    returnDoorId: 1,
    doors: Object.freeze([
      Object.freeze({ id: 1, toLoc: 5, toDoor: 4, x1: 0, z1: 360, x2: 0, z2: 490 })
    ])
  }),

  9: Object.freeze({
    id: 9,
    key: "nestRoom9",
    label: "Nest Room 9",
    swf: "nestRoom9.swf",
    renderProbe: "/probes/nestRoom9-render-basics.html",
    returnDoorId: 2,
    doors: Object.freeze([
      Object.freeze({ id: 1, toLoc: 6, toDoor: 2, x1: -150, z1: 360, x2: -150, z2: 490 }),
      Object.freeze({ id: 2, toLoc: 5, toDoor: 8, x1: -154, z1: 142, x2: -240, z2: 142 })
    ])
  }),

  10: Object.freeze({
    id: 10,
    key: "homeCinema",
    label: "Home Cinema",
    swf: "homeCinema_24_05_12.swf",
    renderProbe: null,
    deferred: true,
    reason: "Tycoon/home cinema room is not in the first simple Nest render set."
  }),

  20: Object.freeze({
    id: 20,
    key: "garden",
    label: "Garden",
    swf: "gardenBG_10_06_13.swf",
    renderProbe: null,
    deferred: true,
    reason: "Garden room is a later render target."
  })
});

export const NEST_HALL_DOOR_TO_LAYER_KEY = Object.freeze({
  1: "door1_mc",
  2: "door2_mc",
  3: "door3_mc",
  4: "door4_mc",
  5: "door5_mc",
  6: "door6_mc",
  7: "door7_mc",
  8: "door8_mc",
  9: "door9_mc",
  10: "door10_mc"
});

export function getNestLocation(locationId) {
  return NEST_LOCATIONS[locationId] || null;
}

export function getNestDoor(locationId, doorId) {
  const location = getNestLocation(locationId);

  if (!location) {
    return null;
  }

  return location.doors.find((door) => door.id === doorId) || null;
}

export function getNestDoorTarget(locationId, doorId) {
  const door = getNestDoor(locationId, doorId);

  if (!door) {
    return null;
  }

  return Object.freeze({
    fromLoc: locationId,
    fromDoor: doorId,
    toLoc: door.toLoc,
    toDoor: door.toDoor,
    targetLocation: getNestLocation(door.toLoc)
  });
}

export function getNestHallDoorLayerKey(doorId) {
  return NEST_HALL_DOOR_TO_LAYER_KEY[doorId] || null;
}
