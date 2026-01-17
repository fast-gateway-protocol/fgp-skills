#!/bin/bash
set -e

echo "Installing FGP Fly Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-fly
    echo "Run: fgp fly auth --from-flyctl" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/fly"

curl -fsSL "https://github.com/fast-gateway-protocol/fly/releases/latest/download/fgp-fly-${OS}-${ARCH}" -o "$BIN_DIR/fgp-fly"
chmod +x "$BIN_DIR/fgp-fly"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Run: fgp fly auth --from-flyctl" >&2
echo '{"status": "installed", "requires_auth": true}'
