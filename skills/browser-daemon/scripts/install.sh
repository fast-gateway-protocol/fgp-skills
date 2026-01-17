#!/bin/bash

# FGP Browser Daemon Installer
# Usage: bash install.sh

set -e

echo "Installing FGP Browser Daemon..." >&2

# Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    ARCH="arm64"
fi

# Check if Homebrew is available (preferred method)
if command -v brew &> /dev/null; then
    echo "Installing via Homebrew..." >&2
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-browser

    echo "" >&2
    echo "Installation complete!" >&2
    echo "" >&2
    echo "Start the daemon with: fgp browser start" >&2
    echo "Verify with: fgp browser health" >&2
    exit 0
fi

# Manual installation
echo "Homebrew not found. Installing manually..." >&2

# Create directories
FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
SERVICE_DIR="$FGP_DIR/services/browser"

mkdir -p "$BIN_DIR" "$SERVICE_DIR"

# Download binary
RELEASE_URL="https://github.com/fast-gateway-protocol/browser/releases/latest/download/fgp-browser-${OS}-${ARCH}"
echo "Downloading from $RELEASE_URL..." >&2

if command -v curl &> /dev/null; then
    curl -fsSL "$RELEASE_URL" -o "$BIN_DIR/fgp-browser"
elif command -v wget &> /dev/null; then
    wget -q "$RELEASE_URL" -O "$BIN_DIR/fgp-browser"
else
    echo "Error: curl or wget required" >&2
    exit 1
fi

chmod +x "$BIN_DIR/fgp-browser"

# Add to PATH if not already
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    SHELL_RC="$HOME/.bashrc"
    if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    fi

    echo "" >> "$SHELL_RC"
    echo "# FGP (Fast Gateway Protocol)" >> "$SHELL_RC"
    echo "export PATH=\"\$HOME/.fgp/bin:\$PATH\"" >> "$SHELL_RC"

    echo "Added $BIN_DIR to PATH in $SHELL_RC" >&2
    export PATH="$BIN_DIR:$PATH"
fi

# Start daemon
echo "Starting daemon..." >&2
"$BIN_DIR/fgp-browser" start &

sleep 1

# Verify
if "$BIN_DIR/fgp-browser" health &>/dev/null; then
    echo "" >&2
    echo "Installation complete!" >&2
    echo "" >&2
    echo "FGP Browser daemon is running." >&2
    echo "Try: fgp-browser open 'https://example.com'" >&2

    # Output JSON for programmatic use
    echo '{"status": "installed", "binary": "'"$BIN_DIR/fgp-browser"'", "socket": "'"$SERVICE_DIR/daemon.sock"'"}'
else
    echo "Warning: Daemon may not have started. Run: fgp-browser start" >&2
    echo '{"status": "installed", "binary": "'"$BIN_DIR/fgp-browser"'", "daemon_running": false}'
fi
