# vim: set filetype=bash
# Notes https://dev.to/g_abud/advanced-git-reference-1o9j

# Overrides settings in ~/.oh-my-zsh/plugins/git/git.plugin.zsh
alias lg="   lazygit"
alias gs="   git status"
alias gd="   clear && git diff"
alias gc="   git commit"
alias gca="  git commit -am"
alias gcam=" git commit --amend"
alias gcN="  git commit --no-verify"
alias gco="  git checkout"
alias gcm="  git commit -m"
alias gcom=" git checkout master"
alias gcos=" git checkout staging"
alias ga="   git add"
alias gap="  git add --patch"
alias gaa="  git add ."
alias gaA="  git add . --all"
alias gf="   git fetch"
alias gsa="  git stash"
alias gsp="  git stash pop"
alias gr="   git rm"
alias gu="   git reset --soft"
alias grH="  git reset HEAD~" # undo one commit (ONLY USE IF NOT YET PUSHED)
alias grv="  git remote -v"
alias gb="   git branch"
alias gba="  git branch -a"
alias gbd="  git branch -d"
alias gbdm=' git branch --merged | egrep -v "(^\*|master|staging)" | xargs git branch -d && gbp'
alias gbD="  git branch -D"
alias gbp="  git fetch origin --prune"
alias gbn="  git pull origin && git checkout -b"
alias gpo="  git pull origin"
alias gpom=" git pull origin master"
alias gpos=" git pull origin staging"
alias gPom=" git push origin master"
alias gPos=" git push origin staging"
alias gPo="  git push origin -u"
alias gPoN=" git push origin --no-verify"
alias gPn="  git push --set-upstream origin --no-verify" # Use this when remote tracking is not set
alias gm="   git merge"
alias gms="  git merge staging"
alias gmm="  git merge master"
alias gl="   git log --pretty=format:'%C(yellow)%h%C(reset) - %an [%C(green)%ar%C(reset)] %s'"
alias glm="  git log --author='$(git config user.name)' --pretty=format:'%C(yellow)%h%C(reset) [%C(green)%ar%C(reset)] %s'"
alias overview='open "https://github.com/shadoath?tab=overview&from='$(date '+%Y-%m-%d')'"'
alias {gPf,gPfm}="git push fury master"

# if [  `hostname` = mbp-42 ]; then
#   # Git autocomplete
#   if [ -f $(brew --prefix)/etc/bash_completion ]; then
#   . ~/.git-completion.bash
#     . $(brew --prefix)/etc/bash_completion
#     __git_complete gco _git_checkout
#     __git_complete gm  _git_checkout
#     __git_complete gPo _git_checkout
#     __git_complete gpo _git_checkout
#     __git_complete gpn _git_checkout
#     __git_complete gbd _git_checkout
#   fi
# fi

function gh() {(
  set -e
  git remote -v | grep push
  remote=${1:-origin}
  echo "Using remote $remote"

  URL=$(git config remote.$remote.url | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")
  echo "Opening $URL..."
  open $URL
)}
