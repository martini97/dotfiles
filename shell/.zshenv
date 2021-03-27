typeset -U PATH path
path=(
  "$HOME/.local/bin"
  "$HOME/neovim/bin"
  "$HOME/.cargo/bin"
  "$path[@]"
)
export PATH

export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

export XDG_CONFIG_HOME="${HOME}/.config"

export ZSH="${HOME}/.oh-my-zsh"
export ZSH_CONFIG_DIR="${XDG_CONFIG_HOME}/zsh"
source "$HOME/.cargo/env"
