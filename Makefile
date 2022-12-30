### ---------------------------------------------------------------------------
### Makefile to rule distribution of Linux configurations I use.
### The goal is to create soft links to assure keeping track of changes in git.
### Use with: make <target>

SHELL := /usr/bin/env bash

SRC := src
HOME := ${HOME}

DUMMIES := .dummies
$(DUMMIES):
	mkdir --parents $@
	@$(call APPEND_GITIGNORE,$@)

# utilities
BACKUP = test ! -e '$(1)' || mv --force --no-target-directory --backup=numbered '$(1)' '$(1).bak'; true
RESTORE = test ! -e '$(1)' || mv --force '$(1)' '$(2)'; true
MKDIR = mkdir --parents '$(1)'
LN = ln -s '$(realpath $(1))' '$(2)'
RM = rm --force '$(1)'
RM_DIR = rm --force --recursive '$(1)'
FIND_LATEST_BACKUP = find $(dir $(1)) -maxdepth 1 \
		     | grep -P $(notdir $(1)).bak\(~\d~\)\? | sort | head -n1
APPEND_GITIGNORE = grep --quiet --line-regexp --fixed-strings $(1) .gitignore 2> /dev/null || echo $(1) >> .gitignore
MSG_BACKUP = printf -- ">>>> backup: $(1)\n"
MSG_INSTALL = printf -- "++++ install: $(1)\n"
MSG_DONE = printf -- "!!!! done: $(1)\n"
MSG_CLEAN = printf -- "---- clean: $(1)\n"

.DEFAULT_GOAL: help
.PHONY: help ### show this help menu
help:
	@sed -nr '/#{3}/{s/\.PHONY: /-- /; s/#{3} /: /; p;}' ${MAKEFILE_LIST}

CONFIGS := vimrc
CONFIGS += aliases.private bashrc.private bashrc.utils inputrc
CONFIGS += ctags
CONFIGS += gitconfig

CONFIGS_SRC := $(addprefix $(SRC)/,$(CONFIGS))

CONFIGS += nvim
CONFIGS_SRC += $(SRC)/config/nvim

CONFIGS_DST := $(patsubst $(SRC)/%,$(HOME)/.%,$(CONFIGS_SRC))
CONFIGS_BAK := $(foreach config,$(CONFIGS_DST),$(shell $(call FIND_LATEST_BACKUP,$(config))))

print-configs:
	@echo $(CONFIGS)

print-sources:
	@echo $(CONFIGS_SRC)

print-destinations:
	@echo $(CONFIGS_DST)

print-backups:
	@echo $(CONFIGS_BAK)

INSTALL := $(addprefix install-,$(CONFIGS))
INSTALL += install-vim-home

.PHONY: $(INSTALL)
$(INSTALL): install-%: $(DUMMIES)/%.dummy
	@$(call MSG_DONE,$@)

$(DUMMIES)/%.dummy: | $(DUMMIES)
	@$(call MSG_BACKUP,$(filter %$*,$(CONFIGS_DST)))
	@$(call BACKUP,$(filter %$*,$(CONFIGS_DST)))
	@$(call MSG_INSTALL,$*)
	@$(call LN,$(filter %$*,$(CONFIGS_SRC)),$(filter %$*,$(CONFIGS_DST)))
	@touch $@

VIM_HOME := $(HOME)/.vim
$(DUMMIES)/vim-home.dummy: | $(DUMMIES)
	@$(call MSG_BACKUP,$(VIM_HOME))
	@$(call BACKUP,$(VIM_HOME))
	@$(call MSG_INSTALL,$*)
	mkdir --parents $(VIM_HOME)/tmp
	@touch $@

UNINSTALL := $(addprefix uninstall-,$(CONFIGS))
.PHONY: $(UNINSTALL)
$(UNINSTALL): uninstall-%:
	@$(call RM,$(filter %$*,$(CONFIGS_DST)))
	@$(call RESTORE,$(shell $(call FIND_LATEST_BACKUP,$(filter %$*,$(CONFIGS_DST)))),$(filter %$*,$(CONFIGS_DST)))
	@$(call RM,$(DUMMIES)/$*.dummy)

.PHONY: install-vim
install-vim: install-vimrc install-vim-home
	@$(call MSG_DONE,$@)

.PHONY: uninstall-vim-home uninstall-vim
uninstall-vim-home:
	@$(call RM_DIR,$(VIM_HOME))
	@$(call RESTORE,$(shell $(call FIND_LATEST_BACKUP,$(VIM_HOME))),$(VIM_HOME))
	@$(call RM,$(DUMMIES)/vim-home.dummy)

uninstall-vim: uninstall-vimrc uninstall-vim-home
	@$(call MSG_DONE,$@)

.PHONY: install-bash uninstall-bash
install-bash: install-aliases.private install-bashrc.private install-bashrc.utils
	@$(call MSG_DONE,$@)

uninstall-bash: uninstall-aliases.private uninstall-bashrc.private uninstall-bashrc.utils
	@$(call MSG_DONE,$@)
