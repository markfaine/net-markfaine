# net.markfaine

## Overview 
This project contains an Ansible collection for Ubuntu that is used to configure a user environment and to install dotfiles.

- ansible
- bash with bash-it
- asdf
- git
- fzf
- nvim with NVChad
- node/npm 
- python3 (libraries)
- ruby
- tmux
- wsl configuration (for WSL2 environments)
- wsl vpn-kit (for WSL2 environments)
- zsh with zim

**Note:** I am assuming the commands below will be all executed as the root user and the ansible `remote_user` will also be root. 

## Instructions
See [Setup a new computer](https://gist.github.com/markfaine/ba7468b0d81d1914ac1a7f97e2998606) for the files referenced below.

1. Create an Ansible vault file as `~/.vault` and edit the file to add the password:
```
@default SUPER_SECRET_PASSWORD
```
2. Set permissions on vault file
```sh
chmod 600 ~.vault
```
3. Create an inventory file as `~/inventory.yml` with the following contents:
```yml
---
# Edit the below as required
all:
  hosts:
    localhost:
      ansible_connection: local
      ansible_python_interpreter: "{{ ansible_playbook_python }}"
      github_username: GITHUB_USERNAME # username may be different in github
      user_name: USER_NAME
      user_homedir: "/home/USER_NAME" # this is the default if unset
      user_comment: "USER_FULL_NAME"
      user_uid: 1000 # This id should exist on default Ubuntu installations but verify before using
      user_group_id: 1000 # This gid should exist on default Ubuntu installations but verify before using
      user_group: USER_GROUP
      user_groups: sudo # This ensures that the user can sudo
      user_shell: USER_SHELL # i.e /usr/bin/bash or /usr/bin/zsh
      user_ssh_keys: # each key here will be installed into `/home/USER_NAME/.ssh/<basename>`
        - /tmp/id_rsa_USER # be sure to delete this when it is no longer needed
      stow_dotfiles_repo: 'git@github.com:markfaine/dotfiles.git' 
```
4. Create `~/ansible.cfg` with the following contents:
```
[defaults]
action_warnings=False
ansible_managed = This file is managed by Ansible, all changes will be lost
inventory = ~/inventory.yml
log_path = ~/ansible.log
remote_user = root
nocows = True
retry_files_enabled = False
timeout = 60
vault_identity_list="default@~/.vault"

[ssh_connection]
pipelining = True
scp_if_ssh = True
```
5. Create `~/bootstrap.sh` with the following contents:
```sh
#!/usr/bin/env bash
apt-get update &>/dev/null
apt-get install -y python3-venv whois
python3 -m venv --system-site-packages /tmp/venv
chmod -R u+rwX,g+rX,o+rX /tmp/venv
. /tmp/venv/bin/activate
python3 -m pip install ansible
VAULT_FILE="$HOME/vault.yml"
if [[ -f "$VAULT_FILE" ]]; then
    exit 0
fi
cat <<EOF > "$VAULT_FILE"
SALT="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12; echo)"
---
user_password_salt: "$SALT"
user_password: $(mkpasswd --method=sha-512 -S "$SALT")
EOF
```
6. Encrypt `~/vault.yml` with Ansible vault:
```sh
. /tmp/venv/bin/activate
ansible-vault encrypt default ~/vault.yml
```
7. Run `bootstrap.sh` 
```sh
chmod +x bootstrap.sh
./bootstrap.sh
```
8. Install the collection:
```sh
. /tmp/venv/bin/activate
ansible-galaxy collection install git+https://github.com/markfaine/net-markfaine.git
```
9. Run the playbook
```sh
ansible-playbook -l localhost \
  ~/.ansible/collections/ansible_collections/net/markfaine/playbooks/playbook.yml \
  -e @~/vault.yml
```
10. Logout and login as the non-root user
