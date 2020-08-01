SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.DEFAULT_GOAL := stow

target_dir = ${HOME}
apps = $(wildcard */)

stow:
	@stow --target=${target_dir} ${apps}
