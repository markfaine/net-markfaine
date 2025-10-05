# net.markfaine.fonts

## Overview

This role installs Nerd Fonts from the official repository. You can select either all fonts or individual fonts. Fonts are installed to `~/.fonts` and the font cache is refreshed.

## Requirements

- Ansible 2.16.1 or later
- Debian or Ubuntu based systems
- wget, jq, unzip installed
- Internet access for downloading fonts from GitHub
- Sudo privileges

## Role Variables

### fonts
- **Description**: List of fonts to install. Use "all" to install all available fonts, or specify individual font names (e.g., ["FiraCode", "Hack"]).
- **Default**: Not set (must be defined)

### username
- **Description**: The username for whom fonts are installed. Required.

### home
- **Default**: `/home/{{ username }}`
- **Description**: The home directory path.

### proxy_env (optional)
- **Description**: Proxy environment variables for downloads.
  ```yaml
  proxy_env:
    http_proxy: http://proxy:3128
    https_proxy: http://proxy:3128
  ```

## Dependencies

None

## Example Playbook

Install all fonts:

```yaml
- hosts: servers
  roles:
    - role: net.markfaine.fonts
      fonts: ["all"]
      username: myuser
```

Install specific fonts:

```yaml
- hosts: servers
  roles:
    - role: net.markfaine.fonts
      fonts: ["FiraCode", "JetBrainsMono"]
      username: myuser
```

## License

GPL-2.0-or-later

## Author Information

Mark Faine <mark.faine@pm.me>
