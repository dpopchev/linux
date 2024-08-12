#!/usr/bin/env bash

TMPFILE=/tmp/lockbg_XXXXXX.png
BGEFFECT=pixelate

make_screenshot() {
    import -window root "$1"
}

pixelate() {
    # BGEFFECT
    convert "$1" -scale 10% -scale 1000% "$1"
}

blur() {
    # BGEFFECT
    convert "$1" -blur 2,5 "$1"
}

screenshot=$(mktemp "$TMPFILE")

make_screenshot $screenshot

$BGEFFECT $screenshot

i3lock --show-failed-attempts --nofork --image $screenshot

trap 'rm -f $background' EXIT
