#!/usr/bin/env bash

LOGFILE="${HOME}/.local/var/log/backup.log"
CONFIG="${HOME}/.backuprc"
SCRIPT=$(basename "$0")

usage () {
    echo "Simple backup shell rsync wrapper"
    echo "Config file location: ${CONFIG}"
    echo "-- PASSFILE, passphrase to be used"
    echo "-- RHOST, remote host"
    echo "-- RUSER, remote host user"
    echo "-- RHOME, remote host"
    echo "-- BACKUP_TARGETS, tuples (operation,absolutepath) array;"
    echo "Find log at: ${LOGFILE}"
}

log () {
    local logdir=$(dirname ${LOGFILE})
    [ ! -d "${logdir}" ] && mkdir --parents ${logdir}

    local message="$1 -- $2"

    local timestamp=$(date "+%d-%m-%Y %H:%M:%S")
    local log_message="${timestamp} -- ${message}\n"

    printf "${log_message}" >> ${LOGFILE}

    [[ ! -z $3 ]] && notify-send "backup.sh -- ${message}"
}

sync () {
    log "INFO" "${SCRIPT} for $1"

    local day=$(date +%U-%A)
    local options=('-a' '--delete' '--quiet')
    local rhost="${RUSER}@${RHOST}"

    sshpass -f ${PASSFILE} \
        rsync ${options[*]} ${1} "${rhost}:${RHOME}/" >> ${LOGFILE} 2>&1

    if [[ $? -eq 0 ]]; then
        log "INFO" "${SCRIPT} succeed"
    else
        log "ERROR" "$0 failed"
    fi
}

log "INFO" "Starting ${SCRIPT}" 1

if [[ -f ${CONFIG} ]]; then
    source "${CONFIG}"
else
    log "ERROR" "Config file missing ${CONFIG}" 1
    exit 2
fi

for pair in "${BACKUP_TARGETS[@]}"; do
    while IFS=',' read -r method target; do
        ${method} $(realpath -s ${target})
    done <<< "${pair}"
done

exit 0
