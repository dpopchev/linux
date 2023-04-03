#!/usr/bin/env bash

function make_passfile {
    local dst="$HOME/.ssh/$1.pass"
    local phrase="$2"
    if [[ -f $dst ]]; then
        echo "File already exists, $dst"
        return 17
    fi
    
    echo "$phrase" > "$dst"
    chmod 600 "${dst}"
}
