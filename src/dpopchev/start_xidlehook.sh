#!/usr/bin/env bash

# Run xidlehook
xidlehook \
    --detect-sleep \
    `# Don't lock when there's a fullscreen application` \
    --not-when-fullscreen \
    `# Don't lock when there's audio playing` \
    --not-when-audio \
    `# Dim the screen after 60 seconds, undim if user becomes active` \
    --timer 420 \
    'brightnessctl -s; brightnessctl s 10%-' \
    'brightnessctl -r' \
    `# Undim & lock after 10 more seconds` \
    --timer 10 \
    'brightnessctl -r; bash ~/.dpopchev/lock.sh' \
    '' \
    `# Finally, suspend an hour after it locks` \
    --timer 20 \
    'systemctl suspend' \
    ''
