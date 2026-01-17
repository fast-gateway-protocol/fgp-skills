---
name: mailgun-daemon
description: Fast Mailgun email operations via FGP daemon. Use when user needs to send emails, batch send, check delivery events, or validate email addresses via Mailgun. Triggers on "mailgun send", "send email mailgun", "email events", "validate email", "batch email".
license: MIT
compatibility: Requires fgp CLI and Mailgun credentials (MAILGUN_API_KEY and MAILGUN_DOMAIN env vars)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Mailgun Daemon

## Why FGP?

FGP daemons maintain persistent connections and avoid cold-start overhead. Instead of spawning a new API client for each request, the daemon stays warm and ready.

Benefits:
- No cold-start latency
- Connection pooling
- Persistent authentication

## Installation

```bash
# Via Homebrew (recommended)
brew tap fast-gateway-protocol/fgp
brew install fgp-mailgun

# Via npx
npx add-skill fgp-mailgun
```

## Quick Start

```bash
export MAILGUN_API_KEY="your-api-key"
export MAILGUN_DOMAIN="mg.yourdomain.com"
fgp start mailgun
fgp call mailgun.send --to "user@example.com" --subject "Hello" --text "World"
```

## Methods

- `mailgun.send` - Send a plain text or HTML email
- `mailgun.send_batch` - Send emails to multiple recipients with recipient variables
- `mailgun.get_events` - Retrieve email events (delivered, opened, clicked, etc.)
- `mailgun.validate` - Validate an email address
- `mailgun.list_routes` - List email routing rules
- `mailgun.create_route` - Create an email routing rule

## Authentication

Set the following environment variables:

```bash
export MAILGUN_API_KEY="key-xxxxxxxxxxxxxx"
export MAILGUN_DOMAIN="mg.yourdomain.com"
```

## Example Usage

### Send a Simple Email

```bash
fgp call mailgun.send \
  --to "recipient@example.com" \
  --from "sender@mg.yourdomain.com" \
  --subject "Welcome to FGP" \
  --html "<h1>Fast Gateway Protocol</h1><p>Blazing fast email delivery.</p>"
```

### Send Batch Emails

```bash
fgp call mailgun.send_batch \
  --to '["user1@example.com", "user2@example.com"]' \
  --from "newsletter@mg.yourdomain.com" \
  --subject "Weekly Update for %recipient.name%" \
  --recipient_variables '{"user1@example.com": {"name": "Alice"}, "user2@example.com": {"name": "Bob"}}'
```

### Get Email Events

```bash
fgp call mailgun.get_events --event "delivered" --limit 100
```

### Validate Email Address

```bash
fgp call mailgun.validate --address "test@example.com"
```
