const TO_DEGR = 180 / Math.PI;

function flashInt(value) {
  return Math.trunc(value);
}

function makeLeg() {
  return {
    pose: 4,
    setPose(value) {
      this.pose = value;
    }
  };
}

function makeDefaultLoc() {
  return {
    maintainY: false,
    isForbidden() {
      return false;
    },
    teleportCheck() {
      return false;
    }
  };
}

export function core5GetDir(weevil, targetX, targetZ) {
  const dx = targetX - weevil.x;
  const dz = targetZ - weevil.z;

  if (dx === 0 && dz === 0) {
    return flashInt(weevil.rotY);
  }

  return flashInt(Math.atan2(-dx, -dz) * TO_DEGR);
}

export function core5WeevilSpeed(weevilScale) {
  return 8 * weevilScale;
}

export class Core5WalkBehaviour {
  constructor({
    weevil,
    creature = {},
    head = {},
    legs = [],
    crntLoc = null,
    onSendMove = null,
    onArrived = null
  }) {
    if (!weevil) {
      throw new Error("Core5WalkBehaviour requires a mutable weevil state object.");
    }

    this._id = 0;
    this._type = 0;

    this.weevil = weevil;
    this.creature = creature;
    this.head = head;
    this.legs = legs.length >= 6 ? legs : Array.from({ length: 6 }, makeLeg);
    this.crntLoc = crntLoc || weevil.crntLoc || makeDefaultLoc();

    this.onSendMove = onSendMove;
    this.onArrived = onArrived;

    this.xDest = 0;
    this.zDest = 0;
    this.rDest = 0;
    this.speed = 0;
    this.reverse = 1;

    this.xIncr = 0;
    this.zIncr = 0;
    this.xCheck = false;
    this.pos = false;

    this.dir = 0;
    this.r = 0;
    this.x = 0;
    this.z = 0;
    this.maintainY = false;

    this.rIncr = 0;
    this.dr = 0;
    this.rCheck = 0;
    this.cw = false;

    this.arrived = false;
    this.finalTurnInitialised = false;
    this.checkForHits = false;
    this.ignoreCollisions = false;
    this.halted = false;

    this.m = 4;
    this.n = 0;
    this.p = 0;
    this.q = 4;
  }

  get id() {
    return this._id;
  }

  get type() {
    return this._type;
  }

  init(params = []) {
    if (typeof this.weevil.stopActionByID === "function") {
      this.weevil.stopActionByID(33);
    }

    if (this.weevil.pose !== 0) {
      this.creature.y = 0;
      this.weevil.pose = 0;
    }

    this.x = this.weevil.x;
    this.z = this.weevil.z;
    this.creature.y = 0;

    this.crntLoc = this.weevil.crntLoc || this.crntLoc || makeDefaultLoc();
    this.maintainY = Boolean(this.crntLoc.maintainY);

    if (this.weevil.mine && !this.maintainY && this.weevil.y !== 0) {
      if (typeof this.weevil.resetYuserVar === "function") {
        this.weevil.resetYuserVar();
      }
    }

    this.ignoreCollisions = Boolean(params[4]);

    if (this.weevil.mine && !this.ignoreCollisions) {
      if (this.crntLoc.isForbidden(this.x, this.z)) {
        this.checkForHits = false;
      } else {
        this.checkForHits = true;
      }
    } else {
      this.checkForHits = false;
    }

    this.xDest = Number(params[0]);
    this.zDest = Number(params[1]);
    this.rDest = Number(params[2]);
    this.speed = Number(params[3]);
    this.reverse = params[5] === false ? 1 : -1;

    const dx = this.xDest - this.x;
    const dz = this.zDest - this.z;
    const distance = Math.sqrt(dx * dx + dz * dz);

    this.halted = false;

    if (distance > 0) {
      this.turn(Math.atan2(-dx, -dz * this.reverse) * TO_DEGR);

      const frames = distance / this.speed;
      this.xIncr = dx / frames;
      this.zIncr = dz / frames;

      if (Math.abs(dx) > Math.abs(dz)) {
        this.xCheck = true;
        this.pos = dx > 0;
      } else {
        this.xCheck = false;
        this.pos = dz > 0;
      }

      this.n = this.p = 0;
      this.m = this.q = 4;
      this.arrived = false;
      this.finalTurnInitialised = false;
    } else {
      this.r = this.weevil.rotY;
      this.arrived = true;
      this.finalTurnInitialised = false;
    }

    this.weevil.walking = true;
  }

  turn(direction) {
    this.dir = direction;
    this.r = this.weevil.rotY;
    this.dr = this.dir - this.r;

    if (this.dr > 180) {
      this.dr -= 360;
    } else if (this.dr < -180) {
      this.dr += 360;
    }

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

  turner(frameStep = 1) {
    const rDelta = this.rIncr * frameStep;

    this.r += rDelta;
    this.rCheck += rDelta;

    let headTurn = flashInt(3 * this.rCheck);

    if (headTurn > 70) {
      headTurn = 70;
    }

    if (headTurn < -70) {
      headTurn = -70;
    }

    if (this.cw) {
      --this.n;
      if (this.n < 0) this.n = 7;

      ++this.p;
      if (this.p > 7) this.p = 0;

      ++this.m;
      if (this.m > 7) this.m = 0;

      --this.q;
      if (this.q < 0) this.q = 7;

      if (this.r > 180) {
        this.r -= 360;
      }

      if (this.rCheck >= this.dr) {
        this.r = this.dir;
        this.rIncr = 0;
        this.head.rotY = 0;
        this.n = 0;
        this.m = 4;
      } else {
        this.head.rotY = Math.min(this.dr - this.rCheck, headTurn);
      }
    } else {
      ++this.n;
      if (this.n > 7) this.n = 0;

      --this.p;
      if (this.p < 0) this.p = 7;

      --this.m;
      if (this.m < 0) this.m = 7;

      ++this.q;
      if (this.q > 7) this.q = 0;

      if (this.r < 180) {
        this.r += 360;
      }

      if (this.rCheck <= this.dr) {
        this.r = this.dir;
        this.rIncr = 0;
        this.head.rotY = 0;
        this.n = 0;
        this.m = 4;
      } else {
        this.head.rotY = Math.max(this.dr - this.rCheck, headTurn);
      }
    }

    this.weevil.rotY = this.r;

    this.legs[0].setPose(this.n);
    this.legs[2].setPose(this.n);
    this.legs[4].setPose(this.p);
    this.legs[1].setPose(this.q);
    this.legs[3].setPose(this.m);
    this.legs[5].setPose(this.m);
  }

  getLegPoses() {
    return this.legs.map((leg) => leg.pose);
  }

  getSnapshot() {
    return {
      behaviourId: this.id,
      type: this.type,
      x: this.weevil.x,
      y: this.weevil.y,
      z: this.weevil.z,
      rotY: this.weevil.rotY,
      walking: Boolean(this.weevil.walking),
      arrived: Boolean(this.arrived),
      halted: Boolean(this.halted),
      destination: {
        x: this.xDest,
        z: this.zDest,
        r: this.rDest
      },
      increments: {
        x: this.xIncr,
        z: this.zIncr,
        r: this.rIncr
      },
      turn: {
        dir: this.dir,
        r: this.r,
        dr: this.dr,
        rCheck: this.rCheck,
        clockwise: Boolean(this.cw)
      },
      cycle: {
        n: this.n,
        m: this.m,
        p: this.p,
        q: this.q
      },
      creature: {
        y: this.creature.y ?? 0,
        rotY: this.creature.rotY ?? 0
      },
      head: {
        rotY: this.head.rotY ?? 0
      },
      legPoses: this.getLegPoses()
    };
  }

  setPose(frameStep = 1) {
    if (this.halted) {
      return;
    }

    if (!this.arrived) {
      if (this.rIncr !== 0) {
        this.turner(frameStep);
        return;
      }

      ++this.n;
      if (this.n > 7) this.n = 0;

      ++this.m;
      if (this.m > 7) this.m = 0;

      const xDelta = this.xIncr * frameStep;
      const zDelta = this.zIncr * frameStep;

      this.x += xDelta;
      this.z += zDelta;

      if (this.xCheck) {
        if (this.pos) {
          if (this.x >= this.xDest) this.arrived = true;
        } else if (this.x <= this.xDest) {
          this.arrived = true;
        }
      } else if (this.pos) {
        if (this.z >= this.zDest) this.arrived = true;
      } else if (this.z <= this.zDest) {
        this.arrived = true;
      }

      if (this.weevil.mine) {
        if (!this.crntLoc.teleportCheck(this.x, this.z)) {
          if (!this.ignoreCollisions && this.crntLoc.isForbidden(this.x, this.z)) {
            if (this.checkForHits) {
              this.weevil.x -= 3 * xDelta;
              this.weevil.z -= 3 * zDelta;
              this.xDest = this.weevil.x;
              this.zDest = this.weevil.z;
              this.arrived = true;

              if (typeof this.onSendMove === "function") {
                this.onSendMove(this.xDest, this.zDest, this.r);
              }

              this.halt();
            } else {
              this.weevil.x = this.x;
              this.weevil.z = this.z;
            }
          } else {
            this.checkForHits = true;
            this.weevil.x = this.x;
            this.weevil.z = this.z;
          }
        }
      } else {
        if (typeof this.weevil.maskIfNeeded === "function") {
          this.weevil.maskIfNeeded();
        }

        this.weevil.x = this.x;
        this.weevil.z = this.z;
      }

      if (!this.maintainY) {
        this.maintainY = false;
        this.weevil.y = 0;
      }

      this.creature.rotY = this.m - 3.5;

      this.legs[0].setPose(this.n);
      this.legs[2].setPose(this.n);
      this.legs[4].setPose(this.n);
      this.legs[1].setPose(this.m);
      this.legs[3].setPose(this.m);
      this.legs[5].setPose(this.m);

      return;
    }

    this.weevil.x = flashInt(this.xDest);
    this.weevil.z = flashInt(this.zDest);
    this.creature.rotY = 0;

    if (this.r !== this.rDest) {
      if (!this.finalTurnInitialised) {
        this.finalTurnInitialised = true;
        this.turn(this.rDest);
      }

      this.turner(frameStep);
    } else {
      this.halt();
    }
  }

  halt() {
    if (this.halted) {
      return;
    }

    this.halted = true;

    for (const leg of this.legs) {
      leg.setPose(4);
    }

    this.creature.rotY = 0;
    this.weevil.walking = false;

    if (typeof this.onArrived === "function") {
      this.onArrived();
    }
  }
}

export function createCore5WalkBehaviour(options) {
  return new Core5WalkBehaviour(options);
}
