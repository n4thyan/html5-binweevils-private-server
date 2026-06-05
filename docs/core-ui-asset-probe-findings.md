# Core UI asset probe findings

Date: 2026-06-05

Probe page:

```text
public/probes/core-ui-assets.html
```

Opened locally at:

```text
http://127.0.0.1:5173/probes/core-ui-assets.html
```

## Result

The debug probe successfully proved that source-backed UI symbols from the decompiled `core5.swf` FFDec export can be loaded directly by the browser.

This is not the final UI shell. It is only a visual verification page for exported source assets.

## Confirmed loaded examples

```text
weevil-profile
control-tab
alert-box
dialogue-box
side-buttons
actions-button
action-icons
mouth-icons
pet-profile
```

The browser loaded the real `DefineSprite_*` SVG exports from:

```text
reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/
```

## Observations from first visual pass

### Good source-backed proof

The probe confirms the important technical point:

```text
source-backed UI symbols from the SWF export can be loaded by the browser before the real UI layout is built
```

This validates the current `CoreSymbolLocator` / `CoreUiAssetProbePlan` approach.

### side-buttons

The item labelled `side-buttons` appears to be part of the buddy/tablet-style side button component, not necessarily the main final game shell side UI by itself.

Do not treat this as the full final shell. Keep it as a located symbol that may belong inside a larger UI composition.

### pet-profile

`pet-profile` loads, but pets are not a current priority. Defer pet UI work until the main shell/profile/chat/actions path is further along.

### weevil-profile

The `weevil-profile` symbol appears to include magazine/newspaper-related content in the first exported frame. This may mean one or more of the following:

```text
frame 1 is not the final runtime state we want
nested children are visible in the raw FFDec export that were normally hidden/changed by ActionScript
profile content is dynamically populated at runtime
additional child symbols or later frames need mapping before this becomes useful as a final playercard/profile UI
```

Do not assume the raw frame-1 SVG is the final in-game playercard appearance.

### alert/dialogue

`alert-box` and `dialogue-box` visually look like useful source-backed UI pieces and should remain high priority for early overlay/panel work.

### actions/mouth icons

`actions-button`, `action-icons`, and `mouth-icons` load and are useful for tracing action/emote UI. These should be mapped more deeply once the main shell path is clearer.

## Next recommended step

```text
1. Keep the probe page as debug-only evidence.
2. Do not use every loaded symbol blindly as final UI.
3. Map runtime states/frames/nested symbols for the useful UI pieces.
4. Prioritise alert/dialogue/control tab/actions/chat/profile shell before pets.
5. Continue with source-backed UI shell planning from UImain.as, not guessed layout.
```
