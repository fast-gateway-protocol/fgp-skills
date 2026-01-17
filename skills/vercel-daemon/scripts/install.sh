#!/bin/bash
set -e

echo "Installing FGP Vercel Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-vercel
    echo "Set VERCEL_TOKEN or run: fgp vercel auth" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/vercel"

curl -fsSL "https://github.com/fast-gateway-protocol/vercel/releases/latest/download/fgp-vercel-${OS}-${ARCH}" -o "$BIN_DIR/fgp-vercel"
chmod +x "$BIN_DIR/fgp-vercel"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set VERCEL_TOKEN env var" >&2
echo '{"status": "installed", "requires_token": true}'
