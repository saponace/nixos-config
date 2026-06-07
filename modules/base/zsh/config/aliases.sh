alias ls='lsd'
alias l='ls'
alias ll='ls -lart'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias g='lazygit'
alias gst='git status' ; compdef _git gst=git-status
alias gadd='git add' ; compdef _git gadd=git-add
alias gco='git checkout' ; compdef _git gco=git-checkout
alias gc='git commit -m' ; compdef _git gc=git-commit-m
alias gca='git commit --amend' ; compdef _git gca=git-commit-amend
alias gr='git rebase' ; compdef _git gr=git-rebase
alias gri='git rebase -i ' ; compdef _git gri=git-rebase-i
alias grs='git restore --staged ' ; compdef _git gri=git-restore-staged
alias gl='git pull' ; compdef _git gl=git-pull
alias gp='git push' ; compdef _git gp=git-push
alias gd='git diff' ; compdef _git gd=git-diff
alias gdu='git diff @{u}'
alias gdc='git diff --cached' ; compdef _git gd=git-diff-cached
alias gn='git restore --staged . ; git clean -fd'

alias grep="grep --color=auto --exclude-dir=.git"
alias df="df -h"
alias du="du -h"
