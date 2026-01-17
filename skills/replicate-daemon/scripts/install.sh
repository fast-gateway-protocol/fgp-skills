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
  brew install fgp-replicate
else
  echo "Installing fgp-replicate for $OS-$ARCH..."
  curl -sSL "https://github.com/fast-gateway-protocol/replicate/releases/download/v1.0.0/fgp-replicate-$OS-$ARCH.tar.gz" | tar xz -C /usr/local/bin
fi

echo "fgp-replicate installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Set REPLICATE_API_TOKEN environment variable"
echo "  2. Run: fgp start replicate"
echo "  3. Test: fgp call replicate.run --model stability-ai/sdxl --input '{\"prompt\":\"A sunset\"}'"
