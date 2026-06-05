import { Stage } from './Stage.js';
import { GameLoop } from './GameLoop.js';
import { SceneManager } from './SceneManager.js';
import { DebugOverlay } from './DebugOverlay.js';
import { BootScene } from '../scenes/BootScene.js';

export class GameApp {
  constructor({ root }) {
    this.root = root;
    this.stage = new Stage({ width: 1024, height: 640 });
    this.debugOverlay = new DebugOverlay();
    this.scenes = new SceneManager();
    this.loop = new GameLoop({
      update: (deltaMs) => this.update(deltaMs),
      render: () => this.render()
    });
  }

  boot() {
    this.root.innerHTML = '';
    this.root.classList.add('bw-port-root');
    this.root.append(this.stage.element, this.debugOverlay.element);

    this.scenes.register('boot', new BootScene({ stage: this.stage }));
    this.scenes.change('boot');

    this.debugOverlay.setLine('mode', 'Milestone 001 foundation');
    this.debugOverlay.setLine('scene', this.scenes.currentName ?? 'none');
    this.debugOverlay.setLine('stage', `${this.stage.width}x${this.stage.height}`);

    this.loop.start();
  }

  update(deltaMs) {
    this.scenes.update(deltaMs);
    this.debugOverlay.setLine('scene', this.scenes.currentName ?? 'none');
  }

  render() {
    this.scenes.render();
  }
}
