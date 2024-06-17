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

- `tasks/main.yml` governs the corresponding task execution order
- `tasks/TASK_NAME.yml` particular step to achieve a state

### Roles

#### bash

k

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
