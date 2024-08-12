#!/usr/bin/env bash

intrpr=${1-bash}
locker=${2-i3lock}

xss-lock --transfer-sleep-lock -- $intrpr $locker
