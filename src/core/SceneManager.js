export class SceneManager {
  constructor() {
    this.scenes = new Map();
    this.current = null;
    this.currentName = null;
  }

  register(name, scene) {
    this.scenes.set(name, scene);
  }

  change(name) {
    const next = this.scenes.get(name);
    if (!next) {
      throw new Error(`Unknown scene: ${name}`);
    }

    if (this.current?.exit) {
      this.current.exit();
    }

    this.current = next;
    this.currentName = name;

    if (this.current.enter) {
      this.current.enter();
    }
  }

  update(deltaMs) {
    if (this.current?.update) {
      this.current.update(deltaMs);
    }
  }

  render() {
    if (this.current?.render) {
      this.current.render();
    }
  }
}
