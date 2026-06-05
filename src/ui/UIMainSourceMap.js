// Source-backed map of core5.swf/scripts/com/binweevils/UImain.as.
//
// This is not a visual implementation. It records the real Flash child names
// and UI construction responsibilities so later HTML5 UI work can be mapped
// from decompiled symbols instead of invented shapes.

export const UIMAIN_SOURCE = 'reference/decompiled-dumpassets/dumpassets/core5.swf/scripts/com/binweevils/UImain.as';
export const CORE_SYMBOLS_SOURCE = 'reference/decompiled-dumpassets/dumpassets/core5.swf/symbolClass/symbols.csv';

export const UI_ROOT_ARGS = Object.freeze([
  'UI_mc',
  'contentHolderU_spr',
  'contentHolderL_spr',
  'inventoryHolder_spr',
  'questHelpHolder_spr',
  'questExtUiHelpHolder_spr'
]);

export const UI_MAIN_CHILD_PATHS = Object.freeze({
  profile: Object.freeze([
    'weevilProfile_mc',
    'weevilProfile_mc.profileContent_spr',
    'weevilProfile_mc.mugShotHolder_spr',
    'weevilProfile_mc.weevilName_txt',
    'weevilProfile_mc.close_btn',
    'weevilProfile_mc.staff_mc',
    'weevilProfile_mc.magazineBadge_mc',
    'weevilProfile_mc.tycoonPanel_mc',
    'weevilProfile_mc.sendBuddyMsg_mc'
  ]),
  petProfile: Object.freeze([
    'petProfile_mc',
    'petProfile_mc.petCommands_spr',
    'petProfile_mc.petName_txt',
    'petProfile_mc.mugShotHolder_spr',
    'petProfile_mc.close_btn',
    'petProfile_mc.loading_mc'
  ]),
  controls: Object.freeze([
    'controls_mc',
    'controls_mc.buddyFeed_mc',
    'controls_mc.lists_mc',
    'controls_mc.chat_spr',
    'controls_mc.chatDisabled_mc',
    'controls_mc.chatLog_spr',
    'controls_mc.chatLog_btn',
    'controls_mc.buddyRequestIndicator_spr',
    'controls_mc.inviteIndicator_spr',
    'controls_mc.camUILoader_spr',
    'controls_mc.camUI_spr',
    'controls_mc.tycoonTV_btn',
    'controls_mc.activate_bt',
    'controls_mc.map_btn',
    'controls_mc.shop_btn',
    'controls_mc.mapBtnGlow_mc',
    'controls_mc.nest_btn',
    'controls_mc.myStuff_btn',
    'controls_mc.myStuffShake_mc',
    'controls_mc.showBuddyList_btn',
    'controls_mc.showBinBadges_btn',
    'controls_mc.showInviteList_btn',
    'controls_mc.showGuestList_btn',
    'controls_mc.buddyAlertsBtn_mc',
    'controls_mc.buddyAlertsBtn_mc._btn',
    'controls_mc.buddyPanel_mc',
    'controls_mc.newsAndMessagesBtn_mc',
    'controls_mc.newsAndMessagesBtn_mc._btn',
    'controls_mc.pet_btn',
    'controls_mc.secretCode_bt',
    'controls_mc.nestHit_btn',
    'controls_mc.mapHit_btn',
    'controls_mc.shopHit_btn',
    'controls_mc.tabletHit_btn',
    'controls_mc.videoAdsHit_btn',
    'controls_mc.buddyAlertHit_btn',
    'controls_mc.buddyHit_btn',
    'controls_mc.binBadgesHit_btn',
    'controls_mc.nestInvitesHit_btn',
    'controls_mc.guestListHit_btn',
    'controls_mc.activateHit_btn',
    'controls_mc.secretCodeHit_btn'
  ]),
  overlays: Object.freeze([
    'alertBox_mc',
    'warningBox_mc',
    'dialogueBox_mc',
    'invitation_mc',
    'buddyRequestMsg_mc',
    'hint_mc',
    'crosshairs_spr',
    'hand_mc',
    'modMsg_spr',
    'reportUser_mc',
    'doshPrompt_mc'
  ]),
  newsAndBadges: Object.freeze([
    'newsAndMessages_spr',
    'newsAndMessages_spr.deviceMain_mc.numNewConvs_spr',
    'newsAndMessages_spr.deviceMain_mc.numNewBuddy_spr',
    'binBadges_mc'
  ])
});

export const UI_MAIN_SYMBOLS = Object.freeze([
  Object.freeze({ symbol: 'core390_fla.weevilProfile_467', id: 2502, role: 'weevil profile panel' }),
  Object.freeze({ symbol: 'core390_fla.controlTab_450', id: 2359, role: 'control tab / lower controls' }),
  Object.freeze({ symbol: 'core390_fla.lists_382', id: 2280, role: 'buddy/invite/guest/ignore lists container' }),
  Object.freeze({ symbol: 'core390_fla.actionIcons_246', id: 2018, role: 'weevil action icons' }),
  Object.freeze({ symbol: 'core390_fla.actionsBtn_134', id: 1761, role: 'actions button' }),
  Object.freeze({ symbol: 'core390_fla.energyBar_bg_135', id: 1744, role: 'energy bar background' }),
  Object.freeze({ symbol: 'core390_fla.levelBar_110', id: 1699, role: 'level bar' }),
  Object.freeze({ symbol: 'core390_fla.petProfile_3', id: 1685, role: 'pet profile panel' }),
  Object.freeze({ symbol: 'core390_fla.petCommands_34', id: 1568, role: 'pet command UI' }),
  Object.freeze({ symbol: 'core390_fla.warningBox_1378', id: 2841, role: 'warning dialogue' }),
  Object.freeze({ symbol: 'core390_fla.alertBox_1370', id: 2832, role: 'alert dialogue' }),
  Object.freeze({ symbol: 'core390_fla.dialogueBox_1357', id: 2803, role: 'yes/no dialogue box' }),
  Object.freeze({ symbol: 'core390_fla.invitation_1365', id: 2817, role: 'nest invitation dialogue' }),
  Object.freeze({ symbol: 'core390_fla.pleaseWait_1363', id: 2802, role: 'please-wait loader' }),
  Object.freeze({ symbol: 'core390_fla.sidebtnsflipout_549', id: 2548, role: 'side button flip-out panel' })
]);

export const UI_MAIN_CONSTRUCTOR_FLOW = Object.freeze([
  Object.freeze({ id: 'store-root-refs', summary: 'Store UI_mc, Bin instance and holder sprites.' }),
  Object.freeze({ id: 'register-tooltips', summary: 'Listen for tooltip registration events and create TooltipsManager on hint_mc.' }),
  Object.freeze({ id: 'wire-buddy-feed', summary: 'Create BuddyFeedContainer from controls_mc.buddyFeed_mc.' }),
  Object.freeze({ id: 'capture-core-panels', summary: 'Capture weevilProfile, petProfile, reportUser, lists, chat, alert, warning, dialogue and invite panels.' }),
  Object.freeze({ id: 'capture-control-buttons', summary: 'Capture map, shop, nest, myStuff, tablet/news, buddy, invite, guest, camera, pet and secret-code buttons.' }),
  Object.freeze({ id: 'attach-ui-root', summary: 'Add UI_mc to upper content holder.' }),
  Object.freeze({ id: 'wire-profile-panel', summary: 'Map profile child buttons, text fields, mugshot holder, staff icons, apparel and tycoon panel.' }),
  Object.freeze({ id: 'wire-pet-profile', summary: 'Map pet profile, pet commands, stats and mugshot holder.' }),
  Object.freeze({ id: 'wire-report-user', summary: 'Map report user dialogue and report reasons.' }),
  Object.freeze({ id: 'wire-buddy-lists', summary: 'Create buddy, ignore, guest and invite UserList instances.' }),
  Object.freeze({ id: 'wire-buddy-panels', summary: 'Create BuddyPanelContainer, BuddyFeedContainer and message indicators.' }),
  Object.freeze({ id: 'wire-news-and-badges', summary: 'Create NewsAndMessages, NewMessagesIndicator and BinBadgesManager.' }),
  Object.freeze({ id: 'wire-level-locks', summary: 'Prepare level-locked hit areas and hints for map/shop/nest/tablet/video/buddy/badges/invites.' })
]);

export function listUIMainChildPaths() {
  return Object.freeze(Object.values(UI_MAIN_CHILD_PATHS).flat());
}

export function findUIMainChildPath(name) {
  const needle = String(name).toLowerCase();
  return listUIMainChildPaths().filter((path) => path.toLowerCase().includes(needle));
}

export function summariseUIMainSourceMap() {
  const paths = listUIMainChildPaths();
  return Object.freeze({
    source: UIMAIN_SOURCE,
    symbolsSource: CORE_SYMBOLS_SOURCE,
    rootArgs: UI_ROOT_ARGS.length,
    childPaths: paths.length,
    symbols: UI_MAIN_SYMBOLS.length,
    constructorSteps: UI_MAIN_CONSTRUCTOR_FLOW.length,
    summary: UI_MAIN_CONSTRUCTOR_FLOW.map((step, index) => `${index + 1}. ${step.id}`).join('\n')
  });
}
