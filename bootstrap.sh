#!/usr/bin/env bash
#shellcheck shell=bash
set -euo pipefail

# Configure a barebones environment for running tooling to configure full development environment
# Recommend running as a user other than the target user, for example root
# Running against a host other than localhost will require ssh public key access to the host

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DEPENDENCIES=(curl wget)
UV_INSTALL_DIR=/tmp/uv
UV_INSTALL_SCRIPT="https://astral.sh/uv/install.sh"
COLLECTION="git+https://github.com/markfaine/net-markfaine.git"
COLLECTION_BRANCH="experimental"

function install_dependencies() {
    local tags
    printf "Installing dependencies\n"
    tags="$(IFS=' '; echo "${dependencies[*]}")"
    apt install -y "${tag[@]}"
}

function install_uv(){
    printf "Installing and configuring uv\n"
    curl -LsSf "$UV_INSTALL_SCRIPT" | env UV_INSTALL_DIR="$UV_INSTALL_DIR" sh &>/dev/null
    mkdir -p $UV_INSTALL_DIR
}

function install_collection(){
    printf "Installing collection\n"
    uvx --from ansible-core ansible-galaxy collection install -f "$COLLECTION,$COLLECTION_BRANCH" &>/dev/null
}

pushd $UV_INSTALL_DIR &>/dev/null || exit 1

# Set base command
playbook_cmd=(uvx --with passlib --from ansible-core ansible-playbook)

# Add inventory
inventory="$1"
if [[ "${inventory:-}" == "" ]]; then
    cp -f "$DIR/inventory.yml" "$UV_INSTALL_DIR/inventory.yml"
    playbook_cmd+=(-i "$UV_INSTALL_DIR/inventory.yml" -l localhost --connection local)
else
    playbook_cmd+=(-i "$inventory")
fi

playbook_cmd+=(~/.ansible/collections/ansible_collections/net/markfaine/playbooks/playbook.yml)

printf "Running playbooks\n"
echo "${playbook_cmd[*]}"

"${playbook_cmd[@]}"
