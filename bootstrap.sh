#!/usr/bin/env bash
#shellcheck shell=bash
set -euo pipefail

# Configure a barebones environment for running tooling to configure full development environment
# Recommend running as a user other than the target user, for example root

if [[ "$EUID" -ne 0 ]]; then
    printf "You should run this script as the root user\n"
    exit 1
fi

# Functions
debug() {
    if [[ "$DEBUG" == "true" ]]; then
        printf "DEBUG ===> %s\n" "$*"
    fi
}

usage() {
    cat <<-EOF
          Usage: $0 [-d|--debug] [-h|--help] [COLLECTION_DIR]
          Args:
          --debug         Enable debug output
          --help          Show this message
          COLLECTION_DIR  The collection directory
EOF
    exit
}


# Install curl, uv, initialize a project
apt install -y curl
curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/tmp/uv" sh
source /tmp/uv/env
mkdir -p /tmp/bootstrap
pushd /tmp/bootstrap &>/dev/null || exit 1
uv run --no-project ansible \
	-c "ansible-galaxy collection install -f git+https://github.com/markfaine/net-markfaine.git"

if ! uv run --no-project ansible \
	-c "ansible-playbook ~/.ansible/collections/ansible_collections/net/markfaine/playbooks/playbook.yml; then
    printf "Sorry there was an error!\n"
    exit 1
fi

cat <<EOF 
  Login as the target user and run the followng commands:

  # If you have a dotenv
  # npx dotenv-vault@latest pull [ENVIRONMENT]

  # Install/Update mise packages
  # mise up # by default this will also pull tuckr dotfiles from the specified dotfiles repo
  


