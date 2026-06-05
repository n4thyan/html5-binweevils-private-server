// Source-backed HTML5 model of core5.swf/scripts/com/binweevils/Bin.as.
//
// This captures the Flash core client startup sequence after mainDEV661.swf
// calls core.init(...). It is not a backend, UI, room, or movement
// implementation yet.

export const CORE_SWF_SOURCE = 'reference/decompiled-dumpassets/dumpassets/core5.swf/scripts/com/binweevils/Bin.as';

export const CORE_CONSTRUCTOR_STEP_IDS = Object.freeze({
  SET_SINGLETONS: 'set-singletons',
  CREATE_WEBSOCKET_EVENT_MANAGERS: 'create-websocket-event-managers',
  BIND_SMARTFOX_EVENTS: 'bind-smartfox-events',
  CREATE_CAMERA_VIEWPORT: 'create-camera-viewport',
  ATTACH_VIEWPORT: 'attach-viewport',
  CAPTURE_HOLDERS: 'capture-ui-layer-holders',
  CREATE_FACTORIES: 'create-factories',
  CREATE_ARRAYS_TIMERS: 'create-arrays-and-timers',
  CREATE_UI: 'create-ui-main',
  SETUP_CAMERA_UI: 'setup-camera-ui',
  ADD_OVERLAY_LAYERS: 'add-overlay-layers',
  CREATE_TUTORIAL_MANAGER: 'create-tutorial-manager'
});

export const CORE_INIT_STEP_IDS = Object.freeze({
  GUARD_INITIALISED: 'guard-initialised',
  RESET_LOGOUT_TIMER: 'reset-logout-timer',
  STORE_LOADER_CALLBACKS: 'store-loader-callbacks',
  STORE_DEFAULT_LOC: 'store-default-loc',
  WIRE_UI_CLIENT_STATE: 'wire-ui-client-state',
  REQUEST_CHAT_STATE: 'request-chat-state',
  REQUEST_ZONE_TIME: 'request-zone-time',
  LOAD_WEEVIL_FACTORY: 'load-weevil-factory',
  CREATE_MY_WEEVIL: 'create-my-weevil',
  INIT_NESTS: 'init-nests',
  LOAD_LOCATION_DEFS: 'load-location-defs',
  LOAD_NEST_LOCATION_DEFS: 'load-nest-location-defs',
  LOAD_SCALED_WEEVILS: 'load-scaled-weevils',
  LOAD_WEEVIL_STATS: 'load-weevil-stats',
  LOAD_TREASURE_HUNT: 'load-treasure-hunt',
  LOAD_QUEST_DATA: 'load-quest-data',
  LOAD_MY_PETS: 'load-my-pets',
  LOAD_SPECIAL_MOVES: 'load-special-moves',
  LOAD_LOTTO_DATA: 'load-lotto-data',
  LOAD_SERVER_TIME: 'load-server-time',
  LOAD_EXTRA_FUNCTIONALITY: 'load-extra-functionality',
  CHECK_NEW_USERS: 'check-new-users',
  INIT_COMPLETE: 'init-complete'
});

export const CORE_CONSTRUCTOR_FLOW = Object.freeze([
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.SET_SINGLETONS,
    flashMethod: 'Bin()',
    summary: 'Store Bin singleton and expose Bin_extInterface.bin.'
  }),
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.CREATE_WEBSOCKET_EVENT_MANAGERS,
    flashMethod: 'Bin()',
    summary: 'Create WebSocketConnection, EventManager and SwrveManager references.'
  }),
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.BIND_SMARTFOX_EVENTS,
    flashMethod: 'Bin()',
    summary: 'Bind SmartFox public/moderator/room/user/extension/connection event handlers.'
  }),
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.CREATE_CAMERA_VIEWPORT,
    flashMethod: 'Bin()',
    summary: 'Create Cam3D(-138, 230, 248), aim at (157, 32, 582), and create ViewPort.'
  }),
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.ATTACH_VIEWPORT,
    flashMethod: 'Bin()',
    summary: 'Attach viewPort.display_spr to the lower content holder at index 0.'
  }),
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.CAPTURE_HOLDERS,
    flashMethod: 'Bin()',
    summary: 'Capture draggable, overlay, external UI and big-game holder sprites.'
  }),
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.CREATE_FACTORIES,
    flashMethod: 'Bin()',
    summary: 'Create LocFactory, WeevilFactory and PetFactory references.'
  }),
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.CREATE_ARRAYS_TIMERS,
    flashMethod: 'Bin()',
    summary: 'Create weevils/pets/locs/interface arrays and logout/user/party/render timers.'
  }),
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.CREATE_UI,
    flashMethod: 'Bin()',
    summary: 'Create UImain using UI_mc, content holders, inventory holder and quest holders.'
  }),
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.SETUP_CAMERA_UI,
    flashMethod: 'Bin()',
    summary: 'Call UImain.setupCamUI(cam) and disable chat initially.'
  }),
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.ADD_OVERLAY_LAYERS,
    flashMethod: 'Bin()',
    summary: 'Add tutorial holder, overlay holder, alert, dialogue and hint layers to upper content holder.'
  }),
  Object.freeze({
    id: CORE_CONSTRUCTOR_STEP_IDS.CREATE_TUTORIAL_MANAGER,
    flashMethod: 'Bin()',
    summary: 'Create TycoonCustomerManager and NewUserProgressManager.'
  })
]);

export const CORE_INIT_FLOW = Object.freeze([
  Object.freeze({ id: CORE_INIT_STEP_IDS.GUARD_INITIALISED, flashMethod: 'init', summary: 'Only run init once.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.RESET_LOGOUT_TIMER, flashMethod: 'init', summary: 'Reset the logout timer.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.STORE_LOADER_CALLBACKS, flashMethod: 'init', summary: 'Store showLoader and hideLoader callbacks passed in by main.swf.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.STORE_DEFAULT_LOC, flashMethod: 'init', summary: 'Store defaultLocID passed in by main.swf.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.WIRE_UI_CLIENT_STATE, flashMethod: 'init', summary: 'Wire UImain to ssclient and tycoon mode.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.REQUEST_CHAT_STATE, flashMethod: 'init', summary: 'Request current chat state from ssclient.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.REQUEST_ZONE_TIME, flashMethod: 'init', summary: 'Request current zone time from ssclient.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_WEEVIL_FACTORY, flashMethod: 'loadWeevilFactory', summary: 'Initialise WeevilFactory with Bin and loader callbacks.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.CREATE_MY_WEEVIL, flashMethod: 'weevilFactoryReady', summary: 'Create my weevil from myUserID, myUserName and myUserObj, then mark it as mine.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.INIT_NESTS, flashMethod: 'initNests', summary: 'Create own Nest and other-user Nest controllers.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_LOCATION_DEFS, flashMethod: 'loadLocDefs / locDefsLoaded', summary: 'Load locationDefinitions.xml and initialise Loc objects.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_NEST_LOCATION_DEFS, flashMethod: 'nestLocDefsLoaded', summary: 'Load nestLocDefs.xml and initialise normal and nest Loc objects.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_SCALED_WEEVILS, flashMethod: 'getScaledWeevilsList / scaledWeevilsReceived', summary: 'Load big/small scaled weevil lists.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_WEEVIL_STATS, flashMethod: 'getWeevilStats / myWeevilStatsReceived', summary: 'Load stats, verify hash, update UI stats, buddy list and Swrve user data.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_TREASURE_HUNT, flashMethod: 'getTreasureHunt / treasureHuntReceived', summary: 'Load treasure hunt location asset injections.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_QUEST_DATA, flashMethod: 'getQuestData / questDataReceived', summary: 'Load quest tasks and room items.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_MY_PETS, flashMethod: 'getMyPets / myPetDataReceived', summary: 'Load user pets and create Pet instances.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_SPECIAL_MOVES, flashMethod: 'getSpecialMoves / specialMovesReceived', summary: 'Load acquired special moves into UI.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_LOTTO_DATA, flashMethod: 'getMyLottoTicketsAndNextDrawDate', summary: 'Load lotto ticket and next draw data.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_SERVER_TIME, flashMethod: 'loadOnLoginServerUnixTime', summary: 'Load server time used for runtime/session timing.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.LOAD_EXTRA_FUNCTIONALITY, flashMethod: 'getExtraFunctionalitySWF / onExtraFunctionalitySWFLoaded', summary: 'Load extraFunctionality SWF and run its init method.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.CHECK_NEW_USERS, flashMethod: 'checkNewUsers', summary: 'Decide whether to load new/existing user intro or continue.' }),
  Object.freeze({ id: CORE_INIT_STEP_IDS.INIT_COMPLETE, flashMethod: 'initComplete / initCompleteFirstLogin', summary: 'Set fullyInitialised and enter the first real location/UI state.' })
]);

export const DEFAULT_CORE_INIT_PARAMS = Object.freeze({
  defaultLocID: 5,
  camera: Object.freeze({ x: -138, y: 230, z: 248, aimX: 157, aimY: 32, aimZ: 582 }),
  viewportLayerIndex: 0,
  renderTimerMs: 20,
  logoutTimerMs: 2100000,
  partyTimerMs: 60000
});

export function createCoreInitContext(params = {}) {
  const defaultLocID = Number(params.defaultLocID ?? DEFAULT_CORE_INIT_PARAMS.defaultLocID) || DEFAULT_CORE_INIT_PARAMS.defaultLocID;
  return Object.freeze({
    defaultLocID,
    camera: params.camera ?? DEFAULT_CORE_INIT_PARAMS.camera,
    viewportLayerIndex: params.viewportLayerIndex ?? DEFAULT_CORE_INIT_PARAMS.viewportLayerIndex,
    renderTimerMs: params.renderTimerMs ?? DEFAULT_CORE_INIT_PARAMS.renderTimerMs,
    logoutTimerMs: params.logoutTimerMs ?? DEFAULT_CORE_INIT_PARAMS.logoutTimerMs,
    partyTimerMs: params.partyTimerMs ?? DEFAULT_CORE_INIT_PARAMS.partyTimerMs,
    holders: Object.freeze(['contentHolderU_spr', 'contentHolderL_spr']),
    source: CORE_SWF_SOURCE
  });
}

export function buildCoreConstructorTimeline(params = {}) {
  const context = createCoreInitContext(params);
  return CORE_CONSTRUCTOR_FLOW.map((step, index) => Object.freeze({
    index,
    ...step,
    status: 'planned',
    context: contextForConstructorStep(step.id, context)
  }));
}

export function buildCoreInitTimeline(params = {}) {
  const context = createCoreInitContext(params);
  return CORE_INIT_FLOW.map((step, index) => Object.freeze({
    index,
    ...step,
    status: 'planned',
    context: contextForInitStep(step.id, context)
  }));
}

export function summariseCoreInitFlow(params = {}) {
  const context = createCoreInitContext(params);
  const constructorTimeline = buildCoreConstructorTimeline(context);
  const initTimeline = buildCoreInitTimeline(context);
  return {
    context,
    constructorSteps: constructorTimeline.length,
    initSteps: initTimeline.length,
    firstConstructorStep: constructorTimeline[0]?.id ?? null,
    firstInitStep: initTimeline[0]?.id ?? null,
    finalInitStep: initTimeline.at(-1)?.id ?? null,
    summary: initTimeline.map((step) => `${step.index + 1}. ${step.id}: ${step.flashMethod}`).join('\n')
  };
}

function contextForConstructorStep(stepId, context) {
  switch (stepId) {
    case CORE_CONSTRUCTOR_STEP_IDS.CREATE_CAMERA_VIEWPORT:
      return { camera: context.camera };
    case CORE_CONSTRUCTOR_STEP_IDS.ATTACH_VIEWPORT:
      return { holder: 'contentHolderL_spr', index: context.viewportLayerIndex };
    case CORE_CONSTRUCTOR_STEP_IDS.CREATE_ARRAYS_TIMERS:
      return { renderTimerMs: context.renderTimerMs, logoutTimerMs: context.logoutTimerMs, partyTimerMs: context.partyTimerMs };
    default:
      return {};
  }
}

function contextForInitStep(stepId, context) {
  switch (stepId) {
    case CORE_INIT_STEP_IDS.STORE_DEFAULT_LOC:
      return { defaultLocID: context.defaultLocID };
    case CORE_INIT_STEP_IDS.STORE_LOADER_CALLBACKS:
      return { callbacks: ['showLoader', 'hideLoader'] };
    case CORE_INIT_STEP_IDS.LOAD_LOCATION_DEFS:
      return { pathTemplate: '/binConfig/getFile/<locDefVersion>/<cluster>/locationDefinitions.xml' };
    case CORE_INIT_STEP_IDS.LOAD_NEST_LOCATION_DEFS:
      return { pathTemplate: '/binConfig/getFile/<nestDefVersion>/<cluster>/nestLocDefs.xml' };
    default:
      return {};
  }
}
