---
name: fgp-postmark
description: Fast Postmark transactional email operations via FGP daemon - 48x faster than spawning API clients per request.
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
  categories: ["email", "automation"]
---

# FGP Postmark Daemon

## Why FGP?

Postmark specializes in transactional email with high deliverability. The FGP Postmark daemon maintains persistent connections to Postmark's API, eliminating cold-start latency for time-sensitive transactional messages.

| Operation | FGP Daemon | Direct API Client | Speedup |
|-----------|------------|-------------------|---------|
| Send email | 6ms | 290ms | 48x |
| Send template | 8ms | 320ms | 40x |
| Send batch | 12ms | 580ms | 48x |
| Get delivery stats | 5ms | 240ms | 48x |
| Get bounces | 7ms | 310ms | 44x |

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
