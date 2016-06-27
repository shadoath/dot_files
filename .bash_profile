
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

alias vi=vim
alias fucking="sudo"

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
alias gc='git commit'
alias gco='git checkout'
alias gaa='git add .'
alias ga='git add'
alias gr='git rm'
alias gd='git diff'
alias gba='git branch -a'
alias gcm='git commit -m '
alias gcam='git commit -am '
alias gcmerge='git commit -m "merge"'
alias gpo='git pull origin'
alias gPo='git push origin'
alias gs='git status'
alias gms='git merge staging'
alias gmm='git merge master'

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
#solr
alias sunup='rake sunspot:solr:start'
alias sundown='rake sunspot:solr:stop'
alias sunburn='rake sunspot:solr:run'
alias sunset='rake sunspot:solr:reindex'

# Setting PATH for Python 3.5
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
export PATH

#DNS cache clear IOX 10.9
alias clear_dns="sudo killall -HUP mDNSResponder echo DNS cleared"

# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Show folder in tabs
if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi
