import { WeevilDef } from './WeevilDef.js';
import { createPoseState } from './WeevilPose.js';
import {
  WEEVIL_DRAW_ORDER,
  getAntennaName,
  getBodyVisual,
  getEyePosition,
  getEyeVisual,
  getHeadVisual,
  getLegName,
  getLegVisual,
  getMouthVisual,
  getYawDerivedValues
} from './WeevilVisualConfig.js';

export function createWeevilRenderPlan(rawDef, options = {}) {
  const definition = rawDef instanceof WeevilDef ? rawDef : new WeevilDef(rawDef);
  const decoded = definition.toJSON();
  const pose = createPoseState({
    ps: options.pose ?? options.ps ?? 0,
    ex: options.expression ?? options.ex ?? 0,
    r: options.rotation ?? options.r ?? 0
  });
  const yaw = Number(options.yaw ?? pose.rotation ?? 0);
  const yawDerived = getYawDerivedValues(yaw);
  const bodyVisual = getBodyVisual(decoded.bodyType);
  const headVisual = getHeadVisual(decoded.headType);
  const eyeVisual = getEyeVisual(decoded.eyeType);
  const eyePosition = getEyePosition(decoded.headType, decoded.eyeType);
  const mouthVisual = getMouthVisual(pose.expression);
  const legVisual = getLegVisual(decoded.legType);

  return {
    source: {
      rawDef: decoded.raw,
      expression: pose.expression,
      pose: pose.ps,
      rotation: pose.rotation,
      yaw,
      status: 'prototype-derived-plan'
    },
    validation: WeevilDef.validate(decoded.raw),
    pose,
    yaw: yawDerived,
    visuals: {
      body: bodyVisual,
      head: headVisual,
      eyes: {
        ...eyeVisual,
        position: eyePosition
      },
      mouth: mouthVisual,
      antennae: {
        name: getAntennaName(decoded.antennaType)
      },
      legs: {
        ...legVisual,
        name: getLegName(decoded.legType)
      }
    },
    parts: {
      body: {
        type: decoded.bodyType,
        atlas: bodyVisual.atlas,
        colour: decoded.colours.body,
        visual: bodyVisual
      },
      head: {
        type: decoded.headType,
        atlas: headVisual.atlas,
        colour: decoded.colours.head,
        visual: headVisual
      },
      eyes: {
        type: decoded.eyeType,
        atlasSet: eyeVisual.set,
        colour: decoded.colours.eyes,
        lids: decoded.lids,
        visual: eyeVisual,
        position: eyePosition
      },
      mouth: {
        expression: pose.expression,
        atlas: mouthVisual.atlas,
        visual: mouthVisual
      },
      antennae: {
        type: decoded.antennaType,
        name: getAntennaName(decoded.antennaType),
        colour: decoded.colours.antennae
      },
      legs: {
        type: decoded.legType,
        name: getLegName(decoded.legType),
        lowerFrame: legVisual.lowerFrame,
        colour: decoded.colours.legs,
        visual: legVisual
      }
    },
    order: WEEVIL_DRAW_ORDER
  };
}
