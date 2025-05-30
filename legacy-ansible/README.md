# linux

Collection of `Linux` related repositories and scripts to make my life easier.

## Installation

### Requirements

Get `ansible` or just copy as you see fit.

### Install

```bash
git clone https://github.com/dpopchev/linux.git
ansible-playbook local.yml -K
```

## Usage

Roles use the `localhost` variables:

- `dphome` is under `~/.dpopchev` the home of most `roles` artefacts
- `dpdir.bin` stores executables and when installing bash is set to be the
  leading search path, e.g. `~/.dpopchev/bin:$PATH`
- `dpdir.tools` stores `dmenu_selector` search path for quick and convenient
  access (after `dmenu` role is used)

### Tags

Each role has associated tag.

```bash
ansible-playbook... --list-tags
```

Some need to be run explicitly, i.e. they have additional `never` tag attached
to them.

Roles also provide the tag categories

- `setup` for installation of configurations files and such
- `packages` for installation of packages

### Roles

Roles follow a general structure:

- `tasks/main.yml` governs task execution order
- `tasks/TASK_NAME.yml` particular step to achieve a state, if needed
- `vars/main.yml` variables associated with the tasks
- `files/TASK_NAME/*` files the task would copy or symlink
- `templates/TASK_NAME/*.j2` jinja templates the task would use
- `defaults/main.yml` default values of parameters to be pass by the CLI `extra-vars`

In general fine tune roles using parameters:

```bash
ansible-playbook... -t <ROLE_TAG> \
    --extra-vars '{"<ROLE_VAR>": "<VAR_VALUE>"}'
```

#### dotfiles_handler

General purpose role handling dotfiles. It is expecting a list of file metadata
using the `dotfiles_handler_target` variable.

Each entry should have one of the following fields for the cited purpose:

- `name` is the name of the file or general description
- `kind` is one of `(link, file, template)` setting the strategy for the file,
   namely create a link or copy the file or use a template
- `should_backup` governs whether to backup existing destination file
- `src` full path to the source file
- `dest` full path to the destination

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

Do not forget to see whether `bashrc.private` is sourced by `bashrc`.

##### role variables

- `bash_profile_browser`: default browser
- `bash_profile_pager`: man page browser
- `bash_profile_terminal`: default terminal, used by i3 window manager
- `bash_profile_visual`: default editor used when lacking advanced terminal functionality
- `bash_profile_editor`: default editor used by all modern apps and terminals
- `bash_bashrc_profile`: default PS1 profile

#### nvim

Configuration is partially based on [kickstart](https://github.com/nvim-lua/kickstart.nvim/tree/master).

When using a `flatpak` do, assuming `bash` is installed:

```bash
# create alias file to run vim
# ~/.dpopchev/bashrc/flatpak_nvim.aliases
alias vim="flatpak run io.neovim.nvim"
alias nvim="flatpak run io.neovim.nvim"
```

```bash
# link the configuration
ln -s ~/.config/nvim/ ~/.var/app/io.neovim.nvim/config/nvim
```

#### touchpad

Touchpad is disabled by default using a application entry. Use `xinput list` to
check the device name and then pass it as CLI argument, e.g.

##### role variables

- `touchpad_xinput_devname_pad`: is the touchpad device name
- `touchpad_xinput_devname_padkeys`: are the physical keys on the touchpad

#### i3wm

Will autostart destop entries using. See what will be ran with

```
dex -ad --environment i3
```

#### dmenu

Installs a `dmenu_selector` entry in ``

#### xrandr

Pre-defined screen layouts, makes a configuration on startup using a desktop
entry.

##### role variables

- `xrandr_main_monitor_name`: `xrandr` monitor name to be primary and active only on startup

#### screenshot

`dmenu` tool to take screenshots.

##### role variables

- `screenshot_storage_path`: use to save screenshots

#### popos24

Configuration of Pop OS 24.

- Use `dconf reset -f /org/gnome/` to force reset settings.
- Use `dconf dump /org/gnome/ > gnome-settings-backup.dconf` to backup.
- Use `dconf load /org/gnome/ < gnome-settings-backup.dconf` to restore.
- Use `dconf watch /` to see changes while clicking around.

Good have `gnome-tweaks` and `dconf-editor`

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
