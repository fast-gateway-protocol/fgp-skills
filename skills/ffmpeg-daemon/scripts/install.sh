#!/bin/bash
set -e

echo "Installing FGP FFmpeg Daemon..." >&2

# Check for ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is required but not installed." >&2
    echo "Install with: brew install ffmpeg (macOS) or apt install ffmpeg (Linux)" >&2
    exit 1
fi

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-ffmpeg
    echo "Installed! FFmpeg daemon ready." >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/ffmpeg"

curl -fsSL "https://github.com/fast-gateway-protocol/ffmpeg/releases/latest/download/fgp-ffmpeg-${OS}-${ARCH}" -o "$BIN_DIR/fgp-ffmpeg"
chmod +x "$BIN_DIR/fgp-ffmpeg"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! FFmpeg daemon ready." >&2
echo '{"status": "installed", "ffmpeg_version": "'$(ffmpeg -version | head -1)'"}'
