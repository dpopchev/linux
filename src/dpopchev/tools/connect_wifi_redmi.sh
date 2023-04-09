#!/usr/bin/env bash

sudo nmcli device wifi list --rescan yes &> /dev/null
sudo nmcli device wifi connect 'Redmi Note 8 Pro' 2>&1 | xargs -i notify-send {}
