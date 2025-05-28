# net.markfaine.apt

## Overview

This role installs operating packages that are either used as development tools or dependencies for tools.

It also removes operating system tools that are already installed by Mise.  

The general idea is that there is only one version of the tool and it is preferably managed by Mise or a tool that was installed by Mise, such as npx or pipx.

See the `apt_packages` variable for operating system packages installed by this role.

See the `apt_packages_uninstall` variable for operating system packages uninstalled by this role.
