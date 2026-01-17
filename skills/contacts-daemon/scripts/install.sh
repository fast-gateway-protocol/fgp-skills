#!/bin/bash
set -e

if [ "$(uname -s)" != "Darwin" ]; then
    echo "Error: FGP Contacts is macOS only" >&2
    exit 1
fi

echo "Installing FGP Contacts Daemon..." >&2

ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-contacts
    echo "On first run, grant Contacts access when prompted" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/contacts"

curl -fsSL "https://github.com/fast-gateway-protocol/contacts/releases/latest/download/fgp-contacts-darwin-${ARCH}" -o "$BIN_DIR/fgp-contacts"
chmod +x "$BIN_DIR/fgp-contacts"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! On first run, grant Contacts access when prompted" >&2
echo '{"status": "installed", "platform": "darwin"}'
