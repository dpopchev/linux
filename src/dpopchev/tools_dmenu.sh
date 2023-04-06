#!/usr/bin/env bash

tools_home="${HOME}/.dpopchev/tools"
entries=()

for entry in $tools_home/*; do
    entry=$(basename ${entry%.*})
    entries+=($entry)
done

printf '%s\n' "${entries[@]}" | dmenu | xargs -i bash "${tools_home}/{}.sh"
