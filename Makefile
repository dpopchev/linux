SHELL := /usr/bin/env bash

SRC := src

HOME := ${HOME}
CONFIGS := $(shell find $(SRC)/ -type f)
TARGETS_ALL := $(notdir $(CONFIGS))
TARGET_FILES := $(patsubst $(SRC)/%,$(HOME)/.%,$(CONFIGS))

RM_LINK = [[ ! -L $(1) ]] || unlink "$(1)"
FORCE_BACKUP_FILE = [[ ! -f $(1) ]] || mv --force "$(1)" "$(1).bak"
LN_SRC_CONFIG = ln -s $(realpath $(1)) $2
MKDIR = mkdir --parents
DOWNLOAD = wget --directory-prefix=$(1)/ $(2) --output-file=/dev/null

XRESOURCES = $(HOME)/.Xresources
XRESOURCES_CONFIGS := $(filter $(SRC)/config/Xresources.d/%,$(CONFIGS))
XRESOURCES_TARGETS := $(notdir $(XRESOURCES_CONFIGS))
XRESOURCES_INCLUDE = \#include \".config/Xresources.d/$(1)\"
TEST_XRESOURCES_INCLUDE = grep --fixed-strings --line-regexp --quiet "$(1)" $(XRESOURCES)
ADD_XRESOURCES_INCLUDE = if ! $(call TEST_XRESOURCES_INCLUDE,$(call XRESOURCES_INCLUDE,$(1))); then echo "$(call XRESOURCES_INCLUDE,$(1))" >> $(XRESOURCES); fi

BASH_CONFIGS := $(SRC)/aliases.private $(SRC)/bashrc.private $(SRC)/gitconfig $(SRC)/inputrc $(SRC)/vimrc
BASH_TARGETS := $(notdir $(BASH_CONFIGS))

HOME_CONFIGS := $(BASH_CONFIGS)
HOME_TARGETS := $(BASH_TARGETS)

.PHONY: $(TARGETS_ALL) Xresources.d Xresources $(HOME_TARGETS)

Xresources: | Xresources.d
	@touch "$(HOME)/.$@"

Xresources.d:
	@$(MKDIR) $(HOME)/.config/$@

$(XRESOURCES_TARGETS): Xresources
	@$(call ADD_XRESOURCES_INCLUDE,$@)
	@$(call RM_LINK,$(filter %/$@,$(TARGET_FILES)))
	@$(call FORCE_BACKUP_FILE,$(filter %/$@,$(TARGET_FILES)))
	@$(call LN_SRC_CONFIG,$(filter %/$@,$(CONFIGS)),$(filter %/$@,$(TARGET_FILES)))

$(HOME_TARGETS):
	@$(call RM_LINK,$(filter %/.$@,$(TARGET_FILES)))
	@$(call FORCE_BACKUP_FILE,$(filter %/.$@,$(TARGET_FILES)))
	@$(call LN_SRC_CONFIG,$(filter %/$@,$(CONFIGS)),$(filter %/.$@,$(TARGET_FILES)))

URXVT_EXT_DIR := $(HOME)/.urxvt/ext
URXVT_EXT_SOURCES := https://raw.githubusercontent.com/muennich/urxvt-perls/master/keyboard-select
URXVT_EXT_SOURCES += https://raw.githubusercontent.com/exg/rxvt-unicode/main/src/perl/tabbed
URXVT_EXT_SOURCES += https://raw.githubusercontent.com/simmel/urxvt-resize-font/master/resize-font
URXVT_EXT_SOURCES += https://raw.githubusercontent.com/exg/rxvt-unicode/main/src/perl/selection-to-clipboard
URXVT_EXT_SOURCES += https://raw.githubusercontent.com/su8/urxvt-pasta/master/pasta

.PHONY: urxvt_plugins urxvt_ext_dst

urxvt_ext_dst:
	@$(MKDIR) $(URXVT_EXT_DIR)

urxvt_plugins: | urxvt_ext_dst
	@for ext in $(URXVT_EXT_SOURCES); do $(call DOWNLOAD,$(URXVT_EXT_DIR),$$ext); done

.PHONY: show
show:
	@for target in $(TARGETS_ALL); do echo $$target; done

VIM_HOME_DIR := $(HOME)/.vim
VIM_PLUGINS_DIR := $(VIM_HOME_DIR)/pack/plugins/start
VIM_TMP_DIR := $(VIM_HOME_DIR)/tmp
VIM_DIRS := $(VIM_PLUGINS_DIR) $(VIM_TMP_DIR)

VIM_PLUGIN_GET = git clone --depth 1 --branch master "$(1)" > /dev/null

VIM_PLUGINS := https://github.com/morhetz/gruvbox.git
VIM_PLUGINS += https://github.com/tpope/vim-sensible.git
VIM_PLUGINS += https://github.com/airblade/vim-gitgutter.git
VIM_PLUGINS += https://github.com/itchyny/vim-gitbranch.git
VIM_PLUGINS += https://github.com/itchyny/lightline.vim.git
VIM_PLUGINS += https://github.com/junegunn/vim-easy-align.git
VIM_PLUGINS += https://github.com/nelstrom/vim-visual-star-search.git
VIM_PLUGINS += https://github.com/tpope/vim-commentary.git
VIM_PLUGINS += https://github.com/tpope/vim-repeat.git
VIM_PLUGINS += https://github.com/tpope/vim-surround.git
VIM_PLUGINS += https://github.com/Yggdroot/indentLine.git
VIM_PLUGINS += https://github.com/kien/ctrlp.vim.git
VIM_PLUGINS += https://github.com/preservim/nerdtree.git
VIM_PLUGINS += https://github.com/justinmk/vim-sneak.git
VIM_PLUGINS += https://github.com/junegunn/goyo.vim.git
VIM_PLUGINS += https://github.com/RRethy/vim-illuminate
VIM_PLUGINS += https://github.com/pseewald/vim-anyfold
VIM_PLUGINS += https://github.com/sheerun/vim-polyglot.git
VIM_PLUGINS += https://github.com/jiangmiao/auto-pairs.git
VIM_PLUGINS += https://github.com/maxboisvert/vim-simple-complete.git

.PHONY: vim $(VIM_PLUGINS_DIR) $(VIM_TMP_DIR)

$(VIM_DIRS):
	@$(MKDIR) $@

vim: vimrc | $(VIM_DIRS)
	@for plugin in $(VIM_PLUGINS); do cd $(VIM_PLUGINS_DIR) && $(call VIM_PLUGIN_GET,$$plugin); done
