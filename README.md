# net.markfaine

[![Ansible Collection](https://img.shields.io/badge/Ansible-Collection-blue)](https://ansible.com)
[![License](https://img.shields.io/badge/License-GPL--2.0--or--later-green)](LICENSE)

## Overview

This Ansible collection provides roles and playbooks for setting up and managing
development environments on Ubuntu (and Debian-based) systems. It includes tools
for user management, dotfiles installation, package management, and more, using
modern tools like Doppler for secrets, Mise for runtime management, and Tuckr
for dotfile management.

The collection is designed to be flexible and customizable, allowing users to
configure their environments according to their needs.

## Requirements

- **Ansible**: 2.16.1 or later
- **Target Systems**: Ubuntu 20.04+ or Debian-based distributions
- **Privileges**: Root or sudo access required for system-level changes
- **Internet Access**: Required for downloading packages and cloning repositories

## Quick Start

### Bootstrap a New System

For a fresh Ubuntu installation, run the bootstrap script as root:

```bash
# Update and install curl
apt-get update && apt-get install -y curl

# Run the bootstrap script
curl -fsSL https://raw.githubusercontent.com/markfaine/net-markfaine/main/bootstrap.sh | bash
```

The bootstrap script will:

- Install system dependencies
- Set up uv (Python package manager)
- Install the Ansible collection
- Run the main playbook with interactive inventory creation if needed

### Bootstrap Options

The bootstrap script supports several options:

```bash
./bootstrap.sh [options]

Options:
  -v, --verbose    Show detailed command output
  -i, --inventory FILE    Specify custom inventory file
  -h, --help       Show help message
```

## Configuration

### Inventory

Create an inventory file (e.g., `inventory.yml`) with your user configuration:

```yaml
all:
  hosts:
    localhost:
      ansible_connection: local
      ansible_python_interpreter: /usr/bin/python3

      users:
        - name: 'yourusername'
          comment: 'Your Name'
          uid: '1000'
          gid: '1000'
          group_name: 'yourusername'
          home: '/home/yourusername'
          shell: '/usr/bin/zsh'
          extra_groups: ['sudo', 'docker']
          user_ssh_key_sources:
            - 'https://github.com/yourusername.keys'
          dotfiles_repo: 'https://github.com/yourusername/dotfiles.git'
          docker_access: true
          mise: true
          doppler: true
          state: 'present'
```

### Environment Variables

The bootstrap script can be customized with environment variables:

- `UV_INSTALL_DIR`: Directory for uv installation (default: `/tmp/uv`)
- `COLLECTION`: Collection repository URL
- `COLLECTION_BRANCH`: Branch to install (default: `main`)

## Roles

This collection includes the following roles:

### net.markfaine.apt
Manages APT packages and repositories.

### net.markfaine.user
Creates and configures user accounts with SSH keys, sudo access, and more.

### net.markfaine.dotfiles
Clones and manages dotfiles repositories using git, mise, and tuckr.

### net.markfaine.fonts
Installs Nerd Fonts for development.

### net.markfaine.mise
Sets up Mise (formerly RTX) for runtime management.

### net.markfaine.doppler
Configures Doppler for secrets management.

### net.markfaine.docker
Installs and configures Docker.

### net.markfaine.wsl
WSL-specific configurations.

## Usage

### Running Individual Roles

After bootstrapping, you can run specific roles:

```bash
ansible-playbook -i inventory.yml playbooks/user.yml
ansible-playbook -i inventory.yml playbooks/dotfiles.yml
```

### Updating Dotfiles

The collection clones dotfiles over HTTPS for initial setup. To enable pushing changes back to your repository, update the remote URL:

```bash
cd ~/.config/dotfiles
git remote set-url origin git@github.com:yourusername/dotfiles.git
```

### Managing Secrets with Doppler

The collection can set up Doppler for secrets management. If a `doppler_token` is provided, it will configure authentication automatically. Otherwise, it will prompt for browser-based login.

## Development

### Testing

Run tests with Molecule:

```bash
cd roles/<role_name>
molecule test
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

## Troubleshooting

### Common Issues

- **Permission Denied**: Ensure you're running with sudo or as root
- **Missing Dependencies**: The bootstrap script installs required packages
- **Inventory Errors**: Verify your inventory file syntax and paths

### Getting Help

- Check the role-specific README files in `roles/*/README.md`
- Review Ansible logs for detailed error messages
- Open an issue on GitHub for bugs or feature requests

## License

GPL-2.0-or-later

## Author

Mark Faine <mark.faine@pm.me>
