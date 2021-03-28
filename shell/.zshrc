if [ ! -d "${ZSH}" ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git "${ZSH}"
fi

ZSH_THEME="robbyrussell"
plugins=(git ssh-agent)

function source_if_exists() {
  local file=$1

  if [ -r "${file}" ]; then
    source "${file}"
  fi
}

source_if_exists "${ZSH}/oh-my-zsh.sh"
source_if_exists "${ZSH_CONFIG_DIR}/aliases.zsh"
source_if_exists "${ZSH_CONFIG_DIR}/keybinds.zsh"
source_if_exists "${NVM_DIR}/nvm.sh"
