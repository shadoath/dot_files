# vim: set filetype=bash

alias vi=vim
alias h="history|grep "
alias f="find . |grep "
alias p="ps aux |grep "
alias a="alias  |grep "
alias g="grep -rnw . -e "
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
alias oalias="vim ~/dot_files/includes/base_aliases.zsh"
alias ofunc="vim ~/dot_files/include/functions"
alias ogit=" vim ~/dot_files/include/git_aliases"
alias sbash="source ~/.bash_profile; clear"
alias zbash="source ~/.zshrc; clear"
alias bog="  bundle open"
alias opry=" vim ~/.pryrc"

# Special commands
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

# SSH to AWS
alias saws="ssh sbolton@dragonborn"
alias saws2="ssh ec2-user@52.27.43.136"
alias sawsold="ssh ec2-user@aws"
alias sd="  ssh ubuntu@34.209.33.85"
alias sp="  ssh ubuntu@aws_news"
alias spt=" ssh ubuntu@52.11.165.25"
alias jsp=" ssh ubuntu@aws_tj"
alias tsp=" ssh ec2-user@test"
alias swp=" ssh sbolton@wp" #WP client
alias rsp=" ssh ubuntu@rails"
alias rsp2=" ssh ubuntu@18.237.143.24"
alias swowza=" ssh ec2-user@54.191.120.51"
alias siola=" ssh sbolton@iolaregister"
alias sbwd=" ssh ubuntu@bwd"
alias sbw=" ssh ubuntu@bw"

# Max Ave
alias smaxwp=" ssh -t root@198.58.126.101"
alias smaxapi="ssh -t root@45.79.108.188"

# Time
alias retime="sudo ntpdate time.nist.gov"
alias msttime="sudo rm /etc/localtime; sudo ln -s /usr/share/zoneinfo/America/Denver /etc/localtime"
alias fixtime="sudo timedatectl set-timezone America/Denver"

# Mac OS 10.12.6 (16G29)
alias clear_dns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;"

alias cdd="  cd ~/dot_files"
alias bw="  cd ~/personal-code/biteworthy"
alias dgo="  cd ~/code/dgo"
alias nsr="  cd ~/code/nsr"
alias saxo="  cd ~/code/saxotech_importer"
alias iola="  cd ~/code/iolaregister/FoundationPress"
alias insight="  cd ~/code/insight"

# ls aliases
alias ll="ls -lh"
alias la="ls -lah"
alias ls="ls -la"
