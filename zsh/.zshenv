export PATH="/usr/local/sbin:$HOME/bin:$HOME/go/bin:$HOME/.gems/bin:/usr/local/bin:$PATH"

export EDITOR=nvim
export VISUAL=nvim

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:=${HOME}/.local/share}

export ZDOTDIR=${ZDOTDIR:=${XDG_CONFIG_HOME}/zsh}
export HISTFILE="${XDG_DATA_HOME}/zsh/history"
export HISTSIZE=50000
export SAVEHIST=50000
export LSCOLORS=fxexcxdxbxegedabagacad

export BAT_THEME="Solarized (light)"
export _Z_CMD="j"

export VIRTUALENVWRAPPER_PYTHON="$(command -v python3)"
export WORKON_HOME="${HOME}/.virtualenvs"

export GEM_HOME="${HOME}/.gems"

[[ "${OSTYPE}" == darwin* ]] && export BROWSER="open"
[[ -z "${LANG}" ]] && export LANG="en_US.UTF-8"
[[ -x "$(command -v rg)" ]] && export FZF_DEFAULT_COMMAND='rg --files --hidden'
[[ -x "/bin/zsh" ]] && export SHELL="/bin/zsh"
[[ -x "/usr/local/bin/zsh" ]] && export SHELL="/usr/local/bin/zsh"
[[ -x "$(command -v bat)" ]] && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

command -v pyenv >/dev/null 2>&1 && export PYENV_ROOT="$(pyenv root)"

if (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND='rg --files --hidden'
elif (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
elif (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='ag -l --hidden -g ""'
fi

export PASSWORD_STORE_CLIP_TIME="25"
export PASSWORD_STORE_GENERATED_LENGTH="32"

if [ "$(uname -s)" = "Darwin" ]; then
  export PATH="$HOME/Library/Python/2.7/bin:$HOME/Library/Python/3.8/bin:$PATH"
fi
