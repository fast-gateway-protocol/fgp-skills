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
| Supabase query | 5-15ms | ~600ms | **40-120x** |
| Vercel deploy | 50-100ms | ~2000ms | **20-40x** |
| iMessage read | 1-5ms | ~500ms | **100-480x** |

## Available Skills

### Core Integrations

| Skill | Description | Speedup | Platforms |
|-------|-------------|---------|-----------|
| [`fgp-browser`](skills/browser-daemon) | Chrome automation via CDP | 3-12x | macOS, Linux |
| [`fgp-gmail`](skills/gmail-daemon) | Gmail via Google API | 40-69x | macOS, Linux |
| [`fgp-github`](skills/github-daemon) | GitHub via GraphQL | 40-75x | macOS, Linux |
| [`fgp-calendar`](skills/calendar-daemon) | Google Calendar | 10-20x | macOS, Linux |

### Productivity & Team

| Skill | Description | Speedup | Platforms |
|-------|-------------|---------|-----------|
| [`fgp-slack`](skills/slack-daemon) | Slack messaging | 25-50x | macOS, Linux |
| [`fgp-discord`](skills/discord-daemon) | Discord bot ops | 60-120x | macOS, Linux |
| [`fgp-notion`](skills/notion-daemon) | Notion pages & DBs | 40-80x | macOS, Linux |
| [`fgp-linear`](skills/linear-daemon) | Linear issues | 45-90x | macOS, Linux |

### Deployment & Infrastructure

| Skill | Description | Speedup | Platforms |
|-------|-------------|---------|-----------|
| [`fgp-vercel`](skills/vercel-daemon) | Vercel deployments | 30-60x | macOS, Linux |
| [`fgp-fly`](skills/fly-daemon) | Fly.io apps & machines | 25-50x | macOS, Linux |
| [`fgp-cloudflare`](skills/cloudflare-daemon) | DNS, Workers, KV | 50-100x | macOS, Linux |

### Databases

| Skill | Description | Speedup | Platforms |
|-------|-------------|---------|-----------|
| [`fgp-supabase`](skills/supabase-daemon) | Supabase (SQL, Auth, Storage) | 40-120x | macOS, Linux |
| [`fgp-neon`](skills/neon-daemon) | Neon Postgres branches | 35-70x | macOS, Linux |
| [`fgp-postgres`](skills/postgres-daemon) | Any PostgreSQL database | 30-80x | macOS, Linux |

### Social & Communication

| Skill | Description | Speedup | Platforms |
|-------|-------------|---------|-----------|
| [`fgp-twitter`](skills/twitter-daemon) | Twitter/X API | 35-70x | macOS, Linux |
| [`fgp-twilio`](skills/twilio-daemon) | SMS, calls, WhatsApp | 25-50x | macOS, Linux |
| [`fgp-resend`](skills/resend-daemon) | Transactional email | 30-60x | macOS, Linux |

### Payments & Business

| Skill | Description | Speedup | Platforms |
|-------|-------------|---------|-----------|
| [`fgp-stripe`](skills/stripe-daemon) | Payments, subscriptions | 30-60x | macOS, Linux |

### AI & ML

| Skill | Description | Speedup | Platforms |
|-------|-------------|---------|-----------|
| [`fgp-openai`](skills/openai-daemon) | Embeddings, completions, DALL-E | 20-40x | macOS, Linux |

### Media & Storage

| Skill | Description | Speedup | Platforms |
|-------|-------------|---------|-----------|
| [`fgp-youtube`](skills/youtube-daemon) | YouTube Data API | 40-80x | macOS, Linux |
| [`fgp-google-drive`](skills/google-drive-daemon) | Google Drive files | 40-80x | macOS, Linux |
| [`fgp-google-sheets`](skills/google-sheets-daemon) | Google Sheets spreadsheets | 35-70x | macOS, Linux |
| [`fgp-google-docs`](skills/google-docs-daemon) | Google Docs documents | 30-60x | macOS, Linux |
| [`fgp-ffmpeg`](skills/ffmpeg-daemon) | Video/audio processing via FFmpeg | 5-20x | macOS, Linux |

### macOS Native

| Skill | Description | Speedup | Platforms |
|-------|-------------|---------|-----------|
| [`fgp-imessage`](skills/imessage-daemon) | iMessage via SQLite | 100-480x | macOS only |
| [`fgp-screen-time`](skills/screen-time-daemon) | Screen Time stats | 10-50x | macOS only |
| [`fgp-contacts`](skills/contacts-daemon) | Contacts.framework | 30-60x | macOS only |

### Developer Tools

| Skill | Description | Platforms |
|-------|-------------|-----------|
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

# Slack
fgp slack send "#general" "Hello team!"
fgp slack mentions

# Linear
fgp linear issues --state "In Progress"
fgp linear issue create "Bug fix" --team "Engineering"

# Calendar
fgp calendar today
fgp calendar create "Meeting" --when "tomorrow 2pm"

# iMessage (macOS)
fgp imessage recent
fgp imessage send "Mom" "On my way!"

# Screen Time (macOS)
fgp screen-time today --breakdown
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
