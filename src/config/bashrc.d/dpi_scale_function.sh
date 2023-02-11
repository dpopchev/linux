#!/usr/bin/env bash

function scale_dpi {
    local dpi=$(xdpyinfo | grep dots | grep -P -o '\b\d+')
    local new_dpi=$(printf "%.0f" $(bc -l <<< "${dpi}*$1"))
    echo "Xft.dpi: ${new_dpi}" | xrdb -merge
}
