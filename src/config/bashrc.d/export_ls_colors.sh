#!/usr/bin/env bash

# do not blink in red background when missing something
# https://stackoverflow.com/a/65839614
# LS_COLORS=$(echo $LS_COLORS | sed -E 's/:(or|mi)=[^:]+/:\1=03/g')
LS_COLORS=$(echo $LS_COLORS | sed -E 's/:(or|mi)=[^:]+/:\1=02/g')
