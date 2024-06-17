# linux

Collection of `Linux` related repositories and scripts to make my life easier.

## Installation

### Requirements

Get `ansible` or just copy as you see fit.

### Install

```
git clone https://github.com/dpopchev/linux.git
ansible-playbook local.yml
```

## Usage

Each has associated tag. Some roles need to be run explicitly, i.e. they have
additional `never` tag attached to them.

Roles follow a general structure:

- `tasks/main.yml` governs task execution order
- `tasks/TASK_NAME.yml` particular step to achieve a state
- `vars/main/TASK_NAME.yml` variables associated with the tasks
- `files/TASK_NAME/*` files the task would copy or symlink

### Roles

#### bash

`bash` shell setup starts dogmatically with `~/.bash_profile` sourcing in order:

1. `~/.profile`
1. `~/.config/dpopchev/profile`
1. `~/.bashrc`
1. `~/.bashrc.private`

It will source first existing `~/.profile` and then go over
`~/.config/dpopchev/profile/*`. The latter provides mechanism to populate
environment with variables such as `EDITOR`, or user-specific ones like
`PS1PROFILE`, which is used to select a `PS` profile found into
`~/.config/dpopchev/bashrc/riced_ps1`.

`~/.bashrc.private` will source `~/.config/dpopchev/bashrc/*` for interactive
shells and populate environment with user defined functions, aliases and such.

### Tags

See available tags

```
ansible-playbook --list-tags local.yml
```

#### Run default roles tasks

```
ansible-playbook local.yml
```

#### Run all roles tasks

```
ansible-playbook local.yml --tags 'all,never'
```

## Related repos

- [linux-i3](https://github.com/dpopchev/linux-i3)
- [linux-tmux](https://github.com/dpopchev/linux-tmux)
- [linux-vim](https://github.com/dpopchev/linux-vim)
- [linux-qtile](https://github.com/dpopchev/linux-qtile)
- [linux-xmonad](https://github.com/dpopchev/linux-xmonad)
