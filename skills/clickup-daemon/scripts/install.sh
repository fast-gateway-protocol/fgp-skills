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
  brew install fgp-clickup
else
  echo "Installing fgp-clickup for $OS-$ARCH..."
  curl -sSL "https://github.com/fast-gateway-protocol/clickup/releases/download/v1.0.0/fgp-clickup-$OS-$ARCH.tar.gz" | tar xz -C /usr/local/bin
fi

echo "fgp-clickup installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Set CLICKUP_API_TOKEN environment variable"
echo "  2. Run: fgp start clickup"
echo "  3. Test: fgp call clickup.list_workspaces"
