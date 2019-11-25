# .files
You know, the basic files under `~/` that begin with a `.`

Used to keep my computers and mind in sync.

## Setup for Vim 8
Using Vundle https://github.com/VundleVim/Vundle.vim
``` bash
cd $HOME
git clone https://github.com/shadoath/dot_files
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
`sudo apt install zsh` OR `brew install zsh zsh-completions`
Make zsh the default shell:
`chsh -s $(which zsh)`

`sh -c "$(curl -fsSL https://raw.github.com/shadoath/oh-my-zsh/master/tools/install.sh)"`


From your `~/` home directory, symlink the dot_files:
```bash
mv .bash_profile .bash_profile_original
ln -s ~/dot_files/.zshrc
ln -s /Users/sbolton/dot_files/shadoath.zsh-theme /Users/sbolton/.oh-my-zsh/custom/themes/shadoath.zsh-theme
ln -s ~/dot_files/.vimrc
ln -s ~/dot_files/.gitconfig
ln -s ~/dot_files/.gitignore_global
ln -s ~/dot_files/.git-prompt.sh
ln -s ~/dot_files/.git-completion.bash
ln -s ~/dot_files/.pryrc
ln -s ~/dot_files/.agignore
```


```bash
brew install the_silver_searcher
or
sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
sudo apt-get install silversearcher-ag
or
sudo yum install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
sudo yum install silversearcher-ag
or
[manual](https://gist.github.com/rkaneko/988c3964a3177eb69b75)
```

You will also need `cmake` installed.


Set up vim folders:
```
mkdir ~/.vim/files && mkdir ~/.vim/files/{backup,info,swap,undo}
```

Install fzf (fuzzy find)
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
source ~/.bash_profile
```

Have git save user/pass
```bash
git config credential.helper store
```

View the /includes folder for extended functionality.
* Functions --------- New terminals, Pull requests, YML/hosts s3 sync, tab-color, and IP binding.
  * Aliases
    * Capistrano ---- Deploying Rails.
    * Rails --------- ENV, custom ports, bake and more.
    * Solr ---------- Tell the sun what to do.

## Additional Files
### [ErgoDocs keyboard](https://input.club/configurator-ergodox/) layout using [Colemak](https://colemak.com/Learn)
To install on [OSX](https://github.com/kiibohd/controller/wiki/Loading-DFU-Firmware#mac-osx):
 - Put Keyboard into debug (paperclip + button on bottom)
 - Run dfu-util -D <.dfu.bin> on each KB (left/right)
[PNG](https://github.com/shadoath/dot_files/blob/master/vim-colemak.jpg) for reference

### OTF [Font kit](https://github.com/shadoath/dot_files/blob/master/include/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf) for [nerd fonts](https://github.com/ryanoasis/nerd-fonts)

### Synergy config for home Windows/OSX screen setup

Comment/PR and let's both get smarter.
