// Small canvas helpers for drawing JSON atlas frames.
//
// These are deliberately generic. The exact weevil draw order and coordinates
// still need to be ported from the old canvas renderer and checked against OG
// source/assets. This file only provides safe frame lookup/draw primitives.

export function getAtlasFrame(atlas, frameName) {
  const frames = atlas?.data?.frames;
  if (!frames) return null;

  if (Array.isArray(frames)) {
    return frames.find((entry) => entry.filename === frameName || entry.name === frameName) ?? null;
  }

  return frames[frameName] ?? null;
}

export function getFrameRect(frameEntry) {
  const frame = frameEntry?.frame ?? frameEntry;
  if (!frame) return null;

  return {
    x: Number(frame.x ?? 0),
    y: Number(frame.y ?? 0),
    w: Number(frame.w ?? frame.width ?? 0),
    h: Number(frame.h ?? frame.height ?? 0)
  };
}

export function drawAtlasFrame(ctx, atlas, frameName, x, y, options = {}) {
  const frameEntry = getAtlasFrame(atlas, frameName);
  const rect = getFrameRect(frameEntry);

  if (!rect || !atlas?.image) {
    return false;
  }

  const scale = Number(options.scale ?? 1);
  const anchorX = Number(options.anchorX ?? 0);
  const anchorY = Number(options.anchorY ?? 0);
  const width = rect.w * scale;
  const height = rect.h * scale;

  ctx.drawImage(
    atlas.image,
    rect.x,
    rect.y,
    rect.w,
    rect.h,
    x - anchorX * width,
    y - anchorY * height,
    width,
    height
  );

  return true;
}

export function drawTintedAtlasFrame(ctx, atlas, frameName, x, y, colourHex, options = {}) {
  const frameEntry = getAtlasFrame(atlas, frameName);
  const rect = getFrameRect(frameEntry);

  if (!rect || !atlas?.image) {
    return false;
  }

  const scale = Number(options.scale ?? 1);
  const width = rect.w * scale;
  const height = rect.h * scale;
  const anchorX = Number(options.anchorX ?? 0);
  const anchorY = Number(options.anchorY ?? 0);
  const dx = x - anchorX * width;
  const dy = y - anchorY * height;

  const buffer = getScratchCanvas(rect.w, rect.h);
  const bufferCtx = buffer.getContext('2d');
  bufferCtx.clearRect(0, 0, rect.w, rect.h);
  bufferCtx.drawImage(atlas.image, rect.x, rect.y, rect.w, rect.h, 0, 0, rect.w, rect.h);

  bufferCtx.globalCompositeOperation = 'source-atop';
  bufferCtx.fillStyle = colourHex;
  bufferCtx.fillRect(0, 0, rect.w, rect.h);
  bufferCtx.globalCompositeOperation = 'source-over';

  ctx.drawImage(buffer, 0, 0, rect.w, rect.h, dx, dy, width, height);
  return true;
}

let scratchCanvas = null;

function getScratchCanvas(width, height) {
  if (!scratchCanvas) {
    scratchCanvas = document.createElement('canvas');
  }

  if (scratchCanvas.width !== width) scratchCanvas.width = width;
  if (scratchCanvas.height !== height) scratchCanvas.height = height;

  return scratchCanvas;
}
