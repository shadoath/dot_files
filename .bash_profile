
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

### Added by the Heroku Toolbelt

#export PATH="/usr/local/heroku/bin:$PATH"

#git
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gba='git branch -a'
alias gba='git branch -a'
alias gcm='git commit -m '
alias gca='git commit -am '
alias gcmerge='git commit -m "merge"'
alias gpo='git pull origin'
alias gPo='git push origin'
alias gs='git status'

#capistrano
alias csd='cap staging deploy'
alias cpd='cap production deploy'

#rails
alias fixdb='rake db:drop db:create db:migrate db:seed'
alias fixrails='bundle
fixdb
rails s'

#solr
alias sunup='rake sunspot:solr:start'
alias sundown='rake sunspot:solr:stop'
alias sunburn='rake sunspot:solr:run'
alias sunset='rake sunspot:solr:reindex'
