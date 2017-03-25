[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Show folder in tabs
if [ $ITERM_SESSION_ID -a -z "$PROMPT_COMMAND" ]; then
  # export PROMPT_COMMAND="echo -ne "${PWD##*/}"; ":"$PROMPT_COMMAND";
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi
# Required
export EDITOR=vim
alias vi=vim
alias h="history|grep "
alias f="find . |grep "
alias p="ps aux |grep "
alias a="alias  |grep "
alias fing="sudo"

# Quick edit
alias oh='   sudo vim /etc/hosts'
alias ossh=' sudo vim /Users/sbolton/.ssh/config'
alias ovim=" vim ~/.vimrc"
alias obash="vim ~/.bash_profile"
alias sbash="source ~/.bash_profile; clear"
alias bog="  bundle open"
alias opry=" vim ~/.pryrc"

# Servers
alias ssnr="sudo service nginx restart"
alias sshr="sudo service httpd restart"
alias ssar="sudo service apache2 restart"
alias sd="  ssh deploy@dev"
alias sp="  ssh ubuntu@aws_news"
alias jsp=" ssh ubuntu@aws_tj"
# Time
alias retime="sudo ntpdate time.nist.gov"
alias msttime="sudo rm /etc/localtime; sudo ln -s /usr/share/zoneinfo/America/Denver /etc/localtime"
alias fixtime="sudo timedatectl set-timezone America/Denver"

# Movement
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."

# ls aliases
alias ll="ls -lh"
alias la="ls -lah"
alias ls="ls -la"

[[ -s "$HOME/dot_files/include/git_aliases" ]] && source "$HOME/dot_files/include/git_aliases" # Load the default .profile
[[ -s "$HOME/dot_files/include/rails_aliases" ]] && source "$HOME/dot_files/include/rails_aliases" # Load the default .profile
#GemFury
alias gpf="git push fury master"

#capistrano
alias csd="cap staging deploy"
alias cpd="cap production deploy"
alias jcsd="cap journal_staging deploy"
alias jcpd="cap journal_production deploy"
alias pcsd="cap prt_staging deploy"
alias pcpd="cap prt_production deploy"

# Newsites
alias JRD=" RAILS_ENV=journal_dev"
alias JRS=" RAILS_ENV=journal_staging"
alias JRP=" RAILS_ENV=journal_production"
alias jrs=" JRD rails s -p 3001 -P 42342"

alias PRD=" RAILS_ENV=prt_dev"
alias PRS=" RAILS_ENV=prt_staging"
alias PRP=" RAILS_ENV=prt_production"
alias prs=" PRD rails s -p 3002 -P 42344"

alias saxo_m="bundle exec rake saxotech_importer_engine:install:migrations"

#solr
alias sunup="   bake sunspot:solr:start"
alias sundown=" bake sunspot:solr:stop"
alias sunburn=" bake sunspot:solr:run"
alias sunset="  bake sunspot:solr:reindex"
alias suns="    ps aux | grep solr"
alias sunblock='find . -type f -name write.lock -delete'

# Better terminal output
source ~/.git-prompt.sh
export PS1="\e[1;36m\]Bolton: \e[0;31m\W\e[m\e[0;32m\$(__git_ps1)\e[0;33m\]$ \e[0;37m\]"

# Setting PATH for Python 3.5
# The orginal version is saved in .bash_profile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
# export PATH

#DNS cache clear ioX 10.9
alias clear_dns="sudo killall -HUP mDNSResponder"


### function opens new tab in same directory. if this functionality starts working again in iterm, then i will no longer need this
function nt() {
  open . -a "iterm 2"
}
# open git directory on github
function gg() {
  URL=$(cat .git/config | grep github | sed -E "s/^.*(github\.com):(.*)(\.git)?/http:\/\/\1\/\2/")
  open $URL
}
function pr() {
  open "https://github.com/pulls?utf8=%E2%9C%93&q=is%3Aopen+is%3Apr+user%3ABallantineDigitalMedia"
}
function prn(){
  USER=$(cat .git/config | grep github | sed -E "s/^.*(github\.com):(.*)\/(.*)\.git?/\2/")
  REPO=$(cat .git/config | grep github | sed -E "s/^.*(github\.com):(.*)\/(.*)\.git?/\3/")
  BRANCH=$(__git_ps1 | tr -d "()" | tr -d "[:space:]")
  open "https://github.com/$USER/$REPO/compare/$BRANCH?expand=1"
}

function rsb() {
  IP=$(ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -Eo "([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1" | grep -m1 "")
  rails s -b $IP
}



function GO() {
  open . -a "iterm 2" | rs
  open . -a "iterm 2" | vim
  open . -a "iterm 2" | gba && gpo
}

function sdot() {
  cp ~/.bash_profile ~/dot_files/.bash_profile
  cp ~/.vimrc        ~/dot_files/.vimrc
  cp ~/.pryrc        ~/dot_files/.pryrc
  cd ~/dot_files
}

symlink() {
  cd ~
  rm $1
  ln -sv dot_files/$1 $1
}

tab-color() {
   echo -ne "\033]6;1;bg;red;brightness;$1\a"
   echo -ne "\033]6;1;bg;green;brightness;$2\a"
   echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}
tab-reset() {
  echo -ne "\033]6;1;bg;*;default\a"
}
color-ssh() {
   if [[ -n "$ITERM_SESSION_ID" ]]; then
     if [[ "$*" == *"dev"* ]]; then
       tab-color  255 99 71 # Tomato
     elif [[ "$*" == *"db"* ]]; then
       tab-color 255 51 255 #HOT PINK
     elif [[ "$*" == *"news"* ]] || [[ "$*" == *"nsr"* ]]; then
       tab-color 255 51 51 # RED
     else
       tab-color  0 255 0 # GREEN
     fi
     ssh $*
   fi
}
alias ssh=color-ssh
alias noc="tab-reset"
