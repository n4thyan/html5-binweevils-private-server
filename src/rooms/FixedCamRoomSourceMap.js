// Source-backed map for first FixedCamera room audit.
//
// This does not render a room yet. It captures the original LocFactory/Loc/
// LocFixedCam fields and behaviour that the HTML5 fixed-room port must follow.

export const LOC_FACTORY_SOURCE = 'reference/decompiled-dumpassets/dumpassets/core5.swf/scripts/com/binweevils/engine3D/visuals/LocFactory.as';
export const LOC_SOURCE = 'reference/decompiled-dumpassets/dumpassets/core5.swf/scripts/com/binweevils/engine3D/visuals/Loc.as';
export const LOC_FIXED_CAM_SOURCE = 'reference/decompiled-dumpassets/dumpassets/core5.swf/scripts/com/binweevils/engine3D/visuals/LocFixedCam.as';

export const LOC_TYPE_IDS = Object.freeze({
  STANDARD: 1,
  FIXEDCAM: 2,
  NEST: 3
});

export const FIXED_CAM_REQUIRED_LOC_ATTRIBUTES = Object.freeze([
  'id',
  'name',
  'type',
  'weevilScale',
  'camPos',
  'camAim',
  'entryPos',
  'entryDir',
  'boundType',
  'boundary'
]);

export const FIXED_CAM_OPTIONAL_LOC_ATTRIBUTES = Object.freeze([
  'inventory',
  'playList',
  'clickAnywhere',
  'slippery',
  'upSideDown',
  'specialColours',
  'maintainY',
  'roomEvents',
  'timerID',
  'noZoom'
]);

export const FIXED_CAM_XML_CHILD_GROUPS = Object.freeze({
  fixedCamSpecific: Object.freeze([
    'object',
    'target',
    'character'
  ]),
  shared: Object.freeze([
    'GUI',
    'door',
    'cta',
    'timeTrial',
    'interactive',
    'anim',
    'noGoArea',
    'walkMask'
  ]),
  assetInfo: Object.freeze('Any remaining child nodes become AssetLoader entries via addAssetInfo.')
});

export const FIXED_CAM_LAYER_MODEL = Object.freeze([
  Object.freeze({ name: 'bgHolder_spr', owner: 'Loc', purpose: 'background visuals and bg assets' }),
  Object.freeze({ name: 'content_spr', owner: 'Loc', purpose: 'weevils, pets, fixed objects, dynamic objects and depth-managed visuals' }),
  Object.freeze({ name: 'GUI_spr', owner: 'Loc', purpose: 'room-specific GUI overlays' })
]);

export const FIXED_CAM_RUNTIME_OBJECTS = Object.freeze([
  Object.freeze({ field: 'bg_spr', source: 'LocFixedCam', purpose: 'loaded fixed-camera room movieclip/background sprite' }),
  Object.freeze({ field: 'floorClickArea', source: 'LocFixedCam', purpose: 'click target returned by getClickable() for room movement' }),
  Object.freeze({ field: 'doorsContainer_spr', source: 'LocFixedCam', purpose: 'door/transition hit regions' }),
  Object.freeze({ field: 'objectList', source: 'LocFixedCam.setObjects()', purpose: 'XML object nodes converted to FixedAsset or game slots' }),
  Object.freeze({ field: 'targetList', source: 'LocFixedCam.setTargets()', purpose: 'target/projectile/gameplay nodes' }),
  Object.freeze({ field: 'characterList', source: 'LocFixedCam.setCharacters()', purpose: 'room NPC/character nodes' }),
  Object.freeze({ field: 'walkMasks', source: 'Loc.createWalkMasks()/LocFixedCam.createWalkMasks()', purpose: 'mask MovieClips that restrict valid walking area' }),
  Object.freeze({ field: 'noGos', source: 'Loc.createNoGoAreas()', purpose: 'rect/radius forbidden areas from XML' }),
  Object.freeze({ field: 'ctas', source: 'LocFixedCam.createCtas()', purpose: 'click-to-action triggers from XML' }),
  Object.freeze({ field: 'interactives', source: 'LocFixedCam.createInteractives()', purpose: 'interactive regions resolved through nested path names' }),
  Object.freeze({ field: 'anims', source: 'LocFixedCam.createAnims()', purpose: 'background animation MovieClips driven by timer' })
]);

export const FIXED_CAM_PORT_ORDER = Object.freeze([
  Object.freeze({ id: 'parse-loc-definition', source: 'LocFactory.createLoc', summary: 'Read loc XML attributes and assert type == 2.' }),
  Object.freeze({ id: 'create-layer-model', source: 'Loc constructor', summary: 'Create bgHolder/content/GUI layer equivalents.' }),
  Object.freeze({ id: 'load-room-assets', source: 'Loc.addAssetInfo / Loc.loadManager', summary: 'Load child asset nodes not consumed as doors/objects/etc.' }),
  Object.freeze({ id: 'attach-bg-sprite', source: 'LocFixedCam', summary: 'Resolve the loaded room background/symbol as bg_spr.' }),
  Object.freeze({ id: 'resolve-floor-click-area', source: 'LocFixedCam.getClickable', summary: 'Use the room floorClickArea, not the entire stage, for movement clicks.' }),
  Object.freeze({ id: 'create-objects', source: 'LocFixedCam.setupObjects', summary: 'Resolve XML object name to bg_spr child and wrap as FixedAsset.' }),
  Object.freeze({ id: 'create-doors', source: 'LocFixedCam.createDoors', summary: 'Resolve door{id}_mc and XML destination/entry data.' }),
  Object.freeze({ id: 'create-walk-masks', source: 'LocFixedCam.createWalkMasks', summary: 'Resolve walkMask XML names to bg_spr MovieClips.' }),
  Object.freeze({ id: 'create-no-go-areas', source: 'Loc.createNoGoAreas', summary: 'Create rect/radius forbidden movement areas from XML.' }),
  Object.freeze({ id: 'place-local-weevil', source: 'Loc.addWeevil', summary: 'Apply room weevilScale and add weevil to content layer.' }),
  Object.freeze({ id: 'depth-and-interaction', source: 'Loc visuals/dynams/interactives', summary: 'Sort/render dynamic visuals and trigger interactions.' })
]);

export function isFixedCamLocType(type) {
  return Number(type) === LOC_TYPE_IDS.FIXEDCAM;
}

export function summariseFixedCamRoomSourceMap() {
  return Object.freeze({
    sources: Object.freeze([LOC_FACTORY_SOURCE, LOC_SOURCE, LOC_FIXED_CAM_SOURCE]),
    locType: LOC_TYPE_IDS.FIXEDCAM,
    requiredAttributes: FIXED_CAM_REQUIRED_LOC_ATTRIBUTES.length,
    optionalAttributes: FIXED_CAM_OPTIONAL_LOC_ATTRIBUTES.length,
    fixedCamChildGroups: FIXED_CAM_XML_CHILD_GROUPS.fixedCamSpecific.length,
    sharedChildGroups: FIXED_CAM_XML_CHILD_GROUPS.shared.length,
    layers: FIXED_CAM_LAYER_MODEL.length,
    runtimeObjects: FIXED_CAM_RUNTIME_OBJECTS.length,
    portSteps: FIXED_CAM_PORT_ORDER.length,
    summary: FIXED_CAM_PORT_ORDER.map((step, index) => `${index + 1}. ${step.id}: ${step.source}`).join('\n')
  });
}
