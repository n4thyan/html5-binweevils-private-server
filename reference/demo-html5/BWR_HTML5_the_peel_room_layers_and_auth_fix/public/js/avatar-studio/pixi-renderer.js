import { buildWeevilSvg } from './svg-renderer.js';

let pixiPromise;

async function loadPixi() {
  if (!pixiPromise) {
    pixiPromise = import('https://cdn.jsdelivr.net/npm/pixi.js@8.10.2/dist/pixi.mjs');
  }
  return pixiPromise;
}

export async function renderPixiInto(container, state, options = {}) {
  const PIXI = await loadPixi();
  container.innerHTML = '';
  const host = document.createElement('div');
  host.className = 'pixi-host';
  container.appendChild(host);

  const app = new PIXI.Application();
  await app.init({
    width: 640,
    height: 860,
    backgroundAlpha: 0,
    antialias: true,
    resolution: window.devicePixelRatio || 1,
    autoDensity: true
  });
  host.appendChild(app.canvas);

  const shadow = new PIXI.Graphics();
  shadow.ellipse(320, 812, 150, 22).fill({ color: 0x000000, alpha: 0.18 });
  shadow.filters = [new PIXI.BlurFilter({ strength: 6 })];
  app.stage.addChild(shadow);

  const svgMarkup = buildWeevilSvg(state, options);
  const blob = new Blob([svgMarkup], { type: 'image/svg+xml;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  try {
    const texture = await PIXI.Assets.load(url);
    const sprite = new PIXI.Sprite(texture);
    sprite.anchor.set(0.5, 0.5);
    sprite.position.set(320, 430);
    sprite.width = 510;
    sprite.height = 688;
    sprite.skew.x = -0.035;
    sprite.scale.x = 1.02;
    app.stage.addChild(sprite);
  } finally {
    URL.revokeObjectURL(url);
  }

  return () => {
    try {
      app.destroy(true, { children: true, texture: true, textureSource: true });
    } catch {
      // ignore cleanup failures
    }
  };
}
