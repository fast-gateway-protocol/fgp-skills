#!/bin/bash
set -e

echo "Installing FGP Calendar Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    echo "Installing via Homebrew..." >&2
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-calendar
    echo "" >&2
    echo "Next: fgp calendar auth" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/calendar"

RELEASE_URL="https://github.com/fast-gateway-protocol/calendar/releases/latest/download/fgp-calendar-${OS}-${ARCH}"
curl -fsSL "$RELEASE_URL" -o "$BIN_DIR/fgp-calendar"
chmod +x "$BIN_DIR/fgp-calendar"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Run: fgp calendar auth" >&2
echo '{"status": "installed", "requires_auth": true}'
