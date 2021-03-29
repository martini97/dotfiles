#!/usr/bin/env bash

set -e

. _scripts/common.sh

function install_brew {
  log_installing "brew"
  brew_install=$(tmpfile "brew-install")
  curl -fsSL \
    "https://raw.githubusercontent.com/Homebrew/install/master/install.sh" \
    -o "${brew_install}"
}

function assert_brew {
  if ! command -v brew &> /dev/null; then
    install_brew
  fi

  log_updating "brew"
  brew update >/dev/null
  brew upgrade >/dev/null
  brew tap homebrew/bundle >/dev/null
  brew bundle >/dev/null
  log_ok "brew"
}

function main {
  log_info "starting dependencies setup..."
  assert_brew
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
