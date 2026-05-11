# Set colors - used in other functions
_-automatic-colored() {
    if [[ ${1} == unset || ! -t 1 ]];then
        unset rst bld bldwht bldblk bldred bldgrn bldylw bldblu bldcyn blk red grn ylw blu cyn gry
    elif [[ -t 1 ]];then
        rst="${reset_color}"
        bld="${fg_bold[default]}"
        bldwht="${fg_bold[white]}"
        bldblk="$fg_bold[black]"
        bldred="$fg_bold[red]"
        bldgrn="$fg_bold[green]"
        bldylw="$fg_bold[yellow]"
        bldblu="$fg_bold[blue]"
        bldmgt="${fg_bold[magenta]}"
        bldcyn="$fg_bold[cyan]"
        gry="${fg[white]}"
        blk="$fg[black]"
        red="$fg[red]"
        grn="$fg[green]"
        ylw="$fg[yellow]"
        blu="$fg[blue]"
        mgt="${fg[magenta]}"
        cyn="$fg[cyan]"
    fi
}

# Create a random named tmp directory and cd in it
cdtmp() {
    if [[ "${1}" == '--help' || "${1}" == '-h' || $# -gt 1 ]];then
        _-automatic-colored
        echo "${bldblu}Usage:${rst} ${bldgrn}cdtmp${rst} [${bldcyn}OPTION${rst}]
        create a temporary directory and then change the current working directory to the created directory.
        ${bldcyn}-h${rst}, ${bldcyn}--help${rst}    help information(this screen)"
    else
        local dir=$(mktemp -d)
        _-automatic-colored
        echo "${grn}Executing: cd ${dir}${rst}"
        cd ${dir}
    fi
}

# Create backup file
~() {
_-intro() {
    _-automatic-colored
    echo "${bldblu}Usage:${rst} ${bldgrn}~${rst} [${bldcyn}FILE${rst}]
    backup a file or directory using cp(1)

    The target file name is the original name plus a time stamp attached.(%Y%m%d%H%M%S)"
}
if [[ $# -eq 0 && ${PWD} != ${HOME} ]];then
    cd ${HOME}
elif [[ $# -eq 1 ]];then
    _-automatic-colored
    if [[ ! -e ${1} ]];then
        echo "${bldred}==> ${bld}Aborted: File ${1} doesn't exist${rst}\n"
        _-intro
        return 1
    elif [[ ! -f ${1} ]];then
        echo "${bldred}==> ${bld}Aborted: ${1} is not a regular file${rst}"
        return 1
    elif [[ ! -r ${1} ]];then
        echo "${bldred}==> ${bld}Aborted: File is unaccessible${rst}"
        return 1
    elif [[ ! -s ${1} ]];then
        echo "${bldblu}==> ${bld}Cancelled: This is a zero-byte file, just why do you want to backup it?${rst}"
        return 2
    else
        local DESTNATIONFILENAME="${1}~`strftime '%Y%m%d%H%M%S' ${EPOCHSECONDS}`"
        cp -b "${1}" "${DESTNATIONFILENAME}" && echo "${bldgrn}==> ${bld}Finish writing backup: ${DESTNATIONFILENAME}${rst}"
    fi
else
    _-intro
fi
unset -f _-intro
}

# Extract various types of archives
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}
