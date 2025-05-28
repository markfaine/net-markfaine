# net.markfaine.user

## Overview

This role installs and configures a user account.  It also clones a dotfiles repository from Github.

### Required variables

```yaml
username: 'mfaine'
# password: # if unset this will be set to a random password, but only on creation of the user, never after.
comment: 'Mark Faine'
home: '/home/{{ username }}'
uid: '1001'
group_name: 'mfaine' # if not set it will default to 'users', gid will be ignored.
gid: '1002' # if not set it will be the same as uid
extra_groups: ['sudo']
shell: '/usr/bin/zsh'
github_username: 'markfaine'
dotfiles_repo: 'git+https://github.com/{{ github_username }}/dotfiles'
dotfiles_branch: 'main'
```
