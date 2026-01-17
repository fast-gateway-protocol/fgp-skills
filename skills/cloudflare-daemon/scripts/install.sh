#!/bin/bash
set -e

echo "Installing FGP Cloudflare Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-cloudflare
    echo "Set CLOUDFLARE_API_TOKEN and run: fgp cf zones" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/cloudflare"

curl -fsSL "https://github.com/fast-gateway-protocol/cloudflare/releases/latest/download/fgp-cloudflare-${OS}-${ARCH}" -o "$BIN_DIR/fgp-cloudflare"
chmod +x "$BIN_DIR/fgp-cloudflare"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set CLOUDFLARE_API_TOKEN env var" >&2
echo '{"status": "installed", "requires_token": true}'
