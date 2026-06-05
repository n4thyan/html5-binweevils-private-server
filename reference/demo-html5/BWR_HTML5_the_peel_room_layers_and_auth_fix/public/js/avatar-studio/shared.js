export const CLRS1 = [10027008,43520,153,10057472,8913032,11198463,26367,16750848,13421568,61166,13369548,16777215,16766429,11206400,16763904,15658496,16745604,2631720,10066329,16777145,15597568,26112,1184274,12733185,16736768,16425579,16767167,7620096,16771473,6394113,8899328,14548127,62720,11993014,25670,110971,61093,7011535,25219,50886,10289151,2797311,3014772,5243334,8334079,14138879,16729855,16756735,11338573,15597672,15952037,16757203];
export const CLRS2 = [52224,4474077,15610675,13421568,52428,13369548,8943360,2136473,11206400,16763904,15658496,16745604,10027008,15597568,16766429,12733185,16736768,16425579,16767167,7620096,16750848,16771473,10057472,16777145,6394113,8899328,11206400,14548127,26112,43520,62720,11993014,25670,110971,61093,7011535,25219,50886,61166,10289151,153,26367,2797311,11198463,3014772,5243334,8334079,14138879,8913032,16729855,16756735,11338573,15597672,15952037,16757203,10066329,16777215,2631720];

export const HEAD_SHAPES = [
  { value: 1, name: 'Spheroid head' },
  { value: 2, name: 'Cone head' },
  { value: 3, name: 'Inverse cone head' },
  { value: 4, name: 'Cuboid head' }
];

export const BODY_SHAPES = [
  { value: 1, name: 'Spheroid body' },
  { value: 2, name: 'Cone body' },
  { value: 3, name: 'Inverse cone body' },
  { value: 4, name: 'Cuboid body' }
];

export const EYE_TYPES = [
  { value: 1, name: 'Classic wide' },
  { value: 2, name: 'Tall inset' },
  { value: 3, name: 'Tall wide' },
  { value: 4, name: 'Narrow tilt' },
  { value: 5, name: 'Big stare' },
  { value: 6, name: 'Far-set' }
];

export const ANTENNA_TYPES = [
  { value: 0, name: 'None' },
  { value: 1, name: 'Single small' },
  { value: 2, name: 'Single medium' },
  { value: 3, name: 'Single large' },
  { value: 4, name: 'Double small' },
  { value: 5, name: 'Double medium' },
  { value: 6, name: 'Double large' },
  { value: 7, name: 'Triple small' },
  { value: 8, name: 'Triple medium' },
  { value: 9, name: 'Triple large' },
  { value: 10, name: 'Super original' },
  { value: 11, name: 'Super purple' },
  { value: 12, name: 'Super red white' },
  { value: 13, name: 'Super tri-colour' },
  { value: 14, name: 'Super halloween' },
  { value: 15, name: 'Super fire' },
  { value: 16, name: 'Super ice' }
];

export const LEG_TYPES = [
  { value: 0, name: 'Normal legs' },
  { value: 1, name: 'Stripy legs' },
  { value: 2, name: 'Summer fair' },
  { value: 3, name: 'Super original' },
  { value: 4, name: 'Purple yellow blue' },
  { value: 5, name: 'Halloween' },
  { value: 6, name: 'Black white' },
  { value: 7, name: 'Black blue black' },
  { value: 8, name: 'Fire' },
  { value: 9, name: 'Ice' },
  { value: 10, name: 'Disco' }
];

export const EXPRESSION_TYPES = [
  { value: 0, name: 'Expression 0' },
  { value: 1, name: 'Expression 1' },
  { value: 2, name: 'Expression 2' },
  { value: 3, name: 'Expression 3' },
  { value: 4, name: 'Expression 4' },
  { value: 5, name: 'Expression 5' },
  { value: 6, name: 'Expression 6' }
];

export const PROBOSCIS_TYPES = [
  { value: 0, name: 'Classic long' },
  { value: 1, name: 'Short drop' },
  { value: 2, name: 'Curved sweep' },
  { value: 3, name: 'Long arc' },
  { value: 4, name: 'Stubby' }
];

export const HAT_TYPES = [
  { value: 0, name: 'None' },
  { value: 1, name: 'Beanie' },
  { value: 2, name: 'Cap' },
  { value: 3, name: 'Crown' },
  { value: 4, name: 'Top hat' },
  { value: 5, name: 'Helmet' },
  { value: 6, name: 'Pirate' },
  { value: 7, name: 'Party' },
  { value: 8, name: 'Wizard' },
  { value: 9, name: 'Propeller' },
  { value: 10, name: 'Viking' },
  { value: 11, name: 'Santa' },
  { value: 12, name: 'Halo' }
];

const LEGACY_HEAD_PALETTE = [1, 4, 2, 43, 10, 27, 18, 17];
const LEGACY_BODY_PALETTE = [35, 2, 32, 13, 43, 48, 27, 39];
const LEGACY_EYE_PALETTE = [29, 1, 21, 49, 9, 51, 32, 30, 57, 56, 56];
const LEGACY_LIMB_PALETTE = [32, 44, 35, 14, 43, 7, 18, 17];

function asHex(intColor) {
  return `#${intColor.toString(16).padStart(6, '0')}`;
}

export function paletteItems(source, prefix) {
  return source.map((value, index) => ({
    value: index,
    name: `${prefix} ${String(index).padStart(2, '0')} · ${asHex(value)}`,
    hex: asHex(value)
  }));
}

export const HEAD_COLOURS = paletteItems(CLRS1, 'Head');
export const BODY_COLOURS = paletteItems(CLRS1, 'Body');
export const EYE_COLOURS = paletteItems(CLRS2, 'Eye');
export const ANTENNA_COLOURS = paletteItems(CLRS1, 'Antenna');
export const LIMB_COLOURS = paletteItems(CLRS1, 'Limb');

export function clampInt(value, min, max) {
  const n = Number.parseInt(value, 10);
  if (Number.isNaN(n)) return min;
  return Math.min(max, Math.max(min, n));
}

export function hexToRgb(hex) {
  const raw = String(hex).replace('#', '');
  const normal = raw.length === 3 ? raw.split('').map((c) => c + c).join('') : raw;
  const int = Number.parseInt(normal, 16);
  return {
    r: (int >> 16) & 255,
    g: (int >> 8) & 255,
    b: int & 255
  };
}

export function darken(hex, amount = 0.18) {
  const { r, g, b } = hexToRgb(hex);
  const to = (v) => Math.max(0, Math.round(v * (1 - amount)));
  return `rgb(${to(r)}, ${to(g)}, ${to(b)})`;
}

export function lighten(hex, amount = 0.18) {
  const { r, g, b } = hexToRgb(hex);
  const to = (v) => Math.min(255, Math.round(v + (255 - v) * amount));
  return `rgb(${to(r)}, ${to(g)}, ${to(b)})`;
}

export function colourFromIndex(paletteNumber, index) {
  const palette = paletteNumber === 2 ? CLRS2 : CLRS1;
  const safe = clampInt(index, 0, palette.length - 1);
  return asHex(palette[safe]);
}

export function optionLabel(list, value) {
  const found = list.find((item) => item.value === value);
  return found ? found.name : `Custom ${value}`;
}

export function parseCompactWeevilDef(defString) {
  const cleaned = String(defString || '').trim();
  if (!/^\d{18}$/.test(cleaned)) return null;
  return {
    ht: clampInt(cleaned.slice(0, 1), 1, 4),
    hcIndex: clampInt(cleaned.slice(1, 3), 0, CLRS1.length - 1),
    bt: clampInt(cleaned.slice(3, 4), 1, 4),
    bcIndex: clampInt(cleaned.slice(4, 6), 0, CLRS1.length - 1),
    et: clampInt(cleaned.slice(6, 7), 1, 6),
    ecIndex: clampInt(cleaned.slice(7, 9), 0, CLRS2.length - 1),
    lids: clampInt(cleaned.slice(9, 10), 0, 1),
    at: clampInt(cleaned.slice(10, 12), 0, 99),
    acIndex: clampInt(cleaned.slice(12, 14), 0, CLRS1.length - 1),
    lcIndex: clampInt(cleaned.slice(14, 16), 0, CLRS1.length - 1),
    lt: clampInt(cleaned.slice(16, 18), 0, 99)
  };
}

export function formatCompactWeevilDef(state) {
  return [
    clampInt(state.ht, 1, 4),
    String(clampInt(state.hcIndex, 0, CLRS1.length - 1)).padStart(2, '0'),
    clampInt(state.bt, 1, 4),
    String(clampInt(state.bcIndex, 0, CLRS1.length - 1)).padStart(2, '0'),
    clampInt(state.et, 1, 6),
    String(clampInt(state.ecIndex, 0, CLRS2.length - 1)).padStart(2, '0'),
    clampInt(state.lids, 0, 1),
    String(clampInt(state.at, 0, 99)).padStart(2, '0'),
    String(clampInt(state.acIndex, 0, CLRS1.length - 1)).padStart(2, '0'),
    String(clampInt(state.lcIndex, 0, CLRS1.length - 1)).padStart(2, '0'),
    String(clampInt(state.lt, 0, 99)).padStart(2, '0')
  ].join('');
}

export function defaultAvatarRecord() {
  return {
    weevilDef: '401135129001323200',
    expression: 0,
    proboscis: 0,
    hatId: 0,
    preferredRenderer: 'svg'
  };
}

export function normaliseAvatarRecord(input = {}) {
  const defaults = defaultAvatarRecord();
  const compact = parseCompactWeevilDef(input.weevilDef) ? input.weevilDef : defaults.weevilDef;
  return {
    weevilDef: compact,
    expression: clampInt(input.expression ?? defaults.expression, 0, 6),
    proboscis: clampInt(input.proboscis ?? defaults.proboscis, 0, 4),
    hatId: clampInt(input.hatId ?? defaults.hatId, 0, 12),
    preferredRenderer: ['svg', 'pixi'].includes(input.preferredRenderer) ? input.preferredRenderer : defaults.preferredRenderer
  };
}

export function avatarRecordToState(record = {}) {
  const normalised = normaliseAvatarRecord(record);
  const compact = parseCompactWeevilDef(normalised.weevilDef) || parseCompactWeevilDef(defaultAvatarRecord().weevilDef);
  return {
    ...compact,
    expression: normalised.expression,
    proboscis: normalised.proboscis,
    hatId: normalised.hatId,
    preferredRenderer: normalised.preferredRenderer
  };
}

export function stateToAvatarRecord(state) {
  return normaliseAvatarRecord({
    weevilDef: formatCompactWeevilDef(state),
    expression: state.expression,
    proboscis: state.proboscis,
    hatId: state.hatId,
    preferredRenderer: state.preferredRenderer
  });
}

export function parseLegacyDemoDef(defString) {
  const parts = String(defString || '').split(',').map((part) => Number.parseInt(part.trim(), 10));
  if (parts.length !== 7 || parts.some((value) => Number.isNaN(value))) return null;
  const [head, body, eye, limb, expression, proboscis, hatId] = parts;
  return normaliseAvatarRecord({
    weevilDef: formatCompactWeevilDef({
      ht: 4,
      hcIndex: LEGACY_HEAD_PALETTE[clampInt(head, 0, LEGACY_HEAD_PALETTE.length - 1)],
      bt: 1,
      bcIndex: LEGACY_BODY_PALETTE[clampInt(body, 0, LEGACY_BODY_PALETTE.length - 1)],
      et: 1,
      ecIndex: LEGACY_EYE_PALETTE[clampInt(eye, 0, LEGACY_EYE_PALETTE.length - 1)],
      lids: 0,
      at: 1,
      acIndex: LEGACY_HEAD_PALETTE[clampInt(head, 0, LEGACY_HEAD_PALETTE.length - 1)],
      lcIndex: LEGACY_LIMB_PALETTE[clampInt(limb, 0, LEGACY_LIMB_PALETTE.length - 1)],
      lt: 0
    }),
    expression: clampInt(expression, 0, 4),
    proboscis: clampInt(proboscis, 0, 4),
    hatId: clampInt(hatId, 0, 12),
    preferredRenderer: 'svg'
  });
}

export function recordToLegacyDemoDef(record) {
  const state = avatarRecordToState(record);
  const findClosest = (target, palette) => {
    let bestIndex = 0;
    let bestDistance = Number.POSITIVE_INFINITY;
    palette.forEach((value, index) => {
      const distance = Math.abs(value - target);
      if (distance < bestDistance) {
        bestDistance = distance;
        bestIndex = index;
      }
    });
    return bestIndex;
  };
  return [
    findClosest(state.hcIndex, LEGACY_HEAD_PALETTE),
    findClosest(state.bcIndex, LEGACY_BODY_PALETTE),
    findClosest(state.ecIndex, LEGACY_EYE_PALETTE),
    findClosest(state.lcIndex, LEGACY_LIMB_PALETTE),
    clampInt(state.expression, 0, 4),
    clampInt(state.proboscis, 0, 4),
    clampInt(state.hatId, 0, 12)
  ].join(',');
}

export function serialiseForDataset(record) {
  return JSON.stringify(normaliseAvatarRecord(record)).replaceAll('&', '&amp;').replaceAll("'", '&#39;');
}
