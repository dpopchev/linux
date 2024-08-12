#!/usr/bin/env bash

notify-send "$(acpitool -b | tr -s ' ')"
