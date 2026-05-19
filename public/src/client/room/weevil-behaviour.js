const TO_DEGREES = 180 / Math.PI;

export const WeevilBehaviourIds = Object.freeze({
  WALK: 0,
  JUMP: 1,
  WAVE1: 2,
  WAVE2: 3,
  SHAKE_HEAD: 4,
  NOD: 5,
  SQUAT: 6,
  STAND_TALL: 7
});

export function normaliseAngle(value) {
  return ((value % 360) + 360) % 360;
}

export function signedAngleDelta(from, to) {
  return ((normaliseAngle(to) - normaliseAngle(from) + 540) % 360) - 180;
}

function wrapPose(value) {
  if (value < 0) return 7;
  if (value > 7) return 0;
  return value;
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

// Source-derived HTML5 port of the original weevil Walk.as behaviour.
// This intentionally keeps the same concepts as the AS3 code: x/z destination,
// rotation destination, speed, reverse flag, 5-degree turn steps, leg pose cycling,
// head yaw during turns, final turn after arrival, and idle leg pose 4.
export class SourceWalkBehaviour {
  constructor() {
    this.reset();
  }

  reset() {
    this.x = 0;
    this.z = 0;
    this.xDest = 0;
    this.zDest = 0;
    this.r = 0;
    this.rDest = 0;
    this.dir = 0;
    this.speed = 135;
    this.reverse = 1;
    this.xIncr = 0;
    this.zIncr = 0;
    this.xCheck = false;
    this.pos = false;
    this.rIncr = 0;
    this.dr = 0;
    this.rCheck = 0;
    this.cw = false;
    this.arrived = true;
    this.finalTurnInitialised = false;
    this.n = 0;
    this.p = 0;
    this.m = 4;
    this.q = 4;
    this.headRotY = 0;
    this.creatureRotY = 0;
    return this;
  }

  init({ x, z, rotY, targetX, targetZ, targetRotY = rotY, speed = 135, reverse = false }) {
    this.x = x;
    this.z = z;
    this.r = rotY;
    this.xDest = targetX;
    this.zDest = targetZ;
    this.rDest = targetRotY;
    this.speed = speed;
    this.reverse = reverse ? -1 : 1;
    this.headRotY = 0;
    this.creatureRotY = 0;

    const dx = this.xDest - this.x;
    const dz = this.zDest - this.z;
    const distance = Math.sqrt(dx * dx + dz * dz);

    if (distance > 0) {
      this.turn(Math.atan2(-dx, -dz * this.reverse) * TO_DEGREES);

      const duration = distance / this.speed;
      this.xIncr = dx / duration;
      this.zIncr = dz / duration;

      if (Math.abs(dx) > Math.abs(dz)) {
        this.xCheck = true;
        this.pos = dx > 0;
      } else {
        this.xCheck = false;
        this.pos = dz > 0;
      }

      this.n = 0;
      this.p = 0;
      this.m = 4;
      this.q = 4;
      this.arrived = false;
      this.finalTurnInitialised = false;
    } else {
      this.arrived = true;
      this.finalTurnInitialised = false;
    }

    return this.snapshot();
  }

  turn(direction) {
    this.dir = direction;
    this.dr = this.dir - this.r;

    if (this.dr > 180) this.dr -= 360;
    else if (this.dr < -180) this.dr += 360;

    if (this.dr > 0) {
      this.cw = true;
      this.rIncr = 5;
    } else if (this.dr < 0) {
      this.cw = false;
      this.rIncr = -5;
    } else {
      this.rIncr = 0;
    }

    this.rCheck = 0;
  }

  turner(frameScale = 1) {
    const step = this.rIncr * frameScale;
    this.r += step;
    this.rCheck += step;

    let headTurn = clamp(3 * this.rCheck, -70, 70);

    if (this.cw) {
      this.n = wrapPose(this.n - 1);
      this.p = wrapPose(this.p + 1);
      this.m = wrapPose(this.m + 1);
      this.q = wrapPose(this.q - 1);

      if (this.r > 180) this.r -= 360;

      if (this.rCheck >= this.dr) {
        this.r = this.dir;
        this.rIncr = 0;
        this.headRotY = 0;
        this.n = 0;
        this.m = 4;
      } else {
        this.headRotY = Math.min(this.dr - this.rCheck, headTurn);
      }
    } else {
      this.n = wrapPose(this.n + 1);
      this.p = wrapPose(this.p - 1);
      this.m = wrapPose(this.m - 1);
      this.q = wrapPose(this.q + 1);

      if (this.r < 180) this.r += 360;

      if (this.rCheck <= this.dr) {
        this.r = this.dir;
        this.rIncr = 0;
        this.headRotY = 0;
        this.n = 0;
        this.m = 4;
      } else {
        this.headRotY = Math.max(this.dr - this.rCheck, headTurn);
      }
    }
  }

  step(frameScale = 1, options = {}) {
    const isForbidden = options.isForbidden || (() => false);

    if (!this.arrived) {
      if (this.rIncr !== 0) {
        this.turner(frameScale);
      } else {
        this.n = wrapPose(this.n + 1);
        this.m = wrapPose(this.m + 1);

        const dx = this.xIncr * frameScale;
        const dz = this.zIncr * frameScale;
        const nextX = this.x + dx;
        const nextZ = this.z + dz;

        this.x = nextX;
        this.z = nextZ;

        if (this.xCheck) {
          if ((this.pos && this.x >= this.xDest) || (!this.pos && this.x <= this.xDest)) {
            this.arrived = true;
          }
        } else if ((this.pos && this.z >= this.zDest) || (!this.pos && this.z <= this.zDest)) {
          this.arrived = true;
        }

        if (isForbidden(this.x, this.z)) {
          this.x -= 3 * dx;
          this.z -= 3 * dz;
          this.xDest = this.x;
          this.zDest = this.z;
          this.arrived = true;
          this.halt();
        }

        this.creatureRotY = this.m - 3.5;
      }
    } else {
      this.x = Math.trunc(this.xDest);
      this.z = Math.trunc(this.zDest);
      this.creatureRotY = 0;

      if (this.r !== this.rDest) {
        if (!this.finalTurnInitialised) {
          this.finalTurnInitialised = true;
          this.turn(this.rDest);
        }
        this.turner(frameScale);
      } else {
        this.halt();
      }
    }

    return this.snapshot();
  }

  halt() {
    this.n = 4;
    this.p = 4;
    this.m = 4;
    this.q = 4;
    this.rIncr = 0;
    this.headRotY = 0;
    this.creatureRotY = 0;
    this.arrived = true;
  }

  snapshot() {
    const turning = this.rIncr !== 0;
    const moving = !this.arrived;

    return {
      x: this.x,
      z: this.z,
      rotY: this.r,
      arrived: this.arrived,
      moving,
      turning,
      poseState: {
        creatureY: moving ? 0 : 0,
        creatureRotY: this.creatureRotY,
        headRotX: 0,
        headRotY: this.headRotY,
        shadowAlpha: 1,
        legs: turning
          ? [this.n, this.q, this.n, this.m, this.p, this.m]
          : [this.n, this.m, this.n, this.m, this.n, this.m]
      }
    };
  }
}
