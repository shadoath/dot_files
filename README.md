# .files
You know the files under ~/ that begin with a .

Used to keep my computers and mind in sync.

# Vim 8.0.118
## Setup
Using Vundle https://github.com/VundleVim/Vundle.vim
``` bash
cd $HOME
git clone https://github.com/shadoath/dot_files
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

cd ~/.vim/bundle/YouCompleteMe
./install.py
```
You will also need `cmake` installed

symlink the dotfiles you would like to use
```
ln -sv dot_files/[
  '.bash_profile'
  '.vimrc'
  '.git-completion.bash'
  '.git-prompt.sh'
  '.pryrc'
]
```

View the /includes folder for extended functionality.
* Functions       --  New terminals, Pull requests, tab-color, and IP binding
  * Aliases
    * Capistrano  -- Deploying Rails
    * Git         -- Short and sweet is the way to git. Also auto complete branch names
    * Rails       -- ENV, custom ports, bake and more
    * Solr        -- Tell the sun what to do

### [ErgoDocs keyboard](https://input.club/configurator-ergodox/) layout using [Colemak](https://colemak.com/Learn)

### Please comment and let's both get smarter.
