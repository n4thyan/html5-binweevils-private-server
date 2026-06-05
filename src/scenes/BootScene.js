import { WeevilDef } from '../avatar/WeevilDef.js';
import { SAMPLE_WEEVIL_DEF } from '../avatar/WeevilDefSamples.js';

export class BootScene {
  constructor({ stage }) {
    this.stage = stage;
    this.elapsedMs = 0;
    this.sampleDef = new WeevilDef(SAMPLE_WEEVIL_DEF);
    this.validation = WeevilDef.validate(SAMPLE_WEEVIL_DEF);
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
    ctx.fillText('Milestone 002: source-derived WeevilDef decode proof', 40, 105);
    ctx.fillText('No room, chat, account, or multiplayer systems are active yet.', 40, 132);

    this.renderDefinitionPanel(ctx, 40, 180);
  }

  renderDefinitionPanel(ctx, x, y) {
    const decoded = this.sampleDef.toJSON();

    ctx.strokeStyle = '#f4e9bd';
    ctx.strokeRect(x, y, 560, 340);

    ctx.fillStyle = '#f4e9bd';
    ctx.font = '16px Arial, sans-serif';
    ctx.fillText('WeevilDef source-format decode', x + 20, y + 32);

    ctx.font = '14px Consolas, Monaco, monospace';
    ctx.fillText(`raw: ${SAMPLE_WEEVIL_DEF}`, x + 20, y + 66);
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
