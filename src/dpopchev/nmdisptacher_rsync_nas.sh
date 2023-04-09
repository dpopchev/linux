#!/usr/bin/env bash

interface="$1"
status="$2"
group='rsync-nas'

home_uuid=''

[[ $status != "up" ]] && exit 0;
[[ $CONNECTION_UUID != $home_uuid ]] && exit 0;

IFS=, read -ra users <<< "$(grep $group /etc/group | cut -d: -f4)"
for user in ${users[@]}; do
	display=":$(ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
	uid=$(id -u $user)
	sudo -i -u $user bash -c 'bash ~/.dpopchev/rsync_nas.sh'
	sudo -u $user DISPLAY=$display DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus notify-send "$group: auto backup, see local log"
done
