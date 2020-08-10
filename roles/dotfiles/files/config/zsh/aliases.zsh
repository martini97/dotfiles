alias gcd='cd $(git rev-parse --show-cdup)'
[[ -x "$(command -v pbcoby)" ]] && alias lcc='fc -ln -1 | awk "{\$1=\$1}1" ORS="" | pbcopy'

alias kcontext='kubectl config use-context $(kubectl config get-contexts -o name | fzf --height=10 --prompt="Kubernetes Context> ")'
alias knamespace='kubectl config set-context --current --namespace "$(kubectl get ns -o name | fzf -d/ --with-nth=2 | cut -d/ -f2)"'

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias g=git

if (( $+commands[pyenv] )); then
    alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
fi
