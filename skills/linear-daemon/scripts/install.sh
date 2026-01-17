#!/bin/bash
set -e

echo "Installing FGP Linear Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-linear
    echo "Set LINEAR_API_KEY and run: fgp linear start" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/linear"

curl -fsSL "https://github.com/fast-gateway-protocol/linear/releases/latest/download/fgp-linear-${OS}-${ARCH}" -o "$BIN_DIR/fgp-linear"
chmod +x "$BIN_DIR/fgp-linear"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set LINEAR_API_KEY env var" >&2
echo '{"status": "installed", "requires_token": true}'
