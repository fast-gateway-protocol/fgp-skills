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
  brew install fgp-ollama
else
  echo "Installing fgp-ollama for $OS-$ARCH..."
  curl -sSL "https://github.com/fast-gateway-protocol/ollama/releases/download/v1.0.0/fgp-ollama-$OS-$ARCH.tar.gz" | tar xz -C /usr/local/bin
fi

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
  echo ""
  echo "WARNING: Ollama is not installed."
  echo "Install it with: curl -fsSL https://ollama.ai/install.sh | sh"
fi

echo "fgp-ollama installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Ensure Ollama is running: ollama serve"
echo "  2. Run: fgp start ollama"
echo "  3. Pull a model: fgp call ollama.pull --model llama3.2"
echo "  4. Test: fgp call ollama.chat --model llama3.2 --messages '[{\"role\":\"user\",\"content\":\"Hello!\"}]'"
