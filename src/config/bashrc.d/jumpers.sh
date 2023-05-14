#!/usr/bin/env bash

jcd(){
    local IFS=$'\n'; select subdir in $(find -type d -name "$1*"); do
        cd "$subdir"
        break
    done;
}

jedit(){
    local IFS=$'\n'; select subdir in $(find -type f -name "$1*"); do
        $EDITOR "$subdir"
        break
    done;
}
