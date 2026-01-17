---
name: fgp-gmail
description: Fast Gmail operations via FGP daemon - 69x faster than MCP. Use when user needs to check email, search messages, send email, or manage inbox. Triggers on "check my email", "send email", "search emails", "read message", "list unread".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP Gmail Daemon

Ultra-fast Gmail operations using Google API directly. **69x faster** than browser-based email checking.

## Why FGP?

| Operation | FGP Daemon | Browser MCP | Speedup |
|-----------|------------|-------------|---------|
| List emails | 15-25ms | ~1000ms | **40-69x** |
| Read email | 10-20ms | ~800ms | **40-80x** |
| Send email | 20-40ms | ~1200ms | **30-60x** |
| Search | 25-50ms | ~1500ms | **30-60x** |

No browser automation overhead - direct API calls via persistent daemon.

## Installation

```bash
# Install via Homebrew
brew install fast-gateway-protocol/tap/fgp-gmail

# Or run install script
bash ~/.claude/skills/fgp-gmail/scripts/install.sh
```

## Setup (One-Time)

1. Run authentication:
   ```bash
   fgp gmail auth
   ```

2. Browser opens for Google OAuth consent

3. Credentials stored securely in `~/.fgp/services/gmail/credentials.json`

## Usage

```bash
# List recent emails
fgp gmail list

# List unread only
fgp gmail list --unread

# Read specific email
fgp gmail read <message-id>

# Search emails
fgp gmail search "from:boss@company.com subject:urgent"

# Send email
fgp gmail send --to "recipient@example.com" --subject "Hello" --body "Message body"

# Send with attachment
fgp gmail send --to "user@example.com" --subject "Report" --body "See attached" --attach /path/to/file.pdf
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `list` | List recent emails | `fgp gmail list --limit 20` |
| `list --unread` | List unread only | `fgp gmail list --unread` |
| `read <id>` | Read email content | `fgp gmail read 18a1b2c3d4` |
| `search <query>` | Search emails | `fgp gmail search "is:starred"` |
| `send` | Send email | `fgp gmail send --to x --subject y --body z` |
| `labels` | List labels | `fgp gmail labels` |
| `archive <id>` | Archive email | `fgp gmail archive 18a1b2c3d4` |
| `trash <id>` | Move to trash | `fgp gmail trash 18a1b2c3d4` |
| `mark-read <id>` | Mark as read | `fgp gmail mark-read 18a1b2c3d4` |

## Search Syntax

Uses Gmail's search operators:

| Operator | Example | Description |
|----------|---------|-------------|
| `from:` | `from:john@example.com` | Sender |
| `to:` | `to:me` | Recipient |
| `subject:` | `subject:meeting` | Subject line |
| `is:` | `is:unread`, `is:starred` | Status |
| `has:` | `has:attachment` | Has attachment |
| `after:` | `after:2024/01/01` | Date filter |
| `label:` | `label:work` | Label filter |

## Example Workflows

### Check unread emails
```bash
fgp gmail list --unread --limit 10
```

### Find emails from someone
```bash
fgp gmail search "from:boss@company.com after:2024/01/01"
```

### Send quick reply
```bash
fgp gmail send \
  --to "colleague@company.com" \
  --subject "Re: Project Update" \
  --body "Sounds good, let's sync tomorrow."
```

## Daemon Management

```bash
# Check status
fgp gmail health

# View methods
fgp gmail methods

# Stop daemon
fgp gmail stop

# Restart
fgp gmail start
```

## Troubleshooting

### Not authenticated
```
Error: No credentials found
```
Run: `fgp gmail auth`

### Token expired
```
Error: Token expired
```
Run: `fgp gmail auth --refresh`

### Rate limited
```
Error: Rate limit exceeded
```
Gmail API has quotas. Wait a few minutes or reduce request frequency.

## Security

- OAuth tokens stored in `~/.fgp/services/gmail/`
- Never logs email content
- Credentials never leave your machine
- Revoke access anytime at https://myaccount.google.com/permissions

## Architecture

- **Google Gmail API** (no browser scraping)
- **OAuth 2.0** with refresh tokens
- **UNIX socket** at `~/.fgp/services/gmail/daemon.sock`
- **NDJSON protocol** for requests/responses
