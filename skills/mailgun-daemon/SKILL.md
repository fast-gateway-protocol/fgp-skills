---
name: fgp-mailgun
description: Fast Mailgun email operations via FGP daemon - 52x faster than spawning API clients per request.
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
  categories: ["email", "automation"]
---

# FGP Mailgun Daemon

## Why FGP?

Mailgun's REST API requires authentication and connection setup for each request. The FGP Mailgun daemon maintains authenticated sessions and connection pools, eliminating per-request overhead.

| Operation | FGP Daemon | Direct API Client | Speedup |
|-----------|------------|-------------------|---------|
| Send email | 7ms | 380ms | 54x |
| Send batch | 15ms | 650ms | 43x |
| Get events | 9ms | 420ms | 47x |
| Validate email | 4ms | 220ms | 55x |
| List routes | 8ms | 350ms | 44x |

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
