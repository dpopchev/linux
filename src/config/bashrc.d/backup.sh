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

backup () {
    local day=$(date +%U-%A)
    local arguments=()
    # arguments+=(-a --delete --quite --inplace)
    # arguments+=(--backup --backup-dir=${DST}/${day})
    # arguments+=(${SRC})
    arguments+=('-T' '5')
    wget ${arguments[*]} 192.168.1.99:5001
}
