# net.markfaine.docker

## Overview

This role installs Docker from the official Docker repository and uninstalls any operating system version of Docker.

It also installs the Docker credential helper for pass and Docker Compose.

## Requirements

- Ansible 2.13 or later
- Ubuntu 20.04+ or Debian-based systems (tested on Ubuntu 25.10)
- Sudo privileges
- Internet access for downloading Docker packages and keys
- Supported architectures: amd64, arm64, armhf

## Role Variables

### run_docker_role
- **Default**: `true`
- **Description**: If `false` or unset, the role doesn't run.

### docker_config
- **Default**: See `vars/main.yml` for `docker_default_config`
- **Description**: Maps directly to options in `/etc/docker/daemon.json`. Example:
  ```yaml
  docker_config:
    ipv6: false
    icc: true
    userland-proxy: true
    no-new-privileges: false
    experimental: true
    selinux-enabled: false
    dns: []
  ```

### username
- **Description**: The user to add to the `docker` group.

### proxy_env (optional)
- **Description**: Proxy environment variables for Docker service.

See `vars/main.yml` for non-user-configurable variables like package lists and URLs.

## Dependencies

None

## Example Playbook

```yaml
- hosts: servers
  roles:
    - net.markfaine.docker
```

To override configuration:

```yaml
- hosts: servers
  roles:
    - role: net.markfaine.docker
      docker_config:
        experimental: true
        dns:
          - 8.8.8.8
      username: myuser
```

## License

GPL-2.0-or-later

## Author Information

Mark Faine <mark.faine@pm.me>
