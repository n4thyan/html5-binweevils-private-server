# Core5 first-pass UI sprite registry

This note records the gameplay HUD/UI symbols currently selected from `core5.swf` for the clean Nest UI canvas work.

The ids came from direct JPEXS/FFDec inspection of the exported `DefineSprite` grid. They are source leads for reconstruction, not hand-drawn replacements.

## Source

```text
reference/decompiled-dumpassets/dumpassets/core5.swf/sprites/DefineSprite_<id>/1.svg
```

## Active pass

The active pass is deliberately limited to the Level HUD only:

| UI area | Active ids | Notes |
|---|---:|---|
| Level icon | 1704 | User-selected level icon candidate from the source grid. |
| XP bar | 1681 | User-selected horizontal XP bar that sits below the level icon. |

A dedicated verification page exists for these two symbols:

```text
/probes/core5-ui-level-xp-candidate.html
```

## Parked source leads

| UI area | Candidate ids | Notes |
|---|---:|---|
| Other level parts | 1680, 1682, 1684, 1685 | Keep documented, but do not render in the current pass. |
| Mulch | 1686, 1688 | Mulch coin stack and counter composite. Next likely UI group after Level is visually confirmed. |
| Dosh | 1701, 1706, 1708 | Large Dosh medallion, coin stack, and counter composite. |
| Hunger | 1697, 1699 | Fork/knife icon and hunger meter composite. |
| Chatbar | 1716, 1718, 1721, 1723, 1724, 1725 | Long input bar, disabled text, panel fills, rounded input shell, curved line. |
| Map | 1757, 1761, 1786, 1790, 1795 | Map panel/path/composite candidates. Exact final map button symbol still needs visual confirmation against the exported grid. |

## Porting rule

Use `src/ui/Core5UiSpriteIds.js` as the code registry for these ids. The clean UI canvas should consume the registry rather than hard-coding one-off ids in the page.

When a symbol is confirmed in the canvas, keep the source id and exported SVG path visible in debug metadata until the layout is stable.

Movement work is parked after the Core5 floor projection checkpoint. The next work should stay on the UI shell unless movement is explicitly resumed.
