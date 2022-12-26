SHELL := /usr/bin/env bash

### ---------------------------------------------------------------------------
### Makefile to rule distribution of Linux configurations I use.
### The goal is to create soft links to assure keeping track of changes in git.
### Use with: make <target>

SRC := src

# utilities
BACKUP = [[ ! -e $(1) ]] || yes | cp --backup=numbered --recursive "$(1)" "$(1).bak"; true
RM_LINK = [[ ! -L $(1) ]] || unlink "$(1)"
RM_FILE = [[ ! -f $(1) ]] || rm --force --recursive "$(1)"
RM_DIR = [[ ! -d $(1) ]] || rm --force --recursive "$(1)"
LN = ln -s $(realpath $(1)) $2
MKDIR = mkdir --parents "$(1)"
DOWNLOAD = wget --quiet --directory-prefix=$(1)/ $(2) --output-file=/dev/null
GIT = git clone --quiet --depth 1 "$(1)" > /dev/null; true
PRINT_DONE = printf -- "++++ done: $(1)\n"
PRINT_STEP = printf -- ">>>> step: $(1)\n"
PRINT_CLEAN = printf -- "---- clean: $(1)\n"

.DEFAULT_GOAL: help
.PHONY: help ### show this help menu
help:
	@sed -nr '/#{3}/{s/\.PHONY: /-- /; s/#{3} /: /; p;}' ${MAKEFILE_LIST}



# general approach is to backup target and replace with soft link
$(HOME)/.%: $(SRC)/%
	@$(call PRINT_STEP,backup present $(notdir $@))
	@$(call BACKUP,$@)
	@$(call PRINT_CLEAN,link $(notdir $@))
	@$(call RM_LINK,$@)
	@$(call PRINT_CLEAN,file/dir $(notdir $@))
	@$(call RM_FILE,$@)
	@$(call RM_DIR,$@)
	@$(call PRINT_STEP,replace $(notdir $@))
	@$(call LN,$<,$@)

.PHONY: aliases.private ## bash aliases, rm with clean_<target>
ALL += aliases.private
aliases.private: $(HOME)/.aliases.private
	@$(call PRINT_DONE,$@)

.PHONY: clean_aliases.private
CLEAN_ALL += clean_aliases.private
clean_aliases.private:
	@$(call PRINT_CLEAN,$@)
	@$(call RM_LINK,$(HOME)/.aliases.private)

.PHONY: bashrc.private ## private bashrc, rm with clean_<target>
ALL += bashrc.private
bashrc.private: $(HOME)/.bashrc.private
	@$(call PRINT_DONE,$@)

.PHONY: clean_bashrc.private
CLEAN_ALL += clean_bashrc.private
clean_bashrc.private:
	@$(call PRINT_CLEAN,$@)
	@$(call RM_LINK,$(HOME)/.bashrc.private)

.PHONY: gitconfig ## global git configuration, rm with clean_<target>
ALL += gitconfig
gitconfig: $(HOME)/.gitconfig
	@$(call PRINT_DONE,$@)

.PHONY: clean_gitconfig
CLEAN_ALL += clean_gitconfig
clean_gitconfig:
	@$(call PRINT_CLEAN,$@)
	@$(call RM_LINK,$(HOME)/.gitconfig)

.PHONY: inputrc ## user level GNU readline configuration, rm with clean_<target>
ALL += inputrc
inputrc: $(HOME)/.inputrc
	@$(call PRINT_DONE,$@)

.PHONY: clean_inputrc
CLEAN_ALL += clean_inputrc
clean_inputrc:
	@$(call PRINT_CLEAN,$@)
	@$(call RM_LINK,$(HOME)/.inputrc)

.PHONY: i3 ## i3 wm and corresponding parts configuration, rm with clean_<target>
ALL += i3
i3: $(HOME)/.config/i3
	@$(call PRINT_DONE,$@)

.PHONY: clean_i3
CLEAN_ALL += clean_i3
clean_i3:
	@$(call PRINT_CLEAN,$@)
	@$(call RM_LINK,$(HOME)/.config/i3)

.PHONY: i3status ## i3 wm status bar
ALL += i3status
i3status: $(HOME)/.config/i3status
	@$(call PRINT_DONE,$@)

.PHONY: clean_i3status
CLEAN_ALL += clean_i3status
clean_i3status:
	@$(call PRINT_CLEAN,$@)
	@$(call RM_LINK,$(HOME)/.config/i3status)

.PHONY: picom ## most recent compton fork
ALL += picom
picom: $(HOME)/.config/picom.conf
	@$(call PRINT_DONE,$@)

.PHONY: clean_picom
CLEAN_ALL += clean_picom
clean_picom:
	@$(call PRINT_CLEAN,$@)
	@$(call RM_LINK,$(HOME)/.config/picom.conf)

.PHONY: Xresources ## Xresources includes all configurations
ALL += Xresources
.PHONY: xterm ## Xresources xterm terminal configuration
.PHONY: xft ## Xresources xft fonts configuration

XRESOURCES_CONFIG_TARGETS := xterm xft
Xresources: Xresources.d $(XRESOURCES_CONFIG_TARGETS)
	@$(call PRINT_DONE,$@)

.PHONY: Xresources.d
Xresources.d: $(HOME)/.config/Xresources.d
	@$(call PRINT_DONE,$@)

.PHONY: clean_Xresources.d
CLEAN_ALL += clean_Xresources.d
clean_Xresources.d:
	@$(call PRINT_CLEAN,$@)
	@$(call RM_LINK,$(HOME)/.config/Xresources.d)

XRESOURCES := $(HOME)/.Xresources
TEST_XRESOURCES_INCLUDE = grep --fixed-strings --line-regexp --quiet "$(1)" $(XRESOURCES)
XRESOURCES_INCLUDE = \#include \".config/Xresources.d/$(1)\"
ADD_XRESOURCES_INCLUDE = if ! $(call TEST_XRESOURCES_INCLUDE,$(call XRESOURCES_INCLUDE,$(1))); then echo "$(call XRESOURCES_INCLUDE,$(1))" >> $(XRESOURCES); fi

$(XRESOURCES_CONFIG_TARGETS): Xresources.d
	@$(call PRINT_STEP,backing up $(notdir $(XRESOURCES)))
	@$(call BACKUP,$(XRESOURCES))
	@touch "$(XRESOURCES)"
	@$(call PRINT_STEP,if missing append $(notdir $@) to $(notdir $(XRESOURCES)))
	@$(call ADD_XRESOURCES_INCLUDE,$@)
	@$(call PRINT_DONE,$@)

.PHONY: urxvt ## Xresources urxvt terminal configuration and plugins
.PHONY: urxvt_plugins ## urxvt plugins, rm with clean_<target>
ALL += urxvt urxvt_plugins
URXVT_EXT := $(HOME)/.urxvt/ext
URXVT_PLUGINS :=

keyboard_select: URL:=https://raw.githubusercontent.com/muennich/urxvt-perls/master/keyboard-select
URXVT_PLUGINS += keyboard_select

tabbed: URL:=https://raw.githubusercontent.com/exg/rxvt-unicode/main/src/perl/tabbed
URXVT_PLUGINS += tabbed

resize_font: URL:=https://raw.githubusercontent.com/simmel/urxvt-resize-font/master/resize-font
URXVT_PLUGINS += resize_font

selection_to_clipboard: URL:=https://raw.githubusercontent.com/exg/rxvt-unicode/main/src/perl/selection-to-clipboard
URXVT_PLUGINS += selection_to_clipboard

pasta: URL:=https://raw.githubusercontent.com/su8/urxvt-pasta/master/pasta
URXVT_PLUGINS += pasta
.PHONY: $(URXVT_PLUGINS)
$(URXVT_PLUGINS): | $(URXVT_EXT)
	@$(call PRINT_STEP,urxvt plugin $@)
	@$(call DOWNLOAD,$(URXVT_EXT),$(URL))

urxvt_plugins: $(URXVT_PLUGINS)

.PHONY: clean_urxvt_plugins
CLEAN_ALL += clean_urxvt_plugins
clean_urxvt_plugins:
	@$(call PRINT_CLEAN,$@)
	@$(call RM_DIR,$(URXVT_EXT))

urxvt: Xresources.d urxvt_plugins
	@touch "$(XRESOURCES)"
	@$(call PRINT_STEP,append $(notdir $@) to $(notdir $(XRESOURCES)))
	@$(call ADD_XRESOURCES_INCLUDE,$@)
	@$(call PRINT_DONE,$@)

.PHONY: vim ## vim configuration and plugins
.PHONY: vimrc ## vim configuration
.PHONY: vim_plugins ## vim plugins
ALL += vim vimrc vim_plugins

VIM_DIR := $(HOME)/.vim
VIM_PLUGINS_DIR := $(VIM_DIR)/pack/plugins/start
VIM_TMP_DIR := $(VIM_DIR)/tmp
vimrc: $(HOME)/.vimrc | $(VIM_DIR)
	@$(call PRINT_STEP,create vim home tmp and plugin directories)
	@$(call MKDIR,$(VIM_TMP_DIR))
	@$(call MKDIR,$(VIM_PLUGINS_DIR))
	@$(call PRINT_DONE,$@)

.PHONY: clean_vimrc
clean_vimrc:
	@$(call PRINT_CLEAN,$@)
	@$(call RM_LINK,$(HOME)/.vimrc)
	@$(call RM_DIR,$(VIM_DIR))

VIM_PLUGINS :=

sensible: URL:=https://github.com/tpope/vim-sensible.git
VIM_PLUGINS += sensible

commentary: URL:=https://github.com/tpope/vim-commentary.git
VIM_PLUGINS += commentary

polyglot: URL:=https://github.com/sheerun/vim-polyglot.git
VIM_PLUGINS += polyglot

solarized8: URL:=https://github.com/lifepillar/vim-solarized8.git
VIM_PLUGINS += solarized8

molokai: URL:=https://github.com/tomasr/molokai.git
VIM_PLUGINS += molokai

codedark: URL:=https://github.com/tomasiser/vim-code-dark.git
VIM_PLUGINS += codedark

papercolor: URL:=https://github.com/NLKNguyen/papercolor-theme.git
VIM_PLUGINS += papercolor

surround: URL:=https://github.com/tpope/vim-surround.git
VIM_PLUGINS += surround

sneak: URL:=https://github.com/justinmk/vim-sneak.git
VIM_PLUGINS += sneak

repeat: URL:=https://github.com/tpope/vim-repeat.git
VIM_PLUGINS += repeat

indent_line: URL:=https://github.com/Yggdroot/indentLine.git
VIM_PLUGINS += indent_line

highlighter: URL:=https://github.com/azabiong/vim-highlighter.git
VIM_PLUGINS += highlighter

scratch: URL:=https://github.com/mtth/scratch.vim.git
VIM_PLUGINS += scratch

gitgutter: URL:=https://github.com/airblade/vim-gitgutter.git
VIM_PLUGINS += gitgutter

lightline: URL:=https://github.com/itchyny/lightline.vim.git
VIM_PLUGINS += lightline

gitbranch: URL:=https://github.com/itchyny/vim-gitbranch.git
VIM_PLUGINS += gitbranch

lightline_bufferline: URL:=https://github.com/mengelbrecht/lightline-bufferline.git
VIM_PLUGINS += lightline_bufferline

ctrlp: URL:=https://github.com/ctrlpvim/ctrlp.vim.git
VIM_PLUGINS += ctrlp

ctrlp_modified: URL:=https://github.com/jasoncodes/ctrlp-modified.vim.git
VIM_PLUGINS += ctrlp_modified

auto_pairs: URL:=https://github.com/jiangmiao/auto-pairs.git
VIM_PLUGINS += auto_pairs

slime: URL:=https://github.com/jpalardy/vim-slime.git
VIM_PLUGINS += slime

spell_underline: URL:=https://github.com/osamuaoki/vim-spell-under.git
VIM_PLUGINS += spell_underline

.PHONY: $(VIM_PLUGINS)
$(VIM_PLUGINS): | $(VIM_PLUGINS_DIR)
	@$(call PRINT_STEP,vim plugin $@)
	@cd $(VIM_PLUGINS_DIR) && $(call GIT,$(URL))

vim_plugins: $(VIM_PLUGINS)
	@$(call PRINT_DONE,$@)

.PHONY: clean_vim_plugins
clean_vim_plugins:
	@$(call PRINT_CLEAN,$@)
	@$(call RM_DIR,$(VIM_PLUGINS_DIR))

vim: vimrc vim_plugins
	@$(call PRINT_DONE,$@)

.PHONY: clean_vim
CLEAN_ALL += clean_vim
clean_vim: clean_vim_plugins clean_vimrc
	@$(call PRINT_CLEAN,$@)

# directories some programs need and use in their configurations
DEP_DIRS := $(URXVT_EXT) $(VIM_DIR) $(VIM_PLUGINS_DIR) $(VIM_TMP_DIR)
$(DEP_DIRS):
	@$(call MKDIR,$@)

.PHONY: all ## make all targets
all: $(ALL)
.PHONY: clean ## clean up all installs
clean: $(CLEAN_ALL)
