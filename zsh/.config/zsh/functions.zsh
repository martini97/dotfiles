function reload() {
  source "${ZDOTDIR:=${HOME}}/.zshrc"
  source "${HOME}/.zshenv"
}

function edit () {
  if [[ $TMUX ]]; then
    local pane_id=$(tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep nvim | cut -f1 -d' '| head -n1)
    if [[ $pane_id ]]; then
      tmux select-pane -t $pane_id
    fi
  fi

  nvr -s $@
}

cd() {
  [[ ! -e $argv[-1] ]] || [[ -d $argv[-1] ]] || argv[-1]=${argv[-1]%/*}
  builtin cd "$@"
}

function kexec() {
  local available_commands="sh,Shell\nbash,Bash\npython manage.py shell,Python Shell"
  local pod=$(kubectl get pods -o name | fzf --height=10 --prompt="Pod Name> ")
  read -A command <<< "$(echo $available_commands | fzf --height=10 --prompt="Command> " --with-nth=2 --delimiter=, | awk -F, '{print $1}')"
  kubectl exec -it "${pod}" -- "${command[@]}"
}

function klogs() {
  local pod=$(kubectl get pods -o name | fzf --height=10 --prompt="Kubernetes Pod> ")
  kubectl logs "${pod}" "${=argv}"
}
