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
  brew install fgp-postmark
else
  echo "Installing fgp-postmark for $OS-$ARCH..."
  curl -sSL "https://github.com/fast-gateway-protocol/postmark/releases/download/v1.0.0/fgp-postmark-$OS-$ARCH.tar.gz" | tar xz -C /usr/local/bin
fi

echo "fgp-postmark installed successfully!"
