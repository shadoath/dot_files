#!/bin/bash
# Symlinks the org-appropriate Claude rules file into git repos/worktrees as
# CLAUDE.local.md:
#   origin under rinsed-org  -> claude-rinsed.md
#   anything else            -> claude-personal.md
# Covers each immediate child of the given root dirs (default: ~/code and
# ~/personal-code), plus any worktrees under a root's .worktrees/, or the root
# itself when it is a repo. Also scans one extra level inside nest dirs that
# are themselves repos and contain nested repos (whiteboard-works/, nfp/).
# Re-run after cloning a repo or adding a worktree. CLAUDE.local.md is ignored
# globally via ~/.gitignore_global. A real (non-symlink) CLAUDE.local.md is
# never overwritten.

DOT_FILES="$(cd "$(dirname "$0")" && pwd)"

# Immediate children of these dirs are also repos (the parent is a repo too).
NEST_DIRS=(whiteboard-works nfp)

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

scan_children() {
  local parent="$1" dir
  for dir in "$parent"/*/ "$parent"/.worktrees/*/; do
    [ -d "$dir" ] || continue
    link_repo "${dir%/}"
  done
}

if [ $# -gt 0 ]; then
  ROOTS=("$@")
else
  ROOTS=("$HOME/code" "$HOME/personal-code")
fi

for root in "${ROOTS[@]}"; do
  root="${root%/}"
  [ -d "$root" ] || continue
  link_repo "$root"
  scan_children "$root"
  for nest in "${NEST_DIRS[@]}"; do
    [ -d "$root/$nest" ] || continue
    scan_children "$root/$nest"
  done
done
exit 0
