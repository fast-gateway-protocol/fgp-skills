---
name: fgp-twilio
description: Fast Twilio operations via FGP daemon - 25-50x faster than MCP. Use when user needs to send SMS, make calls, check messages, or manage phone numbers. Triggers on "send sms", "text message", "twilio call", "check messages", "phone number".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP Twilio Daemon

Ultra-fast Twilio operations using direct API access. **25-50x faster** than MCP alternatives.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| Send SMS | 20-40ms | ~800ms | **20-40x** |
| List messages | 15-30ms | ~700ms | **25-45x** |
| Make call | 25-50ms | ~1000ms | **20-40x** |
| Check status | 10-20ms | ~500ms | **25-50x** |

Direct Twilio REST API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-twilio

# Or
bash ~/.claude/skills/fgp-twilio/scripts/install.sh
```

## Setup

```bash
# Set credentials
export TWILIO_ACCOUNT_SID="ACxxxxxxxxxx"
export TWILIO_AUTH_TOKEN="xxxxxxxxxx"

# Default from number (optional)
export TWILIO_FROM_NUMBER="+1234567890"
```

Get credentials from https://console.twilio.com/

## Usage

### SMS

```bash
# Send SMS
fgp twilio sms "+1234567890" "Hello from FGP!"

# Send from specific number
fgp twilio sms "+1234567890" "Hello" --from "+1987654321"

# Send with media (MMS)
fgp twilio sms "+1234567890" "Check this out" --media "https://example.com/image.png"

# List messages
fgp twilio messages

# List messages to/from number
fgp twilio messages --to "+1234567890"
fgp twilio messages --from "+1987654321"

# Get message
fgp twilio message SMxxxxxxxx

# Delete message
fgp twilio message delete SMxxxxxxxx
```

### Calls

```bash
# Make call (with TwiML)
fgp twilio call "+1234567890" --twiml '<Response><Say>Hello!</Say></Response>'

# Make call (with URL)
fgp twilio call "+1234567890" --url "https://example.com/twiml"

# List calls
fgp twilio calls

# Get call
fgp twilio call CAxxxxxxxx

# End call
fgp twilio call hangup CAxxxxxxxx
```

### Phone Numbers

```bash
# List numbers
fgp twilio numbers

# Search available numbers
fgp twilio numbers search --area-code 415

# Buy number
fgp twilio numbers buy "+1415xxxxxxx"

# Release number
fgp twilio numbers release "+1415xxxxxxx"

# Update number
fgp twilio numbers update "+1415xxxxxxx" --sms-url "https://example.com/sms"
```

### WhatsApp

```bash
# Send WhatsApp
fgp twilio whatsapp "+1234567890" "Hello!"

# With template
fgp twilio whatsapp "+1234567890" --template "Your code is {{1}}" --params '["123456"]'

# List WhatsApp messages
fgp twilio whatsapp messages
```

### Verify (2FA)

```bash
# Start verification
fgp twilio verify start "+1234567890" --channel sms

# Check code
fgp twilio verify check "+1234567890" --code 123456

# Via email
fgp twilio verify start "user@example.com" --channel email
```

### Conversations

```bash
# List conversations
fgp twilio conversations

# Create conversation
fgp twilio conversation create --friendly-name "Support Chat"

# Add participant
fgp twilio conversation add-participant CHxxxxxxxx --phone "+1234567890"

# Send message
fgp twilio conversation message CHxxxxxxxx "Hello!"
```

### Lookups

```bash
# Phone number lookup
fgp twilio lookup "+1234567890"

# With carrier info
fgp twilio lookup "+1234567890" --type carrier

# With caller name
fgp twilio lookup "+1234567890" --type caller-name
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `sms` | Send SMS | `fgp twilio sms "+1..." "msg"` |
| `messages` | List messages | `fgp twilio messages` |
| `call` | Make call | `fgp twilio call "+1..." --url ...` |
| `calls` | List calls | `fgp twilio calls` |
| `numbers` | List numbers | `fgp twilio numbers` |
| `whatsapp` | Send WhatsApp | `fgp twilio whatsapp "+1..." "msg"` |
| `verify` | 2FA verify | `fgp twilio verify start "+1..."` |
| `lookup` | Phone lookup | `fgp twilio lookup "+1..."` |

## Example Workflows

### Send alert
```bash
fgp twilio sms "+1234567890" "🚨 Server down: api-prod-1"
```

### 2FA flow
```bash
# Start verification
fgp twilio verify start "+1234567890" --channel sms

# User enters code...

# Check code
fgp twilio verify check "+1234567890" --code 123456
```

### Bulk SMS
```bash
# From file of numbers
cat numbers.txt | while read phone; do
  fgp twilio sms "$phone" "Flash sale! 20% off today only"
  sleep 0.1  # Rate limiting
done
```

## Troubleshooting

### Invalid credentials
```
Error: Authentication Error
```
Check `TWILIO_ACCOUNT_SID` and `TWILIO_AUTH_TOKEN`.

### Invalid phone number
```
Error: The 'To' number is not a valid phone number
```
Use E.164 format: +1234567890

### Unverified number
```
Error: The number is unverified
```
In trial mode, verify destination numbers first.

### Insufficient funds
```
Error: Account has insufficient funds
```
Add funds at https://console.twilio.com/

## Architecture

- **Twilio REST API**
- **Account SID + Auth Token**
- **UNIX socket** at `~/.fgp/services/twilio/daemon.sock`
- **Async support** for call status callbacks
