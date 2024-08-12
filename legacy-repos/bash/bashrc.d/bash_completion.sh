#!/usr/bin/env bash

# shamelessly copied from ubuntut; for future reference if needed
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# if ! shopt -oq posix; then
#   if [ -f /usr/share/bash-completion/bash_completion ]; then
#     source /usr/share/bash-completion/bash_completion
#   elif [ -f /etc/bash_completion ]; then
#     source /etc/bash_completion
#   fi
# fi

# EXPECTED_BASH_COMPLETION=/usr/share/bash-completion/bash_completion
EXPECTED_BASH_COMPLETION=~/.local/share/bash-completion/bash_completion

# Use bash-completion, if available
[[ $PS1 && -f $EXPECTED_BASH_COMPLETION ]] && source $EXPECTED_BASH_COMPLETION
