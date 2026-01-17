#!/bin/bash
set -e

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" || "$ARCH" = "arm64" ]] && ARCH="arm64"

echo "Installing fgp-aws for $OS/$ARCH..."

if command -v brew &> /dev/null; then
    echo "Using Homebrew..."
    brew tap fast-gateway-protocol/fgp 2>/dev/null || true
    brew install fgp-aws
    exit 0
fi

INSTALL_DIR="${HOME}/.fgp/bin"
mkdir -p "$INSTALL_DIR"

VERSION="1.0.0"
URL="https://github.com/fast-gateway-protocol/aws/releases/download/v${VERSION}/fgp-aws-${OS}-${ARCH}.tar.gz"

curl -fsSL "$URL" | tar -xz -C "$INSTALL_DIR"
chmod +x "$INSTALL_DIR/fgp-aws"

echo "Installed to $INSTALL_DIR/fgp-aws"
