autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^H" backward-word
bindkey "^K" up-line-or-beginning-search
bindkey "^J" down-line-or-beginning-search
bindkey "^L" forward-word
