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
  brew install fgp-huggingface
else
  echo "Installing fgp-huggingface for $OS-$ARCH..."
  curl -sSL "https://github.com/fast-gateway-protocol/huggingface/releases/download/v1.0.0/fgp-huggingface-$OS-$ARCH.tar.gz" | tar xz -C /usr/local/bin
fi

echo "fgp-huggingface installed successfully!"
echo ""
echo "Next steps:"
echo "  1. (Optional) Set HF_API_TOKEN for private models"
echo "  2. Run: fgp start huggingface"
echo "  3. Test: fgp call huggingface.embed --model sentence-transformers/all-MiniLM-L6-v2 --inputs 'Hello world'"
