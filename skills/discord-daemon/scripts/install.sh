#!/bin/bash
set -e

echo "Installing FGP Discord Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-discord
    echo "Set DISCORD_BOT_TOKEN and run: fgp discord start" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/discord"

curl -fsSL "https://github.com/fast-gateway-protocol/discord/releases/latest/download/fgp-discord-${OS}-${ARCH}" -o "$BIN_DIR/fgp-discord"
chmod +x "$BIN_DIR/fgp-discord"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set DISCORD_BOT_TOKEN env var" >&2
echo '{"status": "installed", "requires_token": true}'
