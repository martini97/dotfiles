OS_NAME := $(shell uname -s | tr A-Z a-z)

.DEFAULT_GOAL := help
.PHONY: help

dotfiles: ## Install dotfiles with stow (creates symlinks)
	@stow --target=${HOME} kitty git shell neovim tmux ripgrep ctags

dependencies: ## Install os dependencies (WIP)
	@./_scripts/$(OS_NAME)-dependencies.sh

neovim: ## Compile neovim and install it's dependencies
	@echo "NOT IMPLEMENTED YET"

help:  ## Print this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
