#!/bin/bash

# FGP GitHub Daemon Installer
# Usage: bash install.sh

set -e

echo "Installing FGP GitHub Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    ARCH="arm64"
fi

if command -v brew &> /dev/null; then
    echo "Installing via Homebrew..." >&2
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-github

    echo "" >&2
    echo "Installation complete!" >&2
    echo "" >&2
    echo "Next steps:" >&2
    echo "1. Set GITHUB_TOKEN or run: fgp github auth" >&2
    echo "2. Try: fgp github repos" >&2
    exit 0
fi

echo "Homebrew not found. Installing manually..." >&2

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
SERVICE_DIR="$FGP_DIR/services/github"

mkdir -p "$BIN_DIR" "$SERVICE_DIR"

RELEASE_URL="https://github.com/fast-gateway-protocol/github/releases/latest/download/fgp-github-${OS}-${ARCH}"
echo "Downloading from $RELEASE_URL..." >&2

if command -v curl &> /dev/null; then
    curl -fsSL "$RELEASE_URL" -o "$BIN_DIR/fgp-github"
elif command -v wget &> /dev/null; then
    wget -q "$RELEASE_URL" -O "$BIN_DIR/fgp-github"
else
    echo "Error: curl or wget required" >&2
    exit 1
fi

chmod +x "$BIN_DIR/fgp-github"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    SHELL_RC="$HOME/.bashrc"
    if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    fi
    echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> "$SHELL_RC"
    export PATH="$BIN_DIR:$PATH"
fi

echo "" >&2
echo "Installation complete!" >&2
echo "" >&2
echo "Next steps:" >&2
echo "1. Set GITHUB_TOKEN environment variable" >&2
echo "   export GITHUB_TOKEN='ghp_xxxxxxxxxxxx'" >&2
echo "2. Try: fgp-github repos" >&2

echo '{"status": "installed", "binary": "'"$BIN_DIR/fgp-github"'", "requires_token": true}'
