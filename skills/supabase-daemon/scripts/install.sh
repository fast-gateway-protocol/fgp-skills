#!/bin/bash
set -e

echo "Installing FGP Supabase Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-supabase
    echo "Set SUPABASE_URL and SUPABASE_KEY env vars" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/supabase"

curl -fsSL "https://github.com/fast-gateway-protocol/supabase/releases/latest/download/fgp-supabase-${OS}-${ARCH}" -o "$BIN_DIR/fgp-supabase"
chmod +x "$BIN_DIR/fgp-supabase"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set SUPABASE_URL and SUPABASE_KEY" >&2
echo '{"status": "installed", "requires_config": true}'
