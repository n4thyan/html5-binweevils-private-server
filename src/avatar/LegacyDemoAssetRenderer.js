import { loadAtlasMap, loadImage } from '../../reference/demo-html5/BWR_HTML5_the_peel_room_layers_and_auth_fix/public/weevil-creator/src/runtime/canvasAtlasLoader.js';
import { WeevilCanvasRenderer as DemoWeevilCanvasRenderer } from '../../reference/demo-html5/BWR_HTML5_the_peel_room_layers_and_auth_fix/public/weevil-creator/src/runtime/WeevilCanvasRenderer.js';
import { WEEVIL_CANVAS_BOUNDS } from './WeevilVisualConfig.js';

const DEMO_CREATOR_BASE_URL = new URL(
  '../../reference/demo-html5/BWR_HTML5_the_peel_room_layers_and_auth_fix/public/weevil-creator/',
  import.meta.url
).href.replace(/\/$/, '');

export class LegacyDemoAssetRenderer {
  constructor({
    width = WEEVIL_CANVAS_BOUNDS.width,
    height = WEEVIL_CANVAS_BOUNDS.height,
    offscreenWidth = 420,
    offscreenHeight = 420,
    displayWidth = 240,
    displayHeight = 240,
    pitch = 16,
    yaw = 302
  } = {}) {
    this.width = width;
    this.height = height;
    this.offscreenWidth = offscreenWidth;
    this.offscreenHeight = offscreenHeight;
    this.displayWidth = displayWidth;
    this.displayHeight = displayHeight;
    this.pitch = pitch;
    this.yaw = yaw;
    this.loadPromise = null;
    this.loadError = null;
    this.isReady = false;
    this.canvas = null;
    this.renderer = null;
  }

  preload() {
    if (this.loadPromise) return this.loadPromise;

    this.loadPromise = this.createRenderer()
      .then(() => {
        this.isReady = true;
        return this;
      })
      .catch((error) => {
        this.loadError = error;
        console.error('[LegacyDemoAssetRenderer] failed to load demo renderer assets', error);
        return this;
      });

    return this.loadPromise;
  }

  async createRenderer() {
    if (typeof document === 'undefined') {
      throw new Error('LegacyDemoAssetRenderer requires a browser document');
    }

    this.canvas = document.createElement('canvas');
    this.canvas.width = this.offscreenWidth;
    this.canvas.height = this.offscreenHeight;

    const [atlases, upperLegImage, lowerLegImage, lowerLegStripyImage] = await Promise.all([
      loadAtlasMap(DEMO_CREATOR_BASE_URL),
      loadImage(`${DEMO_CREATOR_BASE_URL}/assets/raw/misc/upper_leg.png`),
      loadImage(`${DEMO_CREATOR_BASE_URL}/assets/raw/misc/lower_leg.png`),
      loadImage(`${DEMO_CREATOR_BASE_URL}/assets/raw/misc/lower_leg_stripy.png`)
    ]);

    this.renderer = new DemoWeevilCanvasRenderer(
      this.canvas,
      atlases,
      new Map([
        ['upper_leg.png', upperLegImage],
        ['lower_leg.png', lowerLegImage],
        ['lower_leg_stripy.png', lowerLegStripyImage]
      ])
    );
    this.renderer.autoRotate = false;
    this.renderer.resize(this.offscreenWidth, this.offscreenHeight);
  }

  render(ctx, plan, x, y, options = {}) {
    if (!this.isReady) {
      this.preload();
      this.drawStatus(ctx, x, y, this.loadError ? 'demo asset renderer failed' : 'loading demo asset renderer...');
      return {
        mode: 'legacy-demo-assets',
        drawn: false,
        reason: this.loadError ? 'load-error' : 'loading'
      };
    }

    const expressionIndex = Number(plan.parts.mouth.expression ?? plan.pose.expression ?? 0);
    this.renderer.setDefinition(planToDemoDefinition(plan), { expressionIndex });
    this.renderer.setView(options.pitch ?? this.pitch, options.yaw ?? planRotationToDemoYaw(plan, this.yaw));
    this.renderer.render();

    const displayWidth = options.displayWidth ?? this.displayWidth;
    const displayHeight = options.displayHeight ?? this.displayHeight;
    const drawX = x - Math.max(0, (displayWidth - this.width) * 0.5);
    const drawY = y - Math.max(0, (displayHeight - this.height) * 0.35);

    ctx.save();
    ctx.drawImage(this.canvas, drawX, drawY, displayWidth, displayHeight);
    ctx.restore();

    return {
      mode: 'legacy-demo-assets',
      drawn: true,
      status: 'rendered-with-old-demo-asset-renderer'
    };
  }

  drawStatus(ctx, x, y, message) {
    ctx.save();
    ctx.strokeStyle = '#f4e9bd';
    ctx.strokeRect(x, y, this.width, this.height);
    ctx.fillStyle = '#d2c48b';
    ctx.font = '11px Consolas, Monaco, monospace';
    ctx.fillText(message, x + 8, y + 24);
    ctx.restore();
  }
}

function planToDemoDefinition(plan) {
  return {
    ht: Number(plan.parts.head.type) || 1,
    hc: colourValue(plan.parts.head.colour, 0xffffff),
    bt: Number(plan.parts.body.type) || 1,
    bc: colourValue(plan.parts.body.colour, 0xffffff),
    et: Number(plan.parts.eyes.type) || 1,
    ec: colourValue(plan.parts.eyes.colour, 0x000000),
    at: Number(plan.parts.antennae.type) || 0,
    ac: colourValue(plan.parts.antennae.colour, 0xffffff),
    hat: 0,
    hatc: 0x6b4a12,
    lc: colourValue(plan.parts.legs.colour, 0xffffff),
    lt: Number(plan.parts.legs.type) || 0
  };
}

function colourValue(colour, fallback) {
  if (typeof colour?.value === 'number') return colour.value;
  if (typeof colour?.hex === 'string') return Number.parseInt(colour.hex.replace('#', ''), 16);
  return fallback;
}

function planRotationToDemoYaw(plan, fallbackYaw) {
  const rotation = Number(plan.pose?.rotation ?? plan.source?.rotation);
  if (!Number.isFinite(rotation) || rotation === 0) return fallbackYaw;
  return ((fallbackYaw + rotation) % 360 + 360) % 360;
}
