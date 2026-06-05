// Static Bin Weevils-style client shell renderer.
//
// This is a visual/client-frame foundation only. It does not implement chat,
// movement, rooms, multiplayer, map behaviour, playercards, inventory, or
// backend state.

export class GameShellRenderer {
  constructor({ width = 1024, height = 640 } = {}) {
    this.width = width;
    this.height = height;
  }

  render(ctx, { title = 'Bin Weevils HTML5 Port', subtitle = 'Renderer baseline locked' } = {}) {
    const w = this.width;
    const h = this.height;

    this.drawBackdrop(ctx, w, h);
    this.drawTopBar(ctx, w, title, subtitle);
    this.drawSideButtons(ctx, w, h);
    this.drawBottomChatShell(ctx, w, h);
    this.drawStageFrame(ctx, w, h);
  }

  drawBackdrop(ctx, w, h) {
    const gradient = ctx.createLinearGradient(0, 0, 0, h);
    gradient.addColorStop(0, '#243a16');
    gradient.addColorStop(0.52, '#17270f');
    gradient.addColorStop(1, '#0b1207');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, w, h);

    ctx.fillStyle = 'rgba(255,255,255,0.035)';
    for (let x = 0; x < w; x += 56) {
      ctx.fillRect(x, 0, 1, h);
    }
    for (let y = 0; y < h; y += 56) {
      ctx.fillRect(0, y, w, 1);
    }
  }

  drawTopBar(ctx, w, title, subtitle) {
    this.roundRect(ctx, 18, 14, w - 36, 72, 18, '#4e7f1f', '#b9e660', 3);
    this.roundRect(ctx, 28, 22, w - 56, 56, 14, '#6cad26', 'rgba(255,255,255,0.25)', 1.5);

    ctx.fillStyle = '#fff6b8';
    ctx.font = 'bold 24px Arial, sans-serif';
    ctx.fillText(title, 46, 52);

    ctx.fillStyle = '#2a4411';
    ctx.font = 'bold 13px Arial, sans-serif';
    ctx.fillText(subtitle, 48, 71);

    this.pill(ctx, w - 270, 31, 76, 32, 'LEVEL 1');
    this.pill(ctx, w - 184, 31, 78, 32, 'MULCH 0');
    this.pill(ctx, w - 96, 31, 62, 32, 'MENU');
  }

  drawSideButtons(ctx, w, h) {
    const buttons = [
      ['MAP', w - 92, 118],
      ['BUDS', w - 92, 168],
      ['CARD', w - 92, 218],
      ['NEST', w - 92, 268]
    ];

    for (const [label, x, y] of buttons) {
      this.roundRect(ctx, x, y, 68, 38, 12, '#f2b634', '#7d4a00', 2);
      ctx.fillStyle = '#4c2900';
      ctx.font = 'bold 12px Arial, sans-serif';
      ctx.fillText(label, x + 14, y + 24);
    }
  }

  drawBottomChatShell(ctx, w, h) {
    this.roundRect(ctx, 18, h - 82, w - 36, 64, 18, '#2c5b1e', '#b9e660', 3);
    this.roundRect(ctx, 38, h - 66, w - 268, 34, 16, '#f8f0c5', '#6b5c27', 2);

    ctx.fillStyle = '#776b3e';
    ctx.font = '14px Arial, sans-serif';
    ctx.fillText('Type here...', 58, h - 44);

    this.roundRect(ctx, w - 214, h - 67, 78, 36, 14, '#f2b634', '#7d4a00', 2);
    this.roundRect(ctx, w - 126, h - 67, 88, 36, 14, '#f2b634', '#7d4a00', 2);

    ctx.fillStyle = '#4c2900';
    ctx.font = 'bold 13px Arial, sans-serif';
    ctx.fillText('EMOTES', w - 202, h - 44);
    ctx.fillText('ACTIONS', w - 113, h - 44);
  }

  drawStageFrame(ctx, w, h) {
    this.roundRect(ctx, 36, 102, w - 144, h - 210, 18, 'rgba(5, 12, 7, 0.46)', 'rgba(255,255,255,0.16)', 2);
    ctx.fillStyle = 'rgba(255, 255, 255, 0.04)';
    ctx.fillRect(58, 124, w - 188, h - 254);
  }

  pill(ctx, x, y, w, h, label) {
    this.roundRect(ctx, x, y, w, h, 15, '#f7d54a', '#734a00', 2);
    ctx.fillStyle = '#4c2900';
    ctx.font = 'bold 11px Arial, sans-serif';
    ctx.fillText(label, x + 12, y + 21);
  }

  roundRect(ctx, x, y, w, h, r, fill, stroke = null, lineWidth = 1) {
    ctx.save();
    ctx.beginPath();
    ctx.moveTo(x + r, y);
    ctx.lineTo(x + w - r, y);
    ctx.quadraticCurveTo(x + w, y, x + w, y + r);
    ctx.lineTo(x + w, y + h - r);
    ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
    ctx.lineTo(x + r, y + h);
    ctx.quadraticCurveTo(x, y + h, x, y + h - r);
    ctx.lineTo(x, y + r);
    ctx.quadraticCurveTo(x, y, x + r, y);
    ctx.closePath();
    ctx.fillStyle = fill;
    ctx.fill();
    if (stroke) {
      ctx.strokeStyle = stroke;
      ctx.lineWidth = lineWidth;
      ctx.stroke();
    }
    ctx.restore();
  }
}
