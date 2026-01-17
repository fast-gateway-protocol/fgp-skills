---
name: sendgrid-daemon
description: Fast SendGrid email operations via FGP daemon. Use when user needs to send emails, use templates, manage contacts, or check email stats via SendGrid. Triggers on "sendgrid send", "send email sendgrid", "sendgrid template", "email stats", "add contact sendgrid".
license: MIT
compatibility: Requires fgp CLI and SendGrid API Key (SENDGRID_API_KEY env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP SendGrid Daemon

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
brew install fgp-sendgrid

# Via npx
npx add-skill fgp-sendgrid
```

## Quick Start

```bash
export SENDGRID_API_KEY="your-api-key"
fgp start sendgrid
fgp call sendgrid.send --to "user@example.com" --subject "Hello" --body "World"
```

## Methods

- `sendgrid.send` - Send a plain text or HTML email
- `sendgrid.send_template` - Send an email using a dynamic template
- `sendgrid.list_contacts` - List contacts from your marketing lists
- `sendgrid.add_contact` - Add a contact to a marketing list
- `sendgrid.get_stats` - Get email sending statistics
- `sendgrid.validate_email` - Validate an email address

## Authentication

Set the `SENDGRID_API_KEY` environment variable with your SendGrid API key.

```bash
export SENDGRID_API_KEY="SG.xxxxxx"
```

## Example Usage

### Send a Simple Email

```bash
fgp call sendgrid.send \
  --to "recipient@example.com" \
  --from "sender@yourdomain.com" \
  --subject "Welcome!" \
  --body "<h1>Hello World</h1>"
```

### Send a Template Email

```bash
fgp call sendgrid.send_template \
  --to "recipient@example.com" \
  --template_id "d-xxxxxxxxxxxxx" \
  --dynamic_data '{"name": "John", "product": "FGP"}'
```

### Get Sending Statistics

```bash
fgp call sendgrid.get_stats --start_date "2026-01-01" --end_date "2026-01-17"
```
