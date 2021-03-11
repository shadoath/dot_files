##Git commands to clean old branches:

`git fetch origin --prune`
// Before fetching, remove any remote-tracking references that no longer exist on the remote.
// Git has a default disposition of keeping data unless it’s explicitly thrown away; this extends to holding onto local references to branches on remotes that have themselves deleted those branches.
// This will quickly remove remote branches that have been merged

`git branch --merged`
// Only list branches whose tips are reachable from the specified commit

We can chain onto this command to clean up our local merged branches:
`git branch --merged | egrep -v "(^\*|master|develop)"`
// first by removing master and develop from the list, then:

`git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d'`
// Then passing each arg to `git branch -d ` to remove the local copy

I then combine these two commands into two aliases:

`alias gbp="  git fetch origin --prune"`
`alias gbdm=' git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d && gbp'`


As I was researching this I [found](https://stackoverflow.com/a/59228595/1418337)
`git branch --v | grep "\[gone\]" | awk '{print $1}' | xargs git branch -D`

Powershell: PS> `git branch --v | ? { $_ -match "\[gone\]" } | % { -split $_ | select -First 1 } | % { git branch -D $_ }`
