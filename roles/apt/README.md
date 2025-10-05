# net.markfaine.apt

## Overview

This role installs operating system packages that are either used as development tools or dependencies for tools.

It also removes operating system tools that are already installed by Mise.

The general idea is that there is only one version of the tool and it is preferably managed by Mise or a tool that was installed by Mise, such as npx or pipx.

## Requirements

- Ansible 2.1 or later
- Debian or Ubuntu based systems
- Sudo privileges

## Role Variables

### apt_packages

List of packages to install. Defaults include development tools and libraries.

### apt_packages_uninstall

List of packages to remove, typically those replaced by Mise-managed versions.

## Dependencies

None

## Example Playbook

```yaml
- hosts: servers
  roles:
    - net.markfaine.apt
```

To override packages:

```yaml
- hosts: servers
  roles:
    - role: net.markfaine.apt
      apt_packages:
        - git
        - vim
      apt_packages_uninstall:
        - nano
```

## License

GPL-2.0-or-later

## Author Information

Mark Faine <mark.faine@pm.me>
