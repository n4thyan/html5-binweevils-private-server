import {
  WEEVIL_PRIMARY_PALETTE,
  WEEVIL_SECONDARY_PALETTE,
  toHexColour
} from './WeevilPalette.js';

const DEF_LENGTH = 18;
const FORBIDDEN_FULL_DEFS = new Set([
  '000000000000000000',
  '322311313109222200',
  '322311313109172200'
]);

const FORBIDDEN_SHARED_COLOUR_VALUES = new Set([
  1184274
]);

export class WeevilDef {
  constructor(raw) {
    this.raw = String(raw ?? '');
    this.parts = WeevilDef.decode(this.raw);
  }

  static decode(raw) {
    const value = String(raw ?? '');

    return {
      raw: value,
      headType: numberAt(value, 0, 1),
      headColourIndex: numberAt(value, 1, 2),
      bodyType: numberAt(value, 3, 1),
      bodyColourIndex: numberAt(value, 4, 2),
      eyeType: numberAt(value, 6, 1),
      eyeColourIndex: numberAt(value, 7, 2),
      lids: numberAt(value, 9, 1),
      antennaType: numberAt(value, 10, 2),
      antennaColourIndex: numberAt(value, 12, 2),
      legColourIndex: numberAt(value, 14, 2),
      legType: numberAt(value, 16, 2)
    };
  }

  static validate(raw) {
    const value = String(raw ?? '');
    const errors = [];

    if (value.length !== DEF_LENGTH) {
      errors.push(`Expected ${DEF_LENGTH} digits.`);
    }

    if (!/^\d+$/.test(value)) {
      errors.push('Definition must contain digits only.');
    }

    if (FORBIDDEN_FULL_DEFS.has(value)) {
      errors.push('Definition is explicitly blocked by source rules.');
    }

    const decoded = WeevilDef.decode(value.padEnd(DEF_LENGTH, '0'));

    if (decoded.headType <= 0 || decoded.headType > 4) errors.push('Invalid head type.');
    if (decoded.bodyType <= 0 || decoded.bodyType > 4) errors.push('Invalid body type.');
    if (decoded.eyeType <= 0 || decoded.eyeType > 6) errors.push('Invalid eye type.');
    if (decoded.lids > 1) errors.push('Invalid lids value.');

    checkPaletteIndex(errors, 'head colour', decoded.headColourIndex, WEEVIL_PRIMARY_PALETTE);
    checkPaletteIndex(errors, 'body colour', decoded.bodyColourIndex, WEEVIL_PRIMARY_PALETTE);
    checkPaletteIndex(errors, 'eye colour', decoded.eyeColourIndex, WEEVIL_SECONDARY_PALETTE);
    checkPaletteIndex(errors, 'antenna colour', decoded.antennaColourIndex, WEEVIL_PRIMARY_PALETTE);
    checkPaletteIndex(errors, 'leg colour', decoded.legColourIndex, WEEVIL_PRIMARY_PALETTE);

    const colourValues = [
      WEEVIL_PRIMARY_PALETTE[decoded.headColourIndex],
      WEEVIL_PRIMARY_PALETTE[decoded.bodyColourIndex],
      WEEVIL_SECONDARY_PALETTE[decoded.eyeColourIndex],
      WEEVIL_PRIMARY_PALETTE[decoded.antennaColourIndex],
      WEEVIL_PRIMARY_PALETTE[decoded.legColourIndex]
    ].filter((value) => value !== undefined);

    for (const forbidden of FORBIDDEN_SHARED_COLOUR_VALUES) {
      const count = colourValues.filter((value) => value === forbidden).length;
      if (count > 1) {
        errors.push(`Forbidden repeated colour value: ${forbidden}.`);
      }
    }

    return {
      ok: errors.length === 0,
      errors,
      decoded
    };
  }

  toJSON() {
    return {
      ...this.parts,
      colours: {
        head: colourInfo(this.parts.headColourIndex, WEEVIL_PRIMARY_PALETTE),
        body: colourInfo(this.parts.bodyColourIndex, WEEVIL_PRIMARY_PALETTE),
        eyes: colourInfo(this.parts.eyeColourIndex, WEEVIL_SECONDARY_PALETTE),
        antennae: colourInfo(this.parts.antennaColourIndex, WEEVIL_PRIMARY_PALETTE),
        legs: colourInfo(this.parts.legColourIndex, WEEVIL_PRIMARY_PALETTE)
      }
    };
  }
}

function numberAt(value, start, length) {
  const slice = value.slice(start, start + length);
  return Number.parseInt(slice || '0', 10);
}

function checkPaletteIndex(errors, label, index, palette) {
  if (!Number.isInteger(index) || index < 0 || index >= palette.length) {
    errors.push(`Invalid ${label} index.`);
  }
}

function colourInfo(index, palette) {
  const value = palette[index];
  return {
    index,
    value,
    hex: value === undefined ? null : toHexColour(value)
  };
}
