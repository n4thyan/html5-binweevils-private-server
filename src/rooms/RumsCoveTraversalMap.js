// Traversal targets for the RumsCove playable-shell milestone.
//
// This deliberately separates source-backed exterior room placement from the
// next demo goal: moving between the Rums exterior and the video pod scene.
// videoPod1_10_05_12 is treated as a room-like VOD/external-UI scene, not as a
// normal LocFixedCam roomBG entry unless later source files prove otherwise.

export const RUMS_COVE_TRAVERSAL_SCOPE = Object.freeze({
  currentRoom: 'RumsCove',
  currentLocId: 129,
  targetDemo: 'exterior-to-video-pod-traversal',
  sourcePlacement: 'JPEXS XML + source SVG sprites',
  useManualPlacementAsFinal: false
});

export const RUMS_COVE_TRAVERSAL_TARGETS = Object.freeze([
  Object.freeze({
    key: 'videoPodDoor',
    sourceInstanceName: 'door7_mc',
    sourceDepth: 564,
    sourceCharacterId: 281,
    type: 'scene-transition',
    fromScene: 'rums-cove-exterior',
    toScene: 'videoPod1_10_05_12',
    status: 'next-demo-target',
    note: 'Pod entrance traversal target. Use as the first clickable room switch.'
  }),
  Object.freeze({
    key: 'leftYellowArrow',
    sourceInstanceName: 'door1_mc',
    type: 'deferred-exit-marker',
    fromScene: 'rums-cove-exterior',
    toScene: 'unknown-source-loc',
    status: 'visual-arrow-first-navigation-later',
    note: 'Restore as a visual exit marker first; destination can be mapped later.'
  }),
  Object.freeze({
    key: 'rightYellowArrow',
    sourceInstanceName: 'door2_mc',
    type: 'deferred-exit-marker',
    fromScene: 'rums-cove-exterior',
    toScene: 'unknown-source-loc',
    status: 'visual-arrow-first-navigation-later',
    note: 'Restore as a visual exit marker first; destination can be mapped later.'
  })
]);

export const VIDEO_POD_SCENE_TARGET = Object.freeze({
  key: 'videoPod1_10_05_12',
  sceneType: 'external-ui-room-like-scene',
  normalLocFixedCamRoom: false,
  knownExport: 'videoPod1_10_05_12',
  usefulChildren: Object.freeze([
    'floorClickArea_btn',
    'door1_mc',
    'screen_mc',
    'blankScreen_spr',
    'seat1_btn',
    'seat2_btn',
    'seat3_btn',
    'seat4_btn'
  ]),
  firstPassFloorBoundary: Object.freeze([-200, 100, 400, 300]),
  firstPassBehaviour: 'stub video/VOD media, preserve room-like walking and exit behaviour'
});

export const RUMS_COVE_PLAYABLE_DEMO_ORDER = Object.freeze([
  'source-backed-rums-exterior-render',
  'slime-shell-viewport-wrapper',
  'local-weevil-entry-render',
  'click-to-move-basic-walk',
  'pod-door-hit-test',
  'switch-to-video-pod-scene',
  'restore-yellow-arrow-visuals',
  'map-real-arrow-destinations-later'
]);

export function getRumsCoveTraversalSummary() {
  return Object.freeze({
    currentRoom: RUMS_COVE_TRAVERSAL_SCOPE.currentRoom,
    currentLocId: RUMS_COVE_TRAVERSAL_SCOPE.currentLocId,
    targetCount: RUMS_COVE_TRAVERSAL_TARGETS.length,
    primaryTarget: RUMS_COVE_TRAVERSAL_TARGETS[0].key,
    videoPodSceneType: VIDEO_POD_SCENE_TARGET.sceneType,
    nextAction: RUMS_COVE_PLAYABLE_DEMO_ORDER[1]
  });
}
