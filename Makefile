SHELL := /usr/bin/env bash

## -----------------------------------------------------------------------------
## Makefile to rule distribution of Linux configurations I use.
## The goal is to create soft links to assure keeping track of changes in git.
## Use with: make <target>

SRC := src

# utilities
BACKUP = [[ ! -e $(1) ]] || yes | cp --backup=numbered --recursive "$(1)" "$(1).bak"; true
RM_LINK = [[ ! -L $(1) ]] || unlink "$(1)"
RM_FILE = [[ ! -f $(1) ]] || rm --force --recursive "$(1)"
RM_DIR = [[ ! -d $(1) ]] || rm --force --recursive "$(1)"
LN = ln -s $(realpath $(1)) $2
MKDIR = mkdir --parents "$(1)"
DOWNLOAD = wget --directory-prefix=$(1)/ $(2) --output-file=/dev/null
GIT = git clone --quiet --depth 1 "$(1)" > /dev/null
PRINT_STEP = printf -- "--- step: $(1)\n"
PRINT_DONE = printf -- "+++ done: $(1)\n"

.DEFAULT_GOAL: help
.PHONY: help ## show this help menu
help:
	@sed -nr '/#{2}/{s/\.PHONY: /-- /; s/#{2} /: /; p;}' ${MAKEFILE_LIST}

# general approach is to backup target and replace with soft link
$(HOME)/.%: $(SRC)/%
	@$(call PRINT_STEP,backing up $(notdir $@))
	@$(call BACKUP,$@)
	@$(call PRINT_STEP,attempt to clean link $(notdir $@))
	@$(call RM_LINK,$@)
	@$(call PRINT_STEP,attempt to remove file/dir $(notdir $@))
	@$(call RM_FILE,$@)
	@$(call RM_DIR,$@)
	@$(call PRINT_STEP,make new link to this project $(notdir $@))
	@$(call LN,$<,$@)

.PHONY: aliases.private ## bash aliases
aliases.private: $(HOME)/.aliases.private
	@$(CALL PRINT_DONE,$@)

.PHONY: bashrc.private ## private bashrc
bashrc.private: $(HOME)/.bashrc.private
	@$(CALL PRINT_DONE,$@)

.PHONY: gitconfig ## global git configuration
gitconfig: $(HOME)/.gitconfig
	@$(CALL PRINT_DONE,$@)

.PHONY: inputrc ## user level GNU readline configuration
inputrc: $(HOME)/.inputrc
	@$(CALL PRINT_DONE,$@)

.PHONY: i3 ## i3 wm and corresponding parts configuration
i3: $(HOME)/.config/i3
	@$(CALL PRINT_DONE,$@)

.PHONY: Xresources ## Xresources includes all configurations
.PHONY: urxvt ## Xresources urxvt terminal configuration and plugins
.PHONY: urxvt_plugins ## urxvt plugins
.PHONY: xterm ## Xresources xterm terminal configuration
.PHONY: xft ## Xresources xft fonts configuration

XRESOURCES_CONFIG_TARGETS := xterm xft
Xresources: Xresources.d $(XRESOURCES_CONFIG_TARGETS)
	@$(CALL PRINT_DONE,$@)

.PHONY: Xresources.d
Xresources.d: $(HOME)/.config/Xresources.d
	@$(CALL PRINT_DONE,$@)

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
	@$(call PRINT_STEP,setup urxvt plugin: $@)
	@$(call DOWNLOAD,$(URXVT_EXT),$(URL))

urxvt_plugins: $(URXVT_PLUGINS)

urxvt: Xresources.d urxvt_plugins
	@touch "$(XRESOURCES)"
	@$(call PRINT_STEP,if missing append $(notdir $@) to $(notdir $(XRESOURCES)))
	@$(call ADD_XRESOURCES_INCLUDE,$@)
	@$(call PRINT_DONE,$@)

.PHONY: vim ## vim configuration and plugins
.PHONY: vimrc ## vim configuration
.PHONY: vim_plugins ## vim plugins

vim: vimrc vim_plugins
	@$(call PRINT_DONE,$@)

VIM_DIR := $(HOME)/.vim
VIM_PLUGINS_DIR := $(VIM_DIR)/pack/plugins/start
VIM_TMP_DIR := $(VIM_DIR)/tmp
vimrc: $(HOME)/.vimrc | $(VIM_DIR)
	@$(call PRINT_STEP,setup vim home tmp and plugin directories)
	@$(call MKDIR,$(VIM_TMP_DIR))
	@$(call MKDIR,$(VIM_PLUGINS_DIR))

gruvbox: URL:=https://github.com/morhetz/gruvbox.git
vim_sensible: URL:=https://github.com/tpope/vim-sensible.git
gitgutter: URL:=https://github.com/airblade/vim-gitgutter.git
gitbranch: URL:=https://github.com/itchyny/vim-gitbranch.git
lightline: URL:=https://github.com/itchyny/lightline.vim.git
lightline_bufferline: URL:=https://github.com/mengelbrecht/lightline-bufferline.git
vim_easy_align: URL:=https://github.com/junegunn/vim-easy-align.git
visual_star_search: URL:=https://github.com/nelstrom/vim-visual-star-search.git
vim_commentary: URL:=https://github.com/tpope/vim-commentary.git
vim_repeat: URL:=https://github.com/tpope/vim-repeat.git
vim_surround: URL:=https://github.com/tpope/vim-surround.git
indent_line: URL:=https://github.com/Yggdroot/indentLine.git
ctrlp: URL:=https://github.com/kien/ctrlp.vim.git
nerdtree: URL:=https://github.com/preservim/nerdtree.git
vim_sneak: URL:=https://github.com/justinmk/vim-sneak.git
goyo: URL:=https://github.com/junegunn/goyo.vim.git
vim_illumiate: URL:=https://github.com/RRethy/vim-illuminate
vim_anyfold: URL:=https://github.com/pseewald/vim-anyfold
vim_polyglot: URL:=https://github.com/sheerun/vim-polyglot.git
auto_pairs: URL:=https://github.com/jiangmiao/auto-pairs.git
vim_simple_complete: URL:=https://github.com/maxboisvert/vim-simple-complete.git
vim_highlighter: URL:=https://github.com/azabiong/vim-highlighter.git
VIM_PLUGINS := gruvbox vim_sensible gitgutter gitbranch lightline lightline_bufferline
VIM_PLUGINS += vim_easy_align visual_star_search vim_commentary vim_repeat
VIM_PLUGINS += vim_surround indent_line ctrlp nerdtree vim_sneak goyo
VIM_PLUGINS += vim_illumiate vim_anyfold vim_polyglot auto_pairs
VIM_PLUGINS += vim_simple_complete vim_highlighter
.PHONY: $(VIM_PLUGINS)
$(VIM_PLUGINS): | $(VIM_PLUGINS_DIR)
	@$(call PRINT_STEP,setup vim plugin: $@)
	@$(call GIT,$(URL))


# directories some programs need and use in their configurations
DEP_DIRS := $(URXVT_EXT) $(VIM_DIR) $(VIM_PLUGINS_DIR)
$(DEP_DIRS):
	@$(MKDIR) $@
