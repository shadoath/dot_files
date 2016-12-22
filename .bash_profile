[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export EDITOR=vim

alias vi=vim
alias h="history|grep "
alias f="find . |grep "
alias p="ps aux |grep "
alias fing="sudo"

alias oh='sudo vim /etc/hosts'
alias ovim="  vim ~/.vimrc"
alias obash=" vim ~/.bash_profile"
alias sbash=" source ~/.bash_profile; clear"
alias bog="   bundle open"
alias opry="  vim ~/.pryrc"

#servers
alias RP="RAILS_ENV=production"
alias RS="RAILS_ENV=staging"
alias RT="RAILS_ENV=test"
alias ssar="sudo service apache2 restart"
alias sshr="sudo service httpd restart"
alias ssnr="sudo service nginx restart"
alias sd="  ssh deploy@dev"
alias sp="  ssh deploy@nsr"
alias retime="sudo ntpdate time.nist.gov"
alias msttime="sudo rm /etc/localtime; sudo ln -s /usr/share/zoneinfo/America/Denver /etc/localtime"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# ls aliases
alias ll="ls -lh"
alias la="ls -lah"
alias ls="ls -la"

#git                                     #Think this when Typing
alias gs="  git status"
alias gd="  git diff"
alias gc="  git commit"
alias gcam="git commit -am "
alias gcN=" git commit --no-verify"
alias gco=" git checkout"
alias gbn=" git checkout -b"             #Git Branch New
alias gcm=" git checkout master"
alias gcs=" git checkout staging"
alias ga="  git add"
alias gap=" git add --patch"
alias gaa=" git add ."
alias gaA=" git add . --all"
alias gr="  git rm"
alias gu="  git unstage"
alias grv=" git remote -v"
alias gba=" git branch -a"
alias gbd=" git branch -d"
alias gbD=" git branch -D"
alias gbp=" git fetch origin --prune"
alias gpo=" git pull origin"
alias gpom="git pull origin master"
alias gpos="git pull origin staging"
alias gPom="git push origin master"
alias gPos="git push origin staging"
alias gPo=" git push origin"
alias gPoN="git push origin --no-verify"
alias gpn=" git push --set-upstream origin --no-verify"
alias gm="  git merge"
alias gms=" git merge staging"
alias gmm=" git merge master"
alias gl="  git log"
alias gl="  git log --pretty=format:'%C(Yellow)%h%C(reset) %s'"
alias glm=" git log --author='$(git config user.name)' --pretty=format:'%C(yellow)%h%C(reset) - %an [%C(green)%ar%C(reset)] %s'"
alias glmt="git log --author='$(git config user.name)' --pretty=format:'[%C(green)%ar%C(reset)] %s'"
alias overview='open "https://github.com/shadoath?tab=overview&from='$(date '+%Y-%m-%d')'"'

#GemFury
alias gpf="git push fury master"

#capistrano
alias csd="cap staging deploy"
alias cpd="cap production deploy"

#rails and rake
alias b="    bundle"
alias rs="   rails s"
alias rc="   rails c"
alias rr="   rake routes"
alias rdbm=" rake db:migrate"
alias rdbr=" rake db:rollback"
alias rdbs=" rake db:seed"
alias fudb=" rake db:drop db:create db:migrate"
alias fixdb="rake db:drop db:create db:migrate db:seed"
alias adubs='rake; rubocop .'

#solr
alias sunup="  rake sunspot:solr:start"
alias sundown="rake sunspot:solr:stop"
alias sunburn="rake sunspot:solr:run"
alias sunset=" rake sunspot:solr:reindex"
alias suns="   ps aux | grep solr"

# Better terminal output
source ~/.git-prompt.sh
export PS1="\e[1;36m\]Bolton: \e[0;31m\W\e[m\e[0;32m\$(__git_ps1)\e[0;33m\]$ \e[0;37m\]"

#Git autocomplete
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
  __git_complete gco _git_checkout
  __git_complete gm  _git_checkout
  __git_complete gPo _git_checkout
  __git_complete gpo _git_checkout
  __git_complete gpn _git_checkout
  __git_complete gbd _git_checkout
fi


# Setting PATH for Python 3.5
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
export PATH

#DNS cache clear IOX 10.9
alias clear_dns="sudo killall -HUP mDNSResponder"

# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Show folder in tabs
if [ $ITERM_SESSION_ID -a -z "$PROMPT_COMMAND" ]; then
  export PROMPT_COMMAND="echo -ne "${PWD##*/}"; ":"$PROMPT_COMMAND";
fi

# open git directory on github
function gg() {
  URL=$(cat .git/config | grep github | sed -E "s/^.*(github\.com):(.*)(\.git)?/http:\/\/\1\/\2/")
  open $URL
}
### function opens new tab in same directory. if this functionality starts working again in iterm, then i will no longer need this
function nt() {
  open . -a "iterm 2"
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

tab-color() {
   echo -ne "\033]6;1;bg;red;brightness;$1\a"
   echo -ne "\033]6;1;bg;green;brightness;$2\a"
   echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}
alias noc="tab-reset"
tab-reset() {
  echo -ne "\033]6;1;bg;*;default\a"
}
color-ssh() {
   if [[ -n "$ITERM_SESSION_ID" ]]; then
     if [[ "$*" == *"dev"* ]]; then
       tab-color  255 99 71 # TomAtO
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
