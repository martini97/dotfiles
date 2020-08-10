# dotfiles

My dotfiles, focused on JavaScript/TypeScript/Python development.

Managed via dotfile, so far it only supports Mac, but I will eventually add
my setup to other environments.
The dot files management is usually done via `stow`, however in some cases I
prefer to have ansible template render the file (as in `.zshenv`), in that case
a symlink is not generated, so be careful editing those files.

## Dependencies
- Git
- Ansible
- cURL

## Setup

You need to create the group_vars/vault.yml before running, it's better to keep this file somewhere
safe and where you can access from other machines. I'm keeping mine on a password manager. You can
find the vars required for the vault with this command:

```bash
rg "^.*?(vault_[a-zA-Z0-9_]*).*?$" -r '$1' --no-filename | sort -u
```

Setup:

```bash
git clone https://github.com/martini97/dotfiles.git
cd dotfiles
python3 -m venv .venv
pip install ansible
ansible-vault create group_vars/vault.yml
ansible-playbook -i ./hosts dotfiles.yml --ask-become-pass --ask-vault-pass --tags "all"
```

## Non automated steps:

+ Install [Logitech Options](https://www.logitech.com/pt-br/product/options)
