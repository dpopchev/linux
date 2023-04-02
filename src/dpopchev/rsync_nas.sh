#/usr/bin/env bash

config="${HOME}/.config/rsync_nas.conf"
scriptname=$(basename "$0")
scriptname=${scriptname%%.*}
logfile=${HOME}/.$scriptname.log

usage(){
    echo 'Differential backup to NAS using rsync'
    echo "Config file is sourced from: $config"
    echo "-- PASSFILE: file with pass phrase to be used via sshpass"
    echo "-- RHOST: remote host"
    echo "-- RUSER: remote user"
    echo "-- RHOME: remote home directory"
    echo "-- SRCS: array of absolute paths to backup"
}

[[ $# -gt 0 ]] && { usage; exit 1; }
[[ ! -f $config ]] && { echo "Missing $config"; usage; exit 2; }

source $config

if ! ping -c1 -w3 -q "$RHOST" > /dev/null 2>&1; then
    notify-send "$scriptname: cannot reach $RHOST"
    exit 6
fi

destination="$RUSER@$RHOST:$RHOME/"

rsync_opts=('-a' '--delete' '--quiet' '--stats' "--log-file=$logfile")
rsync_opts+=('--inplace' '--backup')

timestamp=$(date +%U-%A)
rsync_opts+=("--backup-dir=diffs/diff-${timestamp}")

normalized_srcs=()
for i in "${SRCS[@]}"; do
    i=$(realpath -s $i)
    case "${i}" in
        /)
            i="/"
        ;;
        */)
            i="${i%/}"
        ;;
        esac
    normalized_srcs+=("${i}")
done

notify-send "$scriptname: starting, see $logfile"

cat /dev/null > $logfile
sshpass -f ${PASSFILE} rsync "${rsync_opts[@]}" "${normalized_srcs[*]}" "${destination}"

exit 0
