import {
  colourFromIndex,
  darken,
  lighten,
  clampInt
} from './shared.js';

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
  const cuboidBoost = headType === 4 ? 1.06 : 1;
  const presets = {
    1: { leftX: 238, rightX: 384, y: 168, r: 64 * cuboidBoost, iris: 24, browLift: 0 },
    2: { leftX: 242, rightX: 378, y: 178, r: 58 * cuboidBoost, iris: 22, browLift: 8 },
    3: { leftX: 228, rightX: 392, y: 176, r: 62 * cuboidBoost, iris: 22, browLift: 4 },
    4: { leftX: 246, rightX: 376, y: 180, r: 54 * cuboidBoost, iris: 20, browLift: 10 },
    5: { leftX: 232, rightX: 388, y: 160, r: 68 * cuboidBoost, iris: 25, browLift: -2 },
    6: { leftX: 220, rightX: 400, y: 170, r: 58 * cuboidBoost, iris: 22, browLift: 2 }
  };
  return presets[type] || presets[1];
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

function clampRange(value, min, max) {
  const n = Number(value);
  if (Number.isNaN(n)) return min;
  return Math.min(max, Math.max(min, n));
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

function safeId(value, fallback = 'weevil') {
  const cleaned = String(value || '').trim().replace(/[^a-zA-Z0-9_-]+/g, '-');
  return cleaned || fallback;
}

function drawLegGroup(state, outline, view = previewMetrics(0), idPrefix = 'weevil') {
  const base = colourFromIndex(1, state.lcIndex);
  const shade = darken(base, 0.25);
  const style = legStyleForType(state.lt, base);
  const patternId = `${safeId(idPrefix)}-legPattern`;
  const stripyClass = style ? `
    <pattern id="${patternId}" width="30" height="30" patternUnits="userSpaceOnUse" patternTransform="rotate(18)">
      <rect width="30" height="30" fill="${base}"/>
      <rect width="10" height="30" x="0" fill="${style[0]}"/>
      <rect width="10" height="30" x="10" fill="${style[1]}"/>
      <rect width="10" height="30" x="20" fill="${style[2]}"/>
    </pattern>` : '';
  const fill = style ? `url(#${patternId})` : base;
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

export function buildWeevilSvg(state, options = {}) {
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
  const view = previewMetrics(options.previewTurn ?? state.previewTurn ?? 0);
  const uid = safeId(options.idPrefix || `weevil-${Math.round(view.turn)}`);
  const filterId = `${uid}-softShadow`;
  const clipId = `${uid}-headFaceClip`;
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
      <filter id="${filterId}" x="-30%" y="-30%" width="160%" height="160%">
        <feDropShadow dx="0" dy="16" stdDeviation="20" flood-color="rgba(0,0,0,.25)"/>
      </filter>
      <clipPath id="${clipId}">
        <path d="${light}"/>
      </clipPath>
    </defs>
    <g filter="url(#${filterId})">
      <ellipse cx="320" cy="820" rx="146" ry="24" fill="rgba(0,0,0,.14)"/>
      <g transform="${bodyRigTransform}">
        ${drawLegGroup(state, outline, view, uid)}
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
        <g clip-path="url(#${clipId})">
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

export function renderSvgInto(container, state, options = {}) {
  const svg = buildWeevilSvg(state, options);
  container.innerHTML = svg;
  return svg;
}
