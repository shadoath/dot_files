# vim: set filetype=bash
alias vi=vim
alias h="history | grep "
alias f="find . | grep "
alias p="ps aux | grep "
alias a="alias  | grep "
# todo --exclude-dir=node_modules
alias g="grep -rnw . -e " # Go find me some text [info](https://explainshell.com/explain?cmd=grep+-rnw+.+-e+text)
alias c="clear"
alias {:q,:Q,:qa}="exit"
alias bs="bundle show |grep "
alias fing="sudo"
alias Kill="sudo kill -s SIGTERM "
alias fing-dots="find . -type f -name '._DS_Store' -exec rm {} +"


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
alias orails=" vim ~/dot_files/include/rails_aliases.zsh"
alias sbash="source ~/.bash_profile; clear"
alias zbash="source ~/.zshrc; clear"
alias bog="  bundle open"
alias psd="open -a /Applications/Adobe\ Photoshop\ 2020/Adobe\ Photoshop\ 2020.app"
alias opry=" vim ~/.pryrc"
alias myvhost="vim /usr/local/etc/httpd/extra/httpd-vhosts.conf"
alias oprompt="vim ~/dot_files/shadoath.zsh-theme"
# Server quick edit
alias vhost="sudo vim /etc/httpd/conf.d/http-vhosts.conf"
alias ctags="`brew --prefix`/bin/ctags"
alias bssp="brew services start postgresql"
alias bsSp="brew services stop postgresql"

# Nix
alias nix="noglob nix"

# Colors/tabs
alias noc="tab-reset"
alias tred="tab-color 255 51 51" # RED
alias tblue="tab-color 0 128 255" # Blue
alias tpink="tab-color 255 51 255" # HOT PINK
alias tgreen="tab-color 34 118 47" # Forest green

# Special commands
## delete all files starting with ._
alias no_ds="find . -type f -name '._*' -exec rm {} +"

## Prisma with pnpm
alias pn=pnpm
alias pnrd="npg && pnpm run dev"
alias pnps="pnpm npx run prisma studio"

# Prisma with npm
alias nrd="npg && npm run dev"
alias nps="npm run prisma-studio"

# Prisma npx commands
alias npg="npx prisma generate"
alias npdp="npx prisma db push"
alias npmr="npx prisma migrate reset"
alias npmrS="npx prisma migrate reset --skip-generate"


## Laravel
alias phps="php artisan serve"

## Servers
alias sql=" mysql.server start"
alias ssnr="sudo service nginx restart"
alias ssmr="sudo service mysql restart"
alias ssrn="sudo systemctl restart nginx"
alias sshr="sudo service httpd restart"
alias ssar="sudo service apache2 restart"

## Quick ssh commands
alias ssfs="ssh skyfox@sfs"              # SkyFoxStudios

## Time
alias retime="sudo ntpdate time.nist.gov"
alias msttime="sudo rm /etc/localtime; sudo ln -s /usr/share/zoneinfo/America/Denver /etc/localtime"
alias fixtime="sudo timedatectl set-timezone America/Denver"

# Mac OS 10.12.6
alias clear_dns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;"

## Quick jumps
alias cdd="   cd ~/dot_files"
alias pc="cd /personal-code"

## ls aliases
alias ll="ls --color=auto -lh"
alias la="ls --color=auto -lah"
alias ls="ls --color=auto -la"
# alias llm="ls  --color=auto -llm"

## Docker
alias dc="docker-compose"
alias dcb="dc build --no-cache"
alias dc-reset="dc down && dc build --no-cache && dc up"
