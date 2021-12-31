SHELL := /usr/bin/env bash

SRC := src

HOME := ${HOME}
CONFIGS := $(shell find $(SRC)/ -type f)
TARGETS := $(notdir $(CONFIGS))

.PHONY: test
test:
	echo $(CONFIGS)
	echo $(TARGETS)

.PHONY: $(TARGETS)

$(TARGETS_DIR):
	@mkdir --parents $@

$(HOME)/.%: $(SRC)/% | $(TARGETS_DIR)
	@[[ ! -L $@ ]] || unlink $@
	@[[ ! -f $@ ]] || mv --force $@ $@.bak
	@ln -s $(realpath $<) $@

install: $(TARGETS)
