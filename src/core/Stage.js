export class Stage {
  constructor({ width, height }) {
    this.width = width;
    this.height = height;

    this.element = document.createElement('div');
    this.element.className = 'bw-stage';
    this.element.style.width = `${width}px`;
    this.element.style.height = `${height}px`;

    this.canvas = document.createElement('canvas');
    this.canvas.width = width;
    this.canvas.height = height;
    this.canvas.className = 'bw-stage-canvas';

    this.context = this.canvas.getContext('2d');
    if (!this.context) {
      throw new Error('Unable to create 2D canvas context.');
    }

    this.element.append(this.canvas);
  }

  clear() {
    this.context.clearRect(0, 0, this.width, this.height);
  }
}
