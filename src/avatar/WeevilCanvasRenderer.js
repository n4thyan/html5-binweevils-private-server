// Canvas renderer shell for Milestone 002.
//
// Current default mode is `debug`, which draws labelled placeholder layers.
// Future `atlas` mode is intentionally gated so real frame drawing cannot be
// mistaken for complete/final rendering before assets and coordinates are ready.

import { drawAtlasFrame, drawTintedAtlasFrame } from './AtlasFrameRenderer.js';

export class WeevilCanvasRenderer {
  constructor({ width = 180, height = 220, mode = 'debug' } = {}) {
    this.width = width;
    this.height = height;
    this.mode = mode;
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

    this.drawStage(ctx, 'debug placeholder');
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

    if (label) {
      ctx.fillStyle = '#d2c48b';
      ctx.font = '10px Consolas, Monaco, monospace';
      ctx.fillText(label, 8, 14);
    }
  }

  drawBody(ctx, plan) {
    ctx.fillStyle = plan.parts.body.colour.hex ?? '#777777';
    ctx.beginPath();
    ctx.ellipse(90, 132, 48, 62, 0, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = '#111111';
    ctx.stroke();
  }

  drawHead(ctx, plan) {
    ctx.fillStyle = plan.parts.head.colour.hex ?? '#999999';
    ctx.beginPath();
    ctx.ellipse(90, 70, 42, 38, 0, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = '#111111';
    ctx.stroke();
  }

  drawEyes(ctx, plan) {
    ctx.fillStyle = '#ffffff';
    ctx.beginPath();
    ctx.ellipse(74, 64, 11, 14, 0, 0, Math.PI * 2);
    ctx.ellipse(106, 64, 11, 14, 0, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = plan.parts.eyes.colour.hex ?? '#000000';
    ctx.beginPath();
    ctx.arc(74, 66, 5, 0, Math.PI * 2);
    ctx.arc(106, 66, 5, 0, Math.PI * 2);
    ctx.fill();
  }

  drawMouth(ctx, plan) {
    ctx.strokeStyle = '#111111';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.arc(90, 82, 15, 0.1, Math.PI - 0.1);
    ctx.stroke();
  }

  drawAntennae(ctx, plan) {
    ctx.strokeStyle = plan.parts.antennae.colour.hex ?? '#999999';
    ctx.lineWidth = 4;
    ctx.beginPath();
    ctx.moveTo(70, 40);
    ctx.lineTo(52, 16);
    ctx.moveTo(110, 40);
    ctx.lineTo(128, 16);
    ctx.stroke();

    ctx.fillStyle = plan.parts.antennae.colour.hex ?? '#999999';
    ctx.beginPath();
    ctx.arc(52, 16, 6, 0, Math.PI * 2);
    ctx.arc(128, 16, 6, 0, Math.PI * 2);
    ctx.fill();
  }

  drawLegs(ctx, plan) {
    ctx.strokeStyle = plan.parts.legs.colour.hex ?? '#777777';
    ctx.lineWidth = 6;

    for (const footX of [52, 76, 104, 128]) {
      ctx.beginPath();
      ctx.moveTo(90, 180);
      ctx.lineTo(footX, 206);
      ctx.stroke();
    }
  }

  drawLabels(ctx, plan) {
    ctx.fillStyle = '#f4e9bd';
    ctx.font = '10px Consolas, Monaco, monospace';
    ctx.fillText(plan.parts.body.atlas, 8, this.height - 34);
    ctx.fillText(plan.parts.head.atlas, 8, this.height - 22);
    ctx.fillText(plan.parts.mouth.atlas, 8, this.height - 10);
  }
}
