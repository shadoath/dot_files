---
description: Set the iTerm2 tab color for this terminal, or reset it back to the directory-derived color. Use when Skylar runs /sb-tab-color, or asks to change, pin, or reset the tab color.
---

# Set the tab color

Run `~/dot_files/set-tab-color.sh` with the argument Skylar gave.

- A color name or hex: `~/dot_files/set-tab-color.sh purple`, `~/dot_files/set-tab-color.sh '#4dd6c9'`
- `reset` hands the tab back to the hook: `~/dot_files/set-tab-color.sh reset`

Notes:

- The color is pinned for this terminal, so the Stop hook won't overwrite it. The pin clears on `reset`, when the session ends, or on reboot.
- Without a pin the color comes from the directory: `web-<color>` worktrees force their own color, everything else hashes its repo root against iTerm's tab-color swatches.
- The palette is iTerm's own swatch row (`TabColorMenuOptions`), so a color set here matches one picked by right-clicking the tab. Skylar can widen it in iTerm Settings → Advanced → search "tab color".
- If no argument was given, ask which color, and mention that `reset` restores the directory-derived one.
- The script exits 2 on an unknown color and prints the reason — relay that rather than guessing a substitute.
