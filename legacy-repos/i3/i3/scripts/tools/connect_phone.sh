#!/usr/bin/env bash

SCRIPT=$(basename $0)

notify() {
    notify-send "$SCRIPT: $1"
}

if [[ -z $WIFI_PHONE ]]; then
    notify "Error WIFI_PHONE not set"
    exit 1
fi

SSID=$WIFI_PHONE

nmcli device wifi rescan
errmsg=$(nmcli device wifi connect "$SSID" 2>&1 1>/dev/null)

[[ $? -eq 0 ]] && notify "connected to $SSID"

if [[ $? -ne 0 ]]; then
    notify "$errmsg"
    exit 1
fi
