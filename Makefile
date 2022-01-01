SHELL := /usr/bin/env bash

SRC := src

HOME := ${HOME}
CONFIGS := $(shell find $(SRC)/ -type f)
TARGETS_ALL := $(notdir $(CONFIGS))
TARGET_FILES := $(patsubst $(SRC)/%,$(HOME)/.%,$(CONFIGS))

.PHONY: $(TARGETS_ALL) Xresources.d Xresources

RM_LINK = [[ ! -L $(1) ]] || unlink "$(1)"
FORCE_BACKUP_FILE = [[ ! -f $(1) ]] || mv --force "$(1)" "$(1).bak"
LN_SRC_CONFIG = ln -s $(realpath $(1)) $2
MKDIR = mkdir --parents

XRESOURCES = $(HOME)/.Xresources
XRESOURCES_INCLUDE = \#include '.config/Xresources.d/$(1)'
TEST_XRESOURCES_INCLUDE = grep --fixed-strings --line-regexp --quiet "$(1)" $(XRESOURCES)
ADD_XRESOURCES_INCLUDE = if ! $(call TEST_XRESOURCES_INCLUDE,$(call XRESOURCES_INCLUDE,$(1))); then echo "$(call XRESOURCES_INCLUDE,$(1))" >> $(XRESOURCES); fi

Xresources: | Xresources.d
	@touch "$(HOME)/.$@"

Xresources.d:
	@$(MKDIR) $(HOME)/.config/$@

xft: Xresources
	@$(call ADD_XRESOURCES_INCLUDE,$@)
	@$(call RM_LINK,$(filter %/$@,$(TARGET_FILES)))
	@$(call FORCE_BACKUP_FILE,$(filter %/$@,$(TARGET_FILES)))
	@$(call LN_SRC_CONFIG,$(filter %/$@,$(CONFIGS)),$(filter %/$@,$(TARGET_FILES)))
