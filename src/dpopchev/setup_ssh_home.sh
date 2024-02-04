#!/usr/bin/env bash

# Proper way to setup ssh home with templates
# source: https://www.tecmint.com/set-ssh-directory-permissions-in-linux/

SSH_HOME=~/.ssh
SSH_HOME_PERMS=0700
SSH_CONFIG=$SSH_HOME/config

CONFIGS=("authorized_keys" "known_hosts" ${SSH_CONFIG##*/})
CONFIG_PERMS=600
KEY_PERMS=600

setup_config(){
	touch "$1"
	chmod "$2" "$1"
}

setup_key(){
	chmod "$2" "$1"
	chmod "$2" "${1%.*}"
}

setup_strict(){
	chmod 755 ~/
}

[[ -d $SSH_HOME ]] || mkdir --parents $SSH_HOME
chmod $SSH_HOME_PERMS $SSH_HOME

[[ -f $SSH_CONFIG ]] || cat <<'EOF' > $SSH_CONFIG
# Host HOSTNAME
#	HostName ADDRESS
#	User USERNAME
#	PreferredAuthentications publickey,password
#	IdentityFile PRIVATE_KEY_ABS_PATH
#	AddKeysToAgent yes
#	ProxyCommand PROXY_CMD
#	Port PORT
EOF

for config in ${CONFIGS[@]}; do
	setup_config "$SSH_HOME/$config" "$CONFIG_PERMS"
done

ssh_keys=($(find $SSH_HOME/ -maxdepth 1 -name "*.pub"))
[[ ${#ssh_keys[@]} -gt 0 ]] && for ssh_key in "${ssh_keys[@]}"; do setup_key $ssh_key $KEY_PERMS; done 
