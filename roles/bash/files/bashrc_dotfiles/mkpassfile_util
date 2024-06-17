#!/usr/bin/env bash

function mkpassfile {
    # create a passfile with permisions 600 under ~/.ssh
    # pass passfile name as first argument
    # and password value as second
    local passfile_home=$HOME/.ssh

    if [[ $# -eq 0 ]]; then
        echo 'syntax: make_passfile <fname> <passphrase>'
        echo "description: make a passfile into $passfile_home containing passphrase"
        return 1
    fi

    local passfile="$passfile_home/$1.pass"
    local passphrase="$2"

    if [[ -f $passfile ]]; then
        echo "File $passfile already exists"
        return 17
    fi

    echo "$passphrase" > "$passfile"
    chmod 600 "${passfile}"
}
