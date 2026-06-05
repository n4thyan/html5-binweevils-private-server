import { AvatarState } from '../avatar/AvatarState.js';
import { WeevilCanvasRenderer } from '../avatar/WeevilCanvasRenderer.js';
import { SAMPLE_WEEVIL_DEF } from '../avatar/WeevilDefSamples.js';

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

    ctx.fillStyle = '#171717';
    ctx.fillRect(0, 0, this.stage.width, this.stage.height);

    ctx.fillStyle = '#f4e9bd';
    ctx.font = '24px Arial, sans-serif';
    ctx.fillText('Bin Weevils HTML5 Port Foundation', 40, 70);

    ctx.fillStyle = '#d2c48b';
    ctx.font = '16px Arial, sans-serif';
    ctx.fillText('Milestone 002: legacy demo asset renderer path', 40, 105);
    ctx.fillText('Using the proven old HTML5 demo renderer and extracted weevil assets.', 40, 132);

    this.renderDefinitionPanel(ctx, 40, 180);
    this.renderStatePanel(ctx, 640, 180);
    this.renderer.render(ctx, this.renderPlan, 700, 385, { mode: 'legacy-demo-assets' });
  }

  renderDefinitionPanel(ctx, x, y) {
    const decoded = this.avatar.weevilDef.toJSON();

    ctx.strokeStyle = '#f4e9bd';
    ctx.strokeRect(x, y, 560, 340);

    ctx.fillStyle = '#f4e9bd';
    ctx.font = '16px Arial, sans-serif';
    ctx.fillText('WeevilDef source-format decode', x + 20, y + 32);

    ctx.font = '14px Consolas, Monaco, monospace';
    ctx.fillText(`raw: ${this.avatar.weevilDef.raw}`, x + 20, y + 66);
    ctx.fillText(`valid: ${this.validation.ok ? 'yes' : 'no'}`, x + 20, y + 90);

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
      const rowY = y + 122 + index * 18;
      ctx.fillStyle = '#d2c48b';
      ctx.fillText(`${label}:`, x + 20, rowY);
      ctx.fillStyle = '#f4e9bd';
      ctx.fillText(String(value), x + 220, rowY);
    });

    this.renderColourSwatch(ctx, 'head', decoded.colours.head, x + 360, y + 110);
    this.renderColourSwatch(ctx, 'body', decoded.colours.body, x + 360, y + 150);
    this.renderColourSwatch(ctx, 'eyes', decoded.colours.eyes, x + 360, y + 190);
    this.renderColourSwatch(ctx, 'antennae', decoded.colours.antennae, x + 360, y + 230);
    this.renderColourSwatch(ctx, 'legs', decoded.colours.legs, x + 360, y + 270);

    ctx.fillStyle = '#d2c48b';
    ctx.font = '14px Arial, sans-serif';
    ctx.fillText(`runtime: ${Math.floor(this.elapsedMs)}ms`, x + 20, y + 315);
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

    ctx.strokeStyle = '#f4e9bd';
    ctx.strokeRect(x, y, 340, 260);

    ctx.fillStyle = '#f4e9bd';
    ctx.font = '16px Arial, sans-serif';
    ctx.fillText('AvatarState + RenderPlan', x + 20, y + 32);

    ctx.fillStyle = '#d2c48b';
    ctx.font = '13px Arial, sans-serif';
    ctx.fillText('Source-backed fields, demo-backed visuals.', x + 20, y + 58);

    ctx.font = '13px Consolas, Monaco, monospace';
    rows.forEach(([label, value], index) => {
      const rowY = y + 90 + index * 17;
      ctx.fillStyle = '#d2c48b';
      ctx.fillText(`${label}:`, x + 20, rowY);
      ctx.fillStyle = '#f4e9bd';
      ctx.fillText(String(value), x + 120, rowY);
    });
  }

  renderColourSwatch(ctx, label, colour, x, y) {
    ctx.fillStyle = colour.hex ?? '#000000';
    ctx.fillRect(x, y - 14, 26, 18);

    ctx.strokeStyle = '#f4e9bd';
    ctx.strokeRect(x, y - 14, 26, 18);

    ctx.fillStyle = '#f4e9bd';
    ctx.font = '13px Consolas, Monaco, monospace';
    ctx.fillText(`${label}: ${colour.hex ?? 'n/a'} [${colour.index}]`, x + 36, y);
  }
}
