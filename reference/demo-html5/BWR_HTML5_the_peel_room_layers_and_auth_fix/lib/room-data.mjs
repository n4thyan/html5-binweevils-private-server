export const ROOM_WORLD = { width: 1024, height: 640 };

const ROOM_DEFINITIONS = {
  the_peel: {
    id: 'the_peel',
    name: 'The Peel',
    summary: 'The first live HTML5 room test for movement, chat bubbles and saved weevil rendering.',
    backgroundPath: '/img/the-peel-room.png',
    floorPath: '/img/the-peel-floor.png',
    foregroundPath: '/img/the-peel-foreground.png',
    bounds: { minX: 120, maxX: 922, minY: 332, maxY: 596 },
    spawn: { minX: 300, maxX: 740, minY: 430, maxY: 560 },
    obstacles: [
      { type: 'ellipse', cx: 785, cy: 430, rx: 205, ry: 135 },
      { type: 'ellipse', cx: 715, cy: 505, rx: 115, ry: 60 }
    ]
  }
};

export function listRoomDefinitions() {
  return Object.values(ROOM_DEFINITIONS).map((room) => ({
    id: room.id,
    name: room.name,
    summary: room.summary,
    backgroundPath: room.backgroundPath,
    floorPath: room.floorPath || room.backgroundPath,
    foregroundPath: room.foregroundPath || '',
    bounds: { ...room.bounds },
    spawn: { ...room.spawn },
    obstacles: room.obstacles.map((obstacle) => ({ ...obstacle }))
  }));
}

export function getRoomDefinition(roomId = 'the_peel') {
  return ROOM_DEFINITIONS[String(roomId || '').trim()] || ROOM_DEFINITIONS.the_peel;
}

function projectOutsideEllipse(x, y, obstacle) {
  const rx = Math.max(1, Number(obstacle.rx || 0) + Number(obstacle.padding || 0));
  const ry = Math.max(1, Number(obstacle.ry || 0) + Number(obstacle.padding || 0));
  let dx = x - Number(obstacle.cx || 0);
  let dy = y - Number(obstacle.cy || 0);
  if (dx === 0 && dy === 0) {
    dx = Number(obstacle.escapeX || 1);
    dy = Number(obstacle.escapeY || 0.25);
  }
  const norm = (dx * dx) / (rx * rx) + (dy * dy) / (ry * ry);
  if (norm >= 1) return { x, y, changed: false };
  const scale = 1 / Math.sqrt(Math.max(norm, 1e-6));
  return {
    x: Number(obstacle.cx || 0) + dx * scale,
    y: Number(obstacle.cy || 0) + dy * scale,
    changed: true
  };
}

function resolveObstacles(room, x, y) {
  let next = { x, y };
  for (let pass = 0; pass < 6; pass += 1) {
    let moved = false;
    for (const obstacle of room.obstacles || []) {
      if (obstacle.type !== 'ellipse') continue;
      const projected = projectOutsideEllipse(next.x, next.y, obstacle);
      if (projected.changed) {
        next = projected;
        moved = true;
      }
    }
    if (!moved) break;
  }
  return next;
}

export function clampRoomPosition(roomId, x, y) {
  const room = getRoomDefinition(roomId);
  const bounds = room.bounds || ROOM_DEFINITIONS.the_peel.bounds;
  let next = {
    x: Math.max(bounds.minX, Math.min(bounds.maxX, Math.round(Number(x) || 0))),
    y: Math.max(bounds.minY, Math.min(bounds.maxY, Math.round(Number(y) || 0)))
  };
  next = resolveObstacles(room, next.x, next.y);
  next.x = Math.max(bounds.minX, Math.min(bounds.maxX, Math.round(next.x)));
  next.y = Math.max(bounds.minY, Math.min(bounds.maxY, Math.round(next.y)));
  return next;
}

export function roomSpawnForUser(userId = '', roomId = 'the_peel') {
  const room = getRoomDefinition(roomId);
  const seed = Array.from(String(userId)).reduce((acc, char) => acc + char.charCodeAt(0), 0);
  const spawn = room.spawn || ROOM_DEFINITIONS.the_peel.spawn;
  const width = Math.max(1, spawn.maxX - spawn.minX);
  const height = Math.max(1, spawn.maxY - spawn.minY);
  return clampRoomPosition(
    room.id,
    spawn.minX + (seed * 37 % width),
    spawn.minY + (seed * 17 % height)
  );
}

export function getPublicRoomConfig() {
  return {
    defaultRoomId: 'the_peel',
    maps: listRoomDefinitions()
  };
}
