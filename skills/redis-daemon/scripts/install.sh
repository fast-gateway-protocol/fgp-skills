#!/bin/bash
set -e

echo "Installing FGP Redis Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-redis
    echo "Installed! Set REDIS_URL or use default localhost:6379" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/redis"

curl -fsSL "https://github.com/fast-gateway-protocol/redis/releases/latest/download/fgp-redis-${OS}-${ARCH}" -o "$BIN_DIR/fgp-redis"
chmod +x "$BIN_DIR/fgp-redis"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Set REDIS_URL or use default localhost:6379" >&2
echo '{"status": "installed", "default_url": "redis://localhost:6379"}'
