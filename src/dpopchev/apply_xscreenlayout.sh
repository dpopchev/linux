#!/usr/bin/env bash

laptop='eDP-1'
external="$1"
desired_state="${2^^}"

if [[ $desired_state == 'OFF' ]]; then
    xrandr --output $laptop --auto --primary --output $external --off
    exit 0
fi

get_expected_resolution () {
    echo $(xrandr --output "$1" --auto --dryrun | \
        grep -iP "$1" | grep -oP '\d+x\d+')
}

external_resolution=$(get_expected_resolution $external)
laptop_resolution=$(get_expected_resolution $laptop)
laptop_offset=$(echo $laptop_resolution | sed -rn 's/([0-9]+)x[0-9]+/\1/p')

case $external_resolution in
    3840x2160)
        scale=1
        ;;
    *)
        scale=1
        ;;
esac

xrandr --output $laptop --primary --auto --pos 0x0 \
    --output $external --auto --scale ${scale}x${scale} --pos ${laptop_offset}x0 --rotate normal
