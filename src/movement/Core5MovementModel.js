import {
  core5GetDir,
  core5WeevilSpeed,
  createCore5WalkBehaviour
} from "./Core5WalkBehaviour.js";

function makeDefaultLoc() {
  return {
    maintainY: false,
    isForbidden() {
      return false;
    },
    teleportCheck() {
      return false;
    },
    interact() {}
  };
}

function makeLeg() {
  return {
    pose: 4,
    setPose(value) {
      this.pose = value;
    }
  };
}

export class Core5MovementModel {
  constructor({
    x = 0,
    y = 0,
    z = 0,
    rotY = 0,
    weevilScale = 1,
    baseScale = 1,
    mine = true,
    broadcastMoves = false,
    crntLoc = null
  } = {}) {
    this.crntLoc = crntLoc || makeDefaultLoc();

    this.weevilScale = weevilScale;
    this.broadcastMoves = broadcastMoves;

    this.weevil = {
      x,
      y,
      z,
      rotY,
      mine,
      baseScale,
      scale: weevilScale * baseScale,
      pose: 0,
      walking: false,
      crntLoc: this.crntLoc,
      stopActionByID() {},
      resetYuserVar() {},
      maskIfNeeded() {}
    };

    this.creature = { y: 0, rotY: 0 };
    this.head = { rotY: 0 };
    this.legs = Array.from({ length: 6 }, makeLeg);

    this.moveList = [];
    this.events = [];

    this.exitDoor = null;
    this.exitedDoorID = 0;
    this.destLocID = 0;
    this.destDoorID = 0;
    this.destExtUIDataObj = null;

    this.walker = null;
  }

  get weevilSpeed() {
    return core5WeevilSpeed(this.weevilScale);
  }

  getDir(targetX, targetZ) {
    return core5GetDir(this.weevil, targetX, targetZ);
  }

  queueMove(x, z) {
    this.moveList.push({ x, z });
  }

  clearMoveList() {
    this.moveList = [];
  }

  setExitDoor(door) {
    this.exitDoor = door;
  }

  setDestLoc(locID, doorID) {
    this.destLocID = locID;
    this.destDoorID = doorID;
  }

  moveMyWeevil(
    targetX,
    targetZ,
    {
      ignoreCollisions = false,
      exitDoor = null,
      destLocID = 0,
      destDoorID = 0,
      destExtUIDataObj = null,
      direction = 999,
      reverse = false
    } = {}
  ) {
    const dir = direction === 999 ? this.getDir(targetX, targetZ) : direction;

    this.setExitDoor(exitDoor);
    this.setDestLoc(destLocID, destDoorID);
    this.destExtUIDataObj = destExtUIDataObj;

    this.walker = createCore5WalkBehaviour({
      weevil: this.weevil,
      creature: this.creature,
      head: this.head,
      legs: this.legs,
      crntLoc: this.crntLoc,
      onSendMove: (x, z, r) => {
        this.events.push({ type: "sendMove", x, z, r });
      },
      onArrived: () => {
        this.arrived();
      }
    });

    this.walker.init([
      targetX,
      targetZ,
      dir,
      this.weevilSpeed,
      ignoreCollisions,
      reverse
    ]);

    if (this.broadcastMoves) {
      this.events.push({ type: "sendMove", x: targetX, z: targetZ, r: dir });
    }

    return {
      x: targetX,
      z: targetZ,
      r: dir,
      speed: this.weevilSpeed
    };
  }

  update(frameStep = 1) {
    if (this.walker && !this.walker.halted) {
      this.walker.setPose(frameStep);
    }
  }

  getLegPoses() {
    return this.legs.map((leg) => leg.pose);
  }

  getSnapshot() {
    return {
      weevilScale: this.weevilScale,
      speed: this.weevilSpeed,
      weevil: {
        x: this.weevil.x,
        y: this.weevil.y,
        z: this.weevil.z,
        rotY: this.weevil.rotY,
        pose: this.weevil.pose,
        walking: Boolean(this.weevil.walking)
      },
      creature: {
        y: this.creature.y,
        rotY: this.creature.rotY
      },
      head: {
        rotY: this.head.rotY
      },
      legPoses: this.getLegPoses(),
      walker: this.walker && typeof this.walker.getSnapshot === "function"
        ? this.walker.getSnapshot()
        : null
    };
  }

  arrived() {
    this.weevil.walking = false;

    if (typeof this.crntLoc.interact === "function") {
      this.crntLoc.interact(this.weevil.x, this.weevil.z);
    }

    if (this.exitDoor != null) {
      this.exitedDoorID = this.exitDoor.id;
      this.events.push({
        type: "exitDoor",
        door: this.exitDoor,
        doorID: this.exitDoor.id
      });
      this.setExitDoor(null);
    } else if (this.destLocID !== 0) {
      this.events.push({
        type: "loadLoc",
        locID: this.destLocID,
        doorID: this.destDoorID
      });
      this.destLocID = 0;
    } else if (this.destExtUIDataObj != null) {
      this.destExtUIDataObj.fromDoorID = this.exitedDoorID;
      this.events.push({
        type: "loadInterface",
        data: this.destExtUIDataObj
      });
      this.destExtUIDataObj = null;
    }

    if (this.moveList.length > 0) {
      const next = this.moveList.shift();
      this.moveMyWeevil(next.x, next.z);
    }

    this.events.push({ type: "WEEVIL_ARRIVED" });
  }
}

export {
  core5GetDir,
  core5WeevilSpeed
};
