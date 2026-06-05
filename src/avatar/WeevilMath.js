// Prototype-derived renderer math helpers.
//
// Source: old HTML5 demo renderer runtime `math.js`.
// Status: renderer support code. Keep visually matched to the proven demo
// renderer unless source/asset comparison proves a correction is needed.

export class Vec3 {
  constructor(x = 0, y = 0, z = 0) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  clone() {
    return new Vec3(this.x, this.y, this.z);
  }

  add(v) {
    return new Vec3(this.x + v.x, this.y + v.y, this.z + v.z);
  }

  subtract(v) {
    return new Vec3(this.x - v.x, this.y - v.y, this.z - v.z);
  }

  scale(s) {
    return new Vec3(this.x * s, this.y * s, this.z * s);
  }

  dot(v) {
    return this.x * v.x + this.y * v.y + this.z * v.z;
  }

  cross(v) {
    return new Vec3(
      this.y * v.z - this.z * v.y,
      this.z * v.x - this.x * v.z,
      this.x * v.y - this.y * v.x
    );
  }

  length() {
    return Math.hypot(this.x, this.y, this.z);
  }

  normalize() {
    const length = this.length() || 1;
    return new Vec3(this.x / length, this.y / length, this.z / length);
  }
}

export const DEG_TO_RAD = Math.PI / 180;
export const RAD_TO_DEG = 180 / Math.PI;

export function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

export function wrap360(degrees) {
  let value = degrees % 360;
  if (value < 0) value += 360;
  return value;
}

export function snapAngles(pitchDegrees, yawDegrees) {
  const pitch = clamp(Math.round(pitchDegrees / 5) * 5, 0, 50);
  const yaw = wrap360(Math.round(yawDegrees / 5) * 5);

  return {
    pitch,
    yaw,
    pitchIndex: Math.round(pitch / 5),
    yawIndex: Math.round(yaw / 5)
  };
}
