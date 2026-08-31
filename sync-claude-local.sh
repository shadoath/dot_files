#!/bin/bash
# Symlinks the org-appropriate Claude rules file into git repos/worktrees as
# CLAUDE.local.md:
#   origin under rinsed-org  -> claude-rinsed.md
#   anything else            -> claude-personal.md
# Covers each immediate child of the given root dirs (default: ~/code), or the
# root itself when it is a repo. Nested repos deeper than one level are not
# scanned — pass their parent dir explicitly.
# Re-run after cloning a repo or adding a worktree. CLAUDE.local.md is ignored
# globally via ~/.gitignore_global. A real (non-symlink) CLAUDE.local.md is
# never overwritten.

DOT_FILES="$(cd "$(dirname "$0")" && pwd)"

link_repo() {
  local dir="$1"
  [ -e "$dir/.git" ] || return 1 # repo/worktree root only, not subdirs
  local remote src target
  remote="$(git -C "$dir" remote get-url origin 2>/dev/null)"
  if [[ "$remote" == *rinsed-org/* ]]; then
    src="$DOT_FILES/claude-rinsed.md"
  else
    src="$DOT_FILES/claude-personal.md"
  fi
  target="$dir/CLAUDE.local.md"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "$(basename "$dir"): SKIPPED — real CLAUDE.local.md exists, not overwriting"
    return 0
  fi
  ln -sf "$src" "$target"
  echo "$(basename "$dir") -> $(basename "$src")"
}

if [ $# -gt 0 ]; then
  ROOTS=("$@")
else
  ROOTS=("$HOME/code")
fi

for root in "${ROOTS[@]}"; do
  root="${root%/}"
  link_repo "$root" && continue
  for dir in "$root"/*/; do
    link_repo "${dir%/}"
  done
done
exit 0
