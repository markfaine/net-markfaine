# net.markfaine.user

## Overview

This role creates or updates a user and downloads dotfiles from github.

Role variables:

```yaml
username: 'mfaine'
password: 'whatever' # if unset this will be set to a random password, but only on creation of the user, never after.
comment: 'Mark Faine'
home: '/home/{{ username }}'
uid: '1001'
group_name: 'mfaine' # if not set it will default to 'users', gid will be ignored.
gid: '1002' # if not set it will be the same as uid
extra_groups: ['sudo', 'ubuntu','docker'] | default is 'sudo'
shell: '/usr/bin/zsh'
github_username: 'markfaine'
dotfiles_repo: 'git+https://github.com/{{ github_username }}/dotfiles'
dotfiles_branch: 'development'
run_user_role: true # The user must already exist if this is false as the role will not run.
```
