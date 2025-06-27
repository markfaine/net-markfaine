# net.markfaine.user

## Overview

This role installs and configures a user account.

### Required variables

```yaml
username: 'mfaine'
# password: # if unset this will be set to a random password, but only on creation of the user, never after.
comment: 'Mark Faine' # required 
home: '/home/mfaine' # default is /home/ + username
uid: '1001' # required
group_name: 'mfaine' # if not set it will default to 'users', gid will be ignored.
gid: '1002' # if not set it will be the same as uid
extra_groups: ['sudo']
shell: '/usr/bin/zsh' # default is /usr/bin/bash
```
