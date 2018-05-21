[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Show folder in tabs
if [ $ITERM_SESSION_ID -a -z "$PROMPT_COMMAND" ]; then
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
shopt -s histappend dotglob

# Required
export EDITOR=vim
alias vi=vim
alias h="history|grep "
alias f="find . |grep "
alias p="ps aux |grep "
alias a="alias  |grep "
alias c="clear"
alias :q="exit"
alias bs="bundle show |grep "
alias fing="sudo"
alias Kill="sudo kill -s SIGTERM "

# Quick edit
alias oh='   sudo vim /etc/hosts'
alias ossh=' sudo vim ~/.ssh/config'
alias ovim=" vim ~/.vimrc"
alias obash="vim ~/.bash_profile"
alias ofunc="vim ~/dot_files/include/functions"
alias sbash="source ~/.bash_profile; clear"
alias bog="  bundle open"
alias opry=" vim ~/.pryrc"

# Servers
alias ssnr="sudo service nginx restart"
alias ssrn="sudo systemctl restart nginx"
alias sshr="sudo service httpd restart"
alias ssar="sudo service apache2 restart"

# SSH to AWS
alias saws="ssh ec2-user@hostdragon"
alias sawsold="ssh ec2-user@aws"
alias sd="  ssh ubuntu@34.209.33.85"
alias sp="  ssh ubuntu@aws_news"
alias jsp=" ssh ubuntu@aws_tj"
alias jsp2=" ssh ubuntu@54.200.48.115"
alias tsp=" ssh ec2-user@test"
alias rsp=" ssh ubuntu@rails"
alias sbwd=" ssh ubuntu@bwd"

# Time
alias retime="sudo ntpdate time.nist.gov"
alias msttime="sudo rm /etc/localtime; sudo ln -s /usr/share/zoneinfo/America/Denver /etc/localtime"
alias fixtime="sudo timedatectl set-timezone America/Denver"

# Mac OS 10.12.6 (16G29)
alias clear_dns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;"

# Movement
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias cdd="  cd ~/dot_files"

# ls aliases
alias ll="ls -lh"
alias la="ls -lah"
alias ls="ls -la"

[[ -s "$HOME/dot_files/include/git_aliases" ]]        && source "$HOME/dot_files/include/git_aliases"
[[ -s "$HOME/dot_files/include/rails_aliases" ]]      && source "$HOME/dot_files/include/rails_aliases"
[[ -s "$HOME/dot_files/include/capistrano_aliases" ]] && source "$HOME/dot_files/include/capistrano_aliases"
[[ -s "$HOME/dot_files/include/solr_aliases" ]]       && source "$HOME/dot_files/include/solr_aliases"
[[ -s "$HOME/dot_files/include/functions" ]]          && source "$HOME/dot_files/include/functions"
#[[ -s "$HOME/dot_files/include/_aliases" ]] && source "$HOME/dot_files/include/_aliases"

# Better terminal output
cyan=$(tput setaf 6) #36
white=$(tput setaf 7) #37
red=$(tput setaf 1)  #31
green=$(tput setaf 2) #32
yellow=$(tput setaf 3) #33

source ~/.git-prompt.sh
# PS1 uses [] so it doesn't overwrite long command lines and now does word wrap
export PS1="\[$cyan\]`whoami` \[$red\]\W\[\e[m\]\[$green\]\$(__git_ps1)\[$yellow\]\$ \[$white\]"

# cd "/data"
