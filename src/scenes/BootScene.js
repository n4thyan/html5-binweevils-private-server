import { AvatarState } from '../avatar/AvatarState.js';
import { RENDERER_BASELINE_SAMPLES, createBaselineUserVars } from '../avatar/RendererBaselineSamples.js';
import { WeevilCanvasRenderer } from '../avatar/WeevilCanvasRenderer.js';
import { SAMPLE_WEEVIL_DEF } from '../avatar/WeevilDefSamples.js';
import { GameShellRenderer } from '../ui/GameShellRenderer.js';

export class BootScene {
  constructor({ stage }) {
    this.stage = stage;
    this.elapsedMs = 0;
    this.avatar = AvatarState.fromUserVars({
      userId: 1,
      idx: 1,
      name: 'debug_weevil',
      weevilDef: SAMPLE_WEEVIL_DEF,
      x: 420,
      y: 0,
      z: 260,
      r: 0,
      ps: 0,
      ex: 0,
      apparel: '|null:-140,-140,-140',
      doorID: 0,
      locID: 0
    });
    this.renderPlan = this.avatar.createRenderPlan();
    this.renderer = new WeevilCanvasRenderer({ mode: 'legacy-demo-assets' });
    this.shell = new GameShellRenderer({ width: this.stage.width, height: this.stage.height });
    this.samplePlans = RENDERER_BASELINE_SAMPLES.map((sample, index) => ({
      sample,
      avatar: AvatarState.fromUserVars(createBaselineUserVars(sample, index + 1))
    })).map((entry) => ({
      ...entry,
      plan: entry.avatar.createRenderPlan()
    }));
    this.validation = this.renderPlan.validation;
  }

  enter() {
    this.elapsedMs = 0;
  }

  update(deltaMs) {
    this.elapsedMs += deltaMs;
  }

  render() {
    const ctx = this.stage.context;
    this.stage.clear();

    this.shell.render(ctx, {
      title: 'Bin Weevils HTML5 Port Foundation',
      subtitle: 'Milestone 004 shell preview, renderer locked'
    });

    ctx.fillStyle = '#fff6b8';
    ctx.font = '18px Arial, sans-serif';
    ctx.fillText('Milestone 004: client shell preview', 62, 132);

    ctx.fillStyle = '#e4d895';
    ctx.font = '13px Arial, sans-serif';
    ctx.fillText('Static UI frame only. Rooms, chat, movement and backend are not active yet.', 62, 154);

    this.renderDefinitionPanel(ctx, 62, 188);
    this.renderStatePanel(ctx, 640, 188);
    this.renderBaselinePanel(ctx, 640, 464);
    this.renderer.render(ctx, this.renderPlan, 690, 384, { mode: 'legacy-demo-assets' });
  }

  renderDefinitionPanel(ctx, x, y) {
    const decoded = this.avatar.weevilDef.toJSON();

    this.panel(ctx, x, y, 520, 302);

    ctx.fillStyle = '#fff6b8';
    ctx.font = '16px Arial, sans-serif';
    ctx.fillText('WeevilDef source-format decode', x + 20, y + 30);

    ctx.font = '12px Consolas, Monaco, monospace';
    ctx.fillText(`raw: ${this.avatar.weevilDef.raw}`, x + 20, y + 62);
    ctx.fillText(`valid: ${this.validation.ok ? 'yes' : 'no'}`, x + 20, y + 84);

    const rows = [
      ['headType', decoded.headType],
      ['headColourIndex', decoded.headColourIndex],
      ['bodyType', decoded.bodyType],
      ['bodyColourIndex', decoded.bodyColourIndex],
      ['eyeType', decoded.eyeType],
      ['eyeColourIndex', decoded.eyeColourIndex],
      ['lids', decoded.lids],
      ['antennaType', decoded.antennaType],
      ['antennaColourIndex', decoded.antennaColourIndex],
      ['legColourIndex', decoded.legColourIndex],
      ['legType', decoded.legType]
    ];

    rows.forEach(([label, value], index) => {
      const rowY = y + 112 + index * 15;
      ctx.fillStyle = '#d2c48b';
      ctx.fillText(`${label}:`, x + 20, rowY);
      ctx.fillStyle = '#fff6b8';
      ctx.fillText(String(value), x + 188, rowY);
    });

    this.renderColourSwatch(ctx, 'head', decoded.colours.head, x + 316, y + 106);
    this.renderColourSwatch(ctx, 'body', decoded.colours.body, x + 316, y + 140);
    this.renderColourSwatch(ctx, 'eyes', decoded.colours.eyes, x + 316, y + 174);
    this.renderColourSwatch(ctx, 'antennae', decoded.colours.antennae, x + 316, y + 208);
    this.renderColourSwatch(ctx, 'legs', decoded.colours.legs, x + 316, y + 242);

    ctx.fillStyle = '#d2c48b';
    ctx.font = '12px Arial, sans-serif';
    ctx.fillText(`runtime: ${Math.floor(this.elapsedMs)}ms`, x + 20, y + 282);
  }

  renderStatePanel(ctx, x, y) {
    const avatar = this.avatar.toJSON();
    const plan = this.renderPlan;
    const rows = [
      ['name', avatar.name],
      ['userId', avatar.userId],
      ['idx', avatar.idx],
      ['x/y/z/r', `${avatar.x}/${avatar.y}/${avatar.z}/${avatar.r}`],
      ['ps/ex', `${avatar.ps}/${avatar.ex}`],
      ['body', `${plan.parts.body.visual.label} ${plan.parts.body.visual.width}x${plan.parts.body.visual.height}`],
      ['head', `${plan.parts.head.visual.label} ${plan.parts.head.visual.width}x${plan.parts.head.visual.height}`],
      ['eyes', `${plan.parts.eyes.visual.label} ${plan.parts.eyes.atlasSet}`],
      ['mouth', plan.parts.mouth.atlas],
      ['legs', `${plan.parts.legs.name} ${plan.parts.legs.lowerFrame}`]
    ];

    this.panel(ctx, x, y, 300, 246);

    ctx.fillStyle = '#fff6b8';
    ctx.font = '15px Arial, sans-serif';
    ctx.fillText('AvatarState + RenderPlan', x + 18, y + 28);

    ctx.fillStyle = '#d2c48b';
    ctx.font = '11px Arial, sans-serif';
    ctx.fillText('Source-backed fields, demo-backed visuals.', x + 18, y + 52);

    ctx.font = '11px Consolas, Monaco, monospace';
    rows.forEach(([label, value], index) => {
      const rowY = y + 82 + index * 15;
      ctx.fillStyle = '#d2c48b';
      ctx.fillText(`${label}:`, x + 18, rowY);
      ctx.fillStyle = '#fff6b8';
      ctx.fillText(String(value), x + 112, rowY);
    });
  }

  renderBaselinePanel(ctx, x, y) {
    this.panel(ctx, x, y, 300, 104);

    ctx.fillStyle = '#fff6b8';
    ctx.font = '14px Arial, sans-serif';
    ctx.fillText('Renderer baseline samples', x + 18, y + 24);

    this.samplePlans.forEach((entry, index) => {
      const drawX = x + 16 + index * 92;
      const drawY = y + 30;
      this.renderer.render(ctx, entry.plan, drawX, drawY, {
        mode: 'legacy-demo-assets',
        displayWidth: 82,
        displayHeight: 82
      });
      ctx.fillStyle = '#d2c48b';
      ctx.font = '8px Consolas, Monaco, monospace';
      ctx.fillText(entry.sample.id, drawX + 2, y + 94);
    });
  }

  renderColourSwatch(ctx, label, colour, x, y) {
    ctx.fillStyle = colour.hex ?? '#000000';
    ctx.fillRect(x, y - 12, 24, 16);

    ctx.strokeStyle = '#fff6b8';
    ctx.strokeRect(x, y - 12, 24, 16);

    ctx.fillStyle = '#fff6b8';
    ctx.font = '11px Consolas, Monaco, monospace';
    ctx.fillText(`${label}: ${colour.hex ?? 'n/a'} [${colour.index}]`, x + 34, y);
  }

  panel(ctx, x, y, w, h) {
    ctx.save();
    ctx.fillStyle = 'rgba(12, 18, 9, 0.78)';
    ctx.strokeStyle = '#b9e660';
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.roundRect(x, y, w, h, 12);
    ctx.fill();
    ctx.stroke();
    ctx.restore();
  }
}
