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
    log 'INFO -- Starting backup'
    local day=$(date +%U-%A)
    local options=('-a' '--delete' '--quiet')
    wget ${arguments[*]} ${BACKUP_HOST}:5001 >> ${LOGFILE} 2>&1
    if [[ $? -eq 0 ]]; then
        log 'INFO -- backup succeed'
    else
        log 'ERROR -- backup failed'
    fi
}
