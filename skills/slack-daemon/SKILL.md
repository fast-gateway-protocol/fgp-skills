---
name: fgp-slack
description: Fast Slack operations via FGP daemon - 50x faster than MCP. Use when user needs to send messages, check channels, search Slack, or manage workspace. Triggers on "send slack message", "check slack", "post to channel", "search slack", "list channels".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP Slack Daemon

Ultra-fast Slack operations using direct API access. **50x faster** than browser-based alternatives.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| Send message | 15-30ms | ~800ms | **25-50x** |
| List channels | 10-20ms | ~600ms | **30-60x** |
| Search messages | 25-50ms | ~1000ms | **20-40x** |
| Get thread | 15-25ms | ~700ms | **30-45x** |

Direct Slack Web API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-slack

# Or
bash ~/.claude/skills/fgp-slack/scripts/install.sh
```

## Setup

```bash
# Option 1: OAuth (recommended)
fgp slack auth

# Option 2: Bot token
export SLACK_BOT_TOKEN="xoxb-..."
fgp slack start
```

Create a Slack app at https://api.slack.com/apps with scopes:
- `channels:read`, `channels:history`
- `chat:write`, `chat:write.public`
- `users:read`, `search:read`

## Usage

### Send Messages

```bash
# To channel
fgp slack send "#general" "Hello team!"

# To user (DM)
fgp slack send "@alice" "Quick question..."

# With formatting
fgp slack send "#dev" "Build *passed* :white_check_mark:"

# Reply in thread
fgp slack send "#dev" "Fixed!" --thread ts_123456

# With attachment
fgp slack send "#reports" "Daily report" --file /path/to/report.pdf
```

### Read Messages

```bash
# Recent messages in channel
fgp slack messages "#general"

# With limit
fgp slack messages "#dev" --limit 50

# Get thread
fgp slack thread "#dev" ts_123456

# Unread mentions
fgp slack mentions
```

### Channels

```bash
# List channels
fgp slack channels

# Search channels
fgp slack channels --search "project"

# Channel info
fgp slack channel "#dev"

# Join/leave
fgp slack join "#new-channel"
fgp slack leave "#old-channel"
```

### Users

```bash
# List users
fgp slack users

# User info
fgp slack user "@alice"

# Who's online
fgp slack users --online

# Set status
fgp slack status "In a meeting" :calendar: --until "1 hour"
```

### Search

```bash
# Search messages
fgp slack search "deployment issue"

# In specific channel
fgp slack search "bug fix" --in "#dev"

# From user
fgp slack search "meeting notes" --from "@bob"

# Date range
fgp slack search "quarterly review" --after "2024-01-01"
```

### Reactions

```bash
# Add reaction
fgp slack react "#dev" ts_123456 :thumbsup:

# Remove reaction
fgp slack unreact "#dev" ts_123456 :thumbsup:
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `send` | Send message | `fgp slack send "#ch" "msg"` |
| `messages` | Read messages | `fgp slack messages "#ch"` |
| `thread` | Get thread | `fgp slack thread "#ch" ts` |
| `mentions` | Unread mentions | `fgp slack mentions` |
| `channels` | List channels | `fgp slack channels` |
| `users` | List users | `fgp slack users` |
| `search` | Search messages | `fgp slack search "query"` |
| `status` | Set status | `fgp slack status "msg" :emoji:` |
| `react` | Add reaction | `fgp slack react "#ch" ts :emoji:` |

## Example Workflows

### Morning catch-up
```bash
# Check mentions
fgp slack mentions

# Check important channel
fgp slack messages "#announcements" --limit 10
```

### Quick standup update
```bash
fgp slack send "#standup" "Yesterday: finished auth flow
Today: starting API integration
Blockers: none"
```

### Find discussion
```bash
fgp slack search "database migration" --in "#backend" --after "last week"
```

## Daemon Management

```bash
fgp slack health
fgp slack methods
fgp slack stop
```

## Troubleshooting

### Not authenticated
```
Error: No Slack token found
```
Run `fgp slack auth` or set `SLACK_BOT_TOKEN`.

### Channel not found
```
Error: Channel #foo not found
```
Check channel exists and bot is invited.

### Rate limited
```
Error: Rate limit exceeded
```
Slack limits ~1 req/sec for some endpoints. Wait and retry.

## Architecture

- **Slack Web API** (not RTM)
- **Bot or User OAuth tokens**
- **UNIX socket** at `~/.fgp/services/slack/daemon.sock`
- **Workspace caching** for channel/user lookups
