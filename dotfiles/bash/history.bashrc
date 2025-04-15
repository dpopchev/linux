#!/usr/bin/env bash

# history size
export HISTSIZE=10000
export HISTFILESIZE=10000

# ignore commands or pattern matches, i.e. `*`
export HISTIGNORE="exit:clear:bg:fg:history*"

# don't put duplicate lines or lines starting with space
# in the history. See bash(1) for more options
export HISTCONTROL=erasedups:ignoredups:ignorespace

# timestamp of each command in its history
export HISTTIMEFORMAT='%F %T '

# Causes bash to append and write to history instead of overwriting it so if you
# start a new terminal, you have old session history
# add `history -n` to force reload it from the fail at every command, e.g.
# PROMPT_COMMAND='history -a; history -n'
shopt -s histappend
export PROMPT_COMMAND='history -a'

# Write a multi line command in a single line
shopt -s cmdhist
