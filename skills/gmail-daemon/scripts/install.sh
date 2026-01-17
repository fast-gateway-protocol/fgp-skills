#!/bin/bash

# FGP Gmail Daemon Installer
# Usage: bash install.sh

set -e

echo "Installing FGP Gmail Daemon..." >&2

# Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    ARCH="arm64"
fi

# Check if Homebrew is available
if command -v brew &> /dev/null; then
    echo "Installing via Homebrew..." >&2
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-gmail

    echo "" >&2
    echo "Installation complete!" >&2
    echo "" >&2
    echo "Next steps:" >&2
    echo "1. Run: fgp gmail auth" >&2
    echo "2. Complete OAuth in browser" >&2
    echo "3. Try: fgp gmail list --unread" >&2
    exit 0
fi

# Manual installation
echo "Homebrew not found. Installing manually..." >&2

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
SERVICE_DIR="$FGP_DIR/services/gmail"

mkdir -p "$BIN_DIR" "$SERVICE_DIR"

RELEASE_URL="https://github.com/fast-gateway-protocol/gmail/releases/latest/download/fgp-gmail-${OS}-${ARCH}"
echo "Downloading from $RELEASE_URL..." >&2

if command -v curl &> /dev/null; then
    curl -fsSL "$RELEASE_URL" -o "$BIN_DIR/fgp-gmail"
elif command -v wget &> /dev/null; then
    wget -q "$RELEASE_URL" -O "$BIN_DIR/fgp-gmail"
else
    echo "Error: curl or wget required" >&2
    exit 1
fi

chmod +x "$BIN_DIR/fgp-gmail"

# Add to PATH if needed
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
echo "1. Run: $BIN_DIR/fgp-gmail auth" >&2
echo "2. Complete OAuth in browser" >&2
echo "3. Try: fgp-gmail list --unread" >&2

echo '{"status": "installed", "binary": "'"$BIN_DIR/fgp-gmail"'", "requires_auth": true}'
