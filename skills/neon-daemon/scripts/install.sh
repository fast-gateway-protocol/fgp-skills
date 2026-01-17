#!/bin/bash
set -e

echo "Installing FGP Neon Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-neon
    echo "Set NEON_API_KEY or run: fgp neon auth" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/neon"

curl -fsSL "https://github.com/fast-gateway-protocol/neon/releases/latest/download/fgp-neon-${OS}-${ARCH}" -o "$BIN_DIR/fgp-neon"
chmod +x "$BIN_DIR/fgp-neon"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set NEON_API_KEY env var" >&2
echo '{"status": "installed", "requires_token": true}'
