#!/usr/bin/env bash
#shellcheck shell=bash
set -euo pipefail

# Parse arguments
VERBOSE=0
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-v|--verbose]"
            exit 1
            ;;
    esac
done

# Function to run commands with optional output
run_cmd() {
    if [[ $VERBOSE -eq 1 ]]; then
        "$@"
    else
        "$@" >/dev/null 2>&1
    fi
}

# This script should be run by the user on first login to complete dotfiles setup

echo "Starting dotfiles setup..."

# Install/Update dotfiles
if [[ -x "$HOME/.local/bin/update-dotfiles.sh" ]]; then
    echo "Updating dotfiles repository..."
    run_cmd "$HOME/.local/bin/update-dotfiles.sh"
    echo "✓ Dotfiles repository updated"
else
    echo "✗ Error: update-dotfiles.sh not found or not executable"
    exit 1
fi

# Setup tuckr and mise
echo "Setting up mise and tuckr..."
if command -v mise &>/dev/null; then
    run_cmd eval "$(mise activate bash)"
    run_cmd mise use -g rust
    if command -v cargo &>/dev/null; then
        run_cmd cargo install tuckr
        echo "✓ Tuckr installed"
    else
        echo "✗ Error: cargo not available after installing rust"
        exit 1
    fi
    echo "✓ Mise and Rust configured"
else
    echo "✗ Error: mise not found in PATH"
    exit 1
fi

# Configure dotfiles with tuckr
if [[ -d "$HOME/.config/dotfiles" ]]; then
    pushd "$HOME/.config/dotfiles" &>/dev/null
    if command -v tuckr &>/dev/null; then
        run_cmd tuckr set \* -f
        echo "✓ Dotfiles configured with tuckr"
    else
        echo "✗ Error: tuckr not found after installation"
        popd &>/dev/null
        exit 1
    fi
    popd &>/dev/null
else
    echo "✗ Error: dotfiles directory not found"
    exit 1
fi

# Install tools with mise
echo "Installing tools with mise..."
run_cmd mise install
echo "✓ Tools installed with mise"

# Set Python alternatives to use mise-installed Python
echo "Setting Python alternatives..."
run_cmd sudo update-alternatives --install /usr/bin/python python "$HOME/.local/share/mise/shims/python" 1
run_cmd sudo update-alternatives --install /usr/bin/python3 python3 "$HOME/.local/share/mise/shims/python3" 1
run_cmd sudo update-alternatives --set python "$HOME/.local/share/mise/shims/python"
run_cmd sudo update-alternatives --set python3 "$HOME/.local/share/mise/shims/python3"
echo "✓ Python alternatives set"

echo "✓ Dotfiles setup complete!"
echo "Please restart your shell to apply changes."
