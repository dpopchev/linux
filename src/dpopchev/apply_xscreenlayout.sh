#!/usr/bin/env bash

LAPTOP='eDP-1'
EXTERNAL="$1"
MODE="$2"

if xrandr --query | grep -q "$EXTERNAL disconnected"; then
    notify-send "$EXTERNAL is disconnected"
    exit 0
fi

case $MODE in
    ON | on)
        xrandr --output "$LAPTOP" --primary --mode 1920x1080 --pos 2560x360 --rotate normal \
            --output "$EXTERNAL" --mode 2560x1440 --pos 0x0 --rotate normal
        notify-send "$EXTERNAL is ON"
        ;;
    OFF | off)
        xrandr --output "$LAPTOP" --primary --mode 1920x1080 --pos 0x0 --rotate normal \
            --output "$EXTERNAL" --off
        notify-send "$EXTERNAL is OFF"
        ;;
    *)
        notify-send "$MODE is unknown screen layout"
        ;;
esac

exit 0
