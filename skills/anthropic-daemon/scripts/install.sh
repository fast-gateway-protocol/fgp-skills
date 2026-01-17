#!/bin/bash
set -e

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" || "$ARCH" = "arm64" ]] && ARCH="arm64"

echo "Installing fgp-anthropic for $OS/$ARCH..."

# Try Homebrew first (macOS/Linux)
if command -v brew &> /dev/null; then
    echo "Using Homebrew..."
    brew tap fast-gateway-protocol/fgp 2>/dev/null || true
    brew install fgp-anthropic
    exit 0
fi

# Manual installation
INSTALL_DIR="${HOME}/.fgp/bin"
mkdir -p "$INSTALL_DIR"

VERSION="1.0.0"
URL="https://github.com/fast-gateway-protocol/anthropic/releases/download/v${VERSION}/fgp-anthropic-${OS}-${ARCH}.tar.gz"

echo "Downloading from $URL..."
curl -fsSL "$URL" | tar -xz -C "$INSTALL_DIR"
chmod +x "$INSTALL_DIR/fgp-anthropic"

echo "Installed to $INSTALL_DIR/fgp-anthropic"
echo "Add to PATH: export PATH=\"\$PATH:$INSTALL_DIR\""
