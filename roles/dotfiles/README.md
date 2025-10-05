# net.markfaine.dotfiles

## Overview

This role installs and configures users' dotfiles by cloning Git repositories. Provide the repository URL directly in your user data so the role can work with any Git server (GitHub, GitLab, self-hosted, etc.).

No linking or symlinking is performed by this role. Dotfiles are installed to `~/.config/dotfiles`.

## Requirements

- Ansible 2.16.1 or later
- Debian or Ubuntu based systems
- Git installed
- Sudo privileges
- Internet access for cloning the repository

## Role Variables

### users
- **Description**: List of users to process for dotfiles installation.
  ```yaml
  users:
    - name: 'username'
      home: '/home/username'
      dotfiles_repo: 'ssh://git@git.example.com/configs/dotfiles.git'
      dotfiles_branch: 'main'
  ```

### proxy_env (optional)
- **Description**: Proxy environment variables for Git operations.
  ```yaml
  proxy_env:
    http_proxy: http://proxy:3128
    https_proxy: http://proxy:3128
  ```

## Dependencies

None

## Example Playbook

```yaml
- hosts: servers
  roles:
    - role: net.markfaine.dotfiles
      vars:
        users:
          - name: 'mfaine'
            dotfiles_repo: 'https://git.example.com/users/mfaine/dotfiles.git'
            dotfiles_branch: 'main'
          - name: 'developer'
            dotfiles_repo: 'https://gitlab.com/developer/dotfiles.git'
            dotfiles_branch: 'develop'
```

## License

GPL-2.0-or-later

## Author Information

Mark Faine <mark.faine@pm.me>
