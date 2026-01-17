#!/bin/bash
set -e

echo "Installing FGP yt-dlp Daemon..." >&2

# Check for yt-dlp
if ! command -v yt-dlp &> /dev/null; then
    echo "Error: yt-dlp is required but not installed." >&2
    echo "Install with: brew install yt-dlp (macOS) or pip install yt-dlp" >&2
    exit 1
fi

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-ytdlp
    echo "Installed! yt-dlp daemon ready." >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/ytdlp"

curl -fsSL "https://github.com/fast-gateway-protocol/ytdlp/releases/latest/download/fgp-ytdlp-${OS}-${ARCH}" -o "$BIN_DIR/fgp-ytdlp"
chmod +x "$BIN_DIR/fgp-ytdlp"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

# Get yt-dlp version
YTDLP_VERSION=$(yt-dlp --version)

echo "Installed! yt-dlp daemon ready." >&2
echo "{\"status\": \"installed\", \"ytdlp_version\": \"$YTDLP_VERSION\"}"
