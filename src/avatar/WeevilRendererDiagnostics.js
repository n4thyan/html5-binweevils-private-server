// Renderer diagnostics for the HTML5 weevil port.
//
// These helpers intentionally check the local avatar/render-plan contract only.
// They do not validate gameplay, rooms, networking, or backend behaviour.

export function validateRenderPlan(plan) {
  const issues = [];

  if (!plan) {
    return {
      ok: false,
      issues: ['missing render plan']
    };
  }

  requireValue(plan.source?.rawDef, 'source.rawDef', issues);
  requireValue(plan.validation, 'validation', issues);
  requireValue(plan.pose?.poseName, 'pose.poseName', issues);
  requireNumber(plan.pose?.expression, 'pose.expression', issues);
  requireNumber(plan.pose?.rotation, 'pose.rotation', issues);
  requireNumber(plan.yaw?.yawFactor, 'yaw.yawFactor', issues);
  requireNumber(plan.yaw?.faceCompress, 'yaw.faceCompress', issues);

  requirePart(plan.parts?.body, 'body', ['type', 'atlas', 'colour', 'visual'], issues);
  requirePart(plan.parts?.head, 'head', ['type', 'atlas', 'colour', 'visual'], issues);
  requirePart(plan.parts?.eyes, 'eyes', ['type', 'atlasSet', 'colour', 'lids', 'visual', 'position'], issues);
  requirePart(plan.parts?.mouth, 'mouth', ['expression', 'atlas', 'visual'], issues);
  requirePart(plan.parts?.antennae, 'antennae', ['type', 'name', 'colour'], issues);
  requirePart(plan.parts?.legs, 'legs', ['type', 'name', 'lowerFrame', 'colour', 'visual'], issues);

  return {
    ok: issues.length === 0,
    issues
  };
}

export function summariseRenderPlan(plan) {
  const diagnostics = validateRenderPlan(plan);

  if (!plan) {
    return {
      ok: false,
      summary: 'missing render plan',
      diagnostics
    };
  }

  return {
    ok: diagnostics.ok,
    summary: [
      `def=${plan.source?.rawDef ?? 'unknown'}`,
      `pose=${plan.pose?.poseName ?? 'unknown'}`,
      `ex=${plan.pose?.expression ?? 'unknown'}`,
      `r=${plan.pose?.rotation ?? 'unknown'}`,
      `body=${plan.parts?.body?.visual?.label ?? plan.parts?.body?.atlas ?? 'unknown'}`,
      `head=${plan.parts?.head?.visual?.label ?? plan.parts?.head?.atlas ?? 'unknown'}`,
      `eyes=${plan.parts?.eyes?.visual?.label ?? plan.parts?.eyes?.atlasSet ?? 'unknown'}`,
      `mouth=${plan.parts?.mouth?.atlas ?? 'unknown'}`,
      `antennae=${plan.parts?.antennae?.name ?? 'unknown'}`,
      `legs=${plan.parts?.legs?.name ?? 'unknown'}`
    ].join(' | '),
    diagnostics
  };
}

function requirePart(part, name, fields, issues) {
  if (!part) {
    issues.push(`missing parts.${name}`);
    return;
  }

  for (const field of fields) {
    if (!(field in part)) {
      issues.push(`missing parts.${name}.${field}`);
    }
  }
}

function requireValue(value, name, issues) {
  if (value === undefined || value === null || value === '') {
    issues.push(`missing ${name}`);
  }
}

function requireNumber(value, name, issues) {
  if (typeof value !== 'number' || Number.isNaN(value)) {
    issues.push(`invalid ${name}`);
  }
}
