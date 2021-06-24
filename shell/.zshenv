typeset -U PATH path
path=(
  "$HOME/.local/bin"
  "$HOME/neovim/bin"
  "$HOME/.cargo/bin"
  "$HOME/Library/Python/3.9/bin"
  "$path[@]"
)
export PATH

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export XDG_CONFIG_HOME="${HOME}/.config"

export ZSH="${HOME}/.oh-my-zsh"
export ZSH_CONFIG_DIR="${XDG_CONFIG_HOME}/zsh"
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"

export EDITOR=nvim

export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/ripgrep.rc"
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

[ -f "${XDG_CONFIG_HOME}/zsh/private.zshenv" ] && source "${XDG_CONFIG_HOME}/zsh/private.zshenv" || true
