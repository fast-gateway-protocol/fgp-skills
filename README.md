# FGP Skills

**The performance layer for AI agents.** FGP (Fast Gateway Protocol) daemons are 10-100x faster than MCP.

```bash
npx add-skill fast-gateway-protocol/fgp-skills
```

## Why FGP?

MCP (Model Context Protocol) spawns a new process for every tool call. FGP uses **persistent daemons** over UNIX sockets - no cold start, sub-10ms latency.

| Operation | FGP Daemon | MCP Server | Speedup |
|-----------|------------|------------|---------|
| Browser navigate | 2-8ms | 27ms | **3-12x** |
| Gmail list | 15-25ms | ~1000ms | **40-69x** |
| GitHub issues | 8-15ms | ~600ms | **40-75x** |
| iMessage read | 1-5ms | ~500ms | **100-480x** |

## Available Skills

| Skill | Description | Platforms |
|-------|-------------|-----------|
| [`fgp-browser`](skills/browser-daemon) | Fast browser automation via Chrome DevTools Protocol | macOS, Linux |
| [`fgp-gmail`](skills/gmail-daemon) | Fast Gmail operations via Google API | macOS, Linux |
| [`fgp-github`](skills/github-daemon) | Fast GitHub operations via GraphQL | macOS, Linux |
| [`fgp-imessage`](skills/imessage-daemon) | Fast iMessage access via SQLite | macOS only |
| [`fgp-daemon-creator`](skills/fgp-daemon-creator) | Scaffold new FGP daemons | macOS, Linux |

## Installation

### Via add-skill (Recommended)

```bash
# Install all skills
npx add-skill fast-gateway-protocol/fgp-skills

# Install specific skills
npx add-skill fast-gateway-protocol/fgp-skills --skill fgp-browser --skill fgp-gmail

# Install for specific agent
npx add-skill fast-gateway-protocol/fgp-skills -a claude-code
```

### Via Homebrew

```bash
# Add the tap
brew tap fast-gateway-protocol/tap

# Install specific daemons
brew install fgp-browser fgp-gmail fgp-github
```

### Manual Installation

```bash
# Clone and install
git clone https://github.com/fast-gateway-protocol/fgp-skills
cd fgp-skills/skills/browser-daemon
bash scripts/install.sh
```

## Quick Start

After installation, daemons run in the background:

```bash
# Browser automation
fgp browser open "https://example.com"
fgp browser snapshot  # Get ARIA tree

# Gmail
fgp gmail list --unread
fgp gmail send --to "user@example.com" --subject "Hi" --body "Hello!"

# GitHub
fgp github issues --state open
fgp github pr create --title "Feature X"

# iMessage (macOS)
fgp imessage recent
fgp imessage send "Mom" "On my way!"
```

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     AI Agent (Claude, Cursor, etc.)         │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ NDJSON over UNIX socket
                              │ (sub-10ms latency)
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      FGP Daemons                            │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐│
│  │  Browser  │  │   Gmail   │  │  GitHub   │  │ iMessage  ││
│  │  Daemon   │  │  Daemon   │  │  Daemon   │  │  Daemon   ││
│  └───────────┘  └───────────┘  └───────────┘  └───────────┘│
│       │              │              │              │        │
│       ▼              ▼              ▼              ▼        │
│    Chrome         Google         GitHub       SQLite +     │
│     CDP           API           GraphQL      AppleScript   │
└─────────────────────────────────────────────────────────────┘
```

### Why Daemons?

| Aspect | MCP (stdio) | FGP (daemon) |
|--------|-------------|--------------|
| Startup | ~50-200ms spawn | 0ms (already running) |
| Connection | New process each call | Persistent socket |
| Memory | Duplicated per call | Shared across calls |
| State | Stateless | Stateful (caching, connection pools) |

## Creating Your Own Daemon

Use the `fgp-daemon-creator` skill:

```bash
fgp new my-daemon --template api-integration
cd my-daemon
cargo build --release
```

Or see the [daemon SDK documentation](https://github.com/fast-gateway-protocol/daemon).

## Supported Agents

These skills work with any agent that supports the [Agent Skills format](https://github.com/vercel-labs/agent-skills):

- Claude Code
- Cursor
- Codex CLI
- OpenCode
- Windsurf
- And more...

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Adding a New Skill

1. Create skill directory: `skills/my-daemon/`
2. Add `SKILL.md` with frontmatter
3. Add `scripts/install.sh`
4. Submit PR

## License

MIT

## Links

- [FGP Protocol Specification](https://github.com/fast-gateway-protocol/protocol)
- [Daemon SDK (Rust)](https://github.com/fast-gateway-protocol/daemon)
- [FGP Registry](https://fgp.dev)
- [Benchmarks](https://github.com/fast-gateway-protocol/benchmarks)
