// Source-backed HTML5 model of mainDEV661.swf/scripts/com/binweevils/Main.as.
//
// This is not a backend implementation and it does not invent UI. It captures
// the Flash boot order so the HTML5 port can wire the real loader/core flow in
// the same sequence.

export const MAIN_SWF_SOURCE = 'reference/decompiled-dumpassets/dumpassets/mainDEV661.swf/scripts/com/binweevils/Main.as';

export const BOOT_STEP_IDS = Object.freeze({
  READ_ROOT_PARAMS: 'read-root-params',
  SET_STAGE: 'set-stage',
  LOAD_CONFIG: 'load-config',
  APPLY_CONFIG: 'apply-config',
  CHECK_VERSION: 'check-version',
  RESOLVE_DEFAULT_LOC: 'resolve-default-loc',
  LOAD_LOADER_CONTENT: 'load-loader-content',
  LOAD_CORE: 'load-core',
  CORE_INIT_HANDOFF: 'core-init-handoff'
});

export const BIN_BOOT_FLOW = Object.freeze([
  Object.freeze({
    id: BOOT_STEP_IDS.READ_ROOT_PARAMS,
    source: 'Main.as constructor',
    flashMethod: 'Main()',
    summary: 'Read cluster, loginPath, autoBin and zone from root.loaderInfo.parameters.'
  }),
  Object.freeze({
    id: BOOT_STEP_IDS.SET_STAGE,
    source: 'Main.as constructor',
    flashMethod: 'Main()',
    summary: 'Assign global STAGE and create the main loader text animation.'
  }),
  Object.freeze({
    id: BOOT_STEP_IDS.LOAD_CONFIG,
    source: 'Main.as loadConfig()',
    flashMethod: 'loadConfig',
    summary: 'Load binConfig/config.xml after a short timer delay.'
  }),
  Object.freeze({
    id: BOOT_STEP_IDS.APPLY_CONFIG,
    source: 'Main.as configLoaded()',
    flashMethod: 'configLoaded',
    summary: 'Populate URLhandler domain, servicesLocation and asset/CDN paths.'
  }),
  Object.freeze({
    id: BOOT_STEP_IDS.CHECK_VERSION,
    source: 'Main.as checkVersion()',
    flashMethod: 'checkVersion / onCheckVersionHandler',
    summary: 'POST current site version and receive core, locDef, URLDef and related versions.'
  }),
  Object.freeze({
    id: BOOT_STEP_IDS.RESOLVE_DEFAULT_LOC,
    source: 'Main.as getDefaultLocID()',
    flashMethod: 'getDefaultLocID / defaultLocIDReceived',
    summary: 'Use locID 5 for non-login boot, otherwise resolve locID from loginPath.'
  }),
  Object.freeze({
    id: BOOT_STEP_IDS.LOAD_LOADER_CONTENT,
    source: 'Main.as getLoaderAdPath()',
    flashMethod: 'getLoaderAdPath / loaderAdPathReceived / loaderContentLoaded',
    summary: 'Load optional loader campaign/ad SWF before the core SWF.'
  }),
  Object.freeze({
    id: BOOT_STEP_IDS.LOAD_CORE,
    source: 'Main.as loadCore()',
    flashMethod: 'loadCore',
    summary: 'Load core<VersionHandler.coreVersion>.swf from the configured CDN path.'
  }),
  Object.freeze({
    id: BOOT_STEP_IDS.CORE_INIT_HANDOFF,
    source: 'Main.as coreLoaded()',
    flashMethod: 'coreLoaded',
    summary: 'Call core.init(contentHolderU_spr, contentHolderL_spr, showLoader, hideLoader, defaultLocID).'
  })
]);

export const DEFAULT_BOOT_PARAMS = Object.freeze({
  cluster: 'uk',
  loginPath: null,
  autoBin: false,
  zone: null,
  newUser: false,
  allowMultipleLogins: false,
  siteVersion: 0,
  coreVersion: 0,
  defaultLocID: 5
});

export function createBootContext(params = {}) {
  const loginPath = normaliseLoginPath(params.loginPath ?? DEFAULT_BOOT_PARAMS.loginPath);
  const cluster = String(params.cluster ?? DEFAULT_BOOT_PARAMS.cluster || 'uk');
  const coreVersion = Number(params.coreVersion ?? DEFAULT_BOOT_PARAMS.coreVersion) || 0;
  const defaultLocID = loginPath == null
    ? DEFAULT_BOOT_PARAMS.defaultLocID
    : Number(params.defaultLocID ?? DEFAULT_BOOT_PARAMS.defaultLocID) || DEFAULT_BOOT_PARAMS.defaultLocID;

  return Object.freeze({
    cluster,
    loginPath,
    autoBin: params.autoBin === true || params.autoBin === 'true',
    zone: params.zone ?? DEFAULT_BOOT_PARAMS.zone,
    newUser: params.newUser === true,
    allowMultipleLogins: params.allowMultipleLogins === true,
    siteVersion: Number(params.siteVersion ?? DEFAULT_BOOT_PARAMS.siteVersion) || 0,
    coreVersion,
    defaultLocID,
    loginPageURL: loginPath == null ? 'index.php' : 'https://play.binweevils.com/',
    coreSwfName: resolveCoreSwfName(coreVersion),
    source: MAIN_SWF_SOURCE
  });
}

export function buildBootTimeline(params = {}) {
  const context = createBootContext(params);
  return BIN_BOOT_FLOW.map((step, index) => Object.freeze({
    index,
    ...step,
    status: 'planned',
    context: contextForStep(step.id, context)
  }));
}

export function resolveCoreSwfName(coreVersion = 0) {
  const version = Number(coreVersion) || 0;
  return version > 0 ? `core${version}.swf` : 'core.swf';
}

export function summariseBootFlow(params = {}) {
  const context = createBootContext(params);
  const timeline = buildBootTimeline(context);
  return {
    context,
    steps: timeline.length,
    coreSwfName: context.coreSwfName,
    defaultLocID: context.defaultLocID,
    firstStep: timeline[0]?.id ?? null,
    finalStep: timeline.at(-1)?.id ?? null,
    summary: timeline.map((step) => `${step.index + 1}. ${step.id}: ${step.flashMethod}`).join('\n')
  };
}

function normaliseLoginPath(value) {
  const raw = value == null ? '' : String(value).trim();
  return raw === '' ? null : raw;
}

function contextForStep(stepId, context) {
  switch (stepId) {
    case BOOT_STEP_IDS.READ_ROOT_PARAMS:
      return { cluster: context.cluster, loginPath: context.loginPath, autoBin: context.autoBin, zone: context.zone };
    case BOOT_STEP_IDS.RESOLVE_DEFAULT_LOC:
      return { loginPath: context.loginPath, defaultLocID: context.defaultLocID };
    case BOOT_STEP_IDS.LOAD_CORE:
      return { coreVersion: context.coreVersion, coreSwfName: context.coreSwfName };
    case BOOT_STEP_IDS.CORE_INIT_HANDOFF:
      return { defaultLocID: context.defaultLocID, holders: ['contentHolderU_spr', 'contentHolderL_spr'] };
    default:
      return {};
  }
}
