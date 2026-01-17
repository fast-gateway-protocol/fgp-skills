#!/bin/bash
set -e

echo "Installing FGP Stripe Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-stripe
    echo "Set STRIPE_SECRET_KEY env var" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/stripe"

curl -fsSL "https://github.com/fast-gateway-protocol/stripe/releases/latest/download/fgp-stripe-${OS}-${ARCH}" -o "$BIN_DIR/fgp-stripe"
chmod +x "$BIN_DIR/fgp-stripe"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set STRIPE_SECRET_KEY env var" >&2
echo '{"status": "installed", "requires_key": true}'
