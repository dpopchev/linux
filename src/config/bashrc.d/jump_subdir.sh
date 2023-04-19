#!/usr/bin/env bash

jump(){
    dst=$(find -type d -name "$1*" | head -n1 )
    if [[ -z "$dst" ]]; then
        echo "Cannot find $1"; return 2;
    fi
    cd "$dst"
}
