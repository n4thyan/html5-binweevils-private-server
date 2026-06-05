export class DebugOverlay {
  constructor() {
    this.lines = new Map();
    this.element = document.createElement('pre');
    this.element.className = 'bw-debug-overlay';
    this.render();
  }

  setLine(key, value) {
    this.lines.set(key, value);
    this.render();
  }

  render() {
    this.element.textContent = Array.from(this.lines.entries())
      .map(([key, value]) => `${key}: ${value}`)
      .join('\n');
  }
}
