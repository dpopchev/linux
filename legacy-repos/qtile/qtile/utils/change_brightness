#!/usr/bin/env bash

MAX_LIMIT=100

action=$1
delta=$2

get_brightness() {
    echo $(xbacklight -get)
}

make_delta() {
    local action=$1
    local delta=$2

    if [[ $action == 'set' ]]; then
        echo $delta
        return
    fi

    if [[ $action == 'dec' ]]; then
        echo $delta
        return
    fi

    if [[ $(get_brightness) -ge $MAX_LIMIT ]]; then
        echo "0"
        return
    fi

    echo $delta
    return
}

make_action() {
    case $1 in
        set) echo -set;;
        inc) echo -inc;;
        dec) echo -dec;;
        *) echo 'unknown';;
    esac
}

xbacklight $(make_action $action) $(make_delta $action $delta)

brightness=$(get_brightness)
notify-send "Brightness: $brightness%" -h int:value:$brightness -h string:synchronous:brightness
