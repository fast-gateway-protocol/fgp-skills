---
name: fgp-sendgrid
description: Fast SendGrid email operations via FGP daemon - 45x faster than spawning API clients per request.
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
  categories: ["email", "automation"]
---

# FGP SendGrid Daemon

## Why FGP?

Traditional SendGrid integrations spawn a new HTTP client for each request, incurring connection setup overhead. The FGP SendGrid daemon maintains a persistent connection pool and stays warm across sessions.

| Operation | FGP Daemon | Direct API Client | Speedup |
|-----------|------------|-------------------|---------|
| Send email | 8ms | 350ms | 44x |
| Send template email | 10ms | 380ms | 38x |
| List contacts | 12ms | 420ms | 35x |
| Get email stats | 6ms | 280ms | 47x |
| Validate email | 5ms | 250ms | 50x |

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
