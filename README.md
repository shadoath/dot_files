# .files

You know, the basic files under `~/` that begin with a `.`
Used to keep my computers and mind in sync.

## Setup for Vim 8

Note I use VSCode now, so this is mostly for Servers.

Start with Vundle https://github.com/VundleVim/Vundle.vim

```bash
cd $HOME
git clone https://github.com/shadoath/dot_files
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Set up vim folders:
`mkdir ~/.vim/files && mkdir ~/.vim/files/{backup,info,swap,undo}`

### Install ZSH

macOS:

```bash
brew install zsh zsh-completions
```

Linux (server):

```bash
sudo apt install zsh           # Debian/Ubuntu
# sudo yum install zsh         # RHEL/CentOS
```

Then install oh-my-zsh and make zsh the default shell:

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)
```

Custom ZSH plugins

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Customization

From your `~/` home directory, symlink the dot_files:

```bash
mv .zshrc .zshrc_original
ln -s ~/dot_files/.zshrc
ln -s ~/dot_files/shadoath.zsh-theme ~/.oh-my-zsh/custom/themes/shadoath.zsh-theme
ln -s ~/dot_files/.vimrc
ln -s ~/dot_files/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global  # git won't read it otherwise
ln -s ~/dot_files/.git-prompt.sh
ln -s ~/dot_files/.agignore
mkdir -p ~/bin
ln -s ~/dot_files/commit-velocity ~/bin/commit-velocity
```

### Claude Code Hooks

Symlink hook scripts so Claude Code's global settings can reference them:

```bash
mkdir -p ~/.claude/hooks
ln -sf ~/dot_files/sync-tab-color.sh ~/.claude/hooks/sync-tab-color.sh
ln -sf ~/dot_files/spending-tracker.sh ~/.claude/hooks/spending-tracker.sh
```

`notify.sh` and `set-tab-color.sh` are referenced directly from the repo (`$HOME/dot_files/...`) so they need no symlink.
`sync-tab-color.sh` finds `set-tab-color.sh` next to its own real path, so the symlink above is enough for both.

### Tab colors

Tab color comes from the directory: a `web-<color>` worktree forces that color, anything else hashes its repo
root so a given directory always looks the same. The palette is iTerm's own tab-color swatch row, so an
automatic color and one picked by right-clicking a tab are the same color. Widen the palette in
iTerm Settings → Advanced → search "tab color" (`TabColorMenuOptions`); the hook picks up new swatches with no
code change, and more swatches means fewer directories sharing a color.

Override it by hand with `set-tab-color.sh <name|#rrggbb>` or the `/sb-tab-color` command. The choice is pinned
for that terminal so the Stop hook won't overwrite it, and clears on `set-tab-color.sh reset` — which repaints the
directory-derived color immediately rather than waiting for the next hook — or when the terminal exits, on
reboot, or after half a day unused. Colour names resolve to the matching swatch, so `red` and a
`web-red` tab render identically.

### Claude Code Commands

Symlink the slash-command directory so Claude Code picks up the `sb-*` commands:

```bash
mkdir -p ~/.claude
ln -s ~/dot_files/claude-commands ~/.claude/commands
```

### Claude Code Global Instructions

Symlink the global `CLAUDE.md` so it's version-tracked in this repo:

```bash
mkdir -p ~/.claude
ln -sf ~/dot_files/claude-global.md ~/.claude/CLAUDE.md
```

`claude-global.md` holds the universal basics. Org-specific rules are split into
`claude-rinsed.md` (rinsed-org repos) and `claude-personal.md` (everything else),
symlinked into each repo/worktree as `CLAUDE.local.md`:

```bash
~/dot_files/sync-claude-local.sh          # defaults to ~/code
~/dot_files/sync-claude-local.sh ~/other  # or pass root dirs
```

It links each immediate child of the root dirs (or the root itself if it's a repo);
nested repos deeper than one level need their parent passed explicitly. Re-run it
after cloning a repo or adding a worktree. `CLAUDE.local.md` is ignored everywhere
via `~/.gitignore_global`, and a real (non-symlink) `CLAUDE.local.md` is never
overwritten.

### Claude Code Global Settings

Symlink the global `settings.json` (permissions, hooks, plugins, defaults) so it's
version-tracked in this repo. Machine-local overrides go in `~/.claude/settings.local.json`,
which is intentionally left untracked.

```bash
mkdir -p ~/.claude
ln -sf ~/dot_files/claude-settings.json ~/.claude/settings.json
```

### Better search with Ag

macOS:

```bash
brew install the_silver_searcher
```

Linux (server):

```bash
sudo apt-get install silversearcher-ag    # Debian/Ubuntu
# sudo yum install the_silver_searcher    # RHEL/CentOS (EPEL)
```

### Install fzf (fuzzy find)

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

Install all vim plugins:

```bash
vim +PluginInstall +qall
```

Load your profile settings:

```bash
source ~/.zshrc
```

Have git save user/pass

```bash
git config credential.helper store
```

## What's in `include/`

- `functions.zsh` — iTerm tab helpers, PR opener, rails bind-to-LAN, etc.
- `base_aliases.zsh` — general shell shortcuts
- `rails_aliases.zsh` — `be`, `rs`, `rc`, db reset chains
- `git_aliases.zsh` — `g*` aliases plus `GBN()` (Claude-drafted commit messages)
- `git_recent.zsh` — reflog-based branch picker
- `better-git-branch.sh` — branch table with PR status and terminal links (via `gh`)
- `dumpclipboard.rb` — clipboard image → resized PNG for AI consumption
- `personal.zsh` — gitignored, machine-local personal config (see below)
- `rinsed.zsh` — gitignored, machine-local work config (see below)

## Personal vs. work config

This repo is public and used on both personal and work machines, so anything
work- or personal-specific stays out of tracked files:

- `include/rinsed.zsh` and `include/personal.zsh` are gitignored —
  create them locally per machine with whatever aliases, env vars, or
  secrets belong there. `.zshrc` sources each with an existence guard
  (`[[ -f ... ]] && source ...`) so a machine missing one just skips it.
- `include/personal.zsh` was previously named `personal_aliases.zsh`. Because
  the file is gitignored, git can't rename it for you — on a machine still
  holding the old name, run
  `mv ~/dot_files/include/personal_aliases.zsh ~/dot_files/include/personal.zsh`
  or its contents stop loading (silently, since the guard just skips a missing
  file). Both names stay gitignored, so nothing leaks in the meantime.
- `.gitconfig` does the same for git identity via
  `includeIf "gitdir:~/code/"` pointing at a gitignored `~/.gitconfig-work`.
- Tracked files (`base_aliases.zsh`, `.zshrc`, etc.) should stay generic —
  safe to run and safe to be public on any machine.

## Tools

- **`commit-velocity`** — Ruby CLI for per-author commit analytics with moving averages, quarterly rollups, and trend arrows. Run `commit-velocity --help` for options.
- **`sync-tab-color.sh` / `set-tab-color.sh` / `spending-tracker.sh` / `notify.sh`** — Claude Code hooks (see above) for iTerm tab coloring per session, manual tab-color overrides, token-spend alerts, and terminal notifications.
- **`workflow-remover.sh`** — deletes runs of disabled GitHub Actions workflows. Usage: `workflow-remover.sh <org> <repo>`.

## Keyboard

### [Moonlander ZSA keyboard](https://configure.zsa.io/moonlander/layouts/EnmMA/latest/0) layout using [Colemak+](https://colemak.com/Learn)

![layout](https://github.com/shadoath/dot_files/blob/master/images/moonlander-layer-1.png?raw=true)

Comment/PR and let's both get smarter.
