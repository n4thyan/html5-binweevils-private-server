// Canvas renderer shell for Milestone 002.
//
// Current default mode is `debug`, which draws labelled placeholder layers.
// Future `atlas` mode is intentionally gated so real frame drawing cannot be
// mistaken for complete/final rendering before assets and coordinates are ready.

import { drawAtlasFrame, drawTintedAtlasFrame } from './AtlasFrameRenderer.js';
import { WEEVIL_CANVAS_BOUNDS } from './WeevilVisualConfig.js';

export class WeevilCanvasRenderer {
  constructor({
    width = WEEVIL_CANVAS_BOUNDS.width,
    height = WEEVIL_CANVAS_BOUNDS.height,
    mode = 'debug'
  } = {}) {
    this.width = width;
    this.height = height;
    this.mode = mode;
    this.originX = WEEVIL_CANVAS_BOUNDS.originX;
    this.originY = WEEVIL_CANVAS_BOUNDS.originY;
  }

  render(ctx, plan, x, y, options = {}) {
    const mode = options.mode ?? this.mode;

    if (mode === 'atlas') {
      return this.renderAtlas(ctx, plan, x, y, options);
    }

    return this.renderDebug(ctx, plan, x, y);
  }

  renderDebug(ctx, plan, x, y) {
    ctx.save();
    ctx.translate(x, y);

    this.drawStage(ctx, 'debug visual-plan proof');
    this.drawLegs(ctx, plan);
    this.drawBody(ctx, plan);
    this.drawHead(ctx, plan);
    this.drawEyes(ctx, plan);
    this.drawMouth(ctx, plan);
    this.drawAntennae(ctx, plan);
    this.drawLabels(ctx, plan);

    ctx.restore();
    return { mode: 'debug', drawn: true };
  }

  renderAtlas(ctx, plan, x, y, options = {}) {
    const atlases = options.atlases;

    if (!atlases) {
      this.renderMissingAtlasNotice(ctx, x, y, 'No atlas bundle provided');
      return { mode: 'atlas', drawn: false, reason: 'missing-atlases' };
    }

    // This is a tiny smoke-test path only. It proves that atlas drawing helpers
    // can be called from the renderer, but it does not define final weevil
    // placement, masking, projection, or layer order.
    const bodyAtlas = atlases[plan.parts.body.atlas];
    const frameName = options.frameName ?? 'body.png';
    const colour = plan.parts.body.colour.hex;
    const ok = colour
      ? drawTintedAtlasFrame(ctx, bodyAtlas, frameName, x, y, colour, options)
      : drawAtlasFrame(ctx, bodyAtlas, frameName, x, y, options);

    if (!ok) {
      this.renderMissingAtlasNotice(ctx, x, y, `Missing atlas frame: ${frameName}`);
    }

    return { mode: 'atlas', drawn: ok, reason: ok ? null : 'missing-frame' };
  }

  renderMissingAtlasNotice(ctx, x, y, message) {
    ctx.save();
    ctx.translate(x, y);
    this.drawStage(ctx, 'atlas unavailable');
    ctx.fillStyle = '#f4e9bd';
    ctx.font = '12px Consolas, Monaco, monospace';
    ctx.fillText(message, 12, 28);
    ctx.restore();
  }

  drawStage(ctx, label = '') {
    ctx.strokeStyle = '#f4e9bd';
    ctx.strokeRect(0, 0, this.width, this.height);

    ctx.fillStyle = 'rgba(244, 233, 189, 0.08)';
    ctx.fillRect(0, 0, this.width, this.height);

    ctx.strokeStyle = 'rgba(244, 233, 189, 0.35)';
    ctx.beginPath();
    ctx.moveTo(this.originX - 8, this.originY);
    ctx.lineTo(this.originX + 8, this.originY);
    ctx.moveTo(this.originX, this.originY - 8);
    ctx.lineTo(this.originX, this.originY + 8);
    ctx.stroke();

    if (label) {
      ctx.fillStyle = '#d2c48b';
      ctx.font = '10px Consolas, Monaco, monospace';
      ctx.fillText(label, 8, 14);
    }
  }

  drawBody(ctx, plan) {
    const visual = plan.parts.body.visual;
    const scale = 0.42;
    const width = visual.width * scale;
    const height = visual.height * scale;
    const x = this.originX;
    const y = this.originY - 18;

    ctx.fillStyle = plan.parts.body.colour.hex ?? '#777777';
    ctx.beginPath();
    ctx.ellipse(x, y, width / 2, height / 2, 0, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = '#111111';
    ctx.stroke();
  }

  drawHead(ctx, plan) {
    const visual = plan.parts.head.visual;
    const scale = 0.38;
    const width = visual.width * scale;
    const height = visual.height * scale;
    const yawOffset = plan.yaw.yawFactor * 8;
    const x = this.originX + yawOffset;
    const y = this.originY + visual.y * 0.35;

    ctx.fillStyle = plan.parts.head.colour.hex ?? '#999999';
    ctx.beginPath();
    ctx.ellipse(x, y, width / 2, height / 2, 0, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = '#111111';
    ctx.stroke();
  }

  drawEyes(ctx, plan) {
    const headVisual = plan.parts.head.visual;
    const eye = plan.parts.eyes.position;
    const yaw = plan.yaw;
    const baseX = this.originX + yaw.yawFactor * 8;
    const baseY = this.originY + headVisual.y * 0.35;
    const eyeScale = 0.22;
    const offsetY = eye.y * eyeScale;
    const spacing = eye.dx * eyeScale * yaw.faceCompress;
    const leftX = baseX - spacing / 2 + yaw.yawFactor * 7;
    const rightX = baseX + spacing / 2 + yaw.yawFactor * 7;
    const eyeY = baseY + offsetY;
    const rx = 10 * eye.sx;
    const ry = 13 * eye.sy;

    ctx.fillStyle = '#ffffff';
    ctx.beginPath();
    ctx.ellipse(leftX, eyeY, rx, ry, 0, 0, Math.PI * 2);
    ctx.ellipse(rightX, eyeY, rx, ry, 0, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = plan.parts.eyes.colour.hex ?? '#000000';
    ctx.beginPath();
    ctx.arc(leftX + yaw.yawFactor * 2, eyeY + 2, 5, 0, Math.PI * 2);
    ctx.arc(rightX + yaw.yawFactor * 2, eyeY + 2, 5, 0, Math.PI * 2);
    ctx.fill();
  }

  drawMouth(ctx, plan) {
    const headVisual = plan.parts.head.visual;
    const yaw = plan.yaw;
    const x = this.originX + yaw.yawFactor * 12;
    const y = this.originY + headVisual.y * 0.35 + headVisual.mouthY * 0.35;
    const width = 16 * yaw.faceCompress;

    ctx.strokeStyle = '#111111';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.arc(x, y, width, 0.1, Math.PI - 0.1);
    ctx.stroke();
  }

  drawAntennae(ctx, plan) {
    const headVisual = plan.parts.head.visual;
    const baseY = this.originY + headVisual.y * 0.35 - 25;
    const yaw = plan.yaw;
    const baseX = this.originX + yaw.yawFactor * 8;

    ctx.strokeStyle = plan.parts.antennae.colour.hex ?? '#999999';
    ctx.lineWidth = 4;
    ctx.beginPath();
    ctx.moveTo(baseX - 20, baseY + 6);
    ctx.lineTo(baseX - 38 + yaw.yawFactor * 3, baseY - 18);
    ctx.moveTo(baseX + 20, baseY + 6);
    ctx.lineTo(baseX + 38 + yaw.yawFactor * 3, baseY - 18);
    ctx.stroke();

    ctx.fillStyle = plan.parts.antennae.colour.hex ?? '#999999';
    ctx.beginPath();
    ctx.arc(baseX - 38 + yaw.yawFactor * 3, baseY - 18, 6, 0, Math.PI * 2);
    ctx.arc(baseX + 38 + yaw.yawFactor * 3, baseY - 18, 6, 0, Math.PI * 2);
    ctx.fill();
  }

  drawLegs(ctx, plan) {
    ctx.strokeStyle = plan.parts.legs.colour.hex ?? '#777777';
    ctx.lineWidth = 6;

    const rootX = this.originX;
    const rootY = this.originY + 42;
    const yawOffset = plan.yaw.yawFactor * 4;

    for (const footX of [-42, -18, 18, 42]) {
      ctx.beginPath();
      ctx.moveTo(rootX + yawOffset, rootY - 22);
      ctx.lineTo(rootX + footX + yawOffset, rootY + 18);
      ctx.stroke();
    }
  }

  drawLabels(ctx, plan) {
    ctx.fillStyle = '#f4e9bd';
    ctx.font = '10px Consolas, Monaco, monospace';
    ctx.fillText(`${plan.parts.body.visual.label} / ${plan.parts.head.visual.label}`, 8, this.height - 46);
    ctx.fillText(`${plan.parts.eyes.visual.label} / ${plan.parts.mouth.atlas}`, 8, this.height - 34);
    ctx.fillText(`${plan.parts.antennae.name}`, 8, this.height - 22);
    ctx.fillText(`${plan.parts.legs.name} / ${plan.pose.poseName}`, 8, this.height - 10);
  }
}
