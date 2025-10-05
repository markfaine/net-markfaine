# net.markfaine.wsl

## Overview

This role configures WSL2 settings on Ubuntu systems running under Windows Subsystem for Linux. It manages `/etc/wsl.conf` and `.wslconfig` files for optimal WSL2 performance and integration.

Note: The WSL VPN kit installation is currently commented out and needs review due to potential changes in the upstream project.

## Requirements

- Ansible 2.16.1 or later
- Ubuntu system running under WSL2
- Windows host with WSL2 enabled
- `username` variable set (typically from user role)

## Role Variables

### Optional variables

```yaml
wsl_state: 'present'  # 'present' to configure, 'absent' to remove configuration
username: ''          # Windows username for .wslconfig location
state: 'present'      # Alternative state variable (for compatibility)
is_wsl: true          # Whether running in WSL environment
```

## Dependencies

None

## Example Playbook

```yaml
- hosts: wsl_hosts
  roles:
    - role: net.markfaine.wsl
      vars:
        username: 'WindowsUser'
```

## Configuration Files

This role manages:

- `/etc/wsl.conf`: WSL configuration file
- `/mnt/c/Users/{{ username }}/.wslconfig`: Windows-side WSL configuration

## License

GPL-2.0-or-later

## Author Information

Mark Faine
