# vim: set filetype=bash
# Notes https://dev.to/g_abud/advanced-git-reference-1o9j

# Overrides settings in ~/.oh-my-zsh/plugins/git/git.plugin.zsh
alias lg="   lazygit"
alias gPn="  git push --set-upstream origin --no-verify" # Use this when remote tracking is not set
alias gPo="  git push -u origin"
alias gPoc=" RINSED_CLAUDE_REVIEW=true gPo"
alias gPoN=" git push origin --no-verify"
alias gPom=" git push origin master"
alias gPos=" git push origin staging"
alias ga="   git add"
alias gaA="  git add . --all"
alias gaa="  git add ."
alias gap="  git add --patch"
alias gb="   git branch --sort=-committerdate"
alias gbg="  gb -a | grep"
alias gbD="  git branch -D"
alias gba="  gb -a" #Git branch ALL
alias gbd="  git branch -d"
alias gbdm=' git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d && gbp'
alias gbDm='git branch -v | grep "\\[gone\\]" | awk "{print \$1}" | xargs git branch -D'
alias gbn="  git pull origin && git checkout -b"
alias gbN="  git checkout -b"
alias gbp="  git fetch origin --prune"
alias gc="   git commit"
alias gcN="  git commit --no-verify"
alias gca="  git commit -am"
alias gcam=" git commit --amend"
alias gcm="  git commit -m"
alias gco="  git checkout"
alias gcod=" git checkout develop && gpo && gbdm"
alias gcom=" git checkout master && gpo && gbdm"
alias gcoM=" git checkout main"
alias gcos=" git checkout staging"
alias gf="   git fetch"
alias gl="   git log --pretty=format:'%C(yellow)%h%C(reset) - %an [%C(green)%ar%C(reset)] %s'"
alias glv="  git log --pretty=format:'%C(yellow)%H%C(reset) - %an [%C(green)%ar%C(reset)] %s'"
alias glm="  git log --author='$(git config user.name)' --pretty=format:'%C(yellow)%h%C(reset) [%C(green)%ar%C(reset)] %s'"
alias glcred="git log --oneline -- config/credentials.yml.enc" # Check for any changes to this file
alias gm="   git merge"
alias gmd="  git merge develop"
alias gmm="  git merge master"
alias gmod=" git merge develop"
alias gms="  git merge staging"
alias gpo="  git pull origin"
alias gpom=" git pull origin master"
alias gpos=" git pull origin staging"
alias grm="  git rm"
alias gRC="  git rm --cached -r ." # remove those pesky cached files where the case changes
alias grH="  git reset HEAD~" # undo one commit (ONLY USE IF NOT YET PUSHED)
alias grv="  git remote -v"
alias gs="   git status"
alias gst="  git stash"
alias gsp="  git stash pop"
alias gu="   git reset --soft"
alias rn='   git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:"%an - %s"'
alias rns='  git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:"%s"'
alias overview='open "https://github.com/shadoath?tab=overview&from='$(date '+%Y-%m-%d')'"'
alias {gPf,gPfm}="git push fury master"
alias gd="   clear && git diff"
alias gds="  clear && git diff --staged"
alias gbb="!git for-each-ref --color --sort=-committerdate --format=$'%(color:red)%(ahead-behind:HEAD)\t%(color:blue)%(refname:short)\t%(color:yellow)%(committerdate:relative)\t%(color:default)%(describe)' refs/heads/ --no-merged | sed 's/ /\t/' | column -s=$'\t' -t -c 'Ahead,Behind,Branch Name,Last Commit,Description'"

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

# function gh() {(
#   set -e
#   git remote -v | grep push
#   remote=${1:-origin}
#   echo "Using remote $remote"

#   URL=$(git config remote.$remote.url | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")
#   echo "Opening $URL..."
#   open $URL
# )}
