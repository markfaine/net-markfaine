# net.markfaine.doppler

## Overview

This role installs the [Doppler](https://www.doppler.com/) CLI for secrets management per-user.

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
    doppler: true  # Whether to install doppler for this user
```

## Dependencies

None

## Example Playbook

```yaml
- hosts: servers
  roles:
    - role: net.markfaine.doppler
      vars:
        users:
          - name: 'mfaine'
            home: '/home/mfaine'
            shell: '/usr/bin/zsh'
            doppler: true
```

## License

GPL-2.0-or-later

## Author Information

Mark Faine <mark.faine@pm.me>
