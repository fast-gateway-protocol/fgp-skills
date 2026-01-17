#!/bin/bash
set -e

echo "Installing FGP Resend Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-resend
    echo "Set RESEND_API_KEY env var" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/resend"

curl -fsSL "https://github.com/fast-gateway-protocol/resend/releases/latest/download/fgp-resend-${OS}-${ARCH}" -o "$BIN_DIR/fgp-resend"
chmod +x "$BIN_DIR/fgp-resend"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set RESEND_API_KEY env var" >&2
echo '{"status": "installed", "requires_key": true}'
