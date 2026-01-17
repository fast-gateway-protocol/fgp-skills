---
name: pusher-daemon
description: Fast Pusher real-time messaging operations via FGP daemon. Use when user needs to trigger events, send real-time messages, manage channels, or authenticate presence channels. Triggers on "pusher trigger", "send pusher event", "real-time message", "pusher channel", "presence users".
license: MIT
compatibility: Requires fgp CLI and Pusher credentials (PUSHER_APP_ID, PUSHER_KEY, PUSHER_SECRET, PUSHER_CLUSTER env vars)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Pusher Daemon

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
brew install fgp-pusher

# Via npx
npx add-skill fgp-pusher
```

## Quick Start

```bash
export PUSHER_APP_ID="your-app-id"
export PUSHER_KEY="your-key"
export PUSHER_SECRET="your-secret"
export PUSHER_CLUSTER="us2"
fgp start pusher
fgp call pusher.trigger --channel "my-channel" --event "my-event" --data '{"message": "Hello!"}'
```

## Methods

- `pusher.trigger` - Trigger an event on a channel
- `pusher.trigger_batch` - Trigger multiple events in a single request
- `pusher.channel_info` - Get information about a channel
- `pusher.channels` - List all channels
- `pusher.presence_users` - Get users in a presence channel
- `pusher.authenticate` - Generate authentication signature for private/presence channels

## Authentication

Set the following environment variables:

```bash
export PUSHER_APP_ID="123456"
export PUSHER_KEY="xxxxxxxxxxxxxxxx"
export PUSHER_SECRET="xxxxxxxxxxxxxxxx"
export PUSHER_CLUSTER="us2"  # or eu, ap1, ap2, etc.
```

## Example Usage

### Trigger a Single Event

```bash
fgp call pusher.trigger \
  --channel "notifications" \
  --event "new-message" \
  --data '{"user_id": 123, "message": "Hello, World!", "timestamp": "2026-01-17T10:00:00Z"}'
```

### Trigger Batch Events

```bash
fgp call pusher.trigger_batch \
  --events '[
    {"channel": "user-1", "name": "notification", "data": {"text": "You have a new follower"}},
    {"channel": "user-2", "name": "notification", "data": {"text": "Your post was liked"}}
  ]'
```

### Get Channel Information

```bash
fgp call pusher.channel_info --channel "presence-chat-room" --info '["user_count", "subscription_count"]'
```

### List Presence Users

```bash
fgp call pusher.presence_users --channel "presence-chat-room"
```

### Authenticate Private Channel

```bash
fgp call pusher.authenticate \
  --socket_id "123.456" \
  --channel "private-user-123"
```
