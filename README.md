# linux

Collection of `Linux` related repositories and scripts to make my life easier.

## Installation

### Requirements

Get `ansible` or just copy as you see fit.

### Install

```
git clone https://github.com/dpopchev/linux.git
ansible-playbook local.yml -K
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

Each role is associated with same tag. Some roles need to be called explicitly.

See below for variables you can fine tune the roles. In general the syntax is

```
ansible-playbook... -t <ROLE_TAG> \
    --extra-vars '{"<ROLE_VAR>": "<VAR_VALUE>"}'
```

For up to date default values see the file under `.../role/defaults/`.

#### alacritty

- `alacritty_themes_path`: where to store alacritty-themes repository
- `alacritty_theme_choice`: theme choice found under repo `themes`, add the extension
- `alacritty_font_family`: font family name, e.g. "DejaVu Sans Mono"
- `alacritty_font_style`: style, e.g. "Regular"
- `alacritty_font_size`: font size, e.g. 8

#### bash

##### strategy

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

##### role variables

- `bash_profile_browser`: default browser
- `bash_profile_pager`: man page browser
- `bash_profile_terminal`: default terminal, used by i3 window manager
- `bash_profile_visual`: default editor used when lacking advanced terminal functionality
- `bash_profile_editor`: default editor used by all modern apps and terminals

#### nvim

Configuration is partially based on [kickstart](https://github.com/nvim-lua/kickstart.nvim/tree/master).

#### touchpad

Touchpad is disabled by default using a application entry. Use `xinput list` to
check the device name and then pass it as CLI argument, e.g.

#### i3wm

Will autostart destop entries using. See what will be ran with

```
dex -ad --environment i3
```

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
