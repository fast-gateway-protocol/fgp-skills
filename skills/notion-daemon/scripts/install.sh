#!/bin/bash
set -e

echo "Installing FGP Notion Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-notion
    echo "Set NOTION_TOKEN and run: fgp notion start" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/notion"

curl -fsSL "https://github.com/fast-gateway-protocol/notion/releases/latest/download/fgp-notion-${OS}-${ARCH}" -o "$BIN_DIR/fgp-notion"
chmod +x "$BIN_DIR/fgp-notion"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set NOTION_TOKEN env var" >&2
echo '{"status": "installed", "requires_token": true}'
