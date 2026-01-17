#!/bin/bash
set -e

echo "Installing FGP SQLite Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-sqlite
    echo "Installed! SQLite daemon ready." >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/sqlite"

curl -fsSL "https://github.com/fast-gateway-protocol/sqlite/releases/latest/download/fgp-sqlite-${OS}-${ARCH}" -o "$BIN_DIR/fgp-sqlite"
chmod +x "$BIN_DIR/fgp-sqlite"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

# Get SQLite version from system (for info)
SQLITE_VERSION=$(sqlite3 --version 2>/dev/null | head -1 || echo "bundled")

echo "Installed! SQLite daemon ready." >&2
echo "{\"status\": \"installed\", \"sqlite_version\": \"$SQLITE_VERSION\"}"
