#!/usr/bin/env bash

show_term_colors() {
    # preview terminlal colors and their escape sequences
    for color in {0..255}; do
        printf "\\e[38;5;%sm%3s\\e[0m " $color "\\e[38;5;${color}m"
        if ! ((($color + 1) % 8)); then
            echo
        fi
    done
}
