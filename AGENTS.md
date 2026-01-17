# AGENTS.md

This file provides guidance to AI coding agents working with the FGP Skills repository.

## Repository Overview

This repository contains FGP (Fast Gateway Protocol) skills - daemon-based tools that are **10-100x faster than MCP**. Skills are packaged instructions and install scripts that set up persistent daemons.

## Key Concept: FGP vs MCP

**MCP (Model Context Protocol):**
- Spawns new process for each tool call
- 50-200ms startup overhead
- Stateless

**FGP (Fast Gateway Protocol):**
- Persistent daemons over UNIX sockets
- Sub-10ms latency
- Stateful (caching, connection pools)

## Directory Structure

```
fgp-skills/
├── skills/
│   ├── browser-daemon/      # Chrome automation (3-12x faster)
│   │   ├── SKILL.md
│   │   └── scripts/
│   │       └── install.sh
│   ├── gmail-daemon/        # Gmail API (69x faster)
│   ├── github-daemon/       # GitHub GraphQL (75x faster)
│   ├── imessage-daemon/     # iMessage SQLite (480x faster, macOS)
│   └── fgp-daemon-creator/  # Scaffold new daemons
├── README.md
└── AGENTS.md
```

## Creating a New Skill

### 1. Directory Structure

```
skills/
  {daemon-name}/
    SKILL.md              # Required: skill definition
    scripts/
      install.sh          # Required: installation script
    references/           # Optional: additional docs
```

### 2. SKILL.md Format

```markdown
---
name: fgp-{daemon-name}
description: Fast X operations via FGP daemon - Nx faster than MCP. Use when [use case]. Triggers on "[phrases]".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP {Daemon Name}

Description of the daemon and why it's faster.

## Why FGP?

| Operation | FGP Daemon | MCP | Speedup |
|-----------|------------|-----|---------|
| ...       | ...        | ... | **Nx**  |

## Installation

\`\`\`bash
brew install fast-gateway-protocol/tap/fgp-{name}
\`\`\`

## Usage

\`\`\`bash
fgp {name} {command}
\`\`\`

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| ...     | ...         | ...     |

## Troubleshooting

Common issues and solutions.
```

### 3. Install Script Requirements

```bash
#!/bin/bash
set -e

# Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Prefer Homebrew if available
if command -v brew &> /dev/null; then
    brew install fast-gateway-protocol/tap/fgp-{name}
    exit 0
fi

# Manual installation fallback
# Download binary, create directories, update PATH

# Output JSON for programmatic use
echo '{"status": "installed", "binary": "path"}'
```

## Naming Conventions

- **Skill directory**: `{daemon-name}` (e.g., `browser-daemon`, `gmail-daemon`)
- **Package name**: `fgp-{name}` (e.g., `fgp-browser`, `fgp-gmail`)
- **CLI command**: `fgp {name}` (e.g., `fgp browser open`)
- **Socket path**: `~/.fgp/services/{name}/daemon.sock`

## Best Practices

### Performance Claims

Always include:
1. Benchmark table comparing FGP vs MCP
2. Specific operation latencies (in milliseconds)
3. Speedup multiplier (e.g., "3-12x faster")

### Installation

1. Prefer Homebrew for macOS/Linux
2. Provide manual fallback
3. Check and request necessary permissions
4. Start daemon after install if appropriate

### Documentation

1. Keep SKILL.md under 500 lines
2. Use tables for command references
3. Include troubleshooting section
4. Show example workflows

## Testing Skills

```bash
# Install skill
npx add-skill . --skill browser-daemon

# Verify SKILL.md is valid
cat skills/browser-daemon/SKILL.md | head -10

# Test install script (in sandbox)
bash skills/browser-daemon/scripts/install.sh
```

## Related Repositories

- [daemon](https://github.com/fast-gateway-protocol/daemon) - Rust SDK
- [protocol](https://github.com/fast-gateway-protocol/protocol) - Protocol spec
- [browser](https://github.com/fast-gateway-protocol/browser) - Browser daemon
- [gmail](https://github.com/fast-gateway-protocol/gmail) - Gmail daemon
