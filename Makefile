MAKEFLAGS += --warn-undefined-variables

SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

.DELETE_ON_ERROR:
.SUFFIXES:

.DEFAULT_GOAL := help

.PHONY: help ### show this menu
help:
	@sed -nr '/#{3}/{s/\.PHONY:/--/; s/\ *#{3}/:/; p;}' ${MAKEFILE_LIST}

FORCE:

inspect-%: FORCE
	@echo $($*)

define log
	printf "%-60s %20s \n" $(1) $(2)
endef

define add_gitignore
	echo $(1) >> .gitignore;
	sort --unique --output .gitignore{,};
endef

define del_gitignore
	if [ -e .gitignore ]; then \
		sed --in-place '\,$(1),d' .gitignore;\
		sort --unique --output .gitignore{,};\
	fi
endef

backup_suffix := dpopchevbak
define backup_config
	if [ -e "$(1)" ]; then \
		mv --force --no-target-directory --backup=numbered \
		"$(1)" "$(1).$(backup_suffix)";\
	fi
endef

stamp_dir := .stamps
src_dir := src

configs := dpopchev
config_dsts := $(addprefix ${HOME}/.,$(configs))
config_stamps := $(addprefix $(stamp_dir)/,$(addsuffix .stamp,$(configs)))

$(stamp_dir):
	@$(call add_gitignore,$@)
	@mkdir --parents $@
	@$(call log,'create $@','[done]')

$(config_stamps): $(stamp_dir)/%.stamp: | $(stamp_dir)
	@$(call backup_config,$(filter %$*,$(config_dsts)))
	@ln -s $(realpath $(src_dir)/$(filter %$*,$(configs))) $(filter %$*,$(config_dsts))
	@touch $@
	@$(call log,'install $*','[done]')

install_config_targets := $(addprefix install-,$(configs))
.PHONY: $(install_config_targets)
$(install_config_targets): install-%: $(stamp_dir)/%.stamp

.PHONY: install
install: $(install_config_targets)

uninstall_config_targets := $(addprefix uninstall-,$(configs))
.PHONY: $(uninstall_config_targets)
$(uninstall_config_targets): uninstall-%:
	@rm --force $(filter %$*,$(config_dsts))
	@if [ -e $(filter %$*,$(config_dsts)).$(backup_suffix) ]; then \
		mv --force $(filter %$*,$(config_dsts)).$(backup_suffix) $(filter %$*,$(config_dsts));\
	fi
	@if [ -e $(filter %$*,$(config_dsts)) ]; then \
		$(call log,'restore config $*','[done]');\
	fi
	@if [ ! -e $(filter %$*,$(config_dsts)) ]; then \
		$(call log,'restore config $*; inspect localtion manually','[fail]');\
	fi
	@rm --force $(stamp_dir)/$*.stamp

.PHONY: uninstall
uninstall: $(uninstall_config_targets)

.PHONY: clean
clean:
	@rm --recursive --force $(stamp_dir)
