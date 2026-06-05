export class AssetLoader {
  constructor({ manifest }) {
    this.manifest = manifest;
    this.cache = new Map();
  }

  async loadImage(id, src) {
    if (this.cache.has(id)) {
      return this.cache.get(id);
    }

    const image = new Image();
    image.decoding = 'async';

    const loaded = new Promise((resolve, reject) => {
      image.onload = () => resolve(image);
      image.onerror = () => reject(new Error(`Failed to load image: ${src}`));
    });

    image.src = src;
    await loaded;

    this.cache.set(id, image);
    return image;
  }
}
