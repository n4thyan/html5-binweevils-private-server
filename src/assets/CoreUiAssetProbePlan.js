import { getCoreSymbolAssetPath } from './CoreSymbolLocator.js';

export const CORE_UI_ASSET_PROBE_PLAN = Object.freeze([
  Object.freeze({ key: 'weevil-profile', className: 'core390_fla.weevilProfile_467', expectedPath: getCoreSymbolAssetPath('core390_fla.weevilProfile_467') }),
  Object.freeze({ key: 'control-tab', className: 'core390_fla.controlTab_450', expectedPath: getCoreSymbolAssetPath('core390_fla.controlTab_450') }),
  Object.freeze({ key: 'alert-box', className: 'core390_fla.alertBox_1370', expectedPath: getCoreSymbolAssetPath('core390_fla.alertBox_1370') }),
  Object.freeze({ key: 'dialogue-box', className: 'core390_fla.dialogueBox_1357', expectedPath: getCoreSymbolAssetPath('core390_fla.dialogueBox_1357') }),
  Object.freeze({ key: 'side-buttons', className: 'core390_fla.sidebtnsflipout_549', expectedPath: getCoreSymbolAssetPath('core390_fla.sidebtnsflipout_549') }),
  Object.freeze({ key: 'actions-button', className: 'core390_fla.actionsBtn_134', expectedPath: getCoreSymbolAssetPath('core390_fla.actionsBtn_134') }),
  Object.freeze({ key: 'action-icons', className: 'core390_fla.actionIcons_246', expectedPath: getCoreSymbolAssetPath('core390_fla.actionIcons_246') }),
  Object.freeze({ key: 'mouth-icons', className: 'core390_fla.mouthIcons_213', expectedPath: getCoreSymbolAssetPath('core390_fla.mouthIcons_213') }),
  Object.freeze({ key: 'pet-profile', className: 'core390_fla.petProfile_3', expectedPath: getCoreSymbolAssetPath('core390_fla.petProfile_3') })
]);

export function getCoreUiAssetProbePlan() {
  return CORE_UI_ASSET_PROBE_PLAN;
}

export function summariseCoreUiAssetProbePlan() {
  return Object.freeze({
    count: CORE_UI_ASSET_PROBE_PLAN.length,
    paths: Object.freeze(CORE_UI_ASSET_PROBE_PLAN.map((entry) => entry.expectedPath)),
    labels: Object.freeze(CORE_UI_ASSET_PROBE_PLAN.map((entry) => entry.key))
  });
}
