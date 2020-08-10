autoload -U compinit && compinit

bindkey -e

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

[[ -f "${ZDOTDIR}/aliases.zsh" ]] && . "${ZDOTDIR}/aliases.zsh"
[[ -f "${ZDOTDIR}/functions.zsh" ]] && . "${ZDOTDIR}/functions.zsh"
[[ -f "${ZDOTDIR}/keybindings.zsh" ]] && . "${ZDOTDIR}/keybindings.zsh"
[[ -f "${ZDOTDIR}/secrets.zsh" ]] && . "${ZDOTDIR}/secrets.zsh"
[[ -f "${ZDOTDIR}/fzf.zsh" ]] && . "${ZDOTDIR}/fzf.zsh"
[[ -n "${TMUX}" ]] && export NVIM_LISTEN_ADDRESS="/tmp/nvim_${USER}_$(tmux display -p '#S_#{window_id}')"
[[ -x "$(command -v starship)" ]] && eval "$(starship init zsh)"
[[ -x "$(command -v zoxide)" ]] && eval "$(zoxide init zsh)"
[[ -s "${NVM_DIR}/nvm.sh" ]] && . "${NVM_DIR}/nvm.sh"
