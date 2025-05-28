# net.markfaine.docker

## Overview

This role installs docker from the docker repo and uninstalls any operating system version of docker.

It also installs the docker credential helper for pass and docker compose.

Role variables:

```yaml
docker_config: # maps directly to options in ~/.docker/config.json
  ipv6: false
  icc: true
  userland-proxy: true
  no-new-privileges: false
  experimental: true
  selinux-enabled: false
  dns: []
run_docker_role: true # if false or unset the role doesn't run
```

See `vars/main.yml` for non-user-configurable variables.
