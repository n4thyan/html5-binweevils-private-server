export const ProjectionModes = Object.freeze({
  FLAT: 'flat',
  SOURCE_CAMERA: 'source-camera'
});

const WORLD_UP = [0, 1, 0];

function dot(a, b) {
  return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

function cross(a, b) {
  return [
    a[1] * b[2] - a[2] * b[1],
    a[2] * b[0] - a[0] * b[2],
    a[0] * b[1] - a[1] * b[0]
  ];
}

function subtract(a, b) {
  return [a[0] - b[0], a[1] - b[1], a[2] - b[2]];
}

function add(a, b) {
  return [a[0] + b[0], a[1] + b[1], a[2] + b[2]];
}

function multiply(v, scalar) {
  return [v[0] * scalar, v[1] * scalar, v[2] * scalar];
}

function length(v) {
  return Math.sqrt(dot(v, v));
}

function normalise(v) {
  const len = length(v) || 1;
  return [v[0] / len, v[1] / len, v[2] / len];
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

function toScreenPoint(canvas, x, y) {
  return {
    x: clamp(x, -canvas.width * 4, canvas.width * 5),
    y: clamp(y, -canvas.height * 4, canvas.height * 5)
  };
}

function getBoundaryExtents(room) {
  const pad = room.stage.worldPadding ?? 80;
  const boundary = room.bounds.boundary;

  if (room.bounds.type === 'rad') {
    const [cx, cz, r] = boundary;
    return { minX: cx - r - pad, minZ: cz - r - pad, maxX: cx + r + pad, maxZ: cz + r + pad };
  }

  const [minX, minZ, maxX, maxZ] = boundary;
  return { minX: minX - pad, minZ: minZ - pad, maxX: maxX + pad, maxZ: maxZ + pad };
}

export function createRoomProjection(room, canvas, mode = ProjectionModes.FLAT) {
  if (mode === ProjectionModes.SOURCE_CAMERA) {
    return new SourceCameraProjection(room, canvas);
  }
  return new FlatRoomProjection(room, canvas);
}

export class FlatRoomProjection {
  constructor(room, canvas) {
    this.room = room;
    this.canvas = canvas;
    this.mode = ProjectionModes.FLAT;
  }

  worldExtents() {
    return getBoundaryExtents(this.room);
  }

  worldToScreen(x, z, y = 0) {
    const ext = this.worldExtents();
    const nx = (x - ext.minX) / (ext.maxX - ext.minX);
    const nz = (z - ext.minZ) / (ext.maxZ - ext.minZ);
    return {
      x: nx * this.canvas.width,
      y: nz * this.canvas.height,
      depth: z + y
    };
  }

  screenToWorld(screenX, screenY) {
    const ext = this.worldExtents();
    return {
      x: ext.minX + (screenX / this.canvas.width) * (ext.maxX - ext.minX),
      y: 0,
      z: ext.minZ + (screenY / this.canvas.height) * (ext.maxZ - ext.minZ)
    };
  }

  depthForWorld(x, z, y = 0) {
    return z + y;
  }

  scaleForWorld() {
    return 1;
  }
}

export class SourceCameraProjection {
  constructor(room, canvas) {
    this.room = room;
    this.canvas = canvas;
    this.mode = ProjectionModes.SOURCE_CAMERA;

    this.camPos = room.camera?.camPos ?? [0, 200, -400];
    this.camAim = room.camera?.camAim ?? [0, 0, 300];
    this.camBounds = room.camera?.camBounds ?? null;

    this.forward = normalise(subtract(this.camAim, this.camPos));

    // Camera basis using Y-up 3D room coordinates.
    // Fixed-camera rooms such as Nest Hall are expected to work from this single source camera.
    // Rotatable rooms such as Ink's Orange still need their room-specific camera rotation logic ported later.
    this.right = normalise(cross(this.forward, WORLD_UP));
    this.up = normalise(cross(this.right, this.forward));

    const distanceToAim = length(subtract(this.camAim, this.camPos));
    this.focalLength = room.camera?.focalLength ?? Math.max(560, Math.min(980, distanceToAim * 1.55));
    this.centerX = room.camera?.screenCenter?.[0] ?? canvas.width / 2;
    this.centerY = room.camera?.screenCenter?.[1] ?? canvas.height * 0.58;
    this.baseDepth = Math.max(1, dot(subtract([room.entry.position[0], 0, room.entry.position[1]], this.camPos), this.forward));
  }

  worldToScreen(x, z, y = 0) {
    const point = [x, y, z];
    const rel = subtract(point, this.camPos);
    const vx = dot(rel, this.right);
    const vy = dot(rel, this.up);
    const vz = dot(rel, this.forward);
    const safeDepth = Math.max(1, vz);

    return {
      ...toScreenPoint(
        this.canvas,
        this.centerX + (vx / safeDepth) * this.focalLength,
        this.centerY - (vy / safeDepth) * this.focalLength
      ),
      depth: vz
    };
  }

  screenToWorld(screenX, screenY) {
    const viewX = (screenX - this.centerX) / this.focalLength;
    const viewY = -(screenY - this.centerY) / this.focalLength;

    const dir = normalise(add(add(this.forward, multiply(this.right, viewX)), multiply(this.up, viewY)));
    const denom = dir[1];

    if (Math.abs(denom) < 0.0001) {
      const fallback = this.room.entry.position;
      return { x: fallback[0], y: 0, z: fallback[1] };
    }

    const t = (0 - this.camPos[1]) / denom;
    const hit = add(this.camPos, multiply(dir, t));
    return { x: hit[0], y: 0, z: hit[2] };
  }

  depthForWorld(x, z, y = 0) {
    return dot(subtract([x, y, z], this.camPos), this.forward);
  }

  scaleForWorld(x, z, y = 0) {
    const depth = Math.max(1, this.depthForWorld(x, z, y));
    return clamp(this.baseDepth / depth, 0.45, 1.8);
  }
}
