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

reveal-%: FORCE
	@echo $($*)

append-gitignore-%: FORCE
	@grep --quiet --line-regexp --fixed-strings $* .gitignore 2> /dev/null \
		|| echo $* >> .gitignore

remove-gitignore-%: FORCE
	sed --in-place '/$*/d' .gitignore

src-dir := src
src-config-dir := $(src-dir)/config
src-xfce4-dir := $(src-config-dir)/xfce4
src-xresources-dir := $(src-config-dir)/Xresources.d

stamp-dir := .stamps
stamp-backup-dir := $(stamp-dir)/backups
stamp-install-dir := $(stamp-dir)/installs
stamp-uninstall-dir := $(stamp-dir)/uninstalls

$(stamp-dir) $(stamp-backup-dir) $(stamp-install-dir) $(stamp-uninstall-dir):
	@mkdir --parents $@

.PHONY: stampdir
stampdir: $(stamp-dir) append-gitignore-$(stamp-dir)/

all-srcs := $(wildcard $(src-dir)/*)
all-srcs := $(filter-out $(src-config-dir),$(all-srcs))
all-srcs += $(wildcard $(src-config-dir)/*)
all-srcs := $(filter-out $(src-xfce4-dir),$(all-srcs))
all-srcs += $(wildcard $(src-xfce4-dir)/*)
all-srcs := $(filter-out $(src-xresources-dir)/,$(all-srcs))
all-srcs += $(wildcard $(src-xresources-dir)/*)

all-dsts := $(subst $(src-dir)/,${HOME}/.,$(all-srcs))

restore-%: FORCE

backup-suffix := dpopchevbak
$(stamp-backup-dir)/%.stamp: | $(stamp-backup-dir)
	@if [[ -e $(filter %$*,$(all-dsts)) ]]; then \
		echo '-- backup $(filter %$*,$(all-dsts))'; \
		mv --force --no-target-directory --backup=numbered \
		$(filter %$*,$(all-dsts)) $(filter %$*,$(all-dsts)).$(backup-suffix); \
	fi
	@mkdir --parents $(dir $@)
	@rm --force $(stamp-uninstall-dir)/$*.stamp
	@touch $@

$(stamp-install-dir)/%.stamp: | $(stamp-install-dir)
	@echo '-- install $(notdir $*)'
	@mkdir --parents $(dir $(filter %$*,$(all-dsts)))
	@ln -s $(realpath $(filter %$*,$(all-srcs))) $(filter %$*,$(all-dsts))
	@mkdir --parents $(dir $@)
	@touch $@

$(stamp-uninstall-dir)/%.stamp: | $(stamp-uninstall-dir)
	@if [[ ! -e $(stamp-install-dir)/$*.stamp ]]; then\
		echo '-- cannot proceed, installation stamp missing for $(notdir $*)'; \
		exit 2;\
	fi
	@rm --force $(filter %$*,$(all-dsts))
	@if [[ -e $(filter %$*,$(all-dsts)).$(backup-suffix) ]]; then \
		echo '-- restore $*'; \
		mv --force \
		$(filter %$*,$(all-dsts)).$(backup-suffix) $(filter %$*,$(all-dsts)); \
	else \
		echo '-- no backup found $*'; \
		echo '---- restore manually by looking up at $(dir $(filter %$*,$(all-dsts)))'; \
		echo '---- for files with extension of the form $(backup-suffix).~\d~'; \
	fi
	@rm --force $(stamp-install-dir)/$*.stamp
	@rm --force $(stamp-backup-dir)/$*.stamp

all-install-goals :=
all-uninstall-goals :=

bash-srcs := bashrc.private config/bashrc.d
bash-stamps := $(bash-srcs:=.stamp)
bash-steps := $(addprefix $(stamp-backup-dir)/,$(bash-stamps))
bash-steps += $(addprefix $(stamp-install-dir)/,$(bash-stamps))

all-install-goals += install-bash
.PHONY: install-bash ### bashrc.private and config/bashrc.d
install-bash: $(bash-steps)

all-uninstall-goals += uninstall-bash
.PHONY: uninstall-bash
uninstall-bash: $(addprefix $(stamp-uninstall-dir)/,$(bash-stamps))

single-srcs := ctags gitconfig inputrc dpopchev xxkbrc

single-install-goals := $(addprefix install-,$(single-srcs))
all-install-goals += $(single-install-goals)
.PHONY: $(single-install-goals)
$(single-install-goals): install-%: $(stamp-backup-dir)/%.stamp $(stamp-install-dir)/%.stamp

single-uninstall-goals := $(addprefix uninstall-,$(single-srcs))
all-uninstall-goals += $(single-uninstall-goals)
.PHONY: $(single-uninstall-goals)
$(single-uninstall-goals): uninstall-%: $(stamp-uninstall-dir)/%.stamp

vim-home := $(HOME)/.vim
vim-srcs := vimrc
vim-stamps := $(vim-srcs:=.stamp)
vim-steps := $(addprefix $(stamp-backup-dir)/,$(vim-stamps))
vim-steps += $(addprefix $(stamp-install-dir)/,$(vim-stamps))

all-install-goals += install-vim
.PHONY: install-vim ### vimrc and $(HOME)/.vim
install-vim: $(vim-steps)
	@if [[ -e $(vim-home) ]]; then\
		mv --force --no-target-directory --backup=numbered \
		$(vim-home) $(vim-home).$(backup-suffix);\
	fi
	@mkdir --parents $(vim-home)/tmp

all-uninstall-goals += uninstall-vim
.PHONY: uninstall-vim
uninstall-vim: $(addprefix $(stamp-uninstall-dir)/,$(vim-stamps))
	@rm --force --recursive $(vim-home)/
	@if [[ -e $(vim-home).$(backup-suffix) ]]; then\
		mv --force --no-target-directory --backup=numbered $(vim-home).$(backup-suffix) $(vim-home);\
	fi

nvim-srcs := config/nvim
nvim-stamps := $(nvim-srcs:=.stamp)
nvim-steps := $(addprefix $(stamp-backup-dir)/,$(nvim-stamps))
nvim-steps += $(addprefix $(stamp-install-dir)/,$(nvim-stamps))
nvim-steps += install-vim

all-install-goals += install-nvim
.PHONY: install-nvim ### vim and neovim specific
install-nvim: $(nvim-steps)

all-uninstall-goals += uninstall-nvim
.PHONY: uninstall-nvim
uninstall-nvim: $(addprefix $(stamp-uninstall-dir)/,$(nvim-stamps)) uninstall-vim

i3-config-srcs := config/i3
i3-config-stamp := $(i3-config-srcs:=.stamp)
i3-config-steps := $(addprefix $(stamp-backup-dir)/,$(i3-config-stamp))
i3-config-steps += $(addprefix $(stamp-install-dir)/,$(i3-config-stamp))

.PHONY: install-i3-config
install-i3-config: $(i3-config-steps)

.PHONY: uninstall-i3-config
uninstall-i3-config: $(addprefix $(stamp-uninstall-dir)/,$(i3-config-stamp))

tmux-config-srcs := config/tmux
tmux-config-stamp := $(tmux-config-srcs:=.stamp)
tmux-config-steps := $(addprefix $(stamp-backup-dir)/,$(tmux-config-stamp))
tmux-config-steps += $(addprefix $(stamp-install-dir)/,$(tmux-config-stamp))

.PHONY: install-tmux-config
install-tmux-config: $(tmux-config-steps)

.PHONY: uninstall-tmux-config
uninstall-tmux-config: $(addprefix $(stamp-uninstall-dir)/,$(tmux-config-stamp))

redshift-config-srcs := config/redshift.conf
redshift-config-stamp := $(redshift-config-srcs:=.stamp)
redshift-config-steps := $(addprefix $(stamp-backup-dir)/,$(redshift-config-stamp))
redshift-config-steps += $(addprefix $(stamp-install-dir)/,$(redshift-config-stamp))

.PHONY: install-redshift-config
install-redshift-config: $(redshift-config-steps)

.PHONY: uninstall-redshift-config
uninstall-redshift-config: $(addprefix $(stamp-uninstall-dir)/,$(redshift-config-stamp))

i3-status-srcs := config/i3status
i3-status-stamp := $(i3-status-srcs:=.stamp)
i3-status-steps := $(addprefix $(stamp-backup-dir)/,$(i3-status-stamp))
i3-status-steps += $(addprefix $(stamp-install-dir)/,$(i3-status-stamp))

.PHONY: install-i3-status
install-i3-status: $(i3-status-steps)

.PHONY: uninstall-i3-status
uninstall-i3-status: $(addprefix $(stamp-uninstall-dir)/,$(i3-status-stamp))

all-install-goals += install-i3
.PHONY: install-i3 ### configs for i3 and i3status
install-i3: install-i3-config install-i3-status

all-uninstall-goals += uninstall-i3
.PHONY: uninstall-i3
uninstall-i3: uninstall-i3-config uninstall-i3-status

xfce4-terminal-srcs := config/xfce4/terminal
xfce4-terminal-stamps := $(xfce4-terminal-srcs:=.stamp)
xfce4-terminal-steps := $(addprefix $(stamp-backup-dir)/,$(xfce4-terminal-stamps))
xfce4-terminal-steps += $(addprefix $(stamp-install-dir)/,$(xfce4-terminal-stamps))

.PHONY: install-xfce4-terminal
install-xfce4-terminal: $(xfce4-terminal-steps)

.PHONY: uninstall-xfce4-terminal
uninstall-xfce4-terminal: $(addprefix $(stamp-uninstall-dir)/,$(xfce4-terminal-stamps))

alacritty-terminal-srcs := config/alacritty
alacritty-terminal-stamps := $(alacritty-terminal-srcs:=.stamp)
alacritty-terminal-steps := $(addprefix $(stamp-backup-dir)/,$(alacritty-terminal-stamps))
alacritty-terminal-steps += $(addprefix $(stamp-install-dir)/,$(alacritty-terminal-stamps))

.PHONY: install-alacritty-terminal
install-alacritty-terminal: $(alacritty-terminal-steps)

.PHONY: uninstall-alacritty-terminal
uninstall-alacritty-terminal: $(addprefix $(stamp-uninstall-dir)/,$(alacritty-terminal-stamps))

xresources-conf := $(HOME)/.Xresources
xresources-home := $(HOME)/.config/Xresources.d
xresources-xft-srcs := config/Xresources.d/xft
xresources-xft-stamps := $(xresources-xft-srcs:=.stamp)
xresources-xft-steps := $(addprefix $(stamp-backup-dir)/,$(xresources-xft-stamps))
xresources-xft-steps += $(addprefix $(stamp-install-dir)/,$(xresources-xft-stamps))

.PHONY: install-xresources-xft
install-xresources-xft: $(xresources-xft-steps)
	@grep --quiet --line-regexp --fixed-strings xft $(xresources-conf) 2> /dev/null \
		|| echo '#include "$(xresources-home)/xft"' >> $(xresources-conf)

.PHONY: uninstall-xresources-xft
uninstall-xresources-xft: $(addprefix $(stamp-uninstall-dir)/,$(xresources-xft-stamps))
	@sed --in-place '/xft/d' $(xresources-conf)

.PHONY: install ### install all at once
install: $(all-install-goals)

.PHONY: uninstall ### uninstall all at once
uninstall: $(all-uninstall-goals)
