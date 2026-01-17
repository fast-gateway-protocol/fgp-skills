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
  brew install fgp-asana
else
  echo "Installing fgp-asana for $OS-$ARCH..."
  curl -sSL "https://github.com/fast-gateway-protocol/asana/releases/download/v1.0.0/fgp-asana-$OS-$ARCH.tar.gz" | tar xz -C /usr/local/bin
fi

echo "fgp-asana installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Set ASANA_ACCESS_TOKEN environment variable"
echo "  2. Run: fgp start asana"
echo "  3. Test: fgp call asana.list_workspaces"
