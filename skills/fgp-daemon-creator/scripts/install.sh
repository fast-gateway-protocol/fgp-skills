#!/bin/bash
set -e

# FGP Daemon Creator - Install Script
# Sets up the daemon creation tooling

echo "Installing FGP Daemon Creator..." >&2

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Create FGP bin directory if it doesn't exist
mkdir -p "$HOME/.fgp/bin"

# Create the fgp-new command wrapper
cat > "$HOME/.fgp/bin/fgp-new" << EOF
#!/bin/bash
# FGP Daemon Creator - Create new FGP daemon projects
# Usage: fgp-new <daemon-name> [--template <template>]
exec bash "$SKILL_DIR/scripts/create.sh" "\$@"
EOF

chmod +x "$HOME/.fgp/bin/fgp-new"

# Add alias for 'fgp new' if ~/.fgp/bin is in PATH
echo "" >&2
echo "Installed FGP Daemon Creator" >&2
echo "" >&2
echo "Usage:" >&2
echo "  fgp-new my-daemon              # Create with minimal template" >&2
echo "  fgp-new my-daemon --template api-integration" >&2
echo "" >&2
echo "Available templates:" >&2
echo "  - minimal         Bare-bones daemon" >&2
echo "  - api-integration REST/GraphQL wrapper" >&2
echo "  - database        SQLite/Postgres daemon" >&2
echo "  - macos-native    macOS frameworks" >&2
echo "  - browser         Chrome DevTools Protocol" >&2
echo "" >&2

# Check if ~/.fgp/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.fgp/bin:"* ]]; then
    echo "NOTE: Add ~/.fgp/bin to your PATH:" >&2
    echo "  export PATH=\"\$HOME/.fgp/bin:\$PATH\"" >&2
    echo "" >&2
fi

# Output JSON for programmatic use
echo '{"status": "installed", "binary": "'"$HOME/.fgp/bin/fgp-new"'"}'
