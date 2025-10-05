# net.markfaine.user

## Overview

This role installs and configures user accounts on Debian/Ubuntu systems. It can create multiple users with specific UIDs, groups, SSH keys, and sudo privileges.

## Requirements

- Ansible 2.16.1 or later
- Debian or Ubuntu system
- `ansible.posix.authorized_key` collection for SSH key management

## Role Variables

### Multi-user structure

```yaml
users:
  - name: 'mfaine'
    comment: 'Mark Faine'
    uid: '1000'
    gid: '1000'
    group_name: 'mfaine'
    home: '/home/mfaine'
    shell: '/usr/bin/zsh'
    extra_groups: ['sudo', 'docker']
    user_ssh_key_sources:
      - 'https://git.example.com/users/mfaine.keys'
    user_ssh_key_ignore_errors: true
    user_sudo: true
    user_ssh_keys: true
    user_authorized_keys: []
    docker_access: true  # For docker role compatibility
    state: 'present'
```

## Dependencies

None

## Example Playbook

```yaml
- hosts: servers
  roles:
    - role: net.markfaine.user
      vars:
        users:
          - name: 'mfaine'
            uid: '1000'
            comment: 'Mark Faine'
            extra_groups: ['sudo', 'docker']
            user_ssh_key_sources:
              - 'https://git.example.com/users/mfaine.keys'
          - name: 'developer'
            uid: '1001'
            comment: 'Developer'
            shell: '/usr/bin/bash'
            extra_groups: ['sudo']
```

## License

GPL-2.0-or-later

## Author Information

Mark Faine
