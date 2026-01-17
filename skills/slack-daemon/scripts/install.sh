#!/bin/bash
set -e

echo "Installing FGP Slack Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-slack
    echo "Next: fgp slack auth" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/slack"

curl -fsSL "https://github.com/fast-gateway-protocol/slack/releases/latest/download/fgp-slack-${OS}-${ARCH}" -o "$BIN_DIR/fgp-slack"
chmod +x "$BIN_DIR/fgp-slack"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Run: fgp slack auth" >&2
echo '{"status": "installed", "requires_auth": true}'
