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

    local timestamp=$(date "+%d/%m/%Y %H:%M:%S")
    local log_message="${timestamp} -- ${message}\n"

    printf "${log_message}" >> ${LOGFILE}

    [[ ! -z $3 ]] && notify-send "${SCRIPT} -- ${message}"
}

sync_only () {
    log "INFO" "${FUNCNAME[*]} for $1"

    local options=("${ROPTIONS[@]}")

    sshpass -f ${PASSFILE} \
        rsync ${options[*]} "${1}" "${RDESTINATION}" 2>> ${LOGFILE}

    if [[ $? -eq 0 ]]; then
        log "INFO" "${SCRIPT} ${FUNCNAME[*]} succeed"
    else
        log "ERROR" "$0 ${FUNCNAME[*]} failed" 1
    fi
}

sync_diff () {
    log "INFO" "${FUNCNAME[*]} for $1"

    local options=("${ROPTIONS[@]}")
    options+=('--inplace' '--backup')

    local timestamp=$(date +%U-%A-%H)
    options+=("--backup-dir=diffs/diff-${timestamp}")

    sshpass -f ${PASSFILE} \
        rsync ${options[*]} "${1}" "${RDESTINATION}" 2>> ${LOGFILE}

    if [[ $? -eq 0 ]]; then
        log "INFO" "${SCRIPT} ${FUNCNAME[*]} succeed"
    else
        log "ERROR" "$0 ${FUNCNAME[*]} failed" 1
    fi
}

log "INFO" "Starting ${SCRIPT}" 1

if [[ -f ${CONFIG} ]]; then
    source "${CONFIG}"
else
    log "ERROR" "Config file missing ${CONFIG}" 1
    exit 2
fi

RDESTINATION="${RUSER}@${RHOST}:${RHOME}/"
ROPTIONS=('-a' '--delete' '--quiet' '--stats' "--log-file=${LOGFILE}")

for pair in "${BACKUP_TARGETS[@]}"; do
    while IFS=',' read -r method target; do
        ${method} "$(realpath -s "${target}")"
    done <<< "${pair}"
done

exit 0
