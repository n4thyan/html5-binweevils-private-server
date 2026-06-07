import { RUMS_COVE_MAJOR_VISUAL_CANDIDATES } from './RumsCoveCandidateRoleMap.js';

export const RUMS_COVE_SVG_METADATA_TARGETS = Object.freeze(
  RUMS_COVE_MAJOR_VISUAL_CANDIDATES.map((candidate) => Object.freeze({
    key: candidate.key,
    className: candidate.className,
    symbolId: candidate.symbolId,
    svgPath: candidate.spritePath
  }))
);

export function inspectSvgMetadata(path, svgText) {
  const text = String(svgText || '');
  const rootTag = text.match(/<svg\b[^>]*>/i)?.[0] || '';
  const width = attr(rootTag, 'width');
  const height = attr(rootTag, 'height');
  const viewBox = attr(rootTag, 'viewBox');
  const transformCount = (text.match(/\btransform=/g) || []).length;
  const imageCount = (text.match(/<image\b/gi) || []).length;
  const pathCount = (text.match(/<path\b/gi) || []).length;
  const useCount = (text.match(/<use\b/gi) || []).length;
  const groupCount = (text.match(/<g\b/gi) || []).length;
  const clipPathCount = (text.match(/<clipPath\b/gi) || []).length;
  const maskCount = (text.match(/<mask\b/gi) || []).length;
  const transforms = [...text.matchAll(/transform="([^"]+)"/g)].map((match) => match[1]).slice(0, 20);

  return Object.freeze({
    path,
    width,
    height,
    viewBox,
    transformCount,
    imageCount,
    pathCount,
    useCount,
    groupCount,
    clipPathCount,
    maskCount,
    sampleTransforms: Object.freeze(transforms)
  });
}

export function formatSvgMetadata(metadata) {
  const lines = [];
  lines.push(`--- ${metadata.path} ---`);
  lines.push(`width: ${metadata.width || '(none)'}`);
  lines.push(`height: ${metadata.height || '(none)'}`);
  lines.push(`viewBox: ${metadata.viewBox || '(none)'}`);
  lines.push(`groups: ${metadata.groupCount}`);
  lines.push(`paths: ${metadata.pathCount}`);
  lines.push(`uses: ${metadata.useCount}`);
  lines.push(`images: ${metadata.imageCount}`);
  lines.push(`transforms: ${metadata.transformCount}`);
  lines.push(`clipPaths: ${metadata.clipPathCount}`);
  lines.push(`masks: ${metadata.maskCount}`);
  lines.push('sampleTransforms:');
  if (metadata.sampleTransforms.length === 0) {
    lines.push('  (none)');
  } else {
    for (const transform of metadata.sampleTransforms) {
      lines.push(`  ${transform}`);
    }
  }
  return lines.join('\n');
}

export function getRumsCoveSvgMetadataAuditSummary() {
  return Object.freeze({
    targetCount: RUMS_COVE_SVG_METADATA_TARGETS.length,
    nextAction: 'run-local-svg-metadata-audit'
  });
}

function attr(tag, name) {
  const match = tag.match(new RegExp(`${name}="([^"]+)"`, 'i'));
  return match?.[1] || '';
}
