#!/usr/bin/env bash

# Compares the left version number to the right version number and
# exits 0 if the left version is equal or higher.
function version_compare(){
    local version1 version2
    version1="$1"
    version2="$2"
    if [[ "${version1:-}" == "" ]]; then return 1; fi
    if [[ "${version2:-}" == "" ]]; then return 1; fi
    echo "$1" "$2" \
    | python3 -c \
    "import re, sys; arr = \
    lambda x: list(map(int, re.split('[^0-9]+', x))); x, y = \
    map(arr, sys.stdin.read().split()); exit(not x >= y)";
}

function update() {
    while IFS=' ' read line; do
        name="${line%% *}"
        current="${line##* }"
        latest="0.0.0" # no latest available
        if asdf latest "$name" &>/dev/null; then
            latest="$(asdf latest "$name")"
        fi
        printf "Current version for %s is %s and latest version is %s\n" "$name" "$current" "$latest"
        if [[ "$(dpkg --compare-versions "$latest" "gt" "$current")" -eq 0 ]]; then
            if asdf install "$latest" &>/dev/null; then
	        current="$(asdf current "$name" | sort | head -1 | awk '{ print $2 }')"
		asdf set "$name" "$current"
	    fi
        fi
    done < "$HOME/.tool-versions"
}

update
