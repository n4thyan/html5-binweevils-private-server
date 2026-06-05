const DEFAULT_AVATAR = Object.freeze({
  weevilDef: '401135129001323200',
  expression: 0,
  proboscis: 0,
  hatId: 0,
  hatColour: 7620096,
  preferredRenderer: 'html5-canvas'
});

function clampInt(value, min, max, fallback = min) {
  const parsed = Number.parseInt(String(value ?? ''), 10);
  if (Number.isNaN(parsed)) return fallback;
  return Math.min(max, Math.max(min, parsed));
}

export function defaultAvatar() {
  return { ...DEFAULT_AVATAR };
}

export function normaliseAvatar(input = {}, fallback = DEFAULT_AVATAR) {
  const base = { ...DEFAULT_AVATAR, ...(fallback || {}) };
  const weevilDef = /^\d{18}$/.test(String(input.weevilDef || '').trim())
    ? String(input.weevilDef).trim()
    : String(base.weevilDef);
  return {
    weevilDef,
    expression: clampInt(input.expression, 0, 6, base.expression),
    proboscis: clampInt(input.proboscis, 0, 4, base.proboscis),
    hatId: clampInt(input.hatId, 0, 12, base.hatId),
    hatColour: clampInt(input.hatColour ?? input.hatColor, 0, 16777215, base.hatColour),
    preferredRenderer: ['svg', 'pixi', 'html5-canvas'].includes(String(input.preferredRenderer || '').trim())
      ? String(input.preferredRenderer).trim()
      : String(base.preferredRenderer || DEFAULT_AVATAR.preferredRenderer)
  };
}

export function avatarPayloadFromForm(form, fallback = DEFAULT_AVATAR) {
  return normaliseAvatar({
    weevilDef: form.get('weevilDef'),
    expression: form.get('expression'),
    proboscis: form.get('proboscis'),
    hatId: form.get('hatId'),
    hatColour: form.get('hatColour') ?? form.get('hatColor'),
    preferredRenderer: form.get('preferredRenderer')
  }, fallback);
}

export function validateAvatarPayload(avatar = {}) {
  if (!/^\d{18}$/.test(String(avatar.weevilDef || ''))) {
    return 'Compact WeevilDef must be 18 digits.';
  }
  if (!Number.isInteger(Number(avatar.expression)) || avatar.expression < 0 || avatar.expression > 6) {
    return 'Expression value was out of range.';
  }
  if (!Number.isInteger(Number(avatar.proboscis)) || avatar.proboscis < 0 || avatar.proboscis > 4) {
    return 'Proboscis value was out of range.';
  }
  if (!Number.isInteger(Number(avatar.hatId)) || avatar.hatId < 0 || avatar.hatId > 12) {
    return 'Hat value was out of range.';
  }
  if (!Number.isInteger(Number(avatar.hatColour)) || avatar.hatColour < 0 || avatar.hatColour > 16777215) {
    return 'Hat colour value was out of range.';
  }
  return '';
}

export function validateRegistration({ username = '', email = '', password = '', passwordConfirm = '' } = {}) {
  const cleanUsername = String(username || '').trim();
  const cleanEmail = String(email || '').trim();
  const cleanPassword = String(password || '');
  const cleanPasswordConfirm = String(passwordConfirm || '');
  if (!/^[a-zA-Z0-9_-]{3,24}$/.test(cleanUsername)) {
    return 'Use 3-24 letters, numbers, underscores or hyphens.';
  }
  if (!cleanEmail || !cleanEmail.includes('@') || cleanEmail.length > 120) {
    return 'Enter a valid email address.';
  }
  if (cleanPassword.length < 6) {
    return 'Use a password with at least 6 characters.';
  }
  if (cleanPasswordConfirm && cleanPassword !== cleanPasswordConfirm) {
    return 'Passwords did not match.';
  }
  return '';
}
