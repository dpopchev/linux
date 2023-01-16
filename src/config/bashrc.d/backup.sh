#!/usr/bin/env bash

LOGFILE="${HOME}/.local/var/log/backup.log"

help () {
    echo "usage: PASSPHRASE='pass'; "
}

log () {
    local logdir=$(dirname ${LOGFILE})
    [ ! -d "${logdir}" ] && mkdir --parents ${logdir}

    local timestamp=$(date "+%d-%m-%Y %H:%M:%S")
    printf "${timestamp} -- ${*}\n" >> ${LOGFILE}
}
