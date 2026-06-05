import { WeevilDef } from './WeevilDef.js';
import {
  getBodyAtlas,
  getEyeAtlasSet,
  getHeadAtlas,
  getLowerLegFrame,
  getMouthAtlas
} from './WeevilPartMap.js';
import { createPoseState } from './WeevilPose.js';

export function createWeevilRenderPlan(rawDef, options = {}) {
  const definition = rawDef instanceof WeevilDef ? rawDef : new WeevilDef(rawDef);
  const decoded = definition.toJSON();
  const pose = createPoseState({
    ps: options.pose ?? options.ps ?? 0,
    ex: options.expression ?? options.ex ?? 0,
    r: options.rotation ?? options.r ?? 0
  });

  return {
    source: {
      rawDef: decoded.raw,
      expression: pose.expression,
      pose: pose.ps,
      rotation: pose.rotation,
      status: 'prototype-derived-plan'
    },
    validation: WeevilDef.validate(decoded.raw),
    pose,
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
        expression: pose.expression,
        atlas: getMouthAtlas(pose.expression)
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
