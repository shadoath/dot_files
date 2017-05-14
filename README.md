# .files
You know the files under ~/ that begin with .
Keeps my computers and mind in sync.

## Setup
cd $HOME
``` bash
git clone $this_repo dot_files
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim :PluginInstall

cd ~/.vim/bundle/YouCompleteMe
./install.py
```

symlink the dotfiles you would like to use
ln -sv dot_files/[
  '.bash_profile',
  '.vimrc',
  '.git-completion.bash',
  '.git-prompt.sh',
  '.pryrc']

## Includes
.bash_profile is kepts small by spliting into multiple files in the includes folder.
*git_aliass* and *rails_aliases*


#### Also ErgoDocs keyboard layout using Colemak

### Please feel free to use.
Leave comments and let's both get smarter.

#.bash_profile
Oh the aliases
