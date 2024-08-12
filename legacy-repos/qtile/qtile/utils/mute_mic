#!/usr/bin/env bash

action=${1-toggle}

pactl set-source-mute @DEFAULT_SOURCE@ $action

notify-send "Mic $(pactl get-source-mute @DEFAULT_SOURCE@)"
