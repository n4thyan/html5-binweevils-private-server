import { loadAtlasMap, loadImage } from '/weevil-creator/src/runtime/canvasAtlasLoader.js';
import { getDefObj } from '/weevil-creator/src/runtime/WeevilDef.js';
import { WeevilCanvasRenderer } from '/weevil-creator/src/runtime/WeevilCanvasRenderer.js';

let assetsPromise = null;

function creatorBase() {
  return new URL('/weevil-creator/', window.location.origin).href.replace(/\/$/, '');
}

function loadAssets() {
  if (!assetsPromise) {
    const baseUrl = creatorBase();
    assetsPromise = Promise.all([
      loadAtlasMap(baseUrl),
      loadImage(`${baseUrl}/assets/raw/misc/upper_leg.png`),
      loadImage(`${baseUrl}/assets/raw/misc/lower_leg.png`),
      loadImage(`${baseUrl}/assets/raw/misc/lower_leg_stripy.png`)
    ]).then(([atlases, upperLegImage, lowerLegImage, lowerLegStripyImage]) => ({
      atlases,
      legImages: new Map([
        ['upper_leg.png', upperLegImage],
        ['lower_leg.png', lowerLegImage],
        ['lower_leg_stripy.png', lowerLegStripyImage]
      ])
    }));
  }
  return assetsPromise;
}

function avatarToDefinition(raw = {}) {
  const weevilDef = /^\d{18}$/.test(String(raw.weevilDef || '').trim())
    ? String(raw.weevilDef).trim()
    : '401135129001323200';
  return {
    ...getDefObj(weevilDef),
    hat: String(Number(raw.hatId ?? 0) || 0),
    hatc: Number(raw.hatColour ?? raw.hatColor ?? 7620096) || 7620096
  };
}

function measureCanvasSprite(canvas, cached = null) {
  const ctx = canvas.getContext('2d', { willReadFrequently: true });
  const { width, height } = canvas;
  const { data } = ctx.getImageData(0, 0, width, height);

  let minX = width;
  let minY = height;
  let maxX = -1;
  let maxY = -1;

  for (let y = 0; y < height; y += 1) {
    const rowOffset = y * width * 4;
    for (let x = 0; x < width; x += 1) {
      const alpha = data[rowOffset + x * 4 + 3];
      if (alpha < 10) continue;
      if (x < minX) minX = x;
      if (y < minY) minY = y;
      if (x > maxX) maxX = x;
      if (y > maxY) maxY = y;
    }
  }

  if (maxX < 0 || maxY < 0) {
    return cached || {
      minX: 0,
      minY: 0,
      maxX: width - 1,
      maxY: height - 1,
      width,
      height,
      anchorX: width * 0.5,
      anchorY: height - 8,
      topY: 0
    };
  }

  let sumX = 0;
  let countX = 0;
  const floorStartY = Math.max(minY, maxY - 8);
  for (let y = floorStartY; y <= maxY; y += 1) {
    const rowOffset = y * width * 4;
    for (let x = minX; x <= maxX; x += 1) {
      const alpha = data[rowOffset + x * 4 + 3];
      if (alpha < 24) continue;
      sumX += x;
      countX += 1;
    }
  }

  const anchorX = countX ? sumX / countX : (minX + maxX) * 0.5;
  const anchorY = maxY + 2;

  return {
    minX,
    minY,
    maxX,
    maxY,
    width: Math.max(1, maxX - minX + 1),
    height: Math.max(1, maxY - minY + 1),
    anchorX,
    anchorY,
    topY: minY,
  };
}

function createOffscreenCanvas(width, height) {
  if (typeof OffscreenCanvas !== 'undefined') {
    return new OffscreenCanvas(width, height);
  }
  const canvas = document.createElement('canvas');
  canvas.width = width;
  canvas.height = height;
  return canvas;
}

export function createRoomWeevilRenderer(canvas) {
  let renderer = null;
  let lastKey = '';
  let lastMetrics = null;
  const renderCanvas = createOffscreenCanvas(512, 512);

  async function paint(avatar = {}, { width = 256, height = 256, yaw = 302, pitch = 18 } = {}) {
    const { atlases, legImages } = await loadAssets();
    if (!renderer) {
      renderer = new WeevilCanvasRenderer(renderCanvas, atlases, legImages);
      renderer.autoRotate = false;
    }

    if (canvas.width !== width) canvas.width = width;
    if (canvas.height !== height) canvas.height = height;
    renderer.resize(renderCanvas.width, renderCanvas.height);

    const definition = avatarToDefinition(avatar);
    const expressionIndex = Number(avatar.expression ?? 0) || 0;
    const key = JSON.stringify({ definition, expressionIndex, yaw, pitch, width, height });
    if (key === lastKey && lastMetrics) {
      return lastMetrics;
    }

    lastKey = key;
    renderer.setDefinition(structuredClone(definition), { expressionIndex });
    renderer.setView(pitch, yaw);
    renderer.render();

    const rawMetrics = measureCanvasSprite(renderCanvas, null);
    const cropPaddingX = 28;
    const cropPaddingTop = 22;
    const cropPaddingBottom = 10;
    const cropX = Math.max(0, Math.floor(rawMetrics.minX - cropPaddingX));
    const cropY = Math.max(0, Math.floor(rawMetrics.minY - cropPaddingTop));
    const cropMaxX = Math.min(renderCanvas.width, Math.ceil(rawMetrics.maxX + cropPaddingX));
    const cropMaxY = Math.min(renderCanvas.height, Math.ceil(rawMetrics.maxY + cropPaddingBottom));
    const cropW = Math.max(1, cropMaxX - cropX);
    const cropH = Math.max(1, cropMaxY - cropY);

    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, width, height);
    const drawableW = width - 8;
    const drawableH = height - 4;
    const drawScale = Math.min(drawableW / cropW, drawableH / cropH);
    const drawW = cropW * drawScale;
    const drawH = cropH * drawScale;
    const drawX = (width - drawW) * 0.5;
    const drawY = height - drawH - 2;

    ctx.imageSmoothingEnabled = true;
    ctx.drawImage(renderCanvas, cropX, cropY, cropW, cropH, drawX, drawY, drawW, drawH);

    const anchorX = drawX + (rawMetrics.anchorX - cropX) * drawScale;
    const anchorY = drawY + (rawMetrics.anchorY - cropY) * drawScale;
    const topY = drawY + (rawMetrics.topY - cropY) * drawScale;

    lastMetrics = {
      minX: drawX,
      minY: drawY,
      maxX: drawX + drawW,
      maxY: drawY + drawH,
      width: drawW,
      height: drawH,
      anchorX,
      anchorY,
      topY,
      canvasWidth: width,
      canvasHeight: height,
    };
    return lastMetrics;
  }

  return { paint };
}
