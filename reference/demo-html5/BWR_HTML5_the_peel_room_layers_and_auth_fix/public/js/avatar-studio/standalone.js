;(function(){
'use strict';
const CLRS1 = [10027008,43520,153,10057472,8913032,11198463,26367,16750848,13421568,61166,13369548,16777215,16766429,11206400,16763904,15658496,16745604,2631720,10066329,16777145,15597568,26112,1184274,12733185,16736768,16425579,16767167,7620096,16771473,6394113,8899328,14548127,62720,11993014,25670,110971,61093,7011535,25219,50886,10289151,2797311,3014772,5243334,8334079,14138879,16729855,16756735,11338573,15597672,15952037,16757203];
const CLRS2 = [52224,4474077,15610675,13421568,52428,13369548,8943360,2136473,11206400,16763904,15658496,16745604,10027008,15597568,16766429,12733185,16736768,16425579,16767167,7620096,16750848,16771473,10057472,16777145,6394113,8899328,11206400,14548127,26112,43520,62720,11993014,25670,110971,61093,7011535,25219,50886,61166,10289151,153,26367,2797311,11198463,3014772,5243334,8334079,14138879,8913032,16729855,16756735,11338573,15597672,15952037,16757203,10066329,16777215,2631720];

const HEAD_SHAPES = [
  { value: 1, name: 'Spheroid head' },
  { value: 2, name: 'Cone head' },
  { value: 3, name: 'Inverse cone head' },
  { value: 4, name: 'Cuboid head' }
];

const BODY_SHAPES = [
  { value: 1, name: 'Spheroid body' },
  { value: 2, name: 'Cone body' },
  { value: 3, name: 'Inverse cone body' },
  { value: 4, name: 'Cuboid body' }
];

const EYE_TYPES = [
  { value: 1, name: 'Classic wide' },
  { value: 2, name: 'Tall inset' },
  { value: 3, name: 'Tall wide' },
  { value: 4, name: 'Narrow tilt' },
  { value: 5, name: 'Big stare' },
  { value: 6, name: 'Far-set' }
];

const ANTENNA_TYPES = [
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

const LEG_TYPES = [
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

const EXPRESSION_TYPES = [
  { value: 0, name: 'Expression 0' },
  { value: 1, name: 'Expression 1' },
  { value: 2, name: 'Expression 2' },
  { value: 3, name: 'Expression 3' },
  { value: 4, name: 'Expression 4' },
  { value: 5, name: 'Expression 5' },
  { value: 6, name: 'Expression 6' }
];

const PROBOSCIS_TYPES = [
  { value: 0, name: 'Classic long' },
  { value: 1, name: 'Short drop' },
  { value: 2, name: 'Curved sweep' },
  { value: 3, name: 'Long arc' },
  { value: 4, name: 'Stubby' }
];

const HAT_TYPES = [
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

function paletteItems(source, prefix) {
  return source.map((value, index) => ({
    value: index,
    name: `${prefix} ${String(index).padStart(2, '0')} · ${asHex(value)}`,
    hex: asHex(value)
  }));
}

const HEAD_COLOURS = paletteItems(CLRS1, 'Head');
const BODY_COLOURS = paletteItems(CLRS1, 'Body');
const EYE_COLOURS = paletteItems(CLRS2, 'Eye');
const ANTENNA_COLOURS = paletteItems(CLRS1, 'Antenna');
const LIMB_COLOURS = paletteItems(CLRS1, 'Limb');

function clampInt(value, min, max) {
  const n = Number.parseInt(value, 10);
  if (Number.isNaN(n)) return min;
  return Math.min(max, Math.max(min, n));
}

function clampRange(value, min, max) {
  const n = Number(value);
  if (Number.isNaN(n)) return min;
  return Math.min(max, Math.max(min, n));
}

function hexToRgb(hex) {
  const raw = String(hex).replace('#', '');
  const normal = raw.length === 3 ? raw.split('').map((c) => c + c).join('') : raw;
  const int = Number.parseInt(normal, 16);
  return {
    r: (int >> 16) & 255,
    g: (int >> 8) & 255,
    b: int & 255
  };
}

function darken(hex, amount = 0.18) {
  const { r, g, b } = hexToRgb(hex);
  const to = (v) => Math.max(0, Math.round(v * (1 - amount)));
  return `rgb(${to(r)}, ${to(g)}, ${to(b)})`;
}

function lighten(hex, amount = 0.18) {
  const { r, g, b } = hexToRgb(hex);
  const to = (v) => Math.min(255, Math.round(v + (255 - v) * amount));
  return `rgb(${to(r)}, ${to(g)}, ${to(b)})`;
}

function colourFromIndex(paletteNumber, index) {
  const palette = paletteNumber === 2 ? CLRS2 : CLRS1;
  const safe = clampInt(index, 0, palette.length - 1);
  return asHex(palette[safe]);
}

function normaliseHex(value) {
  const raw = String(value || '').trim().replace(/[^0-9a-fA-F]/g, '').slice(0, 6);
  if (raw.length === 3) {
    return `#${raw.split('').map((c) => c + c).join('').toLowerCase()}`;
  }
  if (raw.length !== 6) return null;
  return `#${raw.toLowerCase()}`;
}

function paletteForNumber(paletteNumber) {
  return paletteNumber === 2 ? CLRS2 : CLRS1;
}

function rgbDistance(a, b) {
  return Math.sqrt(((a.r - b.r) ** 2) + ((a.g - b.g) ** 2) + ((a.b - b.b) ** 2));
}

function findNearestPaletteIndex(paletteNumber, hex) {
  const targetHex = normaliseHex(hex);
  if (!targetHex) return 0;
  const target = hexToRgb(targetHex);
  const palette = paletteForNumber(paletteNumber);
  let bestIndex = 0;
  let bestDistance = Number.POSITIVE_INFINITY;
  palette.forEach((colour, index) => {
    const sample = hexToRgb(asHex(colour));
    const distance = rgbDistance(target, sample);
    if (distance < bestDistance) {
      bestDistance = distance;
      bestIndex = index;
    }
  });
  return bestIndex;
}

function optionLabel(list, value) {
  const found = list.find((item) => item.value === value);
  return found ? found.name : `Custom ${value}`;
}

function parseCompactWeevilDef(defString) {
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

function formatCompactWeevilDef(state) {
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

function defaultAvatarRecord() {
  return {
    weevilDef: '401135129001323200',
    expression: 0,
    proboscis: 0,
    hatId: 0,
    preferredRenderer: 'svg'
  };
}

function normaliseAvatarRecord(input = {}) {
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

function avatarRecordToState(record = {}) {
  const normalised = normaliseAvatarRecord(record);
  const compact = parseCompactWeevilDef(normalised.weevilDef) || parseCompactWeevilDef(defaultAvatarRecord().weevilDef);
  return {
    ...compact,
    expression: normalised.expression,
    proboscis: normalised.proboscis,
    hatId: normalised.hatId,
    preferredRenderer: normalised.preferredRenderer,
    previewTurn: 0
  };
}

function stateToAvatarRecord(state) {
  return normaliseAvatarRecord({
    weevilDef: formatCompactWeevilDef(state),
    expression: state.expression,
    proboscis: state.proboscis,
    hatId: state.hatId,
    preferredRenderer: state.preferredRenderer
  });
}

function parseLegacyDemoDef(defString) {
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

function recordToLegacyDemoDef(record) {
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

function serialiseForDataset(record) {
  return JSON.stringify(normaliseAvatarRecord(record)).replaceAll('&', '&amp;').replaceAll("'", '&#39;');
}



function pathForProboscis(index) {
  const paths = [
    'M302 195 C251 250 248 336 214 504',
    'M302 195 C262 242 252 308 226 486',
    'M304 196 C260 236 256 342 219 501 C213 520 195 532 182 521',
    'M304 197 C263 240 250 352 213 509 C207 529 194 535 182 522',
    'M304 196 C273 225 264 295 244 448'
  ];
  return paths[clampInt(index, 0, paths.length - 1)] || paths[0];
}

function pathsForExpression(index) {
  const mouth = [
    'M260 440 Q320 478 380 440',
    'M248 434 Q320 492 392 434',
    'M262 447 Q320 456 378 447',
    'M255 442 Q320 470 390 435',
    'M278 456 Q320 466 362 456',
    'M268 444 Q320 452 372 444',
    'M270 450 Q320 430 370 450'
  ];
  const lower = [
    'M287 468 Q320 476 353 468',
    'M286 475 Q320 486 356 475',
    'M287 468 Q320 470 352 468',
    'M289 471 Q320 478 351 471',
    'M298 473 Q320 478 342 473',
    'M286 463 Q320 468 354 463',
    'M286 466 Q320 456 354 466'
  ];
  const safe = clampInt(index, 0, mouth.length - 1);
  return { mouth: mouth[safe], lower: lower[safe] };
}

function headShapePath(type) {
  switch (type) {
    case 1:
      return {
        base: 'M188 128 C164 128 144 150 144 174 V452 C144 482 162 506 190 514 L422 514 C446 514 466 504 478 486 L500 450 V172 C500 148 480 128 454 128 Z',
        light: 'M176 122 C156 122 140 142 140 164 V442 C140 474 158 494 186 502 L414 502 C438 502 458 492 470 474 L488 442 V164 C488 142 470 122 446 122 Z'
      };
    case 2:
      return {
        base: 'M212 116 C178 136 156 164 150 204 V452 C150 486 170 510 202 516 H412 C434 516 452 508 468 490 L494 460 V202 C486 164 462 136 426 116 Z',
        light: 'M214 122 C186 138 168 162 162 198 V442 C162 474 180 496 208 502 H404 C428 502 446 492 462 474 L482 448 V198 C476 162 456 138 426 122 Z'
      };
    case 3:
      return {
        base: 'M170 128 H470 C486 128 498 142 498 160 V418 C498 456 486 488 460 504 L414 530 H220 C184 530 160 506 154 470 L142 198 C138 168 148 142 170 128 Z',
        light: 'M176 136 H458 C474 136 486 148 486 164 V410 C486 446 474 474 452 488 L410 514 H224 C194 514 174 494 168 464 L156 204 C152 176 158 152 176 136 Z'
      };
    case 4:
    default:
      return {
        base: 'M188 120 H462 a30 30 0 0 1 30 30 v302 a30 30 0 0 1 -8 20 l-50 52 a30 30 0 0 1 -22 10 H188 a30 30 0 0 1 -30 -30 V150 a30 30 0 0 1 30 -30z',
        light: 'M176 114 H448 a28 28 0 0 1 28 28 v292 a28 28 0 0 1 -8 19 l-42 43 a28 28 0 0 1 -20 8 H176 a28 28 0 0 1 -28 -28 V142 a28 28 0 0 1 28 -28z'
      };
  }
}

function bodyShape(type, body, outline) {
  const shade = darken(body, 0.28);
  const light = lighten(body, 0.1);
  switch (type) {
    case 2:
      return `
      <g>
        <path d="M170 392 C215 352 425 352 470 392 C502 420 528 540 490 644 C452 748 378 818 320 818 C262 818 188 748 150 644 C112 540 138 420 170 392 Z" fill="${shade}" stroke="${outline}" stroke-width="7"/>
        <path d="M188 398 C228 368 412 368 452 398 C478 420 496 526 466 620 C434 708 368 760 320 760 C272 760 206 708 174 620 C144 526 162 420 188 398 Z" fill="${light}"/>
      </g>`;
    case 3:
      return `
      <g>
        <path d="M198 370 C246 388 394 388 442 370 C492 352 518 430 514 548 C510 664 440 810 320 810 C200 810 130 664 126 548 C122 430 148 352 198 370 Z" fill="${shade}" stroke="${outline}" stroke-width="7"/>
        <path d="M206 392 C252 404 388 404 434 392 C474 382 490 444 484 536 C478 644 420 742 320 742 C220 742 162 644 156 536 C150 444 166 382 206 392 Z" fill="${light}"/>
      </g>`;
    case 4:
      return `
      <g>
        <path d="M186 378 H454 C484 378 506 398 512 428 C532 524 510 692 426 770 C396 798 360 814 320 814 C280 814 244 798 214 770 C130 692 108 524 128 428 C134 398 156 378 186 378 Z" fill="${shade}" stroke="${outline}" stroke-width="7"/>
        <path d="M190 396 H448 C472 396 488 412 494 438 C510 516 490 664 414 734 C388 758 356 770 320 770 C284 770 252 758 226 734 C150 664 130 516 146 438 C152 412 168 396 190 396 Z" fill="${light}"/>
      </g>`;
    case 1:
    default:
      return `
      <g>
        <ellipse cx="320" cy="560" rx="188" ry="208" fill="${shade}" stroke="${outline}" stroke-width="7"/>
        <ellipse cx="320" cy="535" rx="172" ry="185" fill="${light}"/>
      </g>`;
  }
}

function eyePreset(type, headType) {
  const cuboidScale = headType === 4 ? 0.92 : 1;
  const presets = {
    1: { leftX: 242, rightX: 378, y: 180, r: 56 * cuboidScale, iris: 21, browLift: 2 },
    2: { leftX: 244, rightX: 376, y: 188, r: 50 * cuboidScale, iris: 19, browLift: 10 },
    3: { leftX: 234, rightX: 386, y: 184, r: 54 * cuboidScale, iris: 20, browLift: 6 },
    4: { leftX: 246, rightX: 374, y: 190, r: 46 * cuboidScale, iris: 18, browLift: 12 },
    5: { leftX: 238, rightX: 382, y: 174, r: 60 * cuboidScale, iris: 22, browLift: 0 },
    6: { leftX: 226, rightX: 394, y: 178, r: 52 * cuboidScale, iris: 20, browLift: 4 }
  };
  return presets[type] || presets[1];
}

function previewMetrics(turnValue) {
  const turn = clampRange(turnValue, -60, 60);
  const signed = turn / 60;
  const abs = Math.abs(signed);
  const dir = turn === 0 ? 0 : (turn > 0 ? 1 : -1);
  return {
    turn,
    signed,
    abs,
    dir,
    headTranslateX: signed * 28,
    headScaleX: 1 - abs * 0.09,
    bodyTranslateX: signed * 12,
    bodyScaleX: 1 - abs * 0.05,
    faceTranslateX: signed * 18,
    eyeSpacingScale: 1 - abs * 0.26,
    nearEyeScale: 1 + abs * 0.05,
    farEyeScale: 1 - abs * 0.16,
    farEyeOpacity: 0.78 + ((1 - abs) * 0.14),
    pupilShiftX: signed * 11,
    proboscisShiftX: signed * 18,
    proboscisScaleX: 1 - abs * 0.08,
    mouthShiftX: signed * 9,
    antennaShiftX: signed * 10,
    antennaScaleX: 1 - abs * 0.08,
    collarShiftX: signed * 12,
    sidePlaneOpacity: 0.14 + abs * 0.16
  };
}

function viewLabelFromTurn(turnValue) {
  const turn = clampRange(turnValue, -60, 60);
  if (turn <= -45) return 'Left profile';
  if (turn <= -20) return 'Three-quarter left';
  if (turn < 20) return 'Front';
  if (turn < 45) return 'Three-quarter right';
  return 'Right profile';
}

function drawAntennae(state, headFill, outline) {
  if (state.hatId > 0 || state.at === 0) return '';
  const primary = colourFromIndex(1, state.acIndex);
  const theme = {
    10: ['#ff4600', '#ffbe00', '#ffe95b'],
    11: ['#6544ff', '#c368ff', '#6a4dd0'],
    12: ['#c41f1f', '#ffffff', '#c41f1f'],
    13: ['#00ffff', '#ffe100', '#ff00c8'],
    14: ['#ff8b1a', '#111111', '#ff8b1a'],
    15: ['#ff5c00', '#ff1a1a', '#ffd04a'],
    16: ['#4eeaff', '#77b7ff', '#d7ffff']
  }[state.at] || null;
  const colours = theme || [primary, primary, primary];
  const drawStem = (x1, y1, cx, cy, x2, y2, bobbleX, bobbleY, colour) => `
    <path d="M${x1} ${y1} Q${cx} ${cy} ${x2} ${y2}" stroke="${outline}" stroke-width="9" fill="none" stroke-linecap="round"/>
    <path d="M${x1} ${y1} Q${cx} ${cy} ${x2} ${y2}" stroke="${colour}" stroke-width="7" fill="none" stroke-linecap="round"/>
    <circle cx="${bobbleX}" cy="${bobbleY}" r="18" fill="${colour}" stroke="${outline}" stroke-width="6"/>
    <circle cx="${bobbleX + 8}" cy="${bobbleY - 10}" r="5" fill="#ffffff" opacity=".9"/>
  `;
  switch (state.at) {
    case 1:
      return `<g>${drawStem(320, 64, 320, 44, 320, 22, 320, 22, colours[0])}</g>`;
    case 2:
      return `<g>${drawStem(320, 64, 320, 22, 320, -18, 320, -18, colours[0])}</g>`;
    case 3:
      return `<g>${drawStem(320, 64, 318, 0, 320, -52, 320, -52, colours[0])}</g>`;
    case 4:
      return `<g>${drawStem(292, 70, 274, 42, 256, 20, 256, 20, colours[0])}${drawStem(348, 70, 366, 42, 384, 20, 384, 20, colours[1])}</g>`;
    case 5:
      return `<g>${drawStem(292, 68, 260, 18, 234, -22, 234, -22, colours[0])}${drawStem(348, 68, 380, 18, 406, -22, 406, -22, colours[1])}</g>`;
    case 6:
      return `<g>${drawStem(292, 68, 248, -12, 220, -70, 220, -70, colours[0])}${drawStem(348, 68, 392, -12, 420, -70, 420, -70, colours[1])}</g>`;
    case 7:
      return `<g>${drawStem(320, 64, 320, 40, 320, 14, 320, 14, colours[0])}${drawStem(286, 72, 266, 48, 250, 22, 250, 22, colours[1])}${drawStem(354, 72, 374, 48, 390, 22, 390, 22, colours[2])}</g>`;
    case 8:
      return `<g>${drawStem(320, 64, 320, 18, 320, -18, 320, -18, colours[0])}${drawStem(286, 72, 252, 30, 232, -6, 232, -6, colours[1])}${drawStem(354, 72, 388, 30, 408, -6, 408, -6, colours[2])}</g>`;
    default:
      return `<g>${drawStem(320, 64, 320, -18, 320, -78, 320, -78, colours[0])}${drawStem(286, 72, 248, 0, 214, -44, 214, -44, colours[1])}${drawStem(354, 72, 392, 0, 426, -44, 426, -44, colours[2])}</g>`;
  }
}

function legStyleForType(type, baseColour) {
  const themes = {
    1: ['#ffffff', baseColour, '#ffffff'],
    2: ['#ffd866', baseColour, '#ff8d00'],
    3: ['#ff8d00', '#ffff66', '#ff3f3f'],
    4: ['#6d4dff', '#ffd300', '#39c8ff'],
    5: ['#ff8d00', '#111111', '#ff8d00'],
    6: ['#111111', '#ffffff', '#111111'],
    7: ['#111111', '#275bff', '#111111'],
    8: ['#ff4c00', '#ffdb4d', '#ff2222'],
    9: ['#40f0ff', '#bff6ff', '#6f8fff'],
    10: ['#ff4cc3', '#4cfff1', '#ffe54c']
  };
  return themes[type] || null;
}

function drawLegGroup(state, outline, view = previewMetrics(0)) {
  const base = colourFromIndex(1, state.lcIndex);
  const shade = darken(base, 0.25);
  const style = legStyleForType(state.lt, base);
  const stripyClass = style ? `
    <pattern id="legPattern" width="30" height="30" patternUnits="userSpaceOnUse" patternTransform="rotate(18)">
      <rect width="30" height="30" fill="${base}"/>
      <rect width="10" height="30" x="0" fill="${style[0]}"/>
      <rect width="10" height="30" x="10" fill="${style[1]}"/>
      <rect width="10" height="30" x="20" fill="${style[2]}"/>
    </pattern>` : '';
  const fill = style ? 'url(#legPattern)' : base;
  const farIsLeft = view.turn > 0;
  const farOpacity = 0.78 + ((1 - view.abs) * 0.14);
  const nearScale = 1 + view.abs * 0.03;
  const farScale = 1 - view.abs * 0.04;
  const leftArmX = 112 - (view.dir < 0 ? 10 * view.abs : 2 * view.abs);
  const rightArmX = 528 + (view.dir > 0 ? 10 * view.abs : 2 * view.abs);
  const leftShoulder = 215 - view.abs * 14;
  const rightShoulder = 425 + view.abs * 14;
  const leftLegOuterX = 78 - (view.dir < 0 ? 8 * view.abs : 2 * view.abs);
  const leftLegInnerX = 124 - (view.dir < 0 ? 6 * view.abs : 1 * view.abs);
  const rightLegInnerX = 516 + (view.dir > 0 ? 6 * view.abs : 1 * view.abs);
  const rightLegOuterX = 562 + (view.dir > 0 ? 8 * view.abs : 2 * view.abs);
  const leftScale = farIsLeft ? farScale : nearScale;
  const rightScale = farIsLeft ? nearScale : farScale;
  const leftOpacity = farIsLeft ? farOpacity : 1;
  const rightOpacity = farIsLeft ? 1 : farOpacity;

  const sideLimb = ({ side, armX, shoulderX, legOuterX, legInnerX, scale = 1, opacity = 1 }) => {
    const armCurve = side === 'left'
      ? `M${armX} 516 C${armX - 18} 562 ${armX - 26} 664 ${armX - 32} 832`
      : `M${armX} 516 C${armX + 18} 562 ${armX + 26} 664 ${armX + 32} 832`;
    const armInner = side === 'left'
      ? `M${armX + 34} 500 C${armX + 18} 534 ${armX + 12} 626 ${armX + 10} 726`
      : `M${armX - 34} 500 C${armX - 18} 534 ${armX - 12} 626 ${armX - 10} 726`;
    const shoulder = side === 'left'
      ? `M${armX - 10} 514 C${armX + 26} 462 ${shoulderX} 468 ${shoulderX + 24} 498`
      : `M${armX + 10} 514 C${armX - 26} 462 ${shoulderX} 468 ${shoulderX - 24} 498`;
    const outerLeg = side === 'left'
      ? `M${legOuterX} 530 C${legOuterX - 20} 586 ${legOuterX - 26} 688 ${legOuterX - 32} 842`
      : `M${legOuterX} 530 C${legOuterX + 20} 586 ${legOuterX + 26} 688 ${legOuterX + 32} 842`;
    const innerLeg = side === 'left'
      ? `M${legInnerX} 512 C${legInnerX - 10} 552 ${legInnerX - 14} 642 ${legInnerX - 18} 744`
      : `M${legInnerX} 512 C${legInnerX + 10} 552 ${legInnerX + 14} 642 ${legInnerX + 18} 744`;
    const groupX = side === 'left' ? 188 : 452;
    return `
      <g opacity="${opacity}" transform="translate(${groupX} 0) scale(${scale} 1) translate(-${groupX} 0)">
        <path d="${outerLeg}" stroke="${shade}" stroke-width="22" fill="none"/>
        <path d="${innerLeg}" stroke="${shade}" stroke-width="20" fill="none"/>
        <path d="${shoulder}" stroke="${shade}" stroke-width="22" fill="none"/>
        <path d="${armCurve}" stroke="${shade}" stroke-width="22" fill="none"/>
        <path d="${armInner}" stroke="${shade}" stroke-width="20" fill="none"/>

        <path d="${outerLeg}" stroke="${fill}" stroke-width="24" fill="none"/>
        <path d="${innerLeg}" stroke="${fill}" stroke-width="22" fill="none"/>
        <path d="${shoulder}" stroke="${fill}" stroke-width="24" fill="none"/>
        <path d="${armCurve}" stroke="${fill}" stroke-width="24" fill="none"/>
        <path d="${armInner}" stroke="${fill}" stroke-width="22" fill="none"/>
      </g>`;
  };

  return `
    <defs>${stripyClass}</defs>
    <g stroke-linecap="round" stroke-linejoin="round">
      ${sideLimb({ side: 'left', armX: leftArmX, shoulderX: leftShoulder, legOuterX: leftLegOuterX, legInnerX: leftLegInnerX, scale: leftScale, opacity: leftOpacity })}
      ${sideLimb({ side: 'right', armX: rightArmX, shoulderX: rightShoulder, legOuterX: rightLegOuterX, legInnerX: rightLegInnerX, scale: rightScale, opacity: rightOpacity })}
    </g>`;
}

function drawHat(index, headFill, outline) {
  switch (index) {
    case 1:
      return `<g><path d="M228 110 Q320 62 412 110 L396 148 Q320 122 244 148 Z" fill="#8d4fd3" stroke="${outline}" stroke-width="6"/><circle cx="320" cy="90" r="18" fill="#ffd447" stroke="${outline}" stroke-width="5"/></g>`;
    case 2:
      return `<g><path d="M228 118 Q320 68 414 118 L400 150 Q320 128 242 150 Z" fill="#f24747" stroke="${outline}" stroke-width="6"/><path d="M264 106 Q318 62 380 106 Q371 124 267 124 Z" fill="#df2d2d" stroke="${outline}" stroke-width="6"/></g>`;
    case 3:
      return `<g><path d="M242 136 L266 92 L292 120 L320 84 L348 120 L374 92 L398 136 Z" fill="#ffd14f" stroke="${outline}" stroke-width="6"/><circle cx="266" cy="94" r="7" fill="#ff6a6a"/><circle cx="320" cy="86" r="7" fill="#55d2ff"/><circle cx="374" cy="94" r="7" fill="#77f25f"/></g>`;
    case 4:
      return `<g><rect x="252" y="78" width="136" height="72" rx="12" fill="#222" stroke="${outline}" stroke-width="6"/><rect x="228" y="140" width="184" height="18" rx="9" fill="#111" stroke="${outline}" stroke-width="6"/><rect x="252" y="114" width="136" height="16" fill="#d54242"/></g>`;
    case 5:
      return `<g><path d="M232 126 Q320 58 408 126 L394 158 Q320 132 246 158 Z" fill="#a8b7c9" stroke="${outline}" stroke-width="6"/><rect x="266" y="88" width="108" height="34" rx="12" fill="#c7d5e6" stroke="${outline}" stroke-width="6"/></g>`;
    case 6:
      return `<g><path d="M232 128 Q320 92 408 128 L392 154 Q320 138 248 154 Z" fill="#111" stroke="${outline}" stroke-width="6"/><path d="M382 96 L414 120 L390 132" fill="none" stroke="${outline}" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/><circle cx="415" cy="120" r="7" fill="#fff" stroke="${outline}" stroke-width="4"/></g>`;
    case 7:
      return `<g><path d="M320 70 L392 150 L248 150 Z" fill="#58c3ff" stroke="${outline}" stroke-width="6"/><circle cx="320" cy="70" r="11" fill="#ffd447" stroke="${outline}" stroke-width="4"/><path d="M252 138 Q320 126 388 138" stroke="#ffd447" stroke-width="8" fill="none"/></g>`;
    case 8:
      return `<g><path d="M320 64 L378 136 L344 136 L362 184 L320 154 L278 184 L296 136 L262 136 Z" fill="#6e52de" stroke="${outline}" stroke-width="6" stroke-linejoin="round"/></g>`;
    case 9:
      return `<g><path d="M232 120 Q320 78 408 120 L394 150 Q320 132 246 150 Z" fill="#ff5a5a" stroke="${outline}" stroke-width="6"/><line x1="320" y1="70" x2="320" y2="120" stroke="${outline}" stroke-width="6" stroke-linecap="round"/><line x1="320" y1="70" x2="344" y2="58" stroke="${outline}" stroke-width="6" stroke-linecap="round"/><circle cx="297" cy="58" r="10" fill="#57a8ff" stroke="${outline}" stroke-width="4"/><circle cx="344" cy="58" r="10" fill="#ffd447" stroke="${outline}" stroke-width="4"/></g>`;
    case 10:
      return `<g><path d="M244 128 Q320 88 396 128 L382 154 Q320 138 258 154 Z" fill="#7a5a36" stroke="${outline}" stroke-width="6"/><path d="M246 120 L226 94" stroke="#f1f1f1" stroke-width="12" stroke-linecap="round"/><path d="M394 120 L414 94" stroke="#f1f1f1" stroke-width="12" stroke-linecap="round"/></g>`;
    case 11:
      return `<g><path d="M232 124 Q320 76 408 124 L394 150 Q320 132 246 150 Z" fill="#d83d3d" stroke="${outline}" stroke-width="6"/><path d="M262 112 Q320 48 382 112 Q373 128 268 128 Z" fill="#d83d3d" stroke="${outline}" stroke-width="6"/><path d="M260 114 Q320 70 380 114" stroke="#ffffff" stroke-width="14"/><circle cx="386" cy="106" r="14" fill="#ffffff" stroke="${outline}" stroke-width="4"/></g>`;
    case 12:
      return `<g><ellipse cx="320" cy="94" rx="88" ry="24" fill="none" stroke="#ffde73" stroke-width="10"/><ellipse cx="320" cy="94" rx="88" ry="24" fill="rgba(255,222,115,.14)"/></g>`;
    default:
      return '';
  }
}

function buildWeevilSvg(state, options = {}) {
  const headFill = colourFromIndex(1, state.hcIndex);
  const bodyFill = colourFromIndex(1, state.bcIndex);
  const irisFill = colourFromIndex(2, state.ecIndex);
  const outline = '#0c1517';
  const mouthStroke = '#777b82';
  const headShade = darken(headFill, 0.22);
  const headHighlight = lighten(headFill, 0.08);
  const { base, light } = headShapePath(state.ht);
  const eyes = eyePreset(state.et, state.ht);
  const expression = pathsForExpression(state.expression);
  const view = previewMetrics(state.previewTurn || 0);
  const headScaleTransform = `translate(${320 + view.headTranslateX} 320) scale(${view.headScaleX} 1) translate(-320 -320)`;
  const bodyRigTransform = `translate(${320 + view.bodyTranslateX} 560) scale(${view.bodyScaleX} 1.01) translate(-320 -560)`;
  const sidePlaneTransform = view.dir < 0 ? 'translate(640 0) scale(-1 1)' : '';
  const faceCenterX = 320 + view.faceTranslateX;
  const baseGap = (eyes.rightX - eyes.leftX) / 2;
  const eyeGap = baseGap * view.eyeSpacingScale;
  const leftEyeBaseX = faceCenterX - eyeGap + (view.dir < 0 ? -4 * view.abs : 1.5 * view.abs);
  const rightEyeBaseX = faceCenterX + eyeGap + (view.dir > 0 ? 4 * view.abs : -1.5 * view.abs);
  const farIsLeft = view.turn > 0;
  const leftEyeScale = farIsLeft ? view.farEyeScale : view.nearEyeScale;
  const rightEyeScale = farIsLeft ? view.nearEyeScale : view.farEyeScale;
  const leftEyeOpacity = farIsLeft ? view.farEyeOpacity : 1;
  const rightEyeOpacity = farIsLeft ? 1 : view.farEyeOpacity;
  const leftPupilShift = view.pupilShiftX * (farIsLeft ? 0.7 : 1);
  const rightPupilShift = view.pupilShiftX * (farIsLeft ? 1 : 0.7);
  const leftBrow = `M${leftEyeBaseX - 42} ${116 + eyes.browLift} Q${leftEyeBaseX} ${102 + eyes.browLift - view.abs * 1.5} ${leftEyeBaseX + 42} ${116 + eyes.browLift}`;
  const rightBrow = `M${rightEyeBaseX - 42} ${116 + eyes.browLift} Q${rightEyeBaseX} ${102 + eyes.browLift - view.abs * 1.5} ${rightEyeBaseX + 42} ${116 + eyes.browLift}`;
  const lidOffset = state.lids ? 14 : 0;
  const lidOpacity = state.lids ? 1 : 0;
  const proboscisTransform = `translate(${view.proboscisShiftX} 0) translate(302 196) scale(${view.proboscisScaleX} 1) translate(-302 -196)`;
  const mouthTransform = `translate(${view.mouthShiftX} 0)`;

  const headSidePlane = state.ht === 4
    ? `<g transform="${sidePlaneTransform}"><path d="M431 144 C470 147 485 154 490 165 L490 438 C490 460 481 474 462 488 L432 505 Z" fill="${darken(headFill, 0.18)}" opacity="${view.sidePlaneOpacity}"/></g>`
    : `<g transform="${sidePlaneTransform}"><path d="M430 144 C470 160 487 196 490 230 L488 430 C478 470 454 490 424 502 Z" fill="${darken(headFill, 0.18)}" opacity="${Math.max(0.12, view.sidePlaneOpacity - 0.03)}"/></g>`;

  return `
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 860" aria-label="Weevil preview">
    <defs>
      <filter id="softShadow" x="-30%" y="-30%" width="160%" height="160%">
        <feDropShadow dx="0" dy="16" stdDeviation="20" flood-color="rgba(0,0,0,.25)"/>
      </filter>
      <clipPath id="headFaceClip">
        <path d="${light}"/>
      </clipPath>
    </defs>
    <g filter="url(#softShadow)">
      <ellipse cx="320" cy="820" rx="146" ry="24" fill="rgba(0,0,0,.14)"/>
      <g transform="${bodyRigTransform}">
        ${drawLegGroup(state, outline, view)}
        ${bodyShape(state.bt, bodyFill, outline)}
        <ellipse cx="${320 + view.collarShiftX}" cy="392" rx="116" ry="34" fill="${darken(bodyFill, 0.34)}" opacity=".9"/>
        <ellipse cx="${320 + view.collarShiftX}" cy="384" rx="102" ry="24" fill="${lighten(bodyFill, 0.08)}" opacity=".72"/>
      </g>
      ${state.hatId > 0 ? '' : `<g transform="${headScaleTransform} translate(${view.antennaShiftX} 0) translate(320 76) scale(${view.antennaScaleX} 1) translate(-320 -76)">${drawAntennae(state, headFill, outline)}</g>`}
      <g transform="${headScaleTransform}">
        <g>
          <path d="${base}" fill="${headShade}" stroke="${outline}" stroke-width="7"/>
          <path d="${light}" fill="${headFill}"/>
          ${headSidePlane}
          <path d="M186 146 C210 128 238 122 268 122" stroke="${headHighlight}" stroke-width="5" fill="none" opacity=".42"/>
          <path d="M180 484 L426 484 C438 484 448 480 458 470 L480 448" stroke="${darken(headFill, 0.34)}" stroke-width="7" fill="none" opacity=".26"/>
        </g>
        ${drawHat(state.hatId, headFill, outline)}
        <g clip-path="url(#headFaceClip)">
          <g opacity="${leftEyeOpacity}" transform="translate(${leftEyeBaseX} ${eyes.y}) scale(${leftEyeScale} 1) translate(-${leftEyeBaseX} -${eyes.y})">
            <path d="${leftBrow}" stroke="${outline}" stroke-width="10" fill="none" stroke-linecap="round"/>
            <path d="${leftBrow}" stroke="${darken(headFill, 0.14)}" stroke-width="6" fill="none" stroke-linecap="round"/>
            <circle cx="${leftEyeBaseX}" cy="${eyes.y}" r="${eyes.r}" fill="#ffffff" stroke="${outline}" stroke-width="6"/>
            <circle cx="${leftEyeBaseX + 16 + leftPupilShift}" cy="${eyes.y + 2}" r="${eyes.iris}" fill="${irisFill}" stroke="${outline}" stroke-width="4"/>
            <circle cx="${leftEyeBaseX + 16 + leftPupilShift}" cy="${eyes.y + 2}" r="7" fill="#121212"/>
            <circle cx="${leftEyeBaseX + 3}" cy="${eyes.y - 14}" r="5" fill="#ffffff" opacity=".9"/>
            <path d="M${leftEyeBaseX - eyes.r + 8} ${eyes.y - 8 + lidOffset} Q${leftEyeBaseX} ${eyes.y - eyes.r + 16 + lidOffset} ${leftEyeBaseX + eyes.r - 8} ${eyes.y - 8 + lidOffset}" stroke="${headFill}" stroke-width="18" fill="none" opacity="${lidOpacity}"/>
            <path d="M${leftEyeBaseX - eyes.r + 8} ${eyes.y - 12 + lidOffset} Q${leftEyeBaseX} ${eyes.y - eyes.r + 12 + lidOffset} ${leftEyeBaseX + eyes.r - 8} ${eyes.y - 12 + lidOffset}" stroke="${outline}" stroke-width="5" fill="none" opacity="${lidOpacity}"/>
          </g>
          <g opacity="${rightEyeOpacity}" transform="translate(${rightEyeBaseX} ${eyes.y}) scale(${rightEyeScale} 1) translate(-${rightEyeBaseX} -${eyes.y})">
            <path d="${rightBrow}" stroke="${outline}" stroke-width="10" fill="none" stroke-linecap="round"/>
            <path d="${rightBrow}" stroke="${darken(headFill, 0.14)}" stroke-width="6" fill="none" stroke-linecap="round"/>
            <circle cx="${rightEyeBaseX}" cy="${eyes.y}" r="${eyes.r}" fill="#ffffff" stroke="${outline}" stroke-width="6"/>
            <circle cx="${rightEyeBaseX + 16 + rightPupilShift}" cy="${eyes.y + 2}" r="${eyes.iris}" fill="${irisFill}" stroke="${outline}" stroke-width="4"/>
            <circle cx="${rightEyeBaseX + 16 + rightPupilShift}" cy="${eyes.y + 2}" r="7" fill="#121212"/>
            <circle cx="${rightEyeBaseX + 3}" cy="${eyes.y - 14}" r="5" fill="#ffffff" opacity=".9"/>
            <path d="M${rightEyeBaseX - eyes.r + 8} ${eyes.y - 8 + lidOffset} Q${rightEyeBaseX} ${eyes.y - eyes.r + 16 + lidOffset} ${rightEyeBaseX + eyes.r - 8} ${eyes.y - 8 + lidOffset}" stroke="${headFill}" stroke-width="18" fill="none" opacity="${lidOpacity}"/>
            <path d="M${rightEyeBaseX - eyes.r + 8} ${eyes.y - 12 + lidOffset} Q${rightEyeBaseX} ${eyes.y - eyes.r + 12 + lidOffset} ${rightEyeBaseX + eyes.r - 8} ${eyes.y - 12 + lidOffset}" stroke="${outline}" stroke-width="5" fill="none" opacity="${lidOpacity}"/>
          </g>
          <g transform="${mouthTransform}">
            <path d="${expression.mouth}" fill="none" stroke="${mouthStroke}" stroke-width="5.5" stroke-linecap="round"/>
            <path d="${expression.lower}" fill="none" stroke="${mouthStroke}" stroke-width="4.5" stroke-linecap="round"/>
          </g>
        </g>
        <g transform="${proboscisTransform}">
          <path d="${pathForProboscis(state.proboscis)}" stroke="${outline}" stroke-width="24" fill="none" stroke-linecap="round"/>
          <path d="${pathForProboscis(state.proboscis)}" stroke="${headFill}" stroke-width="20" fill="none" stroke-linecap="round"/>
          <ellipse cx="302" cy="230" rx="22" ry="15" fill="${headFill}" stroke="${outline}" stroke-width="5"/>
        </g>
      </g>
    </g>
  </svg>`;
}

function renderSvgInto(container, state, options = {}) {
  const svg = buildWeevilSvg(state, options);
  container.innerHTML = svg;
  return svg;
}



let pixiPromise;

async function loadPixi() {
  if (window.PIXI) return window.PIXI;
  if (!pixiPromise) {
    pixiPromise = new Promise((resolve, reject) => {
      const existing = document.querySelector('script[data-pixi-loader="1"]');
      if (existing) {
        existing.addEventListener('load', () => resolve(window.PIXI));
        existing.addEventListener('error', () => reject(new Error('Failed to load PixiJS.')));
        return;
      }
      const script = document.createElement('script');
      script.src = 'https://cdn.jsdelivr.net/npm/pixi.js@8.10.2/dist/pixi.min.js';
      script.async = true;
      script.dataset.pixiLoader = '1';
      script.onload = () => window.PIXI ? resolve(window.PIXI) : reject(new Error('PixiJS loaded but global PIXI was not found.'));
      script.onerror = () => reject(new Error('Failed to load PixiJS.'));
      document.head.appendChild(script);
    });
  }
  return pixiPromise;
}

async function renderPixiInto(container, state, options = {}) {
  const PIXI = await loadPixi();
  container.innerHTML = '';
  const host = document.createElement('div');
  host.className = 'pixi-host';
  container.appendChild(host);

  const app = new PIXI.Application();
  await app.init({
    width: 640,
    height: 860,
    backgroundAlpha: 0,
    antialias: true,
    resolution: window.devicePixelRatio || 1,
    autoDensity: true
  });
  host.appendChild(app.canvas);

  const shadow = new PIXI.Graphics();
  shadow.ellipse(320, 820, 146, 24).fill({ color: 0x000000, alpha: 0.14 });
  shadow.filters = [new PIXI.BlurFilter({ strength: 6 })];
  app.stage.addChild(shadow);

  const svgMarkup = buildWeevilSvg(state, options);
  const blob = new Blob([svgMarkup], { type: 'image/svg+xml;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  try {
    const texture = await PIXI.Assets.load(url);
    const sprite = new PIXI.Sprite(texture);
    sprite.anchor.set(0.5, 0.5);
    sprite.position.set(320, 430);
    sprite.width = 520;
    sprite.height = 700;
    app.stage.addChild(sprite);
  } finally {
    URL.revokeObjectURL(url);
  }

  return () => {
    try {
      app.destroy(true, { children: true, texture: true, textureSource: true });
    } catch {
      // ignore cleanup failures
    }
  };
}

const root = document.getElementById('weevilStudioApp');

if (!root) {
  throw new Error('weevilStudioApp root not found.');
}

const initialRecord = (() => {
  try {
    return normaliseAvatarRecord(JSON.parse(root.dataset.avatarRecord || '{}'));
  } catch {
    return normaliseAvatarRecord({});
  }
})();

const afterSavePath = (() => {
  const value = String(root.dataset.afterSavePath || '/room').trim();
  return value.startsWith('/') && !value.startsWith('//') ? value : '/room';
})();

let state = avatarRecordToState(initialRecord);
let activePixiCleanup = null;

function template() {
  return `
  <div class="weevil-shell">
    <aside class="weevil-panel weevil-sidebar">
      <div class="weevil-brand">
        <div class="weevil-brand-bug"></div>
        <div>
          <h1>HTML5 Weevil Studio</h1>
          <p class="weevil-sub">Continuation build using the existing editor as the base. Rotation and part anchors are now handled at the rig level, while colour selection keeps the compact <strong>weevilDef</strong> palette compatible.</p>
        </div>
      </div>

      <section class="weevil-section">
        <h2>Renderer</h2>
        <div class="weevil-grid weevil-grid-2">
          <label>
            <span>Mode</span>
            <select id="preferredRenderer"></select>
          </label>
          <div class="weevil-status-box">
            <strong id="rendererStatus">Stable SVG renderer active.</strong>
            <span>Pixi stays optional and now mirrors the stable SVG pose without extra skew.</span>
          </div>
          <label class="weevil-full">
            <span>Preview turn</span>
            <input type="range" id="previewTurn" min="-60" max="60" step="5" value="0">
          </label>
          <div class="weevil-status-box">
            <strong id="previewTurnLabel">Front</strong>
            <span>Preview-only turn. It keeps the avatar coherent and does not alter the saved compact <code>weevilDef</code>.</span>
          </div>
        </div>
      </section>

      <section class="weevil-section">
        <h2>Compact WeevilDef</h2>
        <div class="weevil-def-row">
          <label class="weevil-full">
            <span>Compact source string</span>
            <input type="text" id="compactDefInput" spellcheck="false" autocomplete="off">
          </label>
          <button id="applyCompact" class="weevil-small">Apply</button>
          <button id="copyCompact" class="weevil-small">Copy</button>
        </div>
        <div class="weevil-note">Real format: <strong>ht hc bt bc et ec lids at ac lc lt</strong> packed into 18 digits. Palette-backed colours still save back into this compact form.</div>
      </section>

      <section class="weevil-section">
        <h2>Legacy demo bridge</h2>
        <div class="weevil-def-row">
          <label class="weevil-full">
            <span>Old 7-slot demo string</span>
            <input type="text" id="legacyDefInput" spellcheck="false" autocomplete="off">
          </label>
          <button id="applyLegacy" class="weevil-small">Apply</button>
          <button id="copyLegacy" class="weevil-small">Copy</button>
        </div>
        <div class="weevil-note">Lets the old working editor format keep talking to the new one so nothing useful gets stranded.</div>
      </section>

      <section class="weevil-section">
        <h2>Body definition</h2>
        <div class="weevil-grid weevil-grid-2">
          <label><span>Head shape</span><select id="ht"></select></label>
          <label><span>Body shape</span><select id="bt"></select></label>
          <label><span>Eye type</span><select id="et"></select></label>
          <label><span>Eyelids</span><select id="lids"></select></label>
          <label><span>Expression</span><select id="expression"></select></label>
          <label><span>Proboscis</span><select id="proboscis"></select></label>
          <label><span>Hat slot</span><select id="hatId"></select></label>
        </div>
      </section>

      <section class="weevil-section">
        <h2>Antennae + legs</h2>
        <div class="weevil-grid weevil-grid-2">
          <label><span>Antenna type</span><select id="at"></select></label>
          <label><span>Leg type</span><select id="lt"></select></label>
        </div>
        <div class="weevil-note">Hat logic is intentionally hats-only. When a hat is present, antennae are hidden to match the original apparel layering behaviour.</div>
      </section>

      <section class="weevil-section">
        <h2>Colour studio</h2>
        <div class="weevil-grid">
          <div class="weevil-colour-field">
            <span>Head colour</span>
            <div class="weevil-colour-row">
              <select id="hcIndex"></select>
              <input type="color" id="hcHexPicker" class="weevil-colour-swatch" value="#98ff00">
              <input type="text" id="hcHexInput" class="weevil-hex-input" maxlength="7" spellcheck="false" value="#98ff00">
            </div>
          </div>
          <div class="weevil-colour-field">
            <span>Body colour</span>
            <div class="weevil-colour-row">
              <select id="bcIndex"></select>
              <input type="color" id="bcHexPicker" class="weevil-colour-swatch" value="#00cc88">
              <input type="text" id="bcHexInput" class="weevil-hex-input" maxlength="7" spellcheck="false" value="#00cc88">
            </div>
          </div>
          <div class="weevil-colour-field">
            <span>Eye colour</span>
            <div class="weevil-colour-row">
              <select id="ecIndex"></select>
              <input type="color" id="ecHexPicker" class="weevil-colour-swatch" value="#00aa00">
              <input type="text" id="ecHexInput" class="weevil-hex-input" maxlength="7" spellcheck="false" value="#00aa00">
            </div>
          </div>
          <div class="weevil-colour-field">
            <span>Antenna colour</span>
            <div class="weevil-colour-row">
              <select id="acIndex"></select>
              <input type="color" id="acHexPicker" class="weevil-colour-swatch" value="#98ff00">
              <input type="text" id="acHexInput" class="weevil-hex-input" maxlength="7" spellcheck="false" value="#98ff00">
            </div>
          </div>
          <div class="weevil-colour-field">
            <span>Leg colour</span>
            <div class="weevil-colour-row">
              <select id="lcIndex"></select>
              <input type="color" id="lcHexPicker" class="weevil-colour-swatch" value="#98ff00">
              <input type="text" id="lcHexInput" class="weevil-hex-input" maxlength="7" spellcheck="false" value="#98ff00">
            </div>
          </div>
        </div>
        <div class="weevil-note">Visual picker + hex field stay synced with the original game palettes. Custom hex values snap to the nearest compatible palette entry so the compact <code>weevilDef</code> stays valid.</div>
      </section>

      <section class="weevil-section">
        <h2>Actions</h2>
        <div class="weevil-actions">
          <button id="randomize" class="weevil-primary">Randomize</button>
          <button id="reset">Reset</button>
          <button id="presetClassic">Classic</button>
          <button id="presetBoxy">Reference-style</button>
          <button id="presetRoyal">Royal</button>
          <button id="saveAvatar" class="weevil-primary weevil-full">Save to mirror profile</button>
          <button id="saveAndContinue" class="weevil-full">Save and enter chat room</button>
          <button id="downloadSvg" class="weevil-full">Download SVG</button>
          <button id="downloadPng" class="weevil-full">Download PNG</button>
        </div>
        <div id="saveStatus" class="weevil-note">Nothing saved yet in this session.</div>
      </section>
    </aside>

    <main class="weevil-panel weevil-viewer">
      <div class="weevil-viewer-head">
        <div>
          <h2>Live preview</h2>
          <p class="weevil-sub">Existing reference image remains the visual target. The main preview and mini preview below now use the same render pipeline so swaps and rotation stay synced.</p>
        </div>
        <div class="weevil-badges">
          <span class="weevil-badge">Base string <strong id="currentCompactDef"></strong></span>
          <span class="weevil-badge">Hat <strong id="currentHatLabel"></strong></span>
          <span class="weevil-badge">View <strong id="currentViewLabel">Front</strong></span>
        </div>
      </div>

      <div class="weevil-stage-wrap">
        <div class="weevil-stage">
          <div id="weevilMount" class="weevil-mount"></div>
        </div>
        <aside class="weevil-inspector">
          <div class="weevil-inspector-card">
            <h3>Mini live preview</h3>
            <div class="weevil-mini-stage">
              <div id="referenceMount" class="weevil-mini-mount"></div>
            </div>
            <p>Uses the exact same avatar state and turn value as the main preview so you can judge stability at both sizes.</p>
          </div>
          <div class="weevil-inspector-card">
            <h3>Reference target</h3>
            <img src="js/avatar-studio/assets/reference-weevil.png" alt="Existing reference weevil" class="weevil-reference-image">
            <p>The upgrade still keeps this boxy head + round body silhouette as the visual anchor unless the actual compact definition says otherwise.</p>
          </div>
          <div class="weevil-inspector-card">
            <h3>Prepared for mirror integration</h3>
            <ul>
              <li>Compact <code>weevilDef</code> preserved</li>
              <li>Hat stored separately</li>
              <li>Client-safe JSON payload</li>
              <li>Reusable SVG output for profile surfaces</li>
            </ul>
          </div>
          <div class="weevil-inspector-card">
            <h3>Payload preview</h3>
            <pre id="payloadPreview"></pre>
          </div>
        </aside>
      </div>

      <div class="weevil-footer">Tip: paste either the compact 18-digit string or the old demo 7-slot string, then export or save.</div>
    </main>
  </div>`;
}

root.innerHTML = template();

const els = {
  preferredRenderer: document.getElementById('preferredRenderer'),
  rendererStatus: document.getElementById('rendererStatus'),
  previewTurn: document.getElementById('previewTurn'),
  previewTurnLabel: document.getElementById('previewTurnLabel'),
  compactDefInput: document.getElementById('compactDefInput'),
  legacyDefInput: document.getElementById('legacyDefInput'),
  currentCompactDef: document.getElementById('currentCompactDef'),
  currentHatLabel: document.getElementById('currentHatLabel'),
  currentViewLabel: document.getElementById('currentViewLabel'),
  payloadPreview: document.getElementById('payloadPreview'),
  saveStatus: document.getElementById('saveStatus'),
  saveAndContinue: document.getElementById('saveAndContinue'),
  weevilMount: document.getElementById('weevilMount'),
  referenceMount: document.getElementById('referenceMount'),
  ht: document.getElementById('ht'),
  hcIndex: document.getElementById('hcIndex'),
  hcHexPicker: document.getElementById('hcHexPicker'),
  hcHexInput: document.getElementById('hcHexInput'),
  bt: document.getElementById('bt'),
  bcIndex: document.getElementById('bcIndex'),
  bcHexPicker: document.getElementById('bcHexPicker'),
  bcHexInput: document.getElementById('bcHexInput'),
  et: document.getElementById('et'),
  ecIndex: document.getElementById('ecIndex'),
  ecHexPicker: document.getElementById('ecHexPicker'),
  ecHexInput: document.getElementById('ecHexInput'),
  lids: document.getElementById('lids'),
  expression: document.getElementById('expression'),
  proboscis: document.getElementById('proboscis'),
  at: document.getElementById('at'),
  acIndex: document.getElementById('acIndex'),
  acHexPicker: document.getElementById('acHexPicker'),
  acHexInput: document.getElementById('acHexInput'),
  lcIndex: document.getElementById('lcIndex'),
  lcHexPicker: document.getElementById('lcHexPicker'),
  lcHexInput: document.getElementById('lcHexInput'),
  lt: document.getElementById('lt'),
  hatId: document.getElementById('hatId')
};

const COLOUR_CONTROL_CONFIG = [
  { key: 'hcIndex', picker: 'hcHexPicker', input: 'hcHexInput', paletteNumber: 1 },
  { key: 'bcIndex', picker: 'bcHexPicker', input: 'bcHexInput', paletteNumber: 1 },
  { key: 'ecIndex', picker: 'ecHexPicker', input: 'ecHexInput', paletteNumber: 2 },
  { key: 'acIndex', picker: 'acHexPicker', input: 'acHexInput', paletteNumber: 1 },
  { key: 'lcIndex', picker: 'lcHexPicker', input: 'lcHexInput', paletteNumber: 1 }
];


function makeOptions(select, items) {
  select.innerHTML = items.map((item) => `<option value="${item.value}">${item.value} · ${item.name}</option>`).join('');
}

function syncColourInputsFromState() {
  COLOUR_CONTROL_CONFIG.forEach(({ key, picker, input, paletteNumber }) => {
    const hex = colourFromIndex(paletteNumber, state[key]);
    els[picker].value = hex;
    els[input].value = hex;
    els[input].dataset.paletteIndex = String(state[key]);
  });
}

function applyColourHexToState(key, paletteNumber, hex) {
  const normalised = normaliseHex(hex);
  if (!normalised) return false;
  state = {
    ...state,
    [key]: findNearestPaletteIndex(paletteNumber, normalised)
  };
  return true;
}

function bindColourControls() {
  COLOUR_CONTROL_CONFIG.forEach(({ key, picker, input, paletteNumber }) => {
    els[picker].addEventListener('input', () => {
      if (applyColourHexToState(key, paletteNumber, els[picker].value)) {
        render();
      }
    });

    els[input].addEventListener('input', () => {
      const maybeHex = normaliseHex(els[input].value);
      if (!maybeHex) return;
      if (applyColourHexToState(key, paletteNumber, maybeHex)) {
        render();
      }
    });

    els[input].addEventListener('blur', () => {
      syncColourInputsFromState();
    });
  });
}

function ensureValueOption(select, items, value) {
  if (!items.some((item) => item.value === value)) {
    const fallback = document.createElement('option');
    fallback.value = String(value);
    fallback.textContent = `${value} · Custom imported value`;
    fallback.dataset.custom = '1';
    select.prepend(fallback);
  }
}

function syncControlsFromState() {
  const valueMaps = [
    [els.ht, HEAD_SHAPES, state.ht],
    [els.hcIndex, HEAD_COLOURS, state.hcIndex],
    [els.bt, BODY_SHAPES, state.bt],
    [els.bcIndex, BODY_COLOURS, state.bcIndex],
    [els.et, EYE_TYPES, state.et],
    [els.ecIndex, EYE_COLOURS, state.ecIndex],
    [els.at, ANTENNA_TYPES, state.at],
    [els.acIndex, ANTENNA_COLOURS, state.acIndex],
    [els.lcIndex, LIMB_COLOURS, state.lcIndex],
    [els.lt, LEG_TYPES, state.lt],
    [els.expression, EXPRESSION_TYPES, state.expression],
    [els.proboscis, PROBOSCIS_TYPES, state.proboscis],
    [els.hatId, HAT_TYPES, state.hatId]
  ];
  valueMaps.forEach(([select, items, value]) => ensureValueOption(select, items, value));
  els.ht.value = String(state.ht);
  els.hcIndex.value = String(state.hcIndex);
  els.bt.value = String(state.bt);
  els.bcIndex.value = String(state.bcIndex);
  els.et.value = String(state.et);
  els.ecIndex.value = String(state.ecIndex);
  els.lids.value = String(state.lids);
  els.expression.value = String(state.expression);
  els.proboscis.value = String(state.proboscis);
  els.at.value = String(state.at);
  els.acIndex.value = String(state.acIndex);
  els.lcIndex.value = String(state.lcIndex);
  els.lt.value = String(state.lt);
  els.hatId.value = String(state.hatId);
  els.preferredRenderer.value = state.preferredRenderer;
  els.previewTurn.value = String(state.previewTurn ?? 0);
  syncColourInputsFromState();
}

function syncReadouts() {
  const record = stateToAvatarRecord(state);
  const compact = formatCompactWeevilDef(state);
  els.compactDefInput.value = compact;
  els.legacyDefInput.value = recordToLegacyDemoDef(record);
  els.currentCompactDef.textContent = compact;
  els.currentHatLabel.textContent = optionLabel(HAT_TYPES, state.hatId);
  const viewLabel = viewLabelFromTurn(state.previewTurn);
  els.previewTurnLabel.textContent = viewLabel;
  els.currentViewLabel.textContent = viewLabel;
  els.payloadPreview.textContent = JSON.stringify(record, null, 2);
}

function collectStateFromControls() {
  state = {
    ...state,
    ht: clampInt(els.ht.value, 1, 4),
    hcIndex: clampInt(els.hcIndex.value, 0, HEAD_COLOURS.length - 1),
    bt: clampInt(els.bt.value, 1, 4),
    bcIndex: clampInt(els.bcIndex.value, 0, BODY_COLOURS.length - 1),
    et: clampInt(els.et.value, 1, 6),
    ecIndex: clampInt(els.ecIndex.value, 0, EYE_COLOURS.length - 1),
    lids: clampInt(els.lids.value, 0, 1),
    expression: clampInt(els.expression.value, 0, 6),
    proboscis: clampInt(els.proboscis.value, 0, 4),
    at: clampInt(els.at.value, 0, 99),
    acIndex: clampInt(els.acIndex.value, 0, ANTENNA_COLOURS.length - 1),
    lcIndex: clampInt(els.lcIndex.value, 0, LIMB_COLOURS.length - 1),
    lt: clampInt(els.lt.value, 0, 99),
    hatId: clampInt(els.hatId.value, 0, 12),
    preferredRenderer: els.preferredRenderer.value === 'pixi' ? 'pixi' : 'svg',
    previewTurn: clampRange(els.previewTurn.value, -60, 60)
  };
}

async function render() {
  syncControlsFromState();
  syncReadouts();
  renderSvgInto(els.referenceMount, state, { mini: true });

  if (typeof activePixiCleanup === 'function') {
    activePixiCleanup();
    activePixiCleanup = null;
  }

  if (state.preferredRenderer === 'pixi') {
    try {
      activePixiCleanup = await renderPixiInto(els.weevilMount, state, {});
      els.rendererStatus.textContent = 'Pixi enhancement active. SVG remains the source pose.';
      return;
    } catch (error) {
      renderSvgInto(els.weevilMount, state, {});
      els.rendererStatus.textContent = 'Pixi enhancement failed, so the editor fell back to stable SVG.';
      console.warn('Pixi renderer failed, falling back to SVG.', error);
      return;
    }
  }

  renderSvgInto(els.weevilMount, state, {});
  els.rendererStatus.textContent = 'Stable SVG renderer active.';
}

function randomize() {
  state = {
    ...state,
    ht: 1 + Math.floor(Math.random() * 4),
    hcIndex: Math.floor(Math.random() * HEAD_COLOURS.length),
    bt: 1 + Math.floor(Math.random() * 4),
    bcIndex: Math.floor(Math.random() * BODY_COLOURS.length),
    et: 1 + Math.floor(Math.random() * 6),
    ecIndex: Math.floor(Math.random() * EYE_COLOURS.length),
    lids: Math.floor(Math.random() * 2),
    expression: Math.floor(Math.random() * 7),
    proboscis: Math.floor(Math.random() * 5),
    at: Math.floor(Math.random() * 17),
    acIndex: Math.floor(Math.random() * ANTENNA_COLOURS.length),
    lcIndex: Math.floor(Math.random() * LIMB_COLOURS.length),
    lt: Math.floor(Math.random() * 2),
    hatId: Math.floor(Math.random() * 13)
  };
  render();
}

function applyRecord(record) {
  state = {
    ...avatarRecordToState(normaliseAvatarRecord(record)),
    previewTurn: clampRange(record.previewTurn ?? state.previewTurn ?? 0, -60, 60)
  };
  render();
}

function download(filename, content, type) {
  const blob = new Blob([content], { type });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = filename;
  document.body.appendChild(anchor);
  anchor.click();
  anchor.remove();
  URL.revokeObjectURL(url);
}

async function downloadPng() {
  const svgMarkup = buildWeevilSvg(state);
  const blob = new Blob([svgMarkup], { type: 'image/svg+xml;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const img = new Image();
  img.onload = () => {
    const canvas = document.createElement('canvas');
    canvas.width = 960;
    canvas.height = 1280;
    const ctx = canvas.getContext('2d');
    const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
    gradient.addColorStop(0, '#16305d');
    gradient.addColorStop(1, '#0c1630');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(img, 90, 70, 780, 1040);
    canvas.toBlob((pngBlob) => {
      if (!pngBlob) return;
      const pngUrl = URL.createObjectURL(pngBlob);
      const anchor = document.createElement('a');
      anchor.href = pngUrl;
      anchor.download = `weevil-${formatCompactWeevilDef(state)}.png`;
      document.body.appendChild(anchor);
      anchor.click();
      anchor.remove();
      URL.revokeObjectURL(pngUrl);
      URL.revokeObjectURL(url);
    }, 'image/png');
  };
  img.src = url;
}

async function copyText(value) {
  try {
    await navigator.clipboard.writeText(value);
  } catch {
    const helper = document.createElement('textarea');
    helper.value = value;
    document.body.appendChild(helper);
    helper.select();
    document.execCommand('copy');
    helper.remove();
  }
}

async function saveAvatar(options = {}) {
  const { redirectAfterSave = false } = options;
  const payload = stateToAvatarRecord(state);
  const body = new URLSearchParams(payload);

  if (location.protocol === 'file:') {
    els.saveStatus.textContent = 'Save to profile only works inside the mirror site/server build. Use Download SVG or PNG in the standalone demo.';
    return false;
  }

  els.saveStatus.textContent = redirectAfterSave ? 'Saving your weevil, then opening the chat room...' : 'Saving to mirror profile...';
  const response = await fetch('/api/me/avatar', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
    body
  });
  const data = await response.json().catch(() => ({ ok: false, error: 'Unexpected response.' }));
  if (!response.ok || !data.ok) {
    els.saveStatus.textContent = data.error || 'Save failed.';
    return false;
  }
  els.saveStatus.textContent = redirectAfterSave ? 'Saved. Opening the chat room...' : 'Saved to your mirror profile.';
  root.dataset.avatarRecord = serialiseForDataset(payload);
  root.dataset.avatarConfigured = '1';
  if (redirectAfterSave) {
    const divider = afterSavePath.includes('?') ? '&' : '?';
    window.location.href = `${afterSavePath}${divider}message=${encodeURIComponent('Weevil saved. You are ready for the room.')}`;
  }
  return true;
}

function bindEvents() {
  [
    els.preferredRenderer,
    els.ht,
    els.hcIndex,
    els.bt,
    els.bcIndex,
    els.et,
    els.ecIndex,
    els.lids,
    els.expression,
    els.proboscis,
    els.at,
    els.acIndex,
    els.lcIndex,
    els.lt,
    els.hatId
  ].forEach((element) => {
    element.addEventListener('change', () => {
      collectStateFromControls();
      render();
    });
  });

  els.previewTurn.addEventListener('input', () => {
    collectStateFromControls();
    render();
  });

  bindColourControls();

  document.getElementById('applyCompact').addEventListener('click', () => {
    const parsed = parseCompactWeevilDef(els.compactDefInput.value);
    if (!parsed) {
      els.saveStatus.textContent = 'Compact WeevilDef must be 18 digits.';
      return;
    }
    applyRecord({ ...stateToAvatarRecord(state), weevilDef: els.compactDefInput.value.trim(), previewTurn: state.previewTurn });
    els.saveStatus.textContent = 'Compact definition applied.';
  });

  document.getElementById('copyCompact').addEventListener('click', () => copyText(formatCompactWeevilDef(state)));
  document.getElementById('applyLegacy').addEventListener('click', () => {
    const parsed = parseLegacyDemoDef(els.legacyDefInput.value);
    if (!parsed) {
      els.saveStatus.textContent = 'Legacy demo string must be seven comma-separated numbers.';
      return;
    }
    applyRecord({ ...parsed, previewTurn: state.previewTurn });
    els.saveStatus.textContent = 'Legacy demo string applied through the compatibility bridge.';
  });
  document.getElementById('copyLegacy').addEventListener('click', () => copyText(recordToLegacyDemoDef(stateToAvatarRecord(state))));
  document.getElementById('randomize').addEventListener('click', randomize);
  document.getElementById('reset').addEventListener('click', () => applyRecord({ previewTurn: state.previewTurn }));
  document.getElementById('presetClassic').addEventListener('click', () => applyRecord({ weevilDef: '101132129001323200', expression: 0, proboscis: 0, hatId: 0, preferredRenderer: state.preferredRenderer, previewTurn: state.previewTurn }));
  document.getElementById('presetBoxy').addEventListener('click', () => applyRecord({ weevilDef: '401135129001323200', expression: 0, proboscis: 0, hatId: 0, preferredRenderer: state.preferredRenderer, previewTurn: state.previewTurn }));
  document.getElementById('presetRoyal').addEventListener('click', () => applyRecord({ weevilDef: '443431510843434301', expression: 3, proboscis: 2, hatId: 3, preferredRenderer: state.preferredRenderer, previewTurn: state.previewTurn }));
  document.getElementById('saveAvatar').addEventListener('click', saveAvatar);
  els.saveAndContinue?.addEventListener('click', () => saveAvatar({ redirectAfterSave: true }));
  document.getElementById('downloadSvg').addEventListener('click', () => download(`weevil-${formatCompactWeevilDef(state)}.svg`, buildWeevilSvg(state), 'image/svg+xml;charset=utf-8'));
  document.getElementById('downloadPng').addEventListener('click', downloadPng);
}

function init() {
  makeOptions(els.preferredRenderer, [
    { value: 'svg', name: 'Stable SVG base' },
    { value: 'pixi', name: 'Pixi enhancement layer' }
  ]);
  makeOptions(els.ht, HEAD_SHAPES);
  makeOptions(els.hcIndex, HEAD_COLOURS);
  makeOptions(els.bt, BODY_SHAPES);
  makeOptions(els.bcIndex, BODY_COLOURS);
  makeOptions(els.et, EYE_TYPES);
  makeOptions(els.ecIndex, EYE_COLOURS);
  makeOptions(els.lids, [
    { value: 0, name: 'Off' },
    { value: 1, name: 'On' }
  ]);
  makeOptions(els.expression, EXPRESSION_TYPES);
  makeOptions(els.proboscis, PROBOSCIS_TYPES);
  makeOptions(els.at, ANTENNA_TYPES);
  makeOptions(els.acIndex, ANTENNA_COLOURS);
  makeOptions(els.lcIndex, LIMB_COLOURS);
  makeOptions(els.lt, LEG_TYPES);
  makeOptions(els.hatId, HAT_TYPES);
  if (els.saveAndContinue) {
    els.saveAndContinue.textContent = afterSavePath === '/room' ? 'Save and enter chat room' : 'Save and continue';
  }
  els.saveStatus.textContent = root.dataset.avatarConfigured === '1'
    ? 'Avatar already saved on your mirror profile. You can tweak it again or jump straight into the room.'
    : 'Save once here to finish your room-ready mirror avatar.';
  bindEvents();
  syncColourInputsFromState();
  render();
}

init();


})();
