[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

alias vi=vim
alias fucking="sudo"

#servers
alias ssnr='sudo service nginx restart'
alias RP='RAILS_ENV=production'
alias RS='RAILS_ENV=staging'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# ls aliases
alias ll='ls -lh'
alias la='ls -lah'

#git
alias gl='git log'
alias gs='git status'
alias gc='git commit'
alias gco='git checkout'
alias gaa='git add .'
alias gaA='git add . --all'
alias ga='git add'
alias gr='git rm'
alias gd='git diff'
alias gba='git branch -a'
alias gbp='git fetch origin --prune'
alias gcam='git commit -am '
alias gcN='git commit --no-verify'
alias gpo='git pull origin'
alias gPo='git push origin'
alias gPoN='git push origin --no-verify'
alias gpom='git pull origin master'
alias gPom='git push origin master'
alias gpos='git pull origin staging'
alias gPos='git push origin staging'
alias gm='git merge'
alias gms='git merge staging'
alias gmm='git merge master'
alias gcm='git checkout master'
alias gcs='git checkout staging'

#GemFury
alias gpf='git push fury master'

#capistrano
alias csd='cap staging deploy'
alias cpd='cap production deploy'

#rails
alias fixdb='rake db:drop db:create db:migrate db:seed'
alias fudb='rake db:drop db:create db:migrate'
alias fixrails='bundle
fixdb
rails s'
alias rs='rails s'
alias rc='rails c'
alias rr='rake routes'
alias rdbm='rake db:migrate'
alias rdbs='rake db:seed'
#solr
alias sunup='rake sunspot:solr:start'
alias sundown='rake sunspot:solr:stop'
alias sunburn='rake sunspot:solr:run'
alias sunset='rake sunspot:solr:reindex'
alias sunps='ps aux | grep solr'

# Setting PATH for Python 3.5
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
export PATH

#DNS cache clear IOX 10.9
alias clear_dns="sudo killall -HUP mDNSResponder"

# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Show folder in tabs
if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi
