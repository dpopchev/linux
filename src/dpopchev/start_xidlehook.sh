#!/usr/bin/env bash

# Run xidlehook
xidlehook \
    --detect-sleep \
    --not-when-fullscreen \
    --not-when-audio \
    --timer 420 \
    'brightnessctl -s; brightnessctl s 10%-' \
    'brightnessctl -r' \
    --timer 10 \
    'brightnessctl -r; bash ~/.dpopchev/lock.sh' \
    '' \
    --timer 1800 \
    'systemctl suspend' \
    ''
