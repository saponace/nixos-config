setopt prompt_subst ## Enable parameter expansion, command substitution and arithmetic expansion in prompts
setopt transient_rprompt  ## Remove any right prompt from display when accepting a command line. This may be useful with terminals with other cut/paste methods
autoload -Uz colors && colors

## Print pwd with alternating colors
alternatedPWD(){
    pwd=$PWD
    homestr="/home/$USER"
    sizehomestr=${#homestr}
    shortPWD=$pwd
    if [[ $pwd == /home/$USER* ]]
    then
        shortPWD=\~${pwd:$sizehomestr}
    fi
    count=0
    colorgrey="\e[0;49;37m"
    color1="\e[0;35m"
    color2="\e[0;32m"
    echo -ne "$color2"
    for (( i = 0; i < ${#shortPWD}; i++ ))
    do
        c="${shortPWD:$i:1}"
        ((mod=count%2))
        if [ "$c" == "/" ]
        then
            echo -ne "$colorgrey/"
            if [ "$mod" == 0 ]
            then
                echo -ne "$color1"
            else
                echo -ne "$color2"
            fi
            ((count++))
        else
            if [ "$c" == "-" ]; then
                printf "%s" "-"
            else
                echo -ne "$c"
            fi
        fi
    done
}

# Short prompt
SHORTPROMPT="%B%F{5}>%f%b "

## Long prompt
if [[ ${EUID} -eq 0 ]];then # root
    USERCOL='%U%F{1}'
else
    USERCOL='%F{6}'
fi
FRAMECOL='%F{241}'
HOSTCOL='%F{12}'
TIMEDATECOL='%F{7}'
LONGPROMPT=$'\n'"${USERCOL}%n%u${FRAMECOL}@${HOSTCOL}%m ${TIMEDATECOL}%T%(?.. [%B%F{red}%?%f%b]) \$(alternatedPWD)\$(_-git_ps1)"$'\n'"$SHORTPROMPT"
unset HOSTCOL USERCOL TIMEDATECOL

# Switch prompt
sp() {
  if [[ $PROMPT == "$SHORTPROMPT" ]];then
    PROMPT=$LONGPROMPT
  else
    PROMPT=$SHORTPROMPT
  fi
}

## Default to long prompt
PROMPT=$LONGPROMPT

## Git PS1
_-git_ps1() {
  if [[ -n ${commands[git]} ]];then
    local PREFIX=' %F{FRAMECOL}- %F{12}%F{6}'
    local SUFFIX='%F{12}%f'
    _git_indicators() {
      local out=''
      [[ -n $(command git status -s --ignore-submodules=dirty 2> /dev/null | tail -n1) ]] && out+='%F{3}*'
      { command git rev-parse --verify refs/stash &> /dev/null } && out+='%F{7}-'
      [[ -n $out ]] && print " ${out}"
    }
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || ref=$(command git rev-parse --short HEAD 2> /dev/null) && echo "${PREFIX}${ref#refs/heads/}$(_git_indicators)${SUFFIX}"
  fi
}

unset FRAMECOL
