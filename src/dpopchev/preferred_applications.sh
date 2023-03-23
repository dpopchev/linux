#!/usr/bin/env bash

declare -A APPS

APPS[tlp]='Service for laptop power management and battery threshold'
APPS[xfce4-power-manager]='power manager with settings, enables brightness buttons'

print_apps(){
    for app in "${!APPS[@]}"; do
        echo "$app: ${APPS[$app]}"
    done
}

print_apps
