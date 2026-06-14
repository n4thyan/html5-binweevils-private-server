const DEFAULT_VIEWPORT = Object.freeze({
  d: 600,
  w: 825,
  h: 490,
  xOffset: 104,
  yOffset: 12,
  x0: 825 * 0.5,
  y0: 490 * 0.5,
  zoomFactor: 1
});

const NEST_PROJECTION_CONFIGS = Object.freeze({
  defaultRoom: Object.freeze({
    id: "defaultRoom",
    boundType: "rect",
    boundary: Object.freeze({ x: -170, z: 30, w: 340, h: 340 }),
    camera: Object.freeze({
      x: 0,
      y: 190,
      z: -330,
      aimX: 0,
      aimY: 90,
      aimZ: 260
    }),
    weevilScale: 0.5
  }),

  hall: Object.freeze({
    id: "hall",
    boundType: "rad",
    boundary: Object.freeze({ x: 0, z: 185, r: 168 }),
    camera: Object.freeze({
      x: 0,
      y: 145,
      z: -115,
      aimX: 0,
      aimY: 15,
      aimZ: 500
    }),
    weevilScale: 0.45
  }),

  garden: Object.freeze({
    id: "garden",
    boundType: "rad",
    boundary: Object.freeze({ x: -3, z: 360, r: 197 }),
    camera: Object.freeze({
      x: -880,
      y: 870,
      z: -680,
      aimX: 10,
      aimY: 108,
      aimZ: 200
    }),
    weevilScale: 0.16
  })
});

const NORMAL_NEST_ROOM_IDS = new Set([1, 2, 3, 4, 6, 7, 8, 9, 55]);

function vector(x = 0, y = 0, z = 0) {
  return { x: Number(x), y: Number(y), z: Number(z) };
}

function subtract(a, b) {
  return vector(a.x - b.x, a.y - b.y, a.z - b.z);
}

function crossProduct(a, b) {
  return vector(
    a.y * b.z - a.z * b.y,
    a.z * b.x - a.x * b.z,
    a.x * b.y - a.y * b.x
  );
}

function norm(v) {
  return Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
}

function unit(v) {
  const length = norm(v);

  if (!Number.isFinite(length) || length === 0) {
    return vector(0, 0, 0);
  }

  return vector(v.x / length, v.y / length, v.z / length);
}

function negate(v) {
  return vector(-v.x, -v.y, -v.z);
}

function rotateAroundAxis(v, axis, sinValue, cosValue) {
  const oneMinusCos = 1 - cosValue;

  return vector(
    v.x * (oneMinusCos * axis.x * axis.x + cosValue)
      + v.y * (oneMinusCos * axis.x * axis.y - sinValue * axis.z)
      + v.z * (oneMinusCos * axis.x * axis.z + sinValue * axis.y),

    v.x * (oneMinusCos * axis.x * axis.y + sinValue * axis.z)
      + v.y * (oneMinusCos * axis.y * axis.y + cosValue)
      + v.z * (oneMinusCos * axis.y * axis.z - sinValue * axis.x),

    v.x * (oneMinusCos * axis.x * axis.z - sinValue * axis.y)
      + v.y * (oneMinusCos * axis.y * axis.z + sinValue * axis.x)
      + v.z * (oneMinusCos * axis.z * axis.z + cosValue)
  );
}

export function getNestProjectionConfig(locationId) {
  if (Number(locationId) === 5) {
    return NEST_PROJECTION_CONFIGS.hall;
  }

  if (Number(locationId) === 20) {
    return NEST_PROJECTION_CONFIGS.garden;
  }

  if (NORMAL_NEST_ROOM_IDS.has(Number(locationId))) {
    return NEST_PROJECTION_CONFIGS.defaultRoom;
  }

  return NEST_PROJECTION_CONFIGS.defaultRoom;
}

export function createCore5Camera(cameraConfig) {
  const camPos = vector(cameraConfig.x, cameraConfig.y, cameraConfig.z);
  const aim = vector(cameraConfig.aimX, cameraConfig.aimY, cameraConfig.aimZ);

  const out = unit(subtract(aim, camPos));
  let side = unit(crossProduct(out, vector(0, 1, 0)));
  let up = unit(crossProduct(side, out));

  side = negate(side);

  return {
    x: camPos.x,
    y: camPos.y,
    z: camPos.z,
    aimX: aim.x,
    aimY: aim.y,
    aimZ: aim.z,
    side,
    up,
    out
  };
}

export function isWithinCore5Viewport(stageX, stageY, viewport = DEFAULT_VIEWPORT) {
  return (
    stageX > viewport.xOffset
    && stageX < viewport.w * viewport.zoomFactor + viewport.xOffset
    && stageY > viewport.yOffset
    && stageY < viewport.h * viewport.zoomFactor + viewport.yOffset
  );
}

export function getFloorClickCoords(stageX, stageY, options = {}) {
  const viewport = options.viewport || DEFAULT_VIEWPORT;
  const projectionConfig = options.projectionConfig || getNestProjectionConfig(options.locationId || 5);
  const camera = options.camera || createCore5Camera(projectionConfig.camera);
  const floorY = Number.isFinite(Number(options.floorY)) ? Number(options.floorY) : 0;

  if (!isWithinCore5Viewport(stageX, stageY, viewport)) {
    return null;
  }

  let localX = stageX - viewport.x0 * viewport.zoomFactor - viewport.xOffset;
  let localY = stageY - viewport.y0 * viewport.zoomFactor - viewport.yOffset;

  localX /= viewport.zoomFactor;
  localY /= viewport.zoomFactor;

  const thetaX = Math.atan2(localY, viewport.d);
  const thetaY = Math.atan2(localX, viewport.d);

  let side = { ...camera.side };
  let up = { ...camera.up };
  let out = { ...camera.out };

  side = rotateAroundAxis(side, up, Math.sin(thetaY), Math.cos(thetaY));
  out = rotateAroundAxis(out, up, Math.sin(thetaY), Math.cos(thetaY));

  up = rotateAroundAxis(up, side, Math.sin(thetaX), Math.cos(thetaX));
  out = rotateAroundAxis(out, side, Math.sin(thetaX), Math.cos(thetaX));

  if (out.y >= 0) {
    return null;
  }

  const distance = (camera.y - floorY) / -out.y;

  return {
    x: Math.trunc(camera.x + distance * out.x),
    z: Math.trunc(camera.z + distance * out.z)
  };
}

export function projectCore5PointToScreen(x, y = 0, z, options = {}) {
  const viewport = options.viewport || DEFAULT_VIEWPORT;
  const projectionConfig = options.projectionConfig || getNestProjectionConfig(options.locationId || 5);
  const camera = options.camera || createCore5Camera(projectionConfig.camera);

  const translated = vector(
    Number(x) - camera.x,
    Number(y) - camera.y,
    Number(z) - camera.z
  );

  const cameraSpace = vector(
    translated.x * camera.side.x + translated.y * camera.side.y + translated.z * camera.side.z,
    translated.x * camera.up.x + translated.y * camera.up.y + translated.z * camera.up.z,
    translated.x * camera.out.x + translated.y * camera.out.y + translated.z * camera.out.z
  );

  cameraSpace.z -= viewport.d;

  const scale = viewport.d / (viewport.d + cameraSpace.z);

  return {
    x: (viewport.x0 + cameraSpace.x * scale) * viewport.zoomFactor + viewport.xOffset,
    y: (viewport.y0 - cameraSpace.y * scale) * viewport.zoomFactor + viewport.yOffset,
    scale
  };
}

export function legaliseNestCore5Point(x, z, options = {}) {
  const projectionConfig = options.projectionConfig || getNestProjectionConfig(options.locationId || 5);
  const weevilScale = Number.isFinite(Number(options.weevilScale))
    ? Number(options.weevilScale)
    : projectionConfig.weevilScale;

  let pointX = Number(x);
  let pointZ = Number(z);

  if (!Number.isFinite(pointX) || !Number.isFinite(pointZ)) {
    return null;
  }

  if (projectionConfig.boundType === "rect") {
    const boundary = projectionConfig.boundary;
    const margin = 40 * weevilScale;
    const left = boundary.x;
    const top = boundary.z;
    const right = boundary.x + boundary.w;
    const bottom = boundary.z + boundary.h;

    if (
      pointX > right + margin
      || pointX < left - margin
      || pointZ > bottom + margin
      || pointZ < top - margin
    ) {
      return null;
    }

    pointX = Math.min(Math.max(pointX, left), right);
    pointZ = Math.min(Math.max(pointZ, top), bottom);

    return { x: pointX, z: pointZ };
  }

  if (projectionConfig.boundType === "rad") {
    const boundary = projectionConfig.boundary;
    const dx = pointX - boundary.x;
    const dz = pointZ - boundary.z;
    const distance = Math.sqrt(dx * dx + dz * dz);

    if (distance > boundary.r) {
      const ratio = boundary.r / distance;
      pointX = boundary.x + dx * ratio;
      pointZ = boundary.z + dz * ratio;
    }

    return { x: pointX, z: pointZ };
  }

  return { x: pointX, z: pointZ };
}

export { DEFAULT_VIEWPORT, NEST_PROJECTION_CONFIGS };
