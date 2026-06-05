import { normaliseAvatar } from './creator-service.mjs';

export function buildSessionState({ user = null, mode = 'view', nextPath = '/profile' } = {}) {
  const avatarConfigured = Boolean(user && (user.avatarConfigured || user.avatarUpdatedAt));
  return {
    ok: true,
    authenticated: Boolean(user),
    mode,
    nextPath,
    user: user ? {
      id: user.id,
      username: user.username,
      email: user.email || '',
      role: user.role || 'user'
    } : null,
    avatar: normaliseAvatar(user?.avatar || {}),
    avatarConfigured
  };
}
