#!/usr/bin/env bash

# Proper way to setup ssh home with templates
# source: https://www.tecmint.com/set-ssh-directory-permissions-in-linux/

SSH_HOME=~/.ssh
SSH_CONFIG=$SSH_HOME/config
CONFIGS=("authorized_keys" "known_hosts" ${SSH_CONFIG##*/})

setup_ssh_home(){
    mkdir --parents $SSH_HOME
    chmod 0700 $SSH_HOME
}

add_config_template(){
    printf "# Host HOSTNAME\n" >> $SSH_CONFIG
    printf "#\tHostName ADDRESS\n" >> $SSH_CONFIG
    printf "#\tUser USERNAME\n" >> $SSH_CONFIG
    printf "#\tPreferredAuthentications publickey,password\n" >> $SSH_CONFIG
    printf "#\tIdentityFile LOCATION_PRIVATE_KEY\n" >> $SSH_CONFIG
    printf "#\tAddKeysToAgent yes\n" >> $SSH_CONFIG
    printf "#\tProxyCommand TBD\n" >> $SSH_CONFIG
    printf "#\tPort PORT\n" >> $SSH_CONFIG
}

setup_config(){
    touch "$1"
    chmod 600 "$1"
}

setup_strict(){
    chmod 755 ~
}

setup_keys(){
    for key in $SSH_HOME/*.pub; do
        chmod 600 "$key"
        chmod 600 "${key%.*}"
    done
}

setup_ssh_home

[[ ! -f $SSH_CONFIG ]] && add_config_template

for config in ${CONFIGS[@]}; do
    setup_config "$SSH_HOME/$config"
done

setup_keys
