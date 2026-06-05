import { getAtlasUrls } from './WeevilAtlasManifest.js';

export class WeevilAtlasLoader {
  constructor({ imageLoader = defaultImageLoader, jsonLoader = defaultJsonLoader } = {}) {
    this.imageLoader = imageLoader;
    this.jsonLoader = jsonLoader;
    this.cache = new Map();
  }

  async load(key) {
    if (this.cache.has(key)) {
      return this.cache.get(key);
    }

    const urls = getAtlasUrls(key);
    if (!urls) {
      throw new Error(`Unknown weevil atlas key: ${key}`);
    }

    const [image, data] = await Promise.all([
      this.imageLoader(urls.png),
      this.jsonLoader(urls.json)
    ]);

    const atlas = { key, image, data, urls };
    this.cache.set(key, atlas);
    return atlas;
  }

  has(key) {
    return this.cache.has(key);
  }

  get(key) {
    return this.cache.get(key) ?? null;
  }

  clear() {
    this.cache.clear();
  }
}

async function defaultJsonLoader(url) {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Failed to load atlas JSON: ${url}`);
  }
  return response.json();
}

async function defaultImageLoader(url) {
  const image = new Image();
  image.decoding = 'async';

  const loaded = new Promise((resolve, reject) => {
    image.onload = () => resolve(image);
    image.onerror = () => reject(new Error(`Failed to load atlas image: ${url}`));
  });

  image.src = url;
  await loaded;
  return image;
}
