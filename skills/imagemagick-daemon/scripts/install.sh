#!/bin/bash
set -e

echo "Installing FGP ImageMagick Daemon..." >&2

# Check for ImageMagick
if ! command -v magick &> /dev/null && ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is required but not installed." >&2
    echo "Install with: brew install imagemagick (macOS) or apt install imagemagick (Linux)" >&2
    exit 1
fi

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-imagemagick
    echo "Installed! ImageMagick daemon ready." >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/imagemagick"

curl -fsSL "https://github.com/fast-gateway-protocol/imagemagick/releases/latest/download/fgp-imagemagick-${OS}-${ARCH}" -o "$BIN_DIR/fgp-imagemagick"
chmod +x "$BIN_DIR/fgp-imagemagick"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

# Get ImageMagick version
IM_VERSION=$(magick --version 2>/dev/null | head -1 || convert --version 2>/dev/null | head -1)

echo "Installed! ImageMagick daemon ready." >&2
echo "{\"status\": \"installed\", \"imagemagick_version\": \"$IM_VERSION\"}"
