#!/bin/bash
set -e
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" || "$ARCH" = "arm64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/fgp 2>/dev/null || true
    brew install fgp-docker
    exit 0
fi

INSTALL_DIR="${HOME}/.fgp/bin"
mkdir -p "$INSTALL_DIR"
VERSION="1.0.0"
curl -fsSL "https://github.com/fast-gateway-protocol/docker/releases/download/v${VERSION}/fgp-docker-${OS}-${ARCH}.tar.gz" | tar -xz -C "$INSTALL_DIR"
chmod +x "$INSTALL_DIR/fgp-docker"
