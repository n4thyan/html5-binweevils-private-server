import { CORE_UI_ASSET_PROBE_PLAN } from './CoreUiAssetProbePlan.js';

const DEFAULT_MAX_ITEMS = 9;

export class CoreUiAssetProbeRenderer {
  constructor({ basePath = '/', maxItems = DEFAULT_MAX_ITEMS } = {}) {
    this.basePath = basePath;
    this.maxItems = maxItems;
    this.assets = CORE_UI_ASSET_PROBE_PLAN.slice(0, maxItems).map((entry) => ({
      ...entry,
      image: null,
      status: 'pending',
      error: null,
      width: 0,
      height: 0,
      src: toBrowserAssetPath(entry.expectedPath, basePath)
    }));
    this.started = false;
  }

  start() {
    if (this.started) return;
    this.started = true;

    for (const asset of this.assets) {
      const image = new Image();
      asset.image = image;
      asset.status = 'loading';
      image.onload = () => {
        asset.status = 'loaded';
        asset.width = image.naturalWidth || image.width || 0;
        asset.height = image.naturalHeight || image.height || 0;
      };
      image.onerror = () => {
        asset.status = 'error';
        asset.error = `Failed to load ${asset.src}`;
      };
      image.src = asset.src;
    }
  }

  getSummary() {
    return Object.freeze({
      total: this.assets.length,
      loaded: this.assets.filter((asset) => asset.status === 'loaded').length,
      loading: this.assets.filter((asset) => asset.status === 'loading').length,
      error: this.assets.filter((asset) => asset.status === 'error').length,
      pending: this.assets.filter((asset) => asset.status === 'pending').length
    });
  }

  render(ctx, x, y, options = {}) {
    this.start();

    const cellWidth = options.cellWidth ?? 176;
    const cellHeight = options.cellHeight ?? 96;
    const columns = options.columns ?? 3;
    const scaleMaxWidth = options.scaleMaxWidth ?? 128;
    const scaleMaxHeight = options.scaleMaxHeight ?? 52;
    const rows = Math.ceil(this.assets.length / columns);
    const width = cellWidth * columns + 24;
    const height = rows * cellHeight + 66;
    const summary = this.getSummary();

    ctx.save();
    ctx.fillStyle = '#111111';
    ctx.globalAlpha = 0.92;
    ctx.fillRect(x, y, width, height);
    ctx.globalAlpha = 1;
    ctx.strokeStyle = '#f4e9bd';
    ctx.strokeRect(x, y, width, height);

    ctx.fillStyle = '#f4e9bd';
    ctx.font = '15px Arial, sans-serif';
    ctx.fillText('Debug: real core5.swf UI asset probe', x + 12, y + 24);

    ctx.fillStyle = '#d2c48b';
    ctx.font = '11px Consolas, Monaco, monospace';
    ctx.fillText(`loaded ${summary.loaded}/${summary.total} | source FFDec DefineSprite SVGs | not final UI`, x + 12, y + 43);

    this.assets.forEach((asset, index) => {
      const col = index % columns;
      const row = Math.floor(index / columns);
      const cellX = x + 12 + col * cellWidth;
      const cellY = y + 60 + row * cellHeight;
      this.renderCell(ctx, asset, cellX, cellY, cellWidth - 12, cellHeight - 10, scaleMaxWidth, scaleMaxHeight);
    });

    ctx.restore();
    return summary;
  }

  renderCell(ctx, asset, x, y, width, height, scaleMaxWidth, scaleMaxHeight) {
    ctx.strokeStyle = '#4b452e';
    ctx.strokeRect(x, y, width, height);

    ctx.fillStyle = '#d2c48b';
    ctx.font = '10px Consolas, Monaco, monospace';
    ctx.fillText(asset.key, x + 6, y + 14);

    ctx.fillStyle = asset.status === 'loaded' ? '#f4e9bd' : '#d2c48b';
    ctx.fillText(asset.status, x + 6, y + height - 8);

    if (asset.status !== 'loaded' || !asset.image) {
      return;
    }

    const rawWidth = asset.width || scaleMaxWidth;
    const rawHeight = asset.height || scaleMaxHeight;
    const scale = Math.min(scaleMaxWidth / rawWidth, scaleMaxHeight / rawHeight, 1);
    const drawWidth = Math.max(1, rawWidth * scale);
    const drawHeight = Math.max(1, rawHeight * scale);
    const drawX = x + Math.floor((width - drawWidth) / 2);
    const drawY = y + 24 + Math.floor((scaleMaxHeight - drawHeight) / 2);

    ctx.drawImage(asset.image, drawX, drawY, drawWidth, drawHeight);
  }
}

export function toBrowserAssetPath(repoPath, basePath = '/') {
  const cleanBase = basePath.endsWith('/') ? basePath : `${basePath}/`;
  const cleanPath = String(repoPath).replace(/^\.\//, '');
  return `${cleanBase}${cleanPath}`.replace(/\/g, '/');
}
