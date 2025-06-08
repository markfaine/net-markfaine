# net.markfaine

## Overview
This project contains tools for installing/updating my tools and dotfiles across multiple Ubuntu (and maybe Debian) environments. It uses Ansible, Doppler, Tuckr, and Mise to Install tooling and dotfiles.

Note: The script below need to be run with a privileged user account.

```sh
# To setup on a stock ubuntu
apt-get update && apt-get install -y curl
curl https://raw.githubusercontent.com/markfaine/net-markfaine/refs/heads/main/bootstrap.sh | bash

```
The above will output an `ansible-playbook` command. Edit the inventory file located at `/tmp/uv/inventory.yml` and then run the `ansible-playbook` command.

Note:  You may want to create a simple `ansible.cfg` file at `/tmp/uv/ansible.cfg` prior to running the ansible playbook.

```ini
[defaults]
action_warnings=False
deprecation_warnings=False
ansible_managed = This file is managed by Ansible, all changes will be lost.
debug=False
forks=10
gathering = smart
host_key_checking = False
interpreter_python=auto_silent
log_path=~/ansible.log
nocolor=False
nocows=True
retry_files_enabled = False
timeout=60
transport=ssh
verbosity=0
[ssh_connection]
pipelining = True
scp_if_ssh = True
```


## Post Ansible

### Doppler
[Doppler](https://doppler.com) requires that you have a doppler project configured for use with env and/or secrets.
However you can just add a `.env` file to your `$HOME` directory and it will also be sourced.  The benefit of using Doppler here is that it allows me to deploy different environment 
variables and secrets for different environments without duplicating files. It's also free for up to 3 users.
```sh
doppler login # Open a browser and login
doppler setup
doppler secrets download --no-file --format env > ~/.env
...
```
See: `doppler --help` for more information.

### Tuckr/Mise
[Tuckr](https://github.com/RaphGL/Tuckr) is like [GNU Stow](https://www.gnu.org/software/stow/) and will install dotfiles.  The dotfiles come from a [dotfiles repo](https://github.com/markfaine/dotfiles/tree/main) and are using the layout required by Tuckr.  The Ansible inventory file contains a variable that points to the dotfiles repo.  Since rust isn't installed until after Mise is installed but mise doesn't have any configuration file until Tuckr symlinks the dotfiles I have to get creative here.

```sh
eval "$(mise activate zsh)"
mise use -g rust
cargo install tuckr
cd ~/.config/dotfiles
tuckr add \* -f # A pre-hook should remove "$HOME/.config/mise/config.toml" if it exists and is a regular file, if not force
exec zsh
```
See `tuckr --help` for more information.

### Mise
[Mise (mise-en-place)](https://mise.jdx.dev/) will install the tools configured from  `~/.config/mise/config.toml` installed from the dotfiles repo by Mise.

```sh
mise install
```

### Restart
Some of the configuration changes won't take effect until the shell restarts.

```sh
exec zsh
```

### Updating dotfiles
Since the point is to be able to manage shared dotfiles (and tools) it's necessary to update the remote for the repository once everything is working so that dotfile updates can easily be pushed back to the remote.  This is because the Ansible role uses an http remote since other users may wish to use this as a starting point for thier own projects. If so, replace the repo below with your repository remote.

```sh
cd ~/.config/dotfiles
git remote set-url origin git@github.com:markfaine/dotfiles.git
```

### Neovim
The first time neovim is opened it may need to download some tools with Mason.  

**Update**: Mise now manages all of the tools required by neovim plugins, with the exception of `ansible-language-server` which I've yet to find a way to install using Mise.

Note: This neovim config is based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and is absolutely a work in progress.

```sh
nvim
# wait for it to finish and then exit
```

### Setting Default Tool Paths

#### Python
This may be later added to the role but for now run this command to set the default python

```sh
sudo update-alternatives --install /usr/bin/python python "$HOME/.local/share/mise/installs/python/latest" 1
sudo update-alternatives --config python # select 0 or 1
```



