#!/usr/bin/env bash

# pass module name from cmd as first argument
MODULE="$1"

# make sure to allow user execute rmmode/modprobe without password via sudoers
if lsmod | grep --word-regexp -q "$MODULE"; then
    sudo rmmod "$MODULE"
    notify-send "Unloaded kernel module: $MODULE"
    exit 0
fi

sudo modprobe "$MODULE"
notify-send "Loaded kernel module: $MODULE"
exit 0
