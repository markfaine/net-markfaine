# net.markfaine.mise

## Overview

This role installs and configures the Mise package manager per-user from the official install script, including PATH setup for Bash and Zsh.

## Requirements

- Ansible 2.16.1 or later
- Debian or Ubuntu based systems
- Sudo privileges
- Internet access for downloading the install script
- curl

## Role Variables

### Multi-user structure

```yaml
users:
  - name: 'username'
    home: '/home/username'
    shell: '/usr/bin/bash'  # or /usr/bin/zsh
    mise: true  # Whether to install mise for this user
```

## Dependencies

None

## Example Playbook

```yaml
- hosts: servers
  roles:
    - role: net.markfaine.mise
      vars:
        users:
          - name: 'mfaine'
            home: '/home/mfaine'
            shell: '/usr/bin/zsh'
            mise: true
```

## License

GPL-2.0-or-later

## Author Information

Mark Faine <mark.faine@pm.me>
