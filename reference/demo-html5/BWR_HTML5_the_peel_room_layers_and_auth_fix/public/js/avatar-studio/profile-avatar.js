import { avatarRecordToState, normaliseAvatarRecord } from './shared.js';
import { renderSvgInto } from './svg-renderer.js';

const mount = document.querySelector('[data-avatar-profile-preview]');
if (mount) {
  try {
    const raw = mount.getAttribute('data-avatar-record') || '{}';
    const record = normaliseAvatarRecord(JSON.parse(raw));
    const state = avatarRecordToState(record);
    renderSvgInto(mount, state, { mini: true });
  } catch {
    // keep profile usable even if avatar data is malformed
  }
}
