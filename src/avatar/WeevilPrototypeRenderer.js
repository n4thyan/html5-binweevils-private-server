// Isolated prototype renderer path.
//
// This file is the clean landing zone for the visually-correct old HTML5 demo
// renderer. The current implementation is still canvas/vector based, but it is
// structured around the same render-plan data that the final atlas renderer will
// consume.
//
// Do not add room, movement, network, or backend logic here.

import { WEEVIL_CANVAS_BOUNDS, WEEVIL_STAGE_CONFIG } from './WeevilVisualConfig.js';

export class WeevilPrototypeRenderer {
  constructor({
    width = WEEVIL_CANVAS_BOUNDS.width,
    height = WEEVIL_CANVAS_BOUNDS.height,
    originX = WEEVIL_CANVAS_BOUNDS.originX,
    originY = WEEVIL_CANVAS_BOUNDS.originY
  } = {}) {
    this.width = width;
    this.height = height;
    this.originX = originX;
    this.originY = originY;
  }

  render(ctx, plan, x, y, options = {}) {
    ctx.save();
    ctx.translate(x, y);

    if (options.stage !== false) {
      this.drawDebugStage(ctx, 'prototype renderer path');
    }

    this.drawGroundShadow(ctx, plan);
    this.drawBackLegs(ctx, plan);
    this.drawBody(ctx, plan);
    this.drawFrontLegs(ctx, plan);
    this.drawHead(ctx, plan);
    this.drawAntennae(ctx, plan);
    this.drawEyes(ctx, plan);
    this.drawMouth(ctx, plan);
    this.drawRendererLabels(ctx, plan);

    ctx.restore();

    return {
      mode: 'prototype',
      drawn: true,
      status: 'vector-shell-awaiting-atlas-shape-transplant'
    };
  }

  drawDebugStage(ctx, label) {
    ctx.strokeStyle = '#f4e9bd';
    ctx.strokeRect(0, 0, this.width, this.height);

    ctx.fillStyle = 'rgba(244, 233, 189, 0.06)';
    ctx.fillRect(0, 0, this.width, this.height);

    ctx.strokeStyle = 'rgba(244, 233, 189, 0.35)';
    ctx.beginPath();
    ctx.moveTo(this.originX - 8, this.originY);
    ctx.lineTo(this.originX + 8, this.originY);
    ctx.moveTo(this.originX, this.originY - 8);
    ctx.lineTo(this.originX, this.originY + 8);
    ctx.stroke();

    ctx.fillStyle = '#d2c48b';
    ctx.font = '10px Consolas, Monaco, monospace';
    ctx.fillText(label, 8, 14);
  }

  drawGroundShadow(ctx) {
    const shadow = WEEVIL_STAGE_CONFIG.groundShadow;
    ctx.save();
    ctx.globalAlpha = shadow.alpha;
    ctx.fillStyle = '#000000';
    ctx.beginPath();
    ctx.ellipse(
      this.originX + shadow.x,
      this.originY + shadow.y,
      shadow.rx * 0.34,
      shadow.ry * 0.34,
      0,
      0,
      Math.PI * 2
    );
    ctx.fill();
    ctx.restore();
  }

  drawBody(ctx, plan) {
    const visual = plan.parts.body.visual;
    const scale = 0.42;
    const width = visual.width * scale;
    const height = visual.height * scale;
    const center = this.getBodyCenter(plan);

    ctx.fillStyle = plan.parts.body.colour.hex ?? '#777777';
    ctx.beginPath();
    ctx.ellipse(center.x, center.y, width / 2, height / 2, 0, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = '#111111';
    ctx.lineWidth = 1.5;
    ctx.stroke();
  }

  drawHead(ctx, plan) {
    const visual = plan.parts.head.visual;
    const scale = 0.38;
    const width = visual.width * scale;
    const height = visual.height * scale;
    const center = this.getHeadCenter(plan);

    ctx.fillStyle = plan.parts.head.colour.hex ?? '#999999';
    ctx.beginPath();
    ctx.ellipse(center.x, center.y, width / 2, height / 2, 0, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = '#111111';
    ctx.lineWidth = 1.5;
    ctx.stroke();
  }

  drawEyes(ctx, plan) {
    const positions = this.getEyePositions(plan);
    const rx = 10 * plan.parts.eyes.position.sx;
    const ry = 13 * plan.parts.eyes.position.sy;

    ctx.fillStyle = '#ffffff';
    ctx.beginPath();
    ctx.ellipse(positions.left.x, positions.left.y, rx, ry, 0, 0, Math.PI * 2);
    ctx.ellipse(positions.right.x, positions.right.y, rx, ry, 0, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = plan.parts.eyes.colour.hex ?? '#000000';
    ctx.beginPath();
    ctx.arc(positions.left.x + plan.yaw.yawFactor * 2, positions.left.y + 2, 5, 0, Math.PI * 2);
    ctx.arc(positions.right.x + plan.yaw.yawFactor * 2, positions.right.y + 2, 5, 0, Math.PI * 2);
    ctx.fill();

    if (plan.parts.eyes.lids) {
      ctx.strokeStyle = '#111111';
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(positions.left.x - rx, positions.left.y - 3);
      ctx.lineTo(positions.left.x + rx, positions.left.y - 3);
      ctx.moveTo(positions.right.x - rx, positions.right.y - 3);
      ctx.lineTo(positions.right.x + rx, positions.right.y - 3);
      ctx.stroke();
    }
  }

  drawMouth(ctx, plan) {
    const head = this.getHeadCenter(plan);
    const mouthY = plan.parts.head.visual.mouthY * 0.35;
    const x = head.x + plan.yaw.yawFactor * 7;
    const y = head.y + mouthY;
    const width = 16 * plan.yaw.faceCompress;

    ctx.strokeStyle = '#111111';
    ctx.lineWidth = 2;
    ctx.beginPath();

    if (plan.parts.mouth.expression === 1) {
      ctx.arc(x, y + 8, width, Math.PI + 0.1, Math.PI * 2 - 0.1);
    } else {
      ctx.arc(x, y, width, 0.1, Math.PI - 0.1);
    }

    ctx.stroke();
  }

  drawAntennae(ctx, plan) {
    if (Number(plan.parts.antennae.type) === 0) return;

    const head = this.getHeadCenter(plan);
    const baseY = head.y - 25;
    const yaw = plan.yaw;

    ctx.strokeStyle = plan.parts.antennae.colour.hex ?? '#999999';
    ctx.lineWidth = 4;
    ctx.beginPath();
    ctx.moveTo(head.x - 20, baseY + 6);
    ctx.lineTo(head.x - 38 + yaw.yawFactor * 3, baseY - 18);
    ctx.moveTo(head.x + 20, baseY + 6);
    ctx.lineTo(head.x + 38 + yaw.yawFactor * 3, baseY - 18);
    ctx.stroke();

    ctx.fillStyle = plan.parts.antennae.colour.hex ?? '#999999';
    ctx.beginPath();
    ctx.arc(head.x - 38 + yaw.yawFactor * 3, baseY - 18, 6, 0, Math.PI * 2);
    ctx.arc(head.x + 38 + yaw.yawFactor * 3, baseY - 18, 6, 0, Math.PI * 2);
    ctx.fill();
  }

  drawBackLegs(ctx, plan) {
    this.drawLegSet(ctx, plan, [-32, 32], 0.65);
  }

  drawFrontLegs(ctx, plan) {
    this.drawLegSet(ctx, plan, [-48, -16, 16, 48], 1);
  }

  drawLegSet(ctx, plan, feet, alpha) {
    ctx.save();
    ctx.globalAlpha = alpha;
    ctx.strokeStyle = plan.parts.legs.colour.hex ?? '#777777';
    ctx.lineWidth = 6;

    const root = this.getLegRoot(plan);
    const yawOffset = plan.yaw.yawFactor * 4;

    for (const footX of feet) {
      ctx.beginPath();
      ctx.moveTo(root.x + yawOffset, root.y - 22);
      ctx.lineTo(root.x + footX + yawOffset, root.y + 18);
      ctx.stroke();
    }

    ctx.restore();
  }

  drawRendererLabels(ctx, plan) {
    ctx.fillStyle = '#f4e9bd';
    ctx.font = '10px Consolas, Monaco, monospace';
    ctx.fillText(`${plan.parts.body.visual.label} / ${plan.parts.head.visual.label}`, 8, this.height - 46);
    ctx.fillText(`${plan.parts.eyes.visual.label} / ${plan.parts.mouth.atlas}`, 8, this.height - 34);
    ctx.fillText(`${plan.parts.antennae.name}`, 8, this.height - 22);
    ctx.fillText(`${plan.parts.legs.name} / ${plan.pose.poseName}`, 8, this.height - 10);
  }

  getBodyCenter(plan) {
    return {
      x: this.originX,
      y: this.originY - 18 + (plan.pose.ps === 6 ? 10 : 0)
    };
  }

  getHeadCenter(plan) {
    return {
      x: this.originX + plan.yaw.yawFactor * 8,
      y: this.originY + plan.parts.head.visual.y * 0.35 + (plan.pose.ps === 6 ? 8 : 0)
    };
  }

  getLegRoot(plan) {
    return {
      x: this.originX,
      y: this.originY + 42 + (plan.pose.ps === 6 ? 8 : 0)
    };
  }

  getEyePositions(plan) {
    const head = this.getHeadCenter(plan);
    const eye = plan.parts.eyes.position;
    const spacing = eye.dx * 0.22 * plan.yaw.faceCompress;
    const eyeY = head.y + eye.y * 0.22;
    const yawShift = plan.yaw.yawFactor * 7;

    return {
      left: {
        x: head.x - spacing / 2 + yawShift,
        y: eyeY
      },
      right: {
        x: head.x + spacing / 2 + yawShift,
        y: eyeY
      }
    };
  }
}
