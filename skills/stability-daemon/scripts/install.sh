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
  brew install fgp-stability
else
  echo "Installing fgp-stability for $OS-$ARCH..."
  curl -sSL "https://github.com/fast-gateway-protocol/stability/releases/download/v1.0.0/fgp-stability-$OS-$ARCH.tar.gz" | tar xz -C /usr/local/bin
fi

echo "fgp-stability installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Set STABILITY_API_KEY environment variable"
echo "  2. Run: fgp start stability"
echo "  3. Test: fgp call stability.generate --prompt 'A sunset' --output /tmp/sunset.png"
