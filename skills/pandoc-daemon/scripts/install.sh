#!/bin/bash
set -e

echo "Installing FGP Pandoc Daemon..." >&2

# Check for Pandoc
if ! command -v pandoc &> /dev/null; then
    echo "Error: Pandoc is required but not installed." >&2
    echo "Install with: brew install pandoc (macOS) or apt install pandoc (Linux)" >&2
    exit 1
fi

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-pandoc
    echo "Installed! Pandoc daemon ready." >&2
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/pandoc"

curl -fsSL "https://github.com/fast-gateway-protocol/pandoc/releases/latest/download/fgp-pandoc-${OS}-${ARCH}" -o "$BIN_DIR/fgp-pandoc"
chmod +x "$BIN_DIR/fgp-pandoc"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

# Get Pandoc version
PANDOC_VERSION=$(pandoc --version | head -1)

echo "Installed! Pandoc daemon ready." >&2
echo "{\"status\": \"installed\", \"pandoc_version\": \"$PANDOC_VERSION\"}"
