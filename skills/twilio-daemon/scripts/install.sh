#!/bin/bash
set -e

echo "Installing FGP Twilio Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-twilio
    echo "Set TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/twilio"

curl -fsSL "https://github.com/fast-gateway-protocol/twilio/releases/latest/download/fgp-twilio-${OS}-${ARCH}" -o "$BIN_DIR/fgp-twilio"
chmod +x "$BIN_DIR/fgp-twilio"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN" >&2
echo '{"status": "installed", "requires_config": true}'
