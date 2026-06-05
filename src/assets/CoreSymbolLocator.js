// Source-backed locator for important exported core5.swf symbols.
//
// FFDec exports sprite timelines as folders like:
// sprites/DefineSprite_<id>_<className>/<frame>.svg
//
// symbolClass/symbols.csv gives the id-to-class mapping; this module turns
// those ids/classes into stable frame paths for later asset-backed rendering.

export const CORE_DECOMPILED_ROOT = 'reference/decompiled-dumpassets/dumpassets/core5.swf';
export const CORE_SYMBOLS_CSV = `${CORE_DECOMPILED_ROOT}/symbolClass/symbols.csv`;

export const CORE_SYMBOL_ASSET_TYPES = Object.freeze({
  SPRITE: 'sprite',
  SHAPE: 'shape',
  BUTTON: 'button',
  IMAGE: 'image',
  SOUND: 'sound',
  FONT: 'font'
});

export const CORE_UI_SYMBOLS = Object.freeze([
  Object.freeze({ id: 2841, className: 'core390_fla.warningBox_1378', role: 'warning dialogue', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2832, className: 'core390_fla.alertBox_1370', role: 'alert dialogue', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2817, className: 'core390_fla.invitation_1365', role: 'nest invitation dialogue', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2803, className: 'core390_fla.dialogueBox_1357', role: 'yes/no dialogue box', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2802, className: 'core390_fla.pleaseWait_1363', role: 'please-wait loader', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2786, className: 'core390_fla.hand_1354', role: 'hand/cursor prompt', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2548, className: 'core390_fla.sidebtnsflipout_549', role: 'side button flip-out panel', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2523, className: 'core390_fla.lottoResults_521', role: 'lotto results panel', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2502, className: 'core390_fla.weevilProfile_467', role: 'weevil profile panel', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2487, className: 'core390_fla.tycoonBusinessIcons_513', role: 'tycoon business icons', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2482, className: 'core390_fla.stars_512', role: 'star rating stars', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2481, className: 'core390_fla.tycoonPanelLower_510', role: 'tycoon lower panel', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2407, className: 'core390_fla.weevilProfile_mask_475', role: 'weevil profile mask', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2403, className: 'core390_fla.weevilPic_mask_474', role: 'weevil picture mask', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2359, className: 'core390_fla.controlTab_450', role: 'control tab / lower controls', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2286, className: 'core390_fla.star_rating_411', role: 'star rating widget', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2280, className: 'core390_fla.lists_382', role: 'buddy/invite/guest/ignore list container', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2266, className: 'core390_fla.actionIconscopy_273', role: 'action icon copy set', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 2018, className: 'core390_fla.actionIcons_246', role: 'weevil action icons', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 1982, className: 'core390_fla.actionBtn_bg_clrs_245', role: 'action button colour backgrounds', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 1964, className: 'core390_fla.myStuffShake_234', role: 'my stuff shake animation', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 1926, className: 'core390_fla.mouthIcons_213', role: 'mouth/expression icons', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 1855, className: 'core390_fla.tableticon4_186', role: 'tablet/news icon', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 1761, className: 'core390_fla.actionsBtn_134', role: 'actions button', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 1744, className: 'core390_fla.energyBar_bg_135', role: 'energy bar background', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 1699, className: 'core390_fla.levelBar_110', role: 'level bar', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 1685, className: 'core390_fla.petProfile_3', role: 'pet profile panel', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 1568, className: 'core390_fla.petCommands_34', role: 'pet commands panel', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 1567, className: 'core390_fla.petcommandmc_48', role: 'pet command item', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE }),
  Object.freeze({ id: 150, className: 'core390_fla.loadingtwirly_1569', role: 'loading twirly animation', assetType: CORE_SYMBOL_ASSET_TYPES.SPRITE })
]);

export const CORE_EMOTE_SYMBOL_RANGE = Object.freeze({
  firstKnownId: 1166,
  lastKnownId: 1425,
  description: 'emojii_1 through emojii_40 plus variants in symbols.csv'
});

export const CORE_PHRASE_SYMBOL_RANGE = Object.freeze({
  firstKnownId: 901,
  lastKnownId: 1159,
  description: 'phrase_* quick chat symbols in symbols.csv'
});

export function getCoreSymbolAssetPath(symbol, frame = 1) {
  const entry = typeof symbol === 'number'
    ? CORE_UI_SYMBOLS.find((candidate) => candidate.id === symbol)
    : CORE_UI_SYMBOLS.find((candidate) => candidate.className === symbol || candidate.role === symbol);

  if (!entry) return null;

  return buildCoreAssetPath(entry, frame);
}

export function buildCoreAssetPath(symbolOrId, frameOrAssetType = 1, maybeFrame = 1) {
  if (typeof symbolOrId === 'object' && symbolOrId != null) {
    return buildPathFromEntry(symbolOrId, Number(frameOrAssetType) || 1);
  }

  const id = Number(symbolOrId);
  const assetType = typeof frameOrAssetType === 'string' ? frameOrAssetType : CORE_SYMBOL_ASSET_TYPES.SPRITE;
  const frame = typeof frameOrAssetType === 'number' ? frameOrAssetType : (Number(maybeFrame) || 1);
  const entry = CORE_UI_SYMBOLS.find((candidate) => candidate.id === id && candidate.assetType === assetType);

  if (entry) {
    return buildPathFromEntry(entry, frame);
  }

  const folder = folderForAssetType(assetType);
  const extension = extensionForAssetType(assetType);
  return `${CORE_DECOMPILED_ROOT}/${folder}/Define${capitalise(assetType)}_${id}/${frame}.${extension}`;
}

export function getCoreSymbolAssetDirectory(symbol) {
  const entry = typeof symbol === 'number'
    ? CORE_UI_SYMBOLS.find((candidate) => candidate.id === symbol)
    : CORE_UI_SYMBOLS.find((candidate) => candidate.className === symbol || candidate.role === symbol);

  if (!entry) return null;
  return `${CORE_DECOMPILED_ROOT}/${folderForAssetType(entry.assetType)}/${buildExportFolderName(entry)}`;
}

export function findCoreUISymbol(query) {
  const needle = String(query).toLowerCase();
  return CORE_UI_SYMBOLS.filter((entry) => (
    entry.className.toLowerCase().includes(needle)
    || entry.role.toLowerCase().includes(needle)
    || String(entry.id) === needle
  ));
}

export function summariseCoreSymbolLocator() {
  return Object.freeze({
    source: CORE_SYMBOLS_CSV,
    uiSymbols: CORE_UI_SYMBOLS.length,
    spriteSymbols: CORE_UI_SYMBOLS.filter((entry) => entry.assetType === CORE_SYMBOL_ASSET_TYPES.SPRITE).length,
    emoteRange: CORE_EMOTE_SYMBOL_RANGE,
    phraseRange: CORE_PHRASE_SYMBOL_RANGE,
    samplePaths: Object.freeze({
      weevilProfile: getCoreSymbolAssetPath('core390_fla.weevilProfile_467'),
      controls: getCoreSymbolAssetPath('core390_fla.controlTab_450'),
      alertBox: getCoreSymbolAssetPath('core390_fla.alertBox_1370'),
      sideButtons: getCoreSymbolAssetPath('core390_fla.sidebtnsflipout_549')
    })
  });
}

function buildPathFromEntry(entry, frame = 1) {
  const folder = folderForAssetType(entry.assetType);
  const extension = extensionForAssetType(entry.assetType);
  return `${CORE_DECOMPILED_ROOT}/${folder}/${buildExportFolderName(entry)}/${frame}.${extension}`;
}

function buildExportFolderName(entry) {
  return `${definePrefixForAssetType(entry.assetType)}_${entry.id}_${entry.className}`;
}

function folderForAssetType(assetType) {
  switch (assetType) {
    case CORE_SYMBOL_ASSET_TYPES.SHAPE:
      return 'shapes';
    case CORE_SYMBOL_ASSET_TYPES.BUTTON:
      return 'buttons';
    case CORE_SYMBOL_ASSET_TYPES.IMAGE:
      return 'images';
    case CORE_SYMBOL_ASSET_TYPES.SOUND:
      return 'sounds';
    case CORE_SYMBOL_ASSET_TYPES.FONT:
      return 'fonts';
    case CORE_SYMBOL_ASSET_TYPES.SPRITE:
    default:
      return 'sprites';
  }
}

function definePrefixForAssetType(assetType) {
  switch (assetType) {
    case CORE_SYMBOL_ASSET_TYPES.SHAPE:
      return 'DefineShape';
    case CORE_SYMBOL_ASSET_TYPES.BUTTON:
      return 'DefineButton';
    case CORE_SYMBOL_ASSET_TYPES.IMAGE:
      return 'DefineImage';
    case CORE_SYMBOL_ASSET_TYPES.SOUND:
      return 'DefineSound';
    case CORE_SYMBOL_ASSET_TYPES.FONT:
      return 'DefineFont';
    case CORE_SYMBOL_ASSET_TYPES.SPRITE:
    default:
      return 'DefineSprite';
  }
}

function extensionForAssetType(assetType) {
  switch (assetType) {
    case CORE_SYMBOL_ASSET_TYPES.IMAGE:
      return 'png';
    case CORE_SYMBOL_ASSET_TYPES.SOUND:
      return 'mp3';
    case CORE_SYMBOL_ASSET_TYPES.FONT:
      return 'ttf';
    case CORE_SYMBOL_ASSET_TYPES.SPRITE:
    case CORE_SYMBOL_ASSET_TYPES.SHAPE:
    case CORE_SYMBOL_ASSET_TYPES.BUTTON:
    default:
      return 'svg';
  }
}

function capitalise(value) {
  const text = String(value || '');
  return text.length === 0 ? text : `${text[0].toUpperCase()}${text.slice(1)}`;
}
