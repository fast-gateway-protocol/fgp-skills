#!/bin/bash

# FGP iMessage Daemon Installer (macOS only)
# Usage: bash install.sh

set -e

# Check macOS
if [ "$(uname -s)" != "Darwin" ]; then
    echo "Error: FGP iMessage is macOS only" >&2
    exit 1
fi

echo "Installing FGP iMessage Daemon..." >&2

ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" = "arm64" ]; then
    ARCH="arm64"
fi

if command -v brew &> /dev/null; then
    echo "Installing via Homebrew..." >&2
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-imessage

    echo "" >&2
    echo "Installation complete!" >&2
    echo "" >&2
    echo "IMPORTANT: Grant Full Disk Access" >&2
    echo "1. Open System Preferences > Security & Privacy > Privacy" >&2
    echo "2. Select 'Full Disk Access'" >&2
    echo "3. Add your terminal app" >&2
    echo "4. Restart terminal" >&2
    echo "" >&2
    echo "Then try: fgp imessage recent" >&2
    exit 0
fi

echo "Homebrew not found. Installing manually..." >&2

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
SERVICE_DIR="$FGP_DIR/services/imessage"

mkdir -p "$BIN_DIR" "$SERVICE_DIR"

RELEASE_URL="https://github.com/fast-gateway-protocol/imessage/releases/latest/download/fgp-imessage-darwin-${ARCH}"
echo "Downloading from $RELEASE_URL..." >&2

curl -fsSL "$RELEASE_URL" -o "$BIN_DIR/fgp-imessage"
chmod +x "$BIN_DIR/fgp-imessage"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    SHELL_RC="$HOME/.zshrc"
    echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> "$SHELL_RC"
    export PATH="$BIN_DIR:$PATH"
fi

# Check Full Disk Access
echo "" >&2
echo "Checking permissions..." >&2

if [ -r "$HOME/Library/Messages/chat.db" ]; then
    echo "Full Disk Access: OK" >&2
else
    echo "" >&2
    echo "WARNING: Full Disk Access not granted" >&2
    echo "" >&2
    echo "To enable:" >&2
    echo "1. Open System Preferences > Security & Privacy > Privacy" >&2
    echo "2. Select 'Full Disk Access'" >&2
    echo "3. Add your terminal app" >&2
    echo "4. Restart terminal" >&2
fi

echo "" >&2
echo "Installation complete!" >&2
echo "Try: fgp-imessage recent" >&2

echo '{"status": "installed", "binary": "'"$BIN_DIR/fgp-imessage"'", "platform": "darwin"}'
