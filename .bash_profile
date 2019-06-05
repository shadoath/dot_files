[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ `hostname` == 'mbp-42' ]
then
  echo "Macbook setup"
  export PATH="/Users/sbolton/.rvm/rubies/ruby-2.4.2/bin/:$PATH"
  # export PATH="/Users/sbolton/.rvm/rubies/ruby-2.5.0/bin/:$PATH"
  export PATH="/usr/local/bin/vim:$PATH"
  export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
  export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
  export PATH="$PATH:/usr/local/etc/profile.d/z.sh"
  if [ $ITERM_SESSION_ID -a -z "$PROMPT_COMMAND" ]; then
    export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
  fi
fi



# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
shopt -s histappend dotglob

# Required
export EDITOR=vim

[[ -s "$HOME/dot_files/include/base_aliases" ]]       && source "$HOME/dot_files/include/base_aliases"
[[ -s "$HOME/dot_files/include/git_aliases" ]]        && source "$HOME/dot_files/include/git_aliases"
[[ -s "$HOME/dot_files/include/rails_aliases" ]]      && source "$HOME/dot_files/include/rails_aliases"
[[ -s "$HOME/dot_files/include/capistrano_aliases" ]] && source "$HOME/dot_files/include/capistrano_aliases"
[[ -s "$HOME/dot_files/include/functions" ]]          && source "$HOME/dot_files/include/functions"
#[[ -s "$HOME/dot_files/include/_aliases" ]] && source "$HOME/dot_files/include/_aliases"

# Better terminal output
cyan=$(tput setaf 6)
white=$(tput setaf 7)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
purple=$(tput setaf 5)

source ~/.git-prompt.sh
# PS1 uses [] so it doesn't overwrite long command lines and now does word wrap
export PS1="\[$cyan\]`whoami`\[$yellow\]@\[$purple\]`hostname` \[$red\]\W\[\e[m\]\[$green\]\$(__git_ps1)\[$yellow\]\$ \[$white\]"
cd "code"
