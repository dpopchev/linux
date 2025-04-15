#!/usr/bin/env bash

jcd(){
    local -r target="${1%/}"
    # jump into directory matching partial pattern passed as argument
    local IFS=$'\n'; select subdir in $(find -not -path '*/.*' -type d -name "${target}*"); do
        cd "$subdir"
        break
    done;
}
