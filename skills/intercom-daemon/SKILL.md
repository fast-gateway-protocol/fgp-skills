---
name: fgp-intercom
description: Fast Intercom customer messaging operations via FGP daemon - 42x faster than spawning API clients per request.
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
  categories: ["messaging", "automation"]
---

# FGP Intercom Daemon

## Why FGP?

Intercom's API enables customer messaging, support, and engagement. The FGP Intercom daemon maintains authenticated sessions and connection pools, ideal for CRM automation and customer support workflows.

| Operation | FGP Daemon | Direct API Client | Speedup |
|-----------|------------|-------------------|---------|
| Create contact | 9ms | 380ms | 42x |
| Send message | 11ms | 450ms | 41x |
| List conversations | 8ms | 340ms | 43x |
| Search contacts | 10ms | 420ms | 42x |
| Create note | 7ms | 290ms | 41x |

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
