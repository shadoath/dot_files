# vim: set filetype=bash

### function opens new tab in same directory. if this functionality starts working again in iterm, then i will no longer need this
function nt() {
  open . -a "iterm"
}
function common_cmds() {
  history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n11
}
# open git directory on github
function gg() {
  URL=$(cat .git/config | grep github | sed -E "s/^.*(github\.com):(.*)(\.git)?/http:\/\/\1\/\2/")
  open $URL
}
#List Pull Requests for {USER}, default prenda-school
# function lpr() {
#   USER=$1
#   : ${USER:="prenda-school"}
#   open "https://github.com/pulls?utf8=%E2%9C%93&q=is%3Aopen+is%3Apr+user%3A"$USER
# }
# Open Pull Request for Github/Bitbucket
function pr(){
  DIR=$(git rev-parse --show-toplevel)
  BRANCH=$(__git_ps1 | tr -d "()" | tr -d "[:space:]")
  if [ -f $DIR/.git/config ]; then
    CONFIG="$DIR/.git/config"
  else
    CONFIG=$(cat .git | sed -e 's/\(gitdir: \)//g')
    CONFIG+='/config'
    BRANCH="staging...prenda-school:$BRANCH"
  fi
  SERVICE_URL=$(cat $CONFIG | grep url\ = -m 1)
  if [[ "${SERVICE_URL}" == *"bitbucket"* ]]; then
    USER=$(cat $CONFIG | grep bitbucket -m 1 | sed -E "s/^.*(bitbucket\.org)\/(.*)\/(.*)\.git?/\2/")
    REPO=$(cat $CONFIG | grep bitbucket -m 1 | sed -E "s/^.*(bitbucket\.org)\/(.*)\/(.*)\.git?/\3/")
    open "https://bitbucket.org/$USER/$REPO/pull-requests/new?source=$USER/$REPO%3A%3A$BRANCH&event_source=branch_list"
  else
    USER=$(cat $CONFIG | grep github -m 1 | sed -E "s/^.*(github\.com)[:\/](.*)\/(.*)\.git?/\2/")
    REPO=$(cat $CONFIG | grep github -m 1 | sed -E "s/^.*(github\.com)[:\/](.*)\/(.*)\.git?/\3/")
    open "https://github.com/$USER/$REPO/compare/$BRANCH?expand=1"
  fi
}

# cat out specified lines for copy pasta
# example: catb 1 5  (show lines 1 through 5  of the file)
function catb() {
 cat $1 | awk "{if (NR>=$2 && NR<=$3) print}"
}


function rsb() {
  IP=$(ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -Eo "([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1" | grep -m1 "")
  rails s -b $IP
}
function speedtest() {
  curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
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
      tab-color  0 128 255 # BLUE
    elif [[ "$*" == *"db-jump"* ]]; then
      tab-color 255 51 255 #HOT PINK
    elif [[ "$*" == *"prenda-hub"* ]] || [[ "$*" == *"sfs"* ]]; then
      tab-color 255 51 51 # RED
    else
      tab-color  0 255 0 # GREEN
    fi
    ssh $*
  fi
}
if [ $HOST=='mbp-42' ]
  then
  alias ssh=color-ssh
fi
