.files
########
You know, the basic files under ~/ that begin with a **.** (or _ in windows)

Used to keep my computers and mind in sync.

Vim 8.0.118
-----------
Using Vundle__::

  cd $HOME
  git clone https://github.com/shadoath/dot_files
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall

  cd ~/.vim/bundle/YouCompleteMe
  ./install.py

__ https://github.com/VundleVim/Vundle.vim

You will need `cmake` installed for YouCompleteMe compiling.

From your home directory symlink the dotfiles you would like to use::

  ln -s dot_files/[
    '.bash_profile'
    '.vimrc'
    '.git-completion.bash'
    '.git-prompt.sh'
    '.gitignore_global'
    '.pryrc'
    '.agignore'
  ]

Set up vim folders::

    mkdir ~/.vim/files/{backup,info,swap,undo}


View the /includes folder for extended functionality.

- Functions --------- New terminals, Pull requests, tab-color, and IP binding.

  - Aliases

    - Capistrano ---- Deploying Rails.
    - Git ----------- Short and sweet is the way to git. Also auto complete branch names.
    - Rails --------- ENV, custom ports, bake and more.
    - Solr ---------- Tell the sun what to do.

Also Included:
--------------

ErgoDocs__ keyboard layout using Colemak__

__ https://input.club/configurator-ergodox/
__ https://colemak.com/Learn

*Comment/use/PR and let's both get smarter.*
