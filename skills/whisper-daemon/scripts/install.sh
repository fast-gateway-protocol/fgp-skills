#!/bin/bash
set -e

echo "Installing FGP Whisper Daemon..." >&2

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" = "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" = "aarch64" ]] && ARCH="arm64"

# Check for whisper backend
WHISPER_BACKEND=""
if command -v whisper-cpp &> /dev/null || command -v whisper &> /dev/null; then
    WHISPER_BACKEND="whisper-cpp"
elif python3 -c "import whisper" 2>/dev/null; then
    WHISPER_BACKEND="openai-whisper"
fi

if command -v brew &> /dev/null; then
    brew tap fast-gateway-protocol/tap 2>/dev/null || true
    brew install fgp-whisper

    if [ -z "$WHISPER_BACKEND" ]; then
        echo "Note: Install whisper backend for local inference:" >&2
        echo "  brew install whisper-cpp (recommended)" >&2
        echo "  pip install openai-whisper (alternative)" >&2
        echo "Or set OPENAI_API_KEY for API-based transcription" >&2
    fi
    exit 0
fi

FGP_DIR="$HOME/.fgp"
BIN_DIR="$FGP_DIR/bin"
mkdir -p "$BIN_DIR" "$FGP_DIR/services/whisper" "$FGP_DIR/models/whisper"

curl -fsSL "https://github.com/fast-gateway-protocol/whisper/releases/latest/download/fgp-whisper-${OS}-${ARCH}" -o "$BIN_DIR/fgp-whisper"
chmod +x "$BIN_DIR/fgp-whisper"

[[ ":$PATH:" != *":$BIN_DIR:"* ]] && echo 'export PATH="$HOME/.fgp/bin:$PATH"' >> ~/.zshrc

echo "Installed! Whisper daemon ready." >&2
if [ -z "$WHISPER_BACKEND" ]; then
    echo "Note: Install whisper backend: pip install openai-whisper" >&2
fi
echo "{\"status\": \"installed\", \"backend\": \"$WHISPER_BACKEND\"}"
