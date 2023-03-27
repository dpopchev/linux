#!/usr/bin/env bash

declare -A APPS

APPS[tlp]='Service for laptop power management and battery threshold, see tlpui'
APPS[dmenu]='Program launcher'
APPS[i3lock]='Screen locker'
APPS[i3status]='Status bar generator'
APPS[xss-lock]='Interface hooking up locker to screen saver'
APPS[brightnessctl]='Read and control device brightness'
APPS[dunst]='Lightweight replacement for notification daemon'
APPS[arandr]='xrandr front end'
APPS[xxkb]='Indicator keyboard layout and keep track set per window'

print_apps(){
    for app in "${!APPS[@]}"; do
        echo "$app: ${APPS[$app]}"
    done
}

print_apps
