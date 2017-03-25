# .files
You know the files under ~/ that begin with .
Used to keep my computers and mind in sync.

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
  '.bash_profile'
  '.vimrc'
  '.git-completion.bash'
  '.git-prompt.sh'
  '.pryrc'
]

after my .bash_profile reached 200+ lines it was split into the includes folder.

#### Also ErgoDocs keyboard layout using Colemak

### Please feel free to use.
Leave comments and let's both get smarter.

# Vim 7.4.488 Setup
Using Vundle https://github.com/VundleVim/Vundle.vim

#.bash_profile
Oh the aliases

