#!/usr/bin/env bash

# one of: dp1, dp2, gentoo
# where dp1 and dp2 are single and double rows accordingly
PS1PROFILE="${PS1PROFILE:-dp1}"

apply_foreground() {
    # apply foreground with name on text
    # name is first argument
    # text is second

    local -r name="$1"
    shift
    local -r text="$*"

    local default='0;39'
    local code=
    case "${name,,}" in
    black) code='0;30' ;;
    red) code='0;31' ;;
    green) code='0;32' ;;
    yellow) code='0;33' ;;
    blue) code='0;34' ;;
    magenta) code='0;35' ;;
    cyan) code='0;36' ;;
    light_grey) code='0;37' ;;
    dark_grey) code='0;90' ;;
    light_red) code='0;91' ;;
    light_green) code='0;92' ;;
    light_yellow) code='0;93' ;;
    light_blue) code='0;94' ;;
    light_magenta) code='0;95' ;;
    light_cyan) code='0;96' ;;
    white) code='0;97' ;;
    *) code=${default} ;;
    esac

    echo -n "\033[${code}m${text}\033[0m"
    return 0
}

apply_background() {
    # apply background with name on text
    # name is first argument
    # text is second

    local -r name="$1"
    shift
    local -r text="$*"

    local default='0;49'
    local code=
    case "${name,,}" in
    black) code='0;40' ;;
    red) code='0;41' ;;
    green) code='0;42' ;;
    yellow) code='0;43' ;;
    blue) code='0;44' ;;
    magenta) code='0;45' ;;
    cyan) code='0;46' ;;
    light_grey) code='0;47' ;;
    dark_grey) code='0;100' ;;
    light_red) code='0;101' ;;
    light_green) code='0;102' ;;
    light_yellow) code='0;103' ;;
    light_blue) code='0;104' ;;
    light_magenta) code='0;105' ;;
    light_cyan) code='0;106' ;;
    white) code='0;107' ;;
    *) code=${default} ;;
    esac

    echo -n "\033[${code}m${text}\033[0m"
    return 0
}

get_loadavg() {
    cat /proc/loadavg | grep -Po '(\d+\.\d+\ )+' | sed -rn 's/\s+$//p'
}

get_suspended_jobs_count() {
    jobs -s | wc -l
}

get_jobs_statuses() {
    # echo comma separated status of jobs in current session
    # "<SUSPENDED JOBS COUNT>,<LOAD AVERAGE>"
    local -r suspended_count=$(get_suspended_jobs_count)
    local -r load=$(get_loadavg)
    echo -n "${suspended_count},${load}"
    return 0
}

print_jobs_status() {
    IFS=',' read -r -a statuses <<<$(get_jobs_statuses)

    local -a status
    if [[ ! -z ${statuses[1]} ]]; then
        status+=("${statuses[1]};")
    fi

    if [[ ${statuses[0]} -gt 0 ]]; then
        status+=("${statuses[0]};")
    fi

    IFS=' ' echo -n "[${status[*]}]"
    return 0
}

get_git_status() {
    # echo comma separated status of git
    # "<BRANCH NAME>,<UNTRACKED COUNT>,<DELETED_COUNT>,<MODIFIED COUNT>,<STAGED COUNT>,<STASH COUNT>"
    local -r branch=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
    local -r staged_count=$(git status --porcelain 2>/dev/null | grep -Pi '^[am]' | wc -l)
    local -r modified_count=$(git status --porcelain 2>/dev/null | grep -Pi '^[am\ ][am]' | wc -l)
    local -r deleted_count=$(git status --porcelain 2>/dev/null | grep -Pi '^ [d]' | wc -l)
    local -r untracked_count=$(git status --porcelain 2>/dev/null | grep -i '^??' | wc -l)
    local -r stash_count=$(git stash list 2>/dev/null | wc -l)

    echo -n "$branch,$untracked_count,$deleted_count,$modified_count,$staged_count,$stash_count"
    return 0
}

git_status() {
    # echo git status if branch located
    IFS=',' read -ra statuses <<<$(get_git_status)

    local -a status
    if [[ -z ${statuses[0]} ]]; then
        echo -n ''
        return 0
    fi

    # branch
    if [[ ! -z ${statuses[0]} ]]; then
        status+=($(apply_foreground cyan "${statuses[0]};"))
    fi

    # staged count
    if [[ ${statuses[4]} -gt 0 ]]; then
        status+=($(apply_foreground green "S;"))
    fi

    # modified count
    if [[ ${statuses[3]} -gt 0 ]]; then
        status+=($(apply_foreground yellow "M;"))
    fi

    # deleted count
    if [[ ${statuses[2]} -gt 0 ]]; then
        status+=($(apply_foreground red "D;"))
    fi

    # untracked count
    if [[ ${statuses[1]} -gt 0 ]]; then
        status+=($(apply_foreground magenta "U;"))
    fi

    # stashed count
    if [[ ${statuses[5]} -gt 0 ]]; then
        status+=($(apply_foreground light_magenta "ST;"))
    fi

    IFS=' ' echo -n "[${status[*]}]"
    return 0
}

print_exitcode() {
    local -r exitcode=$1

    if [[ $exitcode -eq 0 ]]; then
        echo -n ''
        return 0
    fi

    apply_foreground light_red "$exitcode"
    return 0
}

print_suspended_jobs_count() {
    local -r count=$(get_suspended_jobs_count)

    if [[ $count -eq 0 ]]; then
        echo ''
        return 0
    fi

    echo -n $(apply_foreground light_yellow "$count")
    return 0
}

rightalign_git_exitcode() {
    local -r exitcode="$1"
    local -a statuses
    statuses+=("$(print_suspended_jobs_count)")
    statuses+=("$(print_exitcode $exitcode)")
    statuses+=("$(git_status)")

    # when using colors we need to compensate https://superuser.com/a/517110
    local -r len_string=$(echo -en ${statuses[*]} | sed 's/\x1b\[[0-9;]*m//g' | wc -c)
    local -r len_colored_string=$(echo -en ${statuses[*]} | wc -c)
    IFS=' ' printf '%*b' $(($COLUMNS + $len_colored_string - $len_string)) "${statuses[*]}"
}

lower_rightprompt() {
    local -r exitcode=$1
    printf "%*s" $COLUMNS $(print_exitcode $exitcode)
}

upper_rightprompt() {
    printf "%*s" $COLUMNS "$(git_status) $(print_jobs_status)"
}

# Change the window title of X terminals
case ${TERM} in
[aEkx]term* | rxvt* | gnome* | konsole* | interix | tmux*)
    PS1='\[\033]0;\u@\h:\w\007\]'
    ;;
screen*)
    PS1='\[\033_\u@\h:\w\033\\\]'
    ;;
*)
    unset PS1
    ;;
esac

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database instead of using /etc/DIR_COLORS.  Try to use the external file first to take advantage of user additions.
# We run dircolors directly due to its changes in file syntax and
# terminal name patching.
use_color=false
if type -P dircolors >/dev/null; then
    # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
    LS_COLORS=
    if [[ -f ~/.dir_colors ]]; then
        eval "$(dircolors -b ~/.dir_colors)"
    elif [[ -f /etc/DIR_COLORS ]]; then
        eval "$(dircolors -b /etc/DIR_COLORS)"
    else
        eval "$(dircolors -b)"
    fi
    # Note: We always evaluate the LS_COLORS setting even when it's the
    # default.  If it isn't set, then `ls` will only colorize by default
    # based on file attributes and ignore extensions (even the compiled
    # in defaults of dircolors). #583814
    if [[ -n ${LS_COLORS:+set} ]]; then
        use_color=true
    else
        # Delete it if it's empty as it's useless in that case.
        unset LS_COLORS
    fi
else
    # Some systems (e.g. BSD & embedded) don't typically come with
    # dircolors so we need to hardcode some terminals in here.
    case ${TERM} in
    [aEkx]term* | rxvt* | gnome* | konsole* | screen | tmux* | cons25 | *color) use_color=true ;;
    esac
fi

if ${use_color}; then
    if [[ ${EUID} == 0 ]]; then
        # user is root
        PS1+='\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '
    else
        # user is NOT root
        [[ -n $TMUX ]] && hostname='tmux'
        case $PS1PROFILE in
        dp1)
            PROMPT_COMMAND='last_exitcode=$?'
            PROMPT_DIRTRIM=2
            [[ -n $TMUX ]] && hostname='tmux'
            PS1='\[$(tput sc; rightalign_git_exitcode $last_exitcode; tput rc)\]\[\033[01;32m\]'${hostname:-"\\h"}'\[\033[01;34m\]\[\033[00m\] \w \[\033[01;34m\]\$\[\033[00m\] '
            ;;
        dp2)
            PROMPT_COMMAND='last_exitcode=$?'
            PROMPT_DIRTRIM=2
            PS1='\[$(tput sc; upper_rightprompt; tput rc)\]${hostname:-\h}:\w\n'
            PS1+='\[$(tput sc; lower_rightprompt $last_exitcode; tput rc)\]\u \$ '
            ;;
        gentoo)
            PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
            ;;
        *)
            [[ -z $PS1 ]] && PS1='\u@\h \w \$ '
            ;;
        esac
    fi
else
    # show root@ when we don't have colors
    PS1+='\u@\h \w \$ '
fi

unset use_color hostname
