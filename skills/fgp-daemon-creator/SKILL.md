---
name: fgp-daemon-creator
description: Create new FGP daemons from templates. Use when user wants to build a custom FGP daemon, create a new integration, or scaffold a daemon project. Triggers on "create FGP daemon", "new daemon", "build integration", "scaffold FGP".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP Daemon Creator

Scaffold new FGP daemons with best practices baked in. Create production-ready daemons in minutes.

## What is FGP?

FGP (Fast Gateway Protocol) is a daemon-based architecture that replaces slow MCP stdio servers with persistent UNIX socket daemons. Daemons stay warm across sessions, eliminating cold-start latency.

**Key benefits:**
- **10-100x faster** than MCP for most operations
- **Sub-10ms latency** for tool calls
- **No cold start** - daemon runs persistently
- **Simple protocol** - NDJSON over UNIX sockets

## Quick Start

```bash
# Create new daemon project
fgp new my-daemon

# Or with template
fgp new my-daemon --template api-integration

# Navigate to project
cd my-daemon

# Build
cargo build --release

# Run
./target/release/my-daemon start
```

## Available Templates

| Template | Description | Use Case |
|----------|-------------|----------|
| `minimal` | Bare-bones daemon | Learning, simple tools |
| `api-integration` | REST/GraphQL API wrapper | SaaS integrations |
| `database` | Database query daemon | SQLite, Postgres |
| `macos-native` | macOS frameworks | Contacts, Calendar |
| `browser` | Chrome DevTools Protocol | Web automation |

## Project Structure

```
my-daemon/
├── Cargo.toml           # Rust dependencies
├── src/
│   ├── main.rs          # CLI entry point
│   ├── service.rs       # FgpService implementation
│   ├── handlers/        # Method handlers
│   │   ├── mod.rs
│   │   └── my_method.rs
│   └── lib.rs           # Library exports
├── scripts/
│   └── install.sh       # Installation script
├── SKILL.md             # Agent skill definition
└── README.md            # Documentation
```

## Implementing a Daemon

### 1. Define Your Service

```rust
// src/service.rs
use fgp_daemon::{FgpService, Result};
use serde_json::Value;
use std::collections::HashMap;

pub struct MyService {
    // Your state here
    api_client: ApiClient,
}

impl FgpService for MyService {
    fn name(&self) -> &str { "my-daemon" }
    fn version(&self) -> &str { "1.0.0" }

    fn dispatch(&self, method: &str, params: HashMap<String, Value>) -> Result<Value> {
        match method {
            "my-daemon.list" | "list" => self.handle_list(params),
            "my-daemon.get" | "get" => self.handle_get(params),
            "my-daemon.create" | "create" => self.handle_create(params),
            _ => bail!("Unknown method: {}", method),
        }
    }

    fn method_list(&self) -> Vec<(&str, &str)> {
        vec![
            ("my-daemon.list", "List all items"),
            ("my-daemon.get", "Get item by ID"),
            ("my-daemon.create", "Create new item"),
        ]
    }
}
```

### 2. Add Method Handlers

```rust
// src/handlers/list.rs
impl MyService {
    pub fn handle_list(&self, params: HashMap<String, Value>) -> Result<Value> {
        let limit = params.get("limit")
            .and_then(|v| v.as_u64())
            .unwrap_or(20);

        let items = self.api_client.list(limit)?;

        Ok(json!({
            "items": items,
            "count": items.len()
        }))
    }
}
```

### 3. Wire Up the CLI

```rust
// src/main.rs
use clap::{Parser, Subcommand};
use fgp_daemon::FgpServer;

#[derive(Parser)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    Start,
    Stop,
    Health,
    Methods,
    // Add your commands here
    List { #[arg(long, default_value = "20")] limit: u32 },
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    match cli.command {
        Commands::Start => {
            let service = MyService::new()?;
            let server = FgpServer::new(service, "~/.fgp/services/my-daemon/daemon.sock")?;
            server.serve()?;
        }
        Commands::List { limit } => {
            let client = FgpClient::connect("~/.fgp/services/my-daemon/daemon.sock")?;
            let result = client.call("list", json!({ "limit": limit }))?;
            println!("{}", serde_json::to_string_pretty(&result)?);
        }
        // ...
    }
    Ok(())
}
```

## FGP Protocol

### Request Format
```json
{"id": "uuid", "v": 1, "method": "service.action", "params": {...}}
```

### Response Format
```json
{"id": "uuid", "ok": true, "result": {...}, "meta": {"server_ms": 5.2}}
```

### Built-in Methods

Every daemon automatically supports:
- `health` - Check daemon health
- `methods` - List available methods
- `stop` - Graceful shutdown

## Best Practices

### 1. Keep Methods Fast
Target <10ms for most operations. If something takes longer, make it async.

### 2. Handle Errors Gracefully
```rust
fn handle_get(&self, params: HashMap<String, Value>) -> Result<Value> {
    let id = params.get("id")
        .and_then(|v| v.as_str())
        .ok_or_else(|| anyhow!("Missing required parameter: id"))?;

    self.api_client.get(id)
        .map_err(|e| anyhow!("API error: {}", e))
}
```

### 3. Use Connection Pooling
For APIs with rate limits, reuse connections:
```rust
pub struct MyService {
    client: reqwest::Client, // Reused across requests
}
```

### 4. Cache When Appropriate
```rust
use std::sync::RwLock;
use std::collections::HashMap;

pub struct MyService {
    cache: RwLock<HashMap<String, CachedItem>>,
}
```

## Publishing Your Daemon

### 1. Create SKILL.md
```markdown
---
name: my-daemon
description: Fast X operations via FGP daemon. Triggers on "do X", "list Y".
---

# My Daemon

Description and usage instructions...
```

### 2. Add to Homebrew Tap
```ruby
# Formula/my-daemon.rb
class MyDaemon < Formula
  desc "Fast X operations via FGP"
  homepage "https://github.com/your-org/my-daemon"
  url "https://github.com/your-org/my-daemon/releases/download/v1.0.0/my-daemon-darwin-arm64.tar.gz"
  sha256 "..."
end
```

### 3. Submit to FGP Registry
Open a PR to `fast-gateway-protocol/registry` with your daemon metadata.

## Testing

```bash
# Run tests
cargo test

# Test daemon manually
echo '{"id":"1","v":1,"method":"health","params":{}}' | nc -U ~/.fgp/services/my-daemon/daemon.sock
```

## Resources

- [FGP Daemon SDK](https://github.com/fast-gateway-protocol/daemon)
- [Example Daemons](https://github.com/fast-gateway-protocol)
- [Protocol Specification](https://github.com/fast-gateway-protocol/protocol)
