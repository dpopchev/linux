#!/usr/bin/env bash

screenshots_home="${HOME}/Pictures/screenshots"

mkdir --parents $screenshots_home

scrot -s -d 3 $screenshots_home/'%F_%T_$wx$h.png' \
    -e 'xclip -selection clipboard -target image/png -i $f'  \
    && notify-send "Screenshot saved: $screenshots_home"
