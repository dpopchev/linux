#!/usr/bin/env bash

tools_home="${HOME}/.config/i3/scripts/tools"
entries=()

for entry in $tools_home/*; do
    entry=$(basename ${entry%.*})
    entries+=($entry)
done

printf '%s\n' "${entries[@]}" | dmenu -l 10 | xargs -i bash "${tools_home}/{}.sh"
