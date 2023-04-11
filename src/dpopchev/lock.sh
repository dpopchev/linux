#!/usr/bin/env bash

make_temp_image() {
    mktemp /tmp/lock_bg_XXXXXX.png
}

make_screenshot() {
    import -window root "$1"
}

pixelate_screenshot() {
    convert "$1" -scale 10% -scale 1000% "$1"
}

blur_screenshot() {
    convert "$1" -blur 2,5 "$1"
}

background=$(make_temp_image)
make_screenshot $background
pixelate_screenshot $background

i3lock --show-failed-attempts --nofork --image $background

trap 'rm -f $background' EXIT
