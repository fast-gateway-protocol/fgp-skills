---
name: intercom-daemon
description: Fast Intercom customer messaging operations via FGP daemon. Use when user needs to create contacts, send messages, manage conversations, or search users in Intercom. Triggers on "intercom contact", "send intercom", "intercom message", "list conversations", "intercom user".
license: MIT
compatibility: Requires fgp CLI and Intercom Access Token (INTERCOM_ACCESS_TOKEN env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Intercom Daemon

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
brew install fgp-intercom

# Via npx
npx add-skill fgp-intercom
```

## Quick Start

```bash
export INTERCOM_ACCESS_TOKEN="your-access-token"
fgp start intercom
fgp call intercom.create_contact --email "user@example.com" --name "John Doe"
```

## Methods

- `intercom.create_contact` - Create a new contact (user or lead)
- `intercom.update_contact` - Update an existing contact
- `intercom.search_contacts` - Search contacts with filters
- `intercom.send_message` - Send an in-app message to a user
- `intercom.list_conversations` - List conversations with optional filters
- `intercom.reply_conversation` - Reply to a conversation

## Authentication

Set the `INTERCOM_ACCESS_TOKEN` environment variable:

```bash
export INTERCOM_ACCESS_TOKEN="dG9rOjxxxxxxxx_xxxxxxxx"
```

## Example Usage

### Create a Contact

```bash
fgp call intercom.create_contact \
  --role "user" \
  --email "customer@example.com" \
  --name "Jane Smith" \
  --custom_attributes '{"plan": "premium", "signed_up_at": 1705500000}'
```

### Update a Contact

```bash
fgp call intercom.update_contact \
  --id "6789abcdef" \
  --custom_attributes '{"last_seen_at": 1705586400, "page_views": 42}'
```

### Search Contacts

```bash
fgp call intercom.search_contacts \
  --query '{
    "field": "custom_attributes.plan",
    "operator": "=",
    "value": "premium"
  }'
```

### Send an In-App Message

```bash
fgp call intercom.send_message \
  --from_admin_id "12345" \
  --to_user_id "6789abcdef" \
  --message_type "inapp" \
  --body "Hi! How can we help you today?"
```

### List Conversations

```bash
fgp call intercom.list_conversations --state "open" --per_page 25
```

### Reply to a Conversation

```bash
fgp call intercom.reply_conversation \
  --conversation_id "12345678" \
  --admin_id "12345" \
  --message_type "comment" \
  --body "Thanks for reaching out! Let me look into this for you."
```
