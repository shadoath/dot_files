---
description: Set the iTerm2 tab color for this terminal, or reset it back to the directory-derived color. Use when Skylar runs /sb-tab-color, or asks to change, pin, or reset the tab color.
---

# Set the tab color

Run `~/dot_files/set-tab-color.sh` with the argument Skylar gave.

- A color name or hex: `~/dot_files/set-tab-color.sh purple`, `~/dot_files/set-tab-color.sh '#48968c'`
- `reset` restores the directory-derived color right away: `~/dot_files/set-tab-color.sh reset`

Notes:

- The color is pinned for this terminal, so the Stop hook won't overwrite it. The pin clears on `reset`, when the
  terminal exits, on reboot, or after half a day with no session using it. `/clear` and `resume` keep it.
- Without a pin the color comes from the directory, and only if it asks for one: a color name in the repo root's own name (`web-blue`, `teal-tools`) sets that color, and every other directory stays at iTerm's default. Pinning is the only way to color a tab in a directory with no color name.
- Names are red, orange, yellow, green, blue, purple, gray/grey, pink, teal, cyan, brown, fuchsia, indigo, white, black, mint, magenta, lime, coral, salmon, gold, navy, maroon, olive. Any other value has to be a `#rrggbb` hex.
- The first five match iTerm's own swatch row, so `red` here, a `web-red` tab and right-click → red are all the same color.
- If no argument was given, ask which color, and mention that `reset` restores the directory-derived one.
- The script exits 2 on an unknown color and prints the reason — relay that rather than guessing a substitute.
