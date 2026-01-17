---
name: fgp-resend
description: Fast Resend email operations via FGP daemon - 30-60x faster than MCP. Use when user needs to send emails, check delivery status, or manage email templates. Triggers on "send email", "email to", "check email status", "resend", "transactional email".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP Resend Daemon

Ultra-fast Resend email operations using direct API access. **30-60x faster** than MCP alternatives.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| Send email | 15-30ms | ~800ms | **25-55x** |
| Get email | 10-20ms | ~500ms | **25-50x** |
| List emails | 12-25ms | ~600ms | **25-50x** |
| Batch send | 20-40ms | ~1000ms | **25-50x** |

Direct Resend API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-resend

# Or
bash ~/.claude/skills/fgp-resend/scripts/install.sh
```

## Setup

```bash
export RESEND_API_KEY="re_xxxxxxxxxx"
```

Get API key from https://resend.com/api-keys

## Usage

### Send Emails

```bash
# Simple email
fgp resend send --to "user@example.com" --subject "Hello" --text "Hello world!"

# HTML email
fgp resend send --to "user@example.com" --subject "Welcome" --html "<h1>Welcome!</h1>"

# With from address
fgp resend send --from "hello@yourdomain.com" --to "user@example.com" --subject "Hi"

# Multiple recipients
fgp resend send --to "a@example.com,b@example.com" --subject "Announcement"

# CC and BCC
fgp resend send --to "user@example.com" --cc "manager@example.com" --bcc "log@example.com"

# With attachment
fgp resend send --to "user@example.com" --subject "Report" --attach ./report.pdf

# Reply-to
fgp resend send --to "user@example.com" --reply-to "support@example.com"

# With tags
fgp resend send --to "user@example.com" --subject "Welcome" --tags "onboarding,welcome"
```

### Email Status

```bash
# Get email
fgp resend email <email-id>

# List emails
fgp resend emails

# List by status
fgp resend emails --status delivered
fgp resend emails --status bounced
```

### Batch Sending

```bash
# Send batch from JSON
fgp resend batch --file emails.json

# emails.json format:
# [
#   {"to": "a@example.com", "subject": "Hello A", "text": "..."},
#   {"to": "b@example.com", "subject": "Hello B", "text": "..."}
# ]

# Batch with template
fgp resend batch --template welcome --recipients recipients.json
```

### Domains

```bash
# List domains
fgp resend domains

# Add domain
fgp resend domain add yourdomain.com

# Verify domain
fgp resend domain verify yourdomain.com

# Get DNS records
fgp resend domain dns yourdomain.com

# Remove domain
fgp resend domain remove yourdomain.com
```

### API Keys

```bash
# List API keys
fgp resend keys

# Create API key
fgp resend key create --name "Production" --permission full

# Delete API key
fgp resend key delete <key-id>
```

### Audiences (Lists)

```bash
# List audiences
fgp resend audiences

# Create audience
fgp resend audience create "Newsletter Subscribers"

# Add contact
fgp resend audience add <audience-id> --email "user@example.com" --name "John"

# Remove contact
fgp resend audience remove <audience-id> --email "user@example.com"

# List contacts
fgp resend audience contacts <audience-id>
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `send` | Send email | `fgp resend send --to x --subject y` |
| `email` | Get email | `fgp resend email <id>` |
| `emails` | List emails | `fgp resend emails` |
| `batch` | Batch send | `fgp resend batch --file x.json` |
| `domains` | List domains | `fgp resend domains` |
| `domain add` | Add domain | `fgp resend domain add x.com` |
| `audiences` | List audiences | `fgp resend audiences` |

## Email Templates (React Email)

Use React Email templates:

```bash
# Send with React Email template
fgp resend send \
  --to "user@example.com" \
  --react ./emails/welcome.tsx \
  --props '{"name": "John"}'
```

## Example Workflows

### Welcome email
```bash
fgp resend send \
  --from "welcome@yourapp.com" \
  --to "newuser@example.com" \
  --subject "Welcome to YourApp!" \
  --html "<h1>Welcome!</h1><p>Thanks for signing up.</p>"
```

### Password reset
```bash
fgp resend send \
  --from "no-reply@yourapp.com" \
  --to "user@example.com" \
  --subject "Reset your password" \
  --html "<p>Click <a href='https://yourapp.com/reset?token=xxx'>here</a> to reset.</p>"
```

### Check delivery
```bash
# Send and get ID
EMAIL_ID=$(fgp resend send --to "x@example.com" --subject "Test" --text "Test" --json | jq -r '.id')

# Check status
fgp resend email $EMAIL_ID
```

## Troubleshooting

### Invalid API key
```
Error: Invalid API key
```
Check `RESEND_API_KEY` is correct.

### Domain not verified
```
Error: Domain not verified
```
Add DNS records: `fgp resend domain dns yourdomain.com`

### Rate limited
```
Error: Rate limit exceeded
```
Resend allows 10 emails/second on free tier.

### Invalid from address
```
Error: From address not allowed
```
Use a verified domain or `onboarding@resend.dev` for testing.

## Architecture

- **Resend REST API**
- **API key authentication**
- **UNIX socket** at `~/.fgp/services/resend/daemon.sock`
- **Async delivery** with webhook support
