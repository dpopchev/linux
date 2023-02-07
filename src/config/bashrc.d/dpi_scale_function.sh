#!/usr/bin/env bash

function scale_dpi {
    local dpi=$(xdpyinfo | grep dots | grep -P -o '\b\d+')
    xrdb -merge <(printf "Xft.dpi: %.0f" $(bc -l <<< "${dpi}*$1"))
}
