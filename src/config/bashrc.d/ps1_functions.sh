#!/usr/bin/env bash

function join_by { local IFS="$1"; shift; echo "$*"; }

ps1_status() {
    local exitcode=$?
    local attr_reset='\001\033[00m\002'
    local attr_light_red='\001\033[91m\002'
    local attr_yellow='\001\033[93m\002'

    local -a result

    if [[ $exitcode == 0 ]]; then
        # command succeed, no worries
        result+=()
    else
        result+=("${attr_light_red}")
        result+=("${exitcode}")
        result+=("${attr_reset}")
    fi

    local suspended_jobs=$(jobs -s | wc -l)
    if [[ $suspended_jobs == 0 ]]; then
        # no suspended jobs, no worries
        result+=()
    else
        result+=("${attr_yellow}")
        result+=("${suspended_jobs}")
        result+=("${attr_reset}")
    fi

    local IFS=' '
    echo -e "${result[*]}"
}

ps1_user_hostname() {
    local attr_reset='\001\033[00m\002'
    local attr_bold_green='\001\033[01;32m\002'

    local result="${attr_bold_green}\u@\h${attr_reset}"

    # echo -e ${result@P}
}

ps1_cwd() {
    local attr_reset='\001\033[00m\002'
    local attr_bold_blue='\001\033[01;34m\002'

    local result="${attr_bold_blue}\w${attr_reset}"

    # echo -e ${result@P}
}

ps1_git_branch() {
    local attr_reset='\001\033[00m\002'
    local attr_cyan='\001\033[36m\002'
    local attr_bold_blue='\001\033[01;34m\002'

    local branches

    local result
    if branches=$(git branch 2>/dev/null); then
        local branch=$(echo "$branches" | sed -rn 's/^[[:blank:]]*\*[[:blank:]]+([a-zA-Z0-9/-]+)/(\1)/p')
        result="${attr_cyan}${branch}${attr_reset}${attr_bold_blue} \$${attr_reset}"
    else
        result="${attr_bold_blue}\$${attr_reset}"
    fi

    echo -e ${result}
}

# ex - archive extractor
# usage: ex <file>
ex ()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
