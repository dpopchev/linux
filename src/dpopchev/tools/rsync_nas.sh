#!/usr/bin/env bash

grep -Po 'Number of .+' ${HOME}/.rsync_nas.log | xargs -i notify-send {}
