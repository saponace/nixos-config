alias ls='lsd'
alias l='ls'
alias ll='ls -lart'

alias cp='cp --interactive'
alias mv='mv --interactive'
alias rm='rm --interactive --verbose'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias gst='git status' ; compdef _git gst=git-status
alias gadd='git add' ; compdef _git gadd=git-add
alias gco='git checkout' ; compdef _git gco=git-checkout
alias gc='git commit -m' ; compdef _git gc=git-commit-m
alias gca='git commit --amend' ; compdef _git gca=git-commit-amend
alias gr='git rebase' ; compdef _git gr=git-rebase
alias gl='git pull' ; compdef _git gl=git-pull
alias gp='git push' ; compdef _git gp=git-push
alias gd='git diff' ; compdef _git gd=git-diff
