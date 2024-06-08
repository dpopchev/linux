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
- [linux-xresources](https://github.com/dpopchev/linux-xresources)
- [linux-xxkb](https://github.com/dpopchev/linux-xxkb)
- [linux-gentoo](https://github.com/dpopchev/linux-gentoo)
- [linux-qtile](https://github.com/dpopchev/linux-qtile)
- [linux-xmonad](https://github.com/dpopchev/linux-xmonad)
- [linux-snapshot](https://github.com/dpopchev/linux-snapshot)
