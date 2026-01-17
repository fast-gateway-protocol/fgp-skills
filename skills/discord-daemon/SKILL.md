---
name: discord-daemon
description: Fast Discord operations via FGP daemon - 60-120x faster than MCP. Use when user needs to send messages, manage servers, check channels, read messages, or interact with Discord bots. Triggers on "send discord message", "check discord", "post to discord", "list discord servers", "discord channel", "discord DM".
license: MIT
compatibility: Requires fgp CLI and Discord Bot Token (DISCORD_BOT_TOKEN env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Discord Daemon

Ultra-fast Discord operations using direct API access. **60-120x faster** than browser automation.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| Send message | 10-20ms | ~1200ms | **60-120x** |
| List channels | 8-15ms | ~800ms | **50-100x** |
| Get messages | 12-25ms | ~1000ms | **40-80x** |
| User lookup | 5-10ms | ~600ms | **60-120x** |

Direct Discord API via persistent daemon with connection pooling.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-discord

# Or
bash ~/.claude/skills/fgp-discord/scripts/install.sh
```

## Setup

```bash
# Set bot token
export DISCORD_BOT_TOKEN="..."

# Start daemon
fgp discord start
```

Create a bot at https://discord.com/developers/applications with intents:
- Message Content Intent
- Server Members Intent (optional)

## Usage

### Send Messages

```bash
# To channel (by ID or name)
fgp discord send 123456789 "Hello!"
fgp discord send "#general" "Hello!" --server "My Server"

# With embed
fgp discord send "#announcements" --embed "Title" "Description" --color blue

# Reply to message
fgp discord reply 123456789 987654321 "Great point!"

# With file
fgp discord send "#uploads" "Check this out" --file /path/to/image.png
```

### Read Messages

```bash
# Recent messages
fgp discord messages "#general" --server "My Server"

# With limit
fgp discord messages 123456789 --limit 50

# Search
fgp discord search "deployment" --server "My Server"
```

### Servers & Channels

```bash
# List servers
fgp discord servers

# List channels in server
fgp discord channels --server "My Server"

# Channel info
fgp discord channel 123456789
```

### Users & Members

```bash
# Get user
fgp discord user 123456789

# List server members
fgp discord members --server "My Server"

# Who's online
fgp discord members --server "My Server" --online
```

### Reactions

```bash
# Add reaction
fgp discord react 123456789 987654321 :thumbsup:

# Get reactions
fgp discord reactions 123456789 987654321
```

### Roles (Admin)

```bash
# List roles
fgp discord roles --server "My Server"

# Add role to user
fgp discord role add @user "Moderator" --server "My Server"
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `send` | Send message | `fgp discord send #ch "msg"` |
| `messages` | Read messages | `fgp discord messages #ch` |
| `reply` | Reply to message | `fgp discord reply ch msg "text"` |
| `servers` | List servers | `fgp discord servers` |
| `channels` | List channels | `fgp discord channels` |
| `members` | List members | `fgp discord members` |
| `search` | Search messages | `fgp discord search "query"` |
| `react` | Add reaction | `fgp discord react ch msg :emoji:` |

## Example Workflows

### Announce to multiple servers
```bash
for server in "Server1" "Server2" "Server3"; do
  fgp discord send "#announcements" "New release v2.0!" --server "$server"
done
```

### Monitor channel
```bash
fgp discord messages "#alerts" --server "Ops" --limit 20
```

## Troubleshooting

### Bot not in server
```
Error: Missing Access
```
Invite bot with proper permissions.

### Invalid token
```
Error: 401 Unauthorized
```
Check `DISCORD_BOT_TOKEN` is correct.

### Missing permissions
```
Error: Missing Permissions
```
Bot needs appropriate permissions for the action.

## Architecture

- **Discord REST API** (v10)
- **Bot token authentication**
- **UNIX socket** at `~/.fgp/services/discord/daemon.sock`
- **Rate limit handling** built-in
