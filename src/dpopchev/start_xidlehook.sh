#!/usr/bin/env bash

# Run xidlehook
xidlehook \
    --detect-sleep \
    --not-when-fullscreen \
    --not-when-audio \
    --timer 420 \
    '' \
    '' \
    --timer 10 \
    'bash ~/.dpopchev/lock.sh' \
    '' \
    --timer 1800 \
    'systemctl suspend' \
    ''
