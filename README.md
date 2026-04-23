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

`notify.sh` is referenced directly from the repo (`$HOME/dot_files/notify.sh`) so no symlink is needed.

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

## Tools

- **`commit-velocity`** — Ruby CLI for per-author commit analytics with moving averages, quarterly rollups, and trend arrows. Run `commit-velocity --help` for options.
- **`sync-tab-color.sh` / `spending-tracker.sh` / `notify.sh`** — Claude Code hooks (see above) for iTerm tab coloring per session, token-spend alerts, and terminal notifications.
- **`workflow-remover.sh`** — deletes runs of disabled GitHub Actions workflows. Usage: `workflow-remover.sh <org> <repo>`.

## Keyboard

### [Moonlander ZSA keyboard](https://configure.zsa.io/moonlander/layouts/EnmMA/latest/0) layout using [Colemak+](https://colemak.com/Learn)

![layout](https://github.com/shadoath/dot_files/blob/master/images/moonlander-layer-1.png?raw=true)

Comment/PR and let's both get smarter.
