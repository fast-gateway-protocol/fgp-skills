#!/bin/bash
set -e

if [ "$(uname -s)" != "Darwin" ]; then
    echo "Error: FGP Screen Time is macOS only" >&2
    exit 1
fi

echo "Installing FGP Screen Time Daemon..." >&2

ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-screen-time
    echo "" >&2
    echo "IMPORTANT: Grant Full Disk Access to your terminal" >&2
    echo "System Preferences > Security & Privacy > Privacy > Full Disk Access" >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/screen-time"

curl -fsSL "https://github.com/fast-gateway-protocol/screen-time/releases/latest/download/fgp-screen-time-darwin-${ARCH}" -o "$BIN_DIR/fgp-screen-time"
chmod +x "$BIN_DIR/fgp-screen-time"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

# Check permissions
DB_PATH="/private/var/db/CoreDuet/Knowledge/knowledgeC.db"
if [ -r "$DB_PATH" ]; then
    echo "Full Disk Access: OK" >&2
else
    echo "" >&2
    echo "WARNING: Grant Full Disk Access to your terminal" >&2
    echo "System Preferences > Security & Privacy > Privacy > Full Disk Access" >&2
fi

echo '{"status": "installed", "platform": "darwin"}'
