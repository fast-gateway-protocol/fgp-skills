#!/bin/bash
set -e

echo "Installing FGP Google Sheets Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-google-sheets
    echo "Run: fgp sheets auth" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/google-sheets"

curl -fsSL "https://github.com/fast-gateway-protocol/google-sheets/releases/latest/download/fgp-google-sheets-${OS}-${ARCH}" -o "$BIN_DIR/fgp-google-sheets"
chmod +x "$BIN_DIR/fgp-google-sheets"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Run: fgp sheets auth" >&2
echo '{"status": "installed", "requires_auth": true}'
