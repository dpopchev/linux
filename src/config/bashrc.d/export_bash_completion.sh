#!/usr/bin/env bash

# EXPECTED_BASH_COMPLETION=/usr/share/bash-completion/bash_completion
EXPECTED_BASH_COMPLETION=~/.local/share/bash-completion/bash_completion

# Use bash-completion, if available
[[ $PS1 && -f $EXPECTED_BASH_COMPLETION ]] && source $EXPECTED_BASH_COMPLETION
