// Prototype-derived renderer projection helpers.
//
// Source: old HTML5 demo renderer runtime `projection.js`.
// These helpers support the visually-correct weevil renderer transplant.

import { DEG_TO_RAD, Vec3 } from './WeevilMath.js';

export const CAMERA_DISTANCE = 2000;
export const FOCAL_LENGTH = 600;
export const DEFAULT_DEPTH_OFFSET = CAMERA_DISTANCE - FOCAL_LENGTH;

export function createCamera(pitchDegrees, yawDegrees, distance = CAMERA_DISTANCE) {
  const pitch = pitchDegrees * DEG_TO_RAD;
  const yaw = yawDegrees * DEG_TO_RAD;

  const pos = new Vec3(
    Math.sin(yaw) * Math.cos(pitch) * distance,
    Math.sin(pitch) * distance,
    Math.cos(yaw) * Math.cos(pitch) * distance
  );

  const out = new Vec3(-pos.x, -pos.y, -pos.z).normalize();
  const side = out.cross(new Vec3(0, 1, 0)).normalize().scale(-1);
  const up = side.cross(out).normalize();

  return { pos, side, up, out, distance };
}

export function transformPoint(point, camera, focal = FOCAL_LENGTH) {
  const relative = point.subtract(camera.pos);
  return new Vec3(
    camera.side.dot(relative),
    camera.up.dot(relative),
    camera.out.dot(relative) - focal
  );
}

export function projectPoint(point, camera, { focal = FOCAL_LENGTH, sf = 1 } = {}) {
  const transformed = transformPoint(point, camera, focal);
  const ratio = focal / (focal + transformed.z);

  return {
    x: transformed.x * ratio * sf,
    y: transformed.y * ratio * sf,
    scale: ratio * sf,
    depth: -transformed.z + DEFAULT_DEPTH_OFFSET,
    transformed
  };
}
