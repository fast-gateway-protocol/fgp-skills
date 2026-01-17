---
name: imessage-daemon
description: Fast iMessage operations via FGP daemon (macOS only) - 480x faster than alternatives. Use when user needs to send/read iMessages, search conversations, check unread messages, or find follow-ups. Triggers on "send message", "text someone", "check messages", "search iMessage", "send text", "unread messages", "iMessage to".
license: MIT
compatibility: Requires macOS, fgp CLI, and Full Disk Access permission for terminal
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP iMessage Daemon

Ultra-fast iMessage access on macOS using direct SQLite queries. **480x faster** than AppleScript-based approaches.

## Why FGP?

| Operation | FGP Daemon | AppleScript | Speedup |
|-----------|------------|-------------|---------|
| List messages | 1-5ms | ~500ms | **100-480x** |
| Search | 2-10ms | ~800ms | **80-400x** |
| Get recent | 1-3ms | ~400ms | **130-400x** |
| Send message | 50-100ms | ~200ms | **2-4x** |

Direct SQLite access to `chat.db` - no UI automation overhead.

## Requirements

- **macOS only** (reads ~/Library/Messages/chat.db)
- **Full Disk Access** permission for terminal/Claude Code
- Sending requires AppleScript (Messages app must be running)

## Installation

```bash
# Install via Homebrew
brew install fast-gateway-protocol/tap/fgp-imessage

# Or run install script
bash ~/.claude/skills/fgp-imessage/scripts/install.sh
```

## Setup

Grant Full Disk Access to your terminal:

1. Open System Preferences > Security & Privacy > Privacy
2. Select "Full Disk Access" in left sidebar
3. Add your terminal app (Terminal, iTerm2, or Warp)
4. Restart terminal

## Usage

### Read Messages

```bash
# Get recent messages (all conversations)
fgp imessage recent

# Get recent from specific person
fgp imessage recent --from "+1234567890"
fgp imessage recent --from "John Doe"

# Get messages from specific chat
fgp imessage messages --chat "chat123456"

# Limit results
fgp imessage recent --limit 50
```

### Search Messages

```bash
# Search all messages
fgp imessage search "dinner tomorrow"

# Search specific conversation
fgp imessage search "project update" --from "Boss"

# Search with date range
fgp imessage search "meeting" --after "2024-01-01" --before "2024-02-01"
```

### Send Messages

```bash
# Send to phone number
fgp imessage send "+1234567890" "Hey, are you free tonight?"

# Send to email (iMessage)
fgp imessage send "friend@icloud.com" "Check this out"

# Send to contact name
fgp imessage send "John Doe" "See you at 5!"
```

### Conversations

```bash
# List all conversations
fgp imessage chats

# Get conversation details
fgp imessage chat "chat123456"

# List unread messages
fgp imessage unread

# Find follow-up needed
fgp imessage follow-ups
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `recent` | Recent messages | `fgp imessage recent --limit 20` |
| `messages` | Chat messages | `fgp imessage messages --chat xxx` |
| `search` | Search messages | `fgp imessage search "keyword"` |
| `send` | Send message | `fgp imessage send "+1..." "hi"` |
| `chats` | List conversations | `fgp imessage chats` |
| `chat` | Chat details | `fgp imessage chat xxx` |
| `unread` | Unread messages | `fgp imessage unread` |
| `follow-ups` | Needs reply | `fgp imessage follow-ups` |
| `attachments` | List attachments | `fgp imessage attachments --chat xxx` |

## Example Workflows

### Morning inbox check
```bash
# See what's unread
fgp imessage unread

# Check who needs a reply
fgp imessage follow-ups
```

### Find a specific conversation
```bash
# Search for topic
fgp imessage search "restaurant recommendation"

# Get context around it
fgp imessage messages --chat <chat-id> --around <message-id>
```

### Quick reply
```bash
# Send message
fgp imessage send "Mom" "On my way!"
```

## Semantic Search (Beta)

For natural language queries:

```bash
# Find messages about a topic
fgp imessage semantic "that time we talked about the hiking trip"

# Requires: pip install sentence-transformers
```

## Daemon Management

```bash
# Check status
fgp imessage health

# View methods
fgp imessage methods

# Stop/start daemon
fgp imessage stop
fgp imessage start
```

## Troubleshooting

### Permission denied
```
Error: Unable to read chat.db
```
Grant Full Disk Access to your terminal app.

### Messages app not running
```
Error: Messages app not responding
```
Open Messages.app for send functionality.

### Contact not found
```
Error: No chat found for "Name"
```
Try phone number or email instead of contact name.

## Privacy & Security

- **Local only** - all data stays on your machine
- **Read from SQLite** - no network calls for reading
- **Send via AppleScript** - uses native Messages.app
- **No cloud sync** - doesn't access iCloud Messages

## Architecture

- **SQLite queries** on `~/Library/Messages/chat.db`
- **AppleScript** for sending (via Messages.app)
- **UNIX socket** at `~/.fgp/services/imessage/daemon.sock`
- **Contact resolution** via Contacts.framework
