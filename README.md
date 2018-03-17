# .files
You know the files under ~/ that begin with .
Keeps my computers and mind in sync.

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

brew install the_silver_searcher
or
sudo  apt-get install silversearcher-ag
```
You will also need `cmake` installed.

symlink the dotfiles you would like to use:
```
ln -s dot_files/[
  '.bash_profile'
  '.vimrc'
  '.git-completion.bash'
  '.git-prompt.sh'
  '.gitignore_global'
  '.pryrc'
  '.agignore'
]
```

Set up vim folders:
```
mkdir ~/.vim/files/{backup,info,swap,undo}
```

##Windows specific
https://chocolatey.org/install

View the /includes folder for extended functionality.
* Functions --------- New terminals, Pull requests, YML updates, tab-color, and rails IP binding.
  * Aliases
    * Capistrano ---- Deploying Rails.
    * Git ----------- Short and sweet is the way to git. Also auto complete branch names.
    * Rails --------- ENV, custom ports, bake and more.
    * Solr ---------- Tell the sun what to do.

### [ErgoDocs keyboard](https://input.club/configurator-ergodox/) layout using [Colemak](https://colemak.com/Learn)
To install on [OSX](https://github.com/kiibohd/controller/wiki/Loading-DFU-Firmware#mac-osx):
 - Put Keyboard into debug (paperclip + button on bottom)
 - Run dfu-util -D <.dfu.bin> on each KB (left/right)
 - ???
 - Profit

### Comment and let's both get smarter.
