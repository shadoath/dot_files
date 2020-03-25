local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%}"
local who_where="%{$fg[magenta]%}`whoami`%{$fg[white]%}@%{$fg[green]%}$HOST"
local my_path="%{$fg[cyan]%}%c%{$reset_color%}"

PROMPT='${ret_status}${who_where} ${my_path} $(git_prompt_info)'
RPROMPT="[%D{%Y/%m/%f}|%T]"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%} %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%}✔"
