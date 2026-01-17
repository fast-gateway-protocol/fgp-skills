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
  brew install fgp-trello
else
  echo "Installing fgp-trello for $OS-$ARCH..."
  curl -sSL "https://github.com/fast-gateway-protocol/trello/releases/download/v1.0.0/fgp-trello-$OS-$ARCH.tar.gz" | tar xz -C /usr/local/bin
fi

echo "fgp-trello installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Set TRELLO_API_KEY and TRELLO_TOKEN environment variables"
echo "  2. Run: fgp start trello"
echo "  3. Test: fgp call trello.list_boards"
