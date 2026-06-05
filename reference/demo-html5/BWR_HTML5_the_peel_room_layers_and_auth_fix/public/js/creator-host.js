const frames = Array.from(document.querySelectorAll('[data-creator-frame]'));

window.addEventListener('message', (event) => {
  if (event.origin !== window.location.origin) return;
  const data = event.data || {};
  if (data.type === 'creator:navigate' && typeof data.href === 'string' && data.href.startsWith('/')) {
    window.location.href = data.href;
  }
});

frames.forEach((frame) => {
  frame.addEventListener('load', () => {
    frame.classList.add('is-ready');
  });
});
