#!/usr/bin/env bash

get_touchpad_name(){
    echo "$(xinput list --name-only | grep TouchPad)"
}

disable_touchpad(){
    xinput set-prop "$1" 'Device Enabled' 0
}

touchpad=$(get_touchpad_name)
disable_touchpad "$touchpad"
