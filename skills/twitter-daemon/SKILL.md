---
name: fgp-twitter
description: Fast Twitter/X operations via FGP daemon - 35-70x faster than MCP. Use when user needs to post tweets, search, get timelines, or manage Twitter account. Triggers on "post tweet", "search twitter", "get timeline", "twitter mentions", "tweet this".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP Twitter Daemon

Ultra-fast Twitter/X operations using direct API access. **35-70x faster** than browser automation.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| Post tweet | 15-30ms | ~1000ms | **35-65x** |
| Get timeline | 12-25ms | ~900ms | **35-75x** |
| Search | 20-40ms | ~1200ms | **30-60x** |
| User lookup | 10-20ms | ~700ms | **35-70x** |

Direct Twitter API v2 via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-twitter

# Or
bash ~/.claude/skills/fgp-twitter/scripts/install.sh
```

## Setup

```bash
# OAuth 2.0 (recommended for user actions)
fgp twitter auth

# Or use bearer token (read-only)
export TWITTER_BEARER_TOKEN="..."

# Or use API keys (for posting)
export TWITTER_API_KEY="..."
export TWITTER_API_SECRET="..."
export TWITTER_ACCESS_TOKEN="..."
export TWITTER_ACCESS_SECRET="..."
```

Get credentials from https://developer.twitter.com/

## Usage

### Post Tweets

```bash
# Simple tweet
fgp twitter tweet "Hello world!"

# With media
fgp twitter tweet "Check this out" --media ./image.png

# Reply to tweet
fgp twitter reply <tweet-id> "Great point!"

# Quote tweet
fgp twitter quote <tweet-id> "This is important"

# Thread
fgp twitter thread "First tweet" "Second tweet" "Third tweet"

# Schedule tweet
fgp twitter tweet "Good morning!" --schedule "tomorrow 9am"
```

### Timeline & Mentions

```bash
# Home timeline
fgp twitter timeline

# User timeline
fgp twitter timeline @username

# Mentions
fgp twitter mentions

# Likes
fgp twitter likes

# Bookmarks
fgp twitter bookmarks
```

### Search

```bash
# Search tweets
fgp twitter search "AI agents"

# Search with filters
fgp twitter search "rust lang" --filter "has:links -is:retweet"

# Recent vs popular
fgp twitter search "startup" --type recent
fgp twitter search "startup" --type popular

# Search users
fgp twitter search-users "developer"
```

### Users

```bash
# Get user
fgp twitter user @elonmusk

# Get by ID
fgp twitter user-id 44196397

# Followers
fgp twitter followers @username

# Following
fgp twitter following @username

# Follow/unfollow
fgp twitter follow @username
fgp twitter unfollow @username
```

### Engagement

```bash
# Like tweet
fgp twitter like <tweet-id>

# Unlike
fgp twitter unlike <tweet-id>

# Retweet
fgp twitter retweet <tweet-id>

# Undo retweet
fgp twitter unretweet <tweet-id>

# Bookmark
fgp twitter bookmark <tweet-id>

# Remove bookmark
fgp twitter unbookmark <tweet-id>
```

### Lists

```bash
# My lists
fgp twitter lists

# List members
fgp twitter list <list-id> members

# List tweets
fgp twitter list <list-id> tweets

# Add to list
fgp twitter list add <list-id> @username

# Create list
fgp twitter list create "Tech News" --private
```

### DMs

```bash
# Recent DMs
fgp twitter dms

# Send DM
fgp twitter dm @username "Hey!"

# Conversation
fgp twitter dm-conversation <user-id>
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `tweet` | Post tweet | `fgp twitter tweet "Hello"` |
| `reply` | Reply to tweet | `fgp twitter reply <id> "text"` |
| `thread` | Post thread | `fgp twitter thread "1" "2" "3"` |
| `timeline` | Get timeline | `fgp twitter timeline` |
| `mentions` | Get mentions | `fgp twitter mentions` |
| `search` | Search tweets | `fgp twitter search "query"` |
| `user` | Get user | `fgp twitter user @name` |
| `like` | Like tweet | `fgp twitter like <id>` |
| `retweet` | Retweet | `fgp twitter retweet <id>` |
| `follow` | Follow user | `fgp twitter follow @name` |

## Search Operators

| Operator | Example | Description |
|----------|---------|-------------|
| `from:` | `from:elonmusk` | From user |
| `to:` | `to:twitter` | To user |
| `@` | `@openai` | Mentioning user |
| `#` | `#AI` | Hashtag |
| `has:` | `has:media` | Has media/links |
| `is:` | `is:verified` | Is verified/retweet |
| `-` | `-is:retweet` | Exclude |
| `lang:` | `lang:en` | Language |
| `since:` | `since:2024-01-01` | After date |
| `until:` | `until:2024-12-31` | Before date |

## Example Workflows

### Morning engagement
```bash
# Check mentions
fgp twitter mentions

# Check timeline for interesting stuff
fgp twitter timeline --limit 20
```

### Research a topic
```bash
# Search recent discussion
fgp twitter search "LLM agents" --type recent --limit 50

# Find influencers
fgp twitter search-users "AI researcher"
```

### Post thread
```bash
fgp twitter thread \
  "🧵 Here's what I learned about FGP daemons..." \
  "1/ They're 10-100x faster than MCP because..." \
  "2/ The key insight is persistent UNIX sockets..." \
  "3/ Try it yourself: npx add-skill fgp-skills"
```

## Rate Limits

Twitter API has strict rate limits:

| Endpoint | Limit |
|----------|-------|
| Post tweet | 200/15min |
| Timeline | 75/15min |
| Search | 180/15min |
| User lookup | 300/15min |

Check current limits: `fgp twitter rate-limits`

## Troubleshooting

### Not authenticated
```
Error: Authentication required
```
Run `fgp twitter auth` or set API credentials.

### Rate limited
```
Error: Rate limit exceeded
```
Wait for rate limit reset. Check with `fgp twitter rate-limits`.

### Tweet not found
```
Error: Tweet not found
```
Tweet may be deleted or from a protected account.

## Architecture

- **Twitter API v2**
- **OAuth 2.0 + OAuth 1.0a** support
- **UNIX socket** at `~/.fgp/services/twitter/daemon.sock`
- **Rate limit tracking** built-in
