import { WeevilDef } from './WeevilDef.js';
import {
  getBodyAtlas,
  getEyeAtlasSet,
  getHeadAtlas,
  getLowerLegFrame,
  getMouthAtlas
} from './WeevilPartMap.js';

export function createWeevilRenderPlan(rawDef, options = {}) {
  const definition = rawDef instanceof WeevilDef ? rawDef : new WeevilDef(rawDef);
  const decoded = definition.toJSON();
  const expression = Number(options.expression ?? 0);

  return {
    source: {
      rawDef: decoded.raw,
      expression,
      status: 'prototype-derived-plan'
    },
    validation: WeevilDef.validate(decoded.raw),
    parts: {
      body: {
        type: decoded.bodyType,
        atlas: getBodyAtlas(decoded.bodyType),
        colour: decoded.colours.body
      },
      head: {
        type: decoded.headType,
        atlas: getHeadAtlas(decoded.headType),
        colour: decoded.colours.head
      },
      eyes: {
        type: decoded.eyeType,
        atlasSet: getEyeAtlasSet(decoded.eyeType),
        colour: decoded.colours.eyes,
        lids: decoded.lids
      },
      mouth: {
        expression,
        atlas: getMouthAtlas(expression)
      },
      antennae: {
        type: decoded.antennaType,
        colour: decoded.colours.antennae
      },
      legs: {
        type: decoded.legType,
        lowerFrame: getLowerLegFrame(decoded.legType),
        colour: decoded.colours.legs
      }
    },
    // This is a high-level order only. Exact draw order/coordinates still need
    // to be ported from the audited canvas renderer.
    order: [
      'legs.back',
      'body',
      'head',
      'eyes.whites',
      'eyes.irises',
      'eyes.lids',
      'mouth',
      'antennae',
      'legs.front'
    ]
  };
}
