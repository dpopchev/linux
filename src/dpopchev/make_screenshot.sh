#!/usr/bin/env bash

screenshots_home="${HOME}/Pictures/screenshots"

scrot_options=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        full)
            scrot_options+=()
            shift
            ;;
        delay)
            scrot_options+=('-d' '3')
            shift
            ;;
        select)
            scrot_options+=('-s' '-f')
            shift
            ;;
        window)
            scrot_options+=('-s' '-f')
            shift
            ;;
        *)
            shift
            ;;
    esac
done

mkdir --parents $screenshots_home

scrot "${scrot_options[@]}" $screenshots_home/'%F_%T_$wx$h.png' \
    -e 'xclip -selection clipboard -target image/png -i $f'
