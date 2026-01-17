#!/bin/bash

# FGP Daemon Creator
# Usage: bash create.sh <daemon-name> [--template <template>]

set -e

DAEMON_NAME="${1:-my-daemon}"
TEMPLATE="minimal"

# Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        --template)
            TEMPLATE="$2"
            shift 2
            ;;
        *)
            if [ -z "$DAEMON_NAME" ] || [ "$DAEMON_NAME" = "my-daemon" ]; then
                DAEMON_NAME="$1"
            fi
            shift
            ;;
    esac
done

# Validate daemon name
if [[ ! "$DAEMON_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo "Error: Daemon name must be lowercase, start with a letter, and contain only letters, numbers, and hyphens" >&2
    exit 1
fi

echo "Creating FGP daemon: $DAEMON_NAME (template: $TEMPLATE)" >&2

# Create directory structure
mkdir -p "$DAEMON_NAME"/{src/handlers,scripts}

# Create Cargo.toml
cat > "$DAEMON_NAME/Cargo.toml" << EOF
[package]
name = "$DAEMON_NAME"
version = "0.1.0"
edition = "2021"

[dependencies]
fgp-daemon = "0.1"
tokio = { version = "1", features = ["full"] }
serde = { version = "1", features = ["derive"] }
serde_json = "1"
anyhow = "1"
clap = { version = "4", features = ["derive"] }
tracing = "0.1"
tracing-subscriber = "0.3"
EOF

# Create main.rs
cat > "$DAEMON_NAME/src/main.rs" << 'EOF'
use anyhow::Result;
use clap::{Parser, Subcommand};
use fgp_daemon::{FgpClient, FgpServer};
use serde_json::json;

mod service;
use service::MyService;

#[derive(Parser)]
#[command(name = env!("CARGO_PKG_NAME"))]
#[command(version, about)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Start the daemon
    Start,
    /// Stop the daemon
    Stop,
    /// Check daemon health
    Health,
    /// List available methods
    Methods,
    // TODO: Add your commands here
}

fn socket_path() -> String {
    let home = std::env::var("HOME").unwrap_or_else(|_| ".".to_string());
    format!("{}/.fgp/services/{}/daemon.sock", home, env!("CARGO_PKG_NAME"))
}

fn main() -> Result<()> {
    tracing_subscriber::fmt::init();

    let cli = Cli::parse();

    match cli.command {
        Commands::Start => {
            let service = MyService::new()?;
            let server = FgpServer::new(service, &socket_path())?;
            println!("Starting daemon at {}", socket_path());
            server.serve()?;
        }
        Commands::Stop => {
            let client = FgpClient::connect(&socket_path())?;
            client.call("stop", json!({}))?;
            println!("Daemon stopped");
        }
        Commands::Health => {
            let client = FgpClient::connect(&socket_path())?;
            let result = client.call("health", json!({}))?;
            println!("{}", serde_json::to_string_pretty(&result)?);
        }
        Commands::Methods => {
            let client = FgpClient::connect(&socket_path())?;
            let result = client.call("methods", json!({}))?;
            println!("{}", serde_json::to_string_pretty(&result)?);
        }
    }

    Ok(())
}
EOF

# Create service.rs
cat > "$DAEMON_NAME/src/service.rs" << 'EOF'
use anyhow::{bail, Result};
use fgp_daemon::FgpService;
use serde_json::{json, Value};
use std::collections::HashMap;

pub struct MyService {
    // TODO: Add your state here
}

impl MyService {
    pub fn new() -> Result<Self> {
        Ok(Self {
            // TODO: Initialize your state
        })
    }

    fn handle_hello(&self, params: HashMap<String, Value>) -> Result<Value> {
        let name = params
            .get("name")
            .and_then(|v| v.as_str())
            .unwrap_or("World");

        Ok(json!({
            "message": format!("Hello, {}!", name)
        }))
    }

    // TODO: Add more handlers
}

impl FgpService for MyService {
    fn name(&self) -> &str {
        env!("CARGO_PKG_NAME")
    }

    fn version(&self) -> &str {
        env!("CARGO_PKG_VERSION")
    }

    fn dispatch(&self, method: &str, params: HashMap<String, Value>) -> Result<Value> {
        // Strip service prefix if present
        let method = method.strip_prefix(&format!("{}.", self.name())).unwrap_or(method);

        match method {
            "hello" => self.handle_hello(params),
            // TODO: Add more method handlers
            _ => bail!("Unknown method: {}", method),
        }
    }

    fn method_list(&self) -> Vec<(&str, &str)> {
        vec![
            ("hello", "Say hello (params: name)"),
            // TODO: Add more methods
        ]
    }
}
EOF

# Create lib.rs
cat > "$DAEMON_NAME/src/lib.rs" << 'EOF'
pub mod service;
pub use service::MyService;
EOF

# Create handlers mod.rs
cat > "$DAEMON_NAME/src/handlers/mod.rs" << 'EOF'
// Add handler modules here
// pub mod my_handler;
EOF

# Create install script
cat > "$DAEMON_NAME/scripts/install.sh" << 'INSTALL_EOF'
#!/bin/bash
set -e

DAEMON_NAME="$(basename "$(dirname "$(dirname "$0")")")"

echo "Installing $DAEMON_NAME..." >&2

# Build
cargo build --release

# Create service directory
mkdir -p "$HOME/.fgp/services/$DAEMON_NAME"

# Copy binary
cp "target/release/$DAEMON_NAME" "$HOME/.fgp/bin/"

echo "Installed to ~/.fgp/bin/$DAEMON_NAME" >&2
echo "Start with: $DAEMON_NAME start" >&2
INSTALL_EOF

chmod +x "$DAEMON_NAME/scripts/install.sh"

# Create SKILL.md
cat > "$DAEMON_NAME/SKILL.md" << EOF
---
name: $DAEMON_NAME
description: Fast operations via FGP daemon. Use when user needs to [describe use case]. Triggers on "[trigger phrases]".
license: MIT
metadata:
  author: your-name
  version: "0.1.0"
  platforms: ["darwin", "linux"]
---

# $DAEMON_NAME

Description of what this daemon does.

## Installation

\`\`\`bash
brew install fast-gateway-protocol/tap/$DAEMON_NAME
\`\`\`

## Usage

\`\`\`bash
# Start daemon
$DAEMON_NAME start

# Call methods
$DAEMON_NAME hello --name "World"
\`\`\`

## Available Commands

| Command | Description |
|---------|-------------|
| \`hello\` | Say hello |

## Troubleshooting

### Daemon not running
\`\`\`
Error: Connection refused
\`\`\`
Start the daemon: \`$DAEMON_NAME start\`
EOF

# Create README
cat > "$DAEMON_NAME/README.md" << EOF
# $DAEMON_NAME

An FGP daemon for [description].

## Quick Start

\`\`\`bash
# Build
cargo build --release

# Start daemon
./target/release/$DAEMON_NAME start

# In another terminal, test it
./target/release/$DAEMON_NAME hello --name "World"
\`\`\`

## Development

\`\`\`bash
# Run tests
cargo test

# Run with logging
RUST_LOG=debug cargo run -- start
\`\`\`

## Protocol

Socket: \`~/.fgp/services/$DAEMON_NAME/daemon.sock\`

Test manually:
\`\`\`bash
echo '{"id":"1","v":1,"method":"hello","params":{"name":"Test"}}' | nc -U ~/.fgp/services/$DAEMON_NAME/daemon.sock
\`\`\`
EOF

# Create .gitignore
cat > "$DAEMON_NAME/.gitignore" << 'EOF'
/target
Cargo.lock
*.sock
EOF

echo "" >&2
echo "Created FGP daemon: $DAEMON_NAME" >&2
echo "" >&2
echo "Next steps:" >&2
echo "  cd $DAEMON_NAME" >&2
echo "  cargo build" >&2
echo "  ./target/debug/$DAEMON_NAME start" >&2
echo "" >&2

# Output JSON
echo "{\"name\": \"$DAEMON_NAME\", \"template\": \"$TEMPLATE\", \"path\": \"$(pwd)/$DAEMON_NAME\"}"
