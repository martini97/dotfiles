SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.DEFAULT_GOAL := stow

target_dir = ${HOME}
apps = $(filter-out ansible/, $(wildcard */))

stow:
	@stow --target=${target_dir} ${apps}

setup:
	@. ./.venv/bin/activate
	@./.venv/bin/ansible-playbook -i ./hosts dotfiles.yml --ask-become-pass --ask-vault-pass --tags "all"
	@deactivate
