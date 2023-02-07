#!/usr/bin/env bash

function scale_dpi {
    local dpi=$(xdpyinfo | grep dots | grep -P -o '\b\d\d')
    xrdb -merge <(printf "Xft.dpi: %0.f" $(bc -l <<< "${dpi}*$1"))
}
