import assert from 'node:assert/strict';

import {
  CORE_CONSTRUCTOR_STEP_IDS,
  CORE_INIT_STEP_IDS,
  buildCoreConstructorTimeline,
  buildCoreInitTimeline,
  createCoreInitContext,
  summariseCoreInitFlow
} from '../src/core/CoreInitFlow.js';

const expectedConstructorOrder = [
  CORE_CONSTRUCTOR_STEP_IDS.SET_SINGLETONS,
  CORE_CONSTRUCTOR_STEP_IDS.CREATE_WEBSOCKET_EVENT_MANAGERS,
  CORE_CONSTRUCTOR_STEP_IDS.BIND_SMARTFOX_EVENTS,
  CORE_CONSTRUCTOR_STEP_IDS.CREATE_CAMERA_VIEWPORT,
  CORE_CONSTRUCTOR_STEP_IDS.ATTACH_VIEWPORT,
  CORE_CONSTRUCTOR_STEP_IDS.CAPTURE_HOLDERS,
  CORE_CONSTRUCTOR_STEP_IDS.CREATE_FACTORIES,
  CORE_CONSTRUCTOR_STEP_IDS.CREATE_ARRAYS_TIMERS,
  CORE_CONSTRUCTOR_STEP_IDS.CREATE_UI,
  CORE_CONSTRUCTOR_STEP_IDS.SETUP_CAMERA_UI,
  CORE_CONSTRUCTOR_STEP_IDS.ADD_OVERLAY_LAYERS,
  CORE_CONSTRUCTOR_STEP_IDS.CREATE_TUTORIAL_MANAGER
];

const expectedInitOrder = [
  CORE_INIT_STEP_IDS.GUARD_INITIALISED,
  CORE_INIT_STEP_IDS.RESET_LOGOUT_TIMER,
  CORE_INIT_STEP_IDS.STORE_LOADER_CALLBACKS,
  CORE_INIT_STEP_IDS.STORE_DEFAULT_LOC,
  CORE_INIT_STEP_IDS.WIRE_UI_CLIENT_STATE,
  CORE_INIT_STEP_IDS.REQUEST_CHAT_STATE,
  CORE_INIT_STEP_IDS.REQUEST_ZONE_TIME,
  CORE_INIT_STEP_IDS.LOAD_WEEVIL_FACTORY,
  CORE_INIT_STEP_IDS.CREATE_MY_WEEVIL,
  CORE_INIT_STEP_IDS.INIT_NESTS,
  CORE_INIT_STEP_IDS.LOAD_LOCATION_DEFS,
  CORE_INIT_STEP_IDS.LOAD_NEST_LOCATION_DEFS,
  CORE_INIT_STEP_IDS.LOAD_SCALED_WEEVILS,
  CORE_INIT_STEP_IDS.LOAD_WEEVIL_STATS,
  CORE_INIT_STEP_IDS.LOAD_TREASURE_HUNT,
  CORE_INIT_STEP_IDS.LOAD_QUEST_DATA,
  CORE_INIT_STEP_IDS.LOAD_MY_PETS,
  CORE_INIT_STEP_IDS.LOAD_SPECIAL_MOVES,
  CORE_INIT_STEP_IDS.LOAD_LOTTO_DATA,
  CORE_INIT_STEP_IDS.LOAD_SERVER_TIME,
  CORE_INIT_STEP_IDS.LOAD_EXTRA_FUNCTIONALITY,
  CORE_INIT_STEP_IDS.CHECK_NEW_USERS,
  CORE_INIT_STEP_IDS.INIT_COMPLETE
];

const context = createCoreInitContext({ defaultLocID: 12 });
assert.equal(context.defaultLocID, 12);
assert.equal(context.camera.x, -138);
assert.equal(context.camera.y, 230);
assert.equal(context.camera.z, 248);
assert.equal(context.camera.aimX, 157);
assert.equal(context.camera.aimY, 32);
assert.equal(context.camera.aimZ, 582);
assert.equal(context.renderTimerMs, 20);
assert.equal(context.logoutTimerMs, 2100000);
assert.deepEqual(context.holders, ['contentHolderU_spr', 'contentHolderL_spr']);

const constructorTimeline = buildCoreConstructorTimeline({ defaultLocID: 12 });
const initTimeline = buildCoreInitTimeline({ defaultLocID: 12 });

assert.deepEqual(constructorTimeline.map((step) => step.id), expectedConstructorOrder);
assert.deepEqual(initTimeline.map((step) => step.id), expectedInitOrder);
assert.equal(constructorTimeline[3].context.camera.x, -138);
assert.equal(constructorTimeline[4].context.holder, 'contentHolderL_spr');
assert.equal(initTimeline[3].context.defaultLocID, 12);
assert.equal(initTimeline[10].context.pathTemplate, '/binConfig/getFile/<locDefVersion>/<cluster>/locationDefinitions.xml');
assert.equal(initTimeline[11].context.pathTemplate, '/binConfig/getFile/<nestDefVersion>/<cluster>/nestLocDefs.xml');

const summary = summariseCoreInitFlow({ defaultLocID: 12 });
assert.equal(summary.constructorSteps, expectedConstructorOrder.length);
assert.equal(summary.initSteps, expectedInitOrder.length);
assert.equal(summary.firstConstructorStep, CORE_CONSTRUCTOR_STEP_IDS.SET_SINGLETONS);
assert.equal(summary.firstInitStep, CORE_INIT_STEP_IDS.GUARD_INITIALISED);
assert.equal(summary.finalInitStep, CORE_INIT_STEP_IDS.INIT_COMPLETE);
assert.ok(summary.summary.includes('loadWeevilFactory'));

console.log('core-init-flow smoke test passed');
console.log(summary.summary);
