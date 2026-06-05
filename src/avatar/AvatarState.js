import { WeevilDef } from './WeevilDef.js';
import { createWeevilRenderPlan } from './WeevilRenderPlan.js';

export class AvatarState {
  constructor({
    userId = null,
    idx = null,
    name = '',
    weevilDef,
    x = 0,
    y = 0,
    z = 0,
    r = 0,
    ps = 0,
    ex = 0,
    apparel = '|null:-140,-140,-140',
    doorId = 0,
    locId = null,
    isModerator = false
  } = {}) {
    this.userId = userId;
    this.idx = idx;
    this.name = name;
    this.weevilDef = new WeevilDef(weevilDef ?? '101102103001040501');
    this.x = Number(x);
    this.y = Number(y);
    this.z = Number(z);
    this.r = Number(r);
    this.ps = Number(ps);
    this.ex = Number(ex);
    this.apparel = apparel;
    this.doorId = Number(doorId);
    this.locId = locId;
    this.isModerator = Boolean(isModerator);
  }

  static fromUserVars(vars = {}) {
    return new AvatarState({
      userId: vars.userId ?? vars.userID ?? null,
      idx: vars.idx ?? null,
      name: vars.name ?? '',
      weevilDef: vars.weevilDef,
      x: vars.x ?? 0,
      y: vars.y ?? 0,
      z: vars.z ?? 0,
      r: vars.r ?? 0,
      ps: vars.ps ?? 0,
      ex: vars.ex ?? 0,
      apparel: vars.apparel ?? '|null:-140,-140,-140',
      doorId: vars.doorID ?? vars.doorId ?? 0,
      locId: vars.locID ?? vars.locId ?? null,
      isModerator: vars.isModerator ?? vars.m ?? false
    });
  }

  updatePosition({ x = this.x, y = this.y, z = this.z, r = this.r } = {}) {
    this.x = Number(x);
    this.y = Number(y);
    this.z = Number(z);
    this.r = Number(r);
    return this;
  }

  updatePose({ ps = this.ps, ex = this.ex } = {}) {
    this.ps = Number(ps);
    this.ex = Number(ex);
    return this;
  }

  createRenderPlan() {
    return createWeevilRenderPlan(this.weevilDef, { expression: this.ex });
  }

  toJSON() {
    return {
      userId: this.userId,
      idx: this.idx,
      name: this.name,
      weevilDef: this.weevilDef.raw,
      x: this.x,
      y: this.y,
      z: this.z,
      r: this.r,
      ps: this.ps,
      ex: this.ex,
      apparel: this.apparel,
      doorId: this.doorId,
      locId: this.locId,
      isModerator: this.isModerator
    };
  }
}
