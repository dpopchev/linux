#!/usr/bin/env bash

action=${1-toggle}

pactl set-sink-mute @DEFAULT_SINK@ $action

notify-send "Volume $(pactl get-sink-mute @DEFAULT_SINK@)"
