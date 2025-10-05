#!/usr/bin/env bash
#shellcheck shell=bash

set -euo pipefail

if [[ -f "$(dirname "$0")/../.env" ]]; then
    # shellcheck disable=SC1091
    source "$(dirname "$0")/../.env"
fi

if [[ "$EUID" -eq 0 ]]; then
        printf "You should not run this script as the root user\n"
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
	  Usage: $0 [-d|--debug] [-h|--help] COLLECTION_DIR [INSTALL_PATH]
	  Args:
	  --debug         Enable debug output
	  --help          Show this message
	  COLLECTION_DIR  The collection directory
      INSTALL_PATH            Where to install the collection, default is ~/.ansible/collections
EOF
    exit
}

DEBUG="false"
PARAMS=()
while (("$#")); do
    case "$1" in
    -d | --debug)
        DEBUG="true"
        shift
        ;;
    -h | --help)
        usage
        ;;
    --* | -*)
        usage
        ;;
    *) # preserve positional arguments
        PARAMS+=("$1")
        shift
        ;;
    esac
done
if [[ "${#PARAMS[@]}" -eq 0 ]]; then
    usage
fi
COLLECTION_DIR="${PARAMS[0]}"
INSTALL_PATH="${PARAMS[1]:-${INSTALL_PATH:-}}"
if [[ "${INSTALL_PATH:-}" == "" ]]; then
    INSTALL_PATH="${INSTALL_PATH:-$HOME/.ansible/collections}"
fi
#  COLLECTION_DIR="$(PAGER=cat ansible-config dump --format json | jq -r '.[] | select(.name == "COLLECTIONS_PATHS").value[0]')"
if [[ ! -d "$COLLECTION_DIR" ]]; then
    printf "The directory '%s' does not exist!\n" "$COLLECTION_DIR"
    usage
fi
debug "COLLECTION_DIR is '$COLLECTION_DIR'"

if [[ "$COLLECTION_DIR" != "$HOME/.ansible/collections" ]]; then
    ansible-galaxy collection install -f "$COLLECTION_DIR"
else
    printf "Can only install a collection that is not located in %s\n" "$HOME/.ansible/collections/"
    usage
fi
coll="$(yq ~/nats-default/galaxy.yml -o=json | jq -r '(.namespace + "." + .name)')"
ansible-galaxy collection list | grep "$coll" || true
debug "Installed collection: $coll (checked via ansible-galaxy)"
