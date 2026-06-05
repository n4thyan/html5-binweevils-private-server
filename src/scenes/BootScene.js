export class BootScene {
  constructor({ stage }) {
    this.stage = stage;
    this.elapsedMs = 0;
  }

  enter() {
    this.elapsedMs = 0;
  }

  update(deltaMs) {
    this.elapsedMs += deltaMs;
  }

  render() {
    const ctx = this.stage.context;
    this.stage.clear();

    ctx.fillStyle = '#171717';
    ctx.fillRect(0, 0, this.stage.width, this.stage.height);

    ctx.fillStyle = '#f4e9bd';
    ctx.font = '24px Arial, sans-serif';
    ctx.fillText('Bin Weevils HTML5 Port Foundation', 40, 70);

    ctx.fillStyle = '#d2c48b';
    ctx.font = '16px Arial, sans-serif';
    ctx.fillText('Milestone 001: clean runtime boot scene', 40, 105);
    ctx.fillText('No room, chat, account, or multiplayer systems are active yet.', 40, 132);

    ctx.strokeStyle = '#f4e9bd';
    ctx.strokeRect(40, 180, 240, 120);

    ctx.fillStyle = '#f4e9bd';
    ctx.font = '14px Arial, sans-serif';
    ctx.fillText('Legacy stage test area', 60, 210);
    ctx.fillText(`runtime: ${Math.floor(this.elapsedMs)}ms`, 60, 238);
  }
}
