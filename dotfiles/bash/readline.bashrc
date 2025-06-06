#!/usr/bin/env bash

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]]; then
    # Shell is non-interactive.  Be done now!
    return
fi

# nice bash features
shopt -s autocd
shopt -s cdspell
shopt -s checkjobs
shopt -s dirspell

# Check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS
# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Disable completion when the input buffer is empty.  i.e. Hitting tab
# and waiting a long time for bash to expand all of $PATH.
shopt -s no_empty_cmd_completion

# Note: bind used instead of sticking these in .inputrc
bind "set bell-style visible"
bind "set blink-matching-paren on"
bind "set colored-completion-prefix on"
bind "set colored-stats on"

bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set completion-prefix-display-length 3"
bind "set completion-query-items 50"
# bind "set convert-meta on"
# bind "set disable-completion off"
bind "set editing-mode emacs"
bind "set enable-meta-key on"
# bind "set history-preserve-point off"
# bind "set history-size -1"
# bind "set input-meta off"
# bind "set mark-directories on"
# bind "set mark-modified-lines off"
bind "set mark-symlinked-directories on"
# bind "set match-hidden-files on"
# bind "set menu-complete-display-prefix off"
# bind "set page-completions on"
bind "set show-all-if-ambiguous on"
bind "set show-all-if-unmodified on"
bind "set skip-completed-text on"
# bind "set editing-mode vi"
# bind "set show-mode-in-prompt on"
# bind "set vi-cmd-mode-string +"
# bind "set vi-ins-mode-string :"
bind "set visible-stats on"

bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'

# bind '"\e-\t": complete'
# bind '"\t": menu-complete'
# bind '"\t[Z": menu-complete-backward'

bind 'set bind-tty-special-chars off'
bind '"\C-w": backward-kill-word'

bind 'set horizontal-scroll-mode off'
