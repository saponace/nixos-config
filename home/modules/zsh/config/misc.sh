export LANG=en_US.UTF-8
export LANGUAGE=${LANG}
export LC_ALL=${LANG}
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'



zmodload zsh/{datetime,stat,zpty,system,clone,zprof,zselect}
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh &> /dev/null
autoload -Uz zargs zcalc


## Exports
    export QT_QPA_PLATFORMTHEME="qt5ct"
    export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
    export BROWSER=/usr/bin/firefox
export PAGER=less
export MANPAGER=${PAGER}
export EDITOR=nvim
export TAR_OPTIONS='--delay-directory-restore'
export SYSTEMD_LESS=FRXM
export LESS=RM


## Miscellaneous options
    setopt no_beep auto_cd


## try to avoid the 'zsh: no matches found...'
    setopt no_nomatch


## correction
    setopt correct

## History reverse search
    bindkey '^R' history-incremental-pattern-search-backward


## Consider directories as words (So Ctrl+w removes up to the latest slash in a filepath)
    local WORDCHARS=${WORDCHARS/\/}
    autoload -U select-word-style
    select-word-style bash


#----- Signals stuff
    ## do not send the HUP signal to running jobs when the shell exits
    setopt no_hup
    ## display PID when suspending processes
    setopt long_list_jobs
    ## stopped jobs that are removed from the job table with the disown builtin command are automatically sent a SIGCONT to make them running
    setopt auto_continue



## this is needed by a lot of function in this zshrc
    autoload -Uz colors && colors


## fzf: fuzzy search in files and shell history
    source <(fzf --zsh)

## zoxide: better cd
eval "$(zoxide init zsh)"
alias cd=z



#----- Resources limit
    unlimit
    limit coredumpsize 0
    limit -s



## After entering a command, print the complete command and check correctness
_-accept-line() {
    local -a WORDS
    WORDS=( ${(z)BUFFER} )
    local -r FIRSTWORD=${WORDS[1]}
    local -r GREEN=$'\e[32m' RESET_COLORS=$'\e[0m'
    [[ "$(whence -w $FIRSTWORD 2>/dev/null)" == "${FIRSTWORD}: alias" ]] &&
    echo -n $'\n'"${GREEN}Executing: $(whence $FIRSTWORD)${RESET_COLORS}"
    zle .accept-line
}
zle -N accept-line _-accept-line

#----- Navigation
bindkey ' ' magic-space  # perform history expansion and insert a space into the buffer; this is intended to be bound to space
bindkey '^[[1;5C' forward-word   # C-right: move forward one word
bindkey '^[[1;5D' backward-word   # C-left: move backward one word
bindkey ${terminfo[kdch1]} delete-char   ## del: delete forward


#-----  History
    ## save each command's beginning timestamp and the duration to the history file
        setopt extended_history
    ## remove command lines from the history list when the first character on the line is a space
        setopt hist_ignore_space
    ## if a new command line being added to the history list duplicates an older one, the older command is removed from the list
        setopt hist_ignore_all_dups
    ## whenever the user enters a line with history expansion, don’t execute the line directly; instead, perform history expansion and reload the line into the editing buffer
        setopt hist_verify
    ## append the history to history file as soon as they are entered rather than waiting until the shell exits
        setopt inc_append_history
    ## import new commands from the history file also in other zsh-session
        setopt share_history
    ## remove superfluous blanks from each command line being added to the history list
        setopt hist_reduce_blanks
    ## the file to save the history
        HISTFILE=${ZDOTDIR:-${HOME}}/.zhistory
    ## the maximum number of events stored in the internal history list
        HISTSIZE=65535
    ## the maximum number of history events to save in the history file
        SAVEHIST=${HISTSIZE}
    ## Directory history settings
        autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
        add-zsh-hook chpwd chpwd_recent_dirs
    ## number of directory cached in history
        zstyle ':chpwd:*' recent-dirs-max 10
    ## file to save the directory history
        zstyle ':chpwd:*' recent-dirs-file ${ZDOTDIR:-$HOME}/.zdirs





#----- Completion
    ## Completion settings
        setopt complete_in_word auto_name_dirs
    ## if a completion is performed with the cursor within a word, and a full completion is inserted, the cursor is moved to the end of the word
        setopt always_to_end
    ## try to make the completion list smaller (occupying less lines) by printing the matches in columns with different widths
        setopt listpacked
    ## enable sorted/grouped completion
        zstyle ':completion:*' group-name ''
        zstyle ':completion:*:descriptions' format $'%{\e[0;32m%}completing %B%d%b%{\e[0m%}'
        zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
    ## sort man-pages by section
        zstyle ':completion:*:manuals' separate-sections 1
        zstyle ':completion:*:manuals.*' insert-sections 1
    ## enable colored filename completions
        zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    ## if there are more than three options allow selecting from a menu
        zstyle ':completion:*' menu select=3
    ## case insensitive completion
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    ## try to complete file at the end, maybe useful if a completion function is broken
    #zstyle ':completion:*' completer _complete _match _approximate _expand_alias _ignored _files
    ## function name that start with a underline should NOT be included in the completion list
        zstyle ':completion:*:*:*:functions' ignored-patterns '_*'
    ## ignore current directory when ../ ; see also http://www.zsh.org/mla/workers/2014/msg00246.html
        zstyle ':completion:*:*:*' ignore-parents parent pwd
    ## order of the tilde completion, only make sense when enable sorted/grouped completion
        zstyle ':completion:*:-tilde-:*' group-order named-directories directory-stack local-directories users
    ## TODO: sent a mail to zsh-users about that
        zstyle ':completion:*:-tilde-::named-directories' ignored-patterns '_*'
    ## ignore the users that uninterested except really expected
        zstyle ':completion:*:*:*:users' ignored-patterns adm amanda amule apache at avahi avahi-autoipd beaglidx bin cacti canna colord clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm git gkrellmd gopher hacluster haldaemon halt http hsqldb ident incron junkbust kdm ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios named nbd netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn operator pcap pdnsd polkitd postfix postgres privoxy pulse pvm quagga radvd rpc rpcuser rpm rtkit sagemath scard shutdown squid sshd statd svn sync tftp tor usbmux uucp uuidd vcsa wwwrun xfs '_*' 'systemd-*' ${USERNAME}

    zstyle ':completion:*' single-ignored show
    autoload -Uz compinit
    compinit
for i in i386 x86_64 linux32 linux64 pty ptypg stdoutisatty unbuffer me proxychains grc rlwrap;do
    compdef ${i}=command
done
