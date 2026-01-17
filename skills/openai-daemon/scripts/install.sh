#!/bin/bash
set -e

echo "Installing FGP OpenAI Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-openai
    echo "Set OPENAI_API_KEY env var" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/openai"

curl -fsSL "https://github.com/fast-gateway-protocol/openai/releases/latest/download/fgp-openai-${OS}-${ARCH}" -o "$BIN_DIR/fgp-openai"
chmod +x "$BIN_DIR/fgp-openai"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set OPENAI_API_KEY env var" >&2
echo '{"status": "installed", "requires_key": true}'
