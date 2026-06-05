import { loadAtlasMap, loadImage } from "/weevil-creator/src/runtime/canvasAtlasLoader.js";
import { getDefObj } from "/weevil-creator/src/runtime/WeevilDef.js";
import { WeevilCanvasRenderer } from "/weevil-creator/src/runtime/WeevilCanvasRenderer.js";

const mounts = Array.from(document.querySelectorAll('[data-profile-weevil-preview]'));

if (mounts.length) {
  const creatorBaseUrl = new URL('/weevil-creator/', window.location.origin).href.replace(/\/$/, '');
  const [atlases, upperLegImage, lowerLegImage, lowerLegStripyImage] = await Promise.all([
    loadAtlasMap(creatorBaseUrl),
    loadImage(`${creatorBaseUrl}/assets/raw/misc/upper_leg.png`),
    loadImage(`${creatorBaseUrl}/assets/raw/misc/lower_leg.png`),
    loadImage(`${creatorBaseUrl}/assets/raw/misc/lower_leg_stripy.png`),
  ]);

  const rawImages = new Map([
    ['upper_leg.png', upperLegImage],
    ['lower_leg.png', lowerLegImage],
    ['lower_leg_stripy.png', lowerLegStripyImage],
  ]);

  for (const mount of mounts) {
    try {
      const canvas = mount.querySelector('canvas') || mount.appendChild(document.createElement('canvas'));
      const raw = JSON.parse(mount.dataset.avatarRecord || '{}');
      const renderer = new WeevilCanvasRenderer(canvas, atlases, rawImages);
      renderer.autoRotate = false;

      const weevilDef = /^\d{18}$/.test(String(raw.weevilDef || '').trim()) ? String(raw.weevilDef).trim() : '401135129001323200';
      const definition = {
        ...getDefObj(weevilDef),
        hat: String(Number(raw.hatId ?? 0) || 0),
        hatc: Number(raw.hatColour ?? raw.hatColor ?? 7620096) || 7620096,
      };
      const expressionIndex = Number(raw.expression ?? 0) || 0;

      const paint = () => {
        const width = Math.max(180, Math.round(mount.clientWidth || 220));
        const height = Math.max(180, Math.round(mount.clientHeight || 220));
        renderer.resize(width, height);
        renderer.setDefinition(structuredClone(definition), { expressionIndex });
        renderer.setView(16, 302);
        renderer.render();
      };

      paint();
      if (typeof ResizeObserver !== 'undefined') {
        const observer = new ResizeObserver(() => paint());
        observer.observe(mount);
      } else {
        window.addEventListener('resize', paint);
      }
    } catch (error) {
      console.error('Profile weevil preview failed to render.', error);
    }
  }
}
