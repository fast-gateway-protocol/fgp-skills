#!/bin/bash
set -e

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64) ARCH="x64" ;;
  aarch64|arm64) ARCH="arm64" ;;
esac

if command -v brew &> /dev/null; then
  brew tap fast-gateway-protocol/fgp 2>/dev/null || true
  brew install fgp-intercom
else
  echo "Installing fgp-intercom for $OS-$ARCH..."
  curl -sSL "https://github.com/fast-gateway-protocol/intercom/releases/download/v1.0.0/fgp-intercom-$OS-$ARCH.tar.gz" | tar xz -C /usr/local/bin
fi

echo "fgp-intercom installed successfully!"
