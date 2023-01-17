#!/usr/bin/env bash

LOGFILE="${HOME}/.local/var/log/backup.log"

help () {
    echo "expecting external variables"
    echo "-- BACKUP_USER, remote host user"
    echo "-- BACKUP_HOST, remote host"
    echo "-- BACKUP_PASS, passphrase to be used"
    echo "-- BACKUP_TARGETS, path-like variable listing backup targets"
    echo "Find log at: ${LOGFILE}"
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
