# vim: set filetype=bash
alias vi=vim
alias h="history | grep "
alias f="find . | grep "
alias p="ps aux | grep "
alias a="alias  | grep "
alias g="grep -rnw . -e " # Go find me some text [info](https://explainshell.com/explain?cmd=grep+-rnw+.+-e+text)
alias c="clear"
alias {:q,:Q,:qa}="exit"
alias bs="bundle show |grep "
alias fing="sudo"
alias Kill="sudo kill -s SIGTERM "

# Quick edit
alias oh='   sudo vim ~/hosts.base && build_hosts'
alias ohp='  sudo vim ~/hosts.personal && build_hosts'
alias bh='   build_hosts'
alias ossh=' sudo vim ~/.ssh/config'
alias ovim=" vim ~/.vimrc"
alias ozsh=" vim ~/.zshrc"
alias obash="vim ~/.bash_profile"
alias oalias="vim ~/dot_files/include/base_aliases.zsh"
alias ofunc="vim ~/dot_files/include/functions.zsh"
alias ogit=" vim ~/dot_files/include/git_aliases.zsh"
alias sbash="source ~/.bash_profile; clear"
alias zbash="source ~/.zshrc; clear"
alias bog="  bundle open"
alias psd="open -a /Applications/Adobe\ Photoshop\ 2020/Adobe\ Photoshop\ 2020.app"
alias opry=" vim ~/.pryrc"
alias myvhost="vim /usr/local/etc/httpd/extra/httpd-vhosts.conf"
alias oprompt="vim ~/dot_files/shadoath.zsh-theme"
# Server quick edit
alias vhost="sudo vim /etc/httpd/conf.d/http-vhosts.conf"

# rails
# alias rake='noglob rake'

# Special commands
## delete all files starting with ._
alias no_ds="find . -type f -name '._*' -exec rm {} +"

# Laravel
alias phps="php artisan serve"

# Servers
alias sql=" mysql.server start"
alias ssnr="sudo service nginx restart"
alias ssmr="sudo service mysql restart"
alias ssrn="sudo systemctl restart nginx"
alias sshr="sudo service httpd restart"
alias ssar="sudo service apache2 restart"

# Quick ssh commands
alias ssfs=" ssh skyfox@sfs"              # SkyFoxStudios

# Prenda
alias prenda="cd /code/prendaworld/prendaworld"
alias meteor-dev="meteor run --settings dev-settings.json"
### Must have `brew services start mongodb-community@4.4` running
alias meteor-test="MONGO_URL=mongodb://127.0.0.1:27017/meteor-test meteor --settings dev-settings.json"

# Time
alias retime="sudo ntpdate time.nist.gov"
alias msttime="sudo rm /etc/localtime; sudo ln -s /usr/share/zoneinfo/America/Denver /etc/localtime"
alias fixtime="sudo timedatectl set-timezone America/Denver"

# Mac OS 10.12.6
alias clear_dns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;"

# Quick jumps
alias cdd="   cd ~/dot_files"
alias bw="    cd ~/personal-code/biteworthy"
alias dgo="   cd ~/code/dgo"
alias apro="  cd ~/code/adventurepro.us"

alias nsr="   cd ~/code/nsr"
alias saxo="  cd ~/code/saxotech_importer"
alias iola="  cd ~/code/iolaregister/FoundationPress"
alias kbi=" cd ~/code/koganbuilders/bci-ignition"
alias insight="cd ~/code/insight"
alias tools="cd ~/code/tools"

# ls aliases
alias ll="ls -lh"
alias la="ls -lah"
alias ls="ls -la"
