---
name: postmark-daemon
description: Fast Postmark transactional email operations via FGP daemon. Use when user needs to send transactional emails, use templates, batch send, or check delivery stats via Postmark. Triggers on "postmark send", "send email postmark", "postmark template", "delivery stats", "email bounce".
license: MIT
compatibility: Requires fgp CLI and Postmark Server Token (POSTMARK_SERVER_TOKEN env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Postmark Daemon

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
brew install fgp-postmark

# Via npx
npx add-skill fgp-postmark
```

## Quick Start

```bash
export POSTMARK_SERVER_TOKEN="your-server-token"
fgp start postmark
fgp call postmark.send --to "user@example.com" --subject "Order Confirmation" --html "<h1>Thank you!</h1>"
```

## Methods

- `postmark.send` - Send a transactional email
- `postmark.send_template` - Send an email using a Postmark template
- `postmark.send_batch` - Send multiple emails in a single request (up to 500)
- `postmark.get_delivery_stats` - Get delivery statistics
- `postmark.get_bounces` - Get bounce information
- `postmark.get_message_details` - Get details of a sent message

## Authentication

Set the `POSTMARK_SERVER_TOKEN` environment variable:

```bash
export POSTMARK_SERVER_TOKEN="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

## Example Usage

### Send a Transactional Email

```bash
fgp call postmark.send \
  --to "customer@example.com" \
  --from "orders@yourapp.com" \
  --subject "Your order has shipped!" \
  --html "<h1>Shipment Confirmation</h1><p>Your order #12345 is on its way.</p>" \
  --track_opens true \
  --track_links "HtmlAndText"
```

### Send a Template Email

```bash
fgp call postmark.send_template \
  --to "customer@example.com" \
  --from "support@yourapp.com" \
  --template_alias "password-reset" \
  --template_model '{"name": "John", "reset_link": "https://yourapp.com/reset/abc123"}'
```

### Send Batch Emails

```bash
fgp call postmark.send_batch \
  --messages '[
    {"To": "user1@example.com", "Subject": "Welcome", "TextBody": "Hello User 1"},
    {"To": "user2@example.com", "Subject": "Welcome", "TextBody": "Hello User 2"}
  ]'
```

### Get Bounce Information

```bash
fgp call postmark.get_bounces --count 50 --type "HardBounce"
```
