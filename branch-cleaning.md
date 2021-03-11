# Git commands to clean old branches:

## Remote branches
`git fetch origin --prune`
* Before fetching, remove any remote-tracking references that no longer exist on the remote.
* Git has a default disposition of keeping data unless it’s explicitly thrown away; this extends to holding onto local references to branches on remotes that have themselves deleted those branches.
* This will quickly remove remote branches that have been merged

## Local cleanup
1. Start with:

`git branch --merged`
* Only list branches whose tips are reachable from the specified commit
* We can chain onto this command to clean up our local merged branches:

2. First by removing master and develop from the list, then:

`git branch --merged | egrep -v "(^\*|master|develop)"`

3. Then passing each arg to `git branch -d ` to remove the local copy

`git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d'`

4. Then combine these two commands into two aliases:
```
alias gbp="  git fetch origin --prune"
alias gbdm=' git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d && gbp'
```

5. Run `gbdm` to give your local copy a cleanup. I think of this alias as 'git branch delete merged'

## Extra notes
Also [found](https://stackoverflow.com/a/59228595/1418337) this nifty command:
`git branch --v | grep "\[gone\]" | awk '{print $1}' | xargs git branch -D`

Powershell: PS> `git branch --v | ? { $_ -match "\[gone\]" } | % { -split $_ | select -First 1 } | % { git branch -D $_ }`
