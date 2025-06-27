# net.markfaine.dotfiles

## Overview

This role installs and configures a user's dotfiles.

No linking is performed by this role.

Dotfiles are installed to `~/.config/dotfiles`

### Variables

```yaml
username: 'mfaine' # required
home: '/home/mfaine' # default is '/home/' + username
github_username: 'markfaine' # required
dotfiles_repo: 'git+https://github.com/{{ github_username }}/dotfiles' # required
dotfiles_branch: 'main' # default is main
#proxy_env:
#  http_proxy: http://proxy:3128
#  https_proxy: http://proxy:3128
```
