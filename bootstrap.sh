#!/usr/bin/env bash
#shellcheck shell=bash
set -euo pipefail

# Configure a barebones environment for running tooling to configure full development environment
# Recommend running as a user other than the target user, for example root

if [[ "$EUID" -ne 0 ]]; then
    printf "You should run this script as the root user\n"
    exit 1
fi

# A prompt function
function ask() {
    local ans
    while true; do
        printf "\n%s [y|N] ? " "$@"
        read -r ans
        case "$ans" in
        y* | Y*) return 0 ;;
        *) return 1 ;;
        esac
    done
}

function user_prompt(){
    local prompt default
    prompt="${1:-None}"
    default="${2:-''}"
    while true; do
        printf "\n%s: [%s]" "$prompt" "$default"
        read -r result
        if [[ "${result:-}" == "" ]]; then
            result="$default"
            break
        fi
        if ask "You entered '$result', is this correct"; then
            break
        fi
    done
}


# Install curl
if ! command -v curl &>/dev/null; then
    printf "Installing curl\n"
    apt install -y curl
fi

# Install uv
printf "Installing and configuring uv\n"
curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/tmp/uv" sh &>/dev/null
mkdir -p /tmp/bootstrap
pushd /tmp/bootstrap &>/dev/null || exit 1

printf "Installing collection\n"
uvx --from ansible-core ansible-galaxy collection install -f git+https://github.com/markfaine/net-markfaine.git,experimental &>/dev/null

# Set base command
playbook_cmd=(uvx --from ansible-core ansible-playbook)

# Set target host
user_prompt "Target Hostname" "localhost"
playbook_cmd+=(-l "$result")
if [[ "${result:-}" == "localhost" ]]; then
    playbook_cmd+=(--connection local)
fi

roles=(packages user mise wsl docker fonts)
run_roles=()
for role in "${roles[@]}"; do
    if ask "Run the $role role"; then
        run_roles+=($role)
    fi
done
tags="$(IFS=','; echo "${run_roles[*]}")"
playbook_cmd+=(-t "$tags")
playbook_cmd+=(~/.ansible/collections/ansible_collections/net/markfaine/playbooks/playbook.yml)

printf "Run playbooks\n"
echo "${playbook_cmd[*]}"
"${playbook_cmd[@]}"
