#!/usr/bin/env bash

main=${1-eDP-1}

while IFS= read -r screen; do
    [[ $screen != $main ]] && xrandr --output $screen --off
done < <(xrandr --listactivemonitors | grep -oP '\b\w+-\d$')

xrandr | grep $main | grep -q primary
[ $? -ne 0 ] && xrandr --output $main --primary --auto
