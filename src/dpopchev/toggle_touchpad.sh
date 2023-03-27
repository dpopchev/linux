#!/usr/bin/env bash

get_touchpad_name(){
    echo "$(xinput list --name-only | grep TouchPad)"
}

get_touchpad_state(){
    echo $(xinput list-props "$1" | grep 'Device Enabled' | sed 's/^.*:[ \t]*//')
}

toggle_touchpad_state(){
    declare -a STATES=(1 0)
    xinput set-prop "$1" 'Device Enabled' ${STATES[$2]}
}

touchpad=$(get_touchpad_name)
state=$(get_touchpad_state "$touchpad")
toggle_touchpad_state "$touchpad" "$state"
