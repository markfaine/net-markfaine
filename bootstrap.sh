#!/usr/bin/env bash
#shellcheck shell=bash
set -euo pipefail

# Configure a barebones environment for running tooling to configure full development environment
# Recommend running as a user other than the target user, for example root
# Running against a host other than localhost will require ssh public key access to the host

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
UV_INSTALL_DIR=/tmp/uv
UV_INSTALL_SCRIPT="https://astral.sh/uv/install.sh"
COLLECTION="git+https://github.com/markfaine/net-markfaine.git"
COLLECTION_BRANCH="experimental"

pushd "$DIR" &>/dev/null || exit 1


function install_dependencies() {
    printf "Installing dependencies\n"
    apt install -y curl wget git
}

function install_uv(){
    printf "Installing and configuring uv\n"
    curl -LsSf "$UV_INSTALL_SCRIPT" | env UV_INSTALL_DIR="$UV_INSTALL_DIR" sh &>/dev/null
}

function install_collection(){
    printf "Installing collection\n"
    "$UV_INSTALL_DIR/uvx" --from ansible-core ansible-galaxy collection install -f "$COLLECTION,$COLLECTION_BRANCH" &>/dev/null
}

mkdir -p "$UV_INSTALL_DIR"
install_dependencies
install_uv

pushd "$UV_INSTALL_DIR"
install_collection

# If no inventory, use default inventory
if [[ ! -f "$UV_INSTALL_DIR/inventory.yml" ]]; then
    cp -f "$HOME/.ansible/collections/ansible_collections/net/markfaine/inventory.yml" "$UV_INSTALL_DIR"
fi

# Set base command
playbook_cmd=("$UV_INSTALL_DIR/uvx" --with passlib --from ansible-core ansible-playbook)

# Add inventory
inventory="${1:-"$UV_INSTALL_DIR/inventory.yml"})"
playbook_cmd+=(-i "$inventory")
playbook_cmd+=(~/.ansible/collections/ansible_collections/net/markfaine/playbooks/playbook.yml)

printf "\nEdit the inventory at '%s' and then run this command:\n\n" "$UV_INSTALL_DIR/inventory.yml"

echo "${playbook_cmd[*]}"

