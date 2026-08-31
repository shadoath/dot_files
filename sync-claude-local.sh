#!/bin/bash
# Symlinks the org-appropriate Claude rules file into every git repo/worktree
# under the given root dirs (default: ~/code) as CLAUDE.local.md:
#   origin under rinsed-org  -> claude-rinsed.md
#   anything else            -> claude-personal.md
# Re-run after cloning a repo or adding a worktree. CLAUDE.local.md is ignored
# globally via ~/.gitignore_global.

DOT_FILES="$(cd "$(dirname "$0")" && pwd)"

if [ $# -gt 0 ]; then
  ROOTS=("$@")
else
  ROOTS=("$HOME/code")
fi

for root in "${ROOTS[@]}"; do
  for dir in "$root"/*/; do
    dir="${dir%/}"
    git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1 || continue
    remote="$(git -C "$dir" remote get-url origin 2>/dev/null)"
    if [[ "$remote" == *rinsed-org/* ]]; then
      src="$DOT_FILES/claude-rinsed.md"
    else
      src="$DOT_FILES/claude-personal.md"
    fi
    ln -sf "$src" "$dir/CLAUDE.local.md"
    echo "$(basename "$dir") -> $(basename "$src")"
  done
done
