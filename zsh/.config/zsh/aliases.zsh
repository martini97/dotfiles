alias gcd='cd $(git rev-parse --show-cdup)'
[[ -x "$(command -v pbcoby)" ]] && alias lcc='fc -ln -1 | awk "{\$1=\$1}1" ORS="" | pbcopy'

alias kcontext='kubectl config use-context $(kubectl config get-contexts -o name | fzf --height=10 --prompt="Kubernetes Context> ")'
alias knamespace='kubectl config set-context --current --namespace "$(kubectl get ns -o name | fzf -d/ --with-nth=2 | cut -d/ -f2)"'
