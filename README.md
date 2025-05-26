# net.markfaine

## Overview
This project contains tools for installing/updating my tools and dotfiles across multiple Ubuntu (and maybe Debian) environments. It uses Ansible, Doppler, Tuckr, and Mise to Install tooling and dotfiles.

Note: The script below need to be run with a privileged user account.

```sh
# To setup on a stock ubuntu
apt-get update && apt-get install -y curl
curl https://raw.githubusercontent.com/markfaine/net-markfaine/refs/heads/experimental/bootstrap.sh | bash

```
The above will output an `ansible-playbook` command. Edit the inventory file located at `/tmp/uv/inventory.yml` and then run the `ansible-playbook` command.

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
[Tuckr](https://github.com/RaphGL/Tuckr) is like [GNU Stow](https://www.gnu.org/software/stow/) and will install dotfiles.  The dotfiles come from a [dotfiles repo](https://github.com/markfaine/dotfiles/tree/experimental) and are using the layout required by Tuckr.  The Ansible inventory file contains a variable that points to the dotfiles repo.  Since rust isn't installed until after Mise is installed but mise doesn't have any configuration file until Tuckr symlinks the dotfiles I have to get creative here.

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

### Neovim
The first time neovim is opened it will need to download some tools with Mason.  Later, I will try to make it use the tools installed by Mise.

Note: This neovim config is based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and is absolutely a work in progress.

```sh
nvim
# wait for it to finish and then exit
```

