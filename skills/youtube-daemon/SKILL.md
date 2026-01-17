---
name: youtube-daemon
description: Fast YouTube operations via FGP daemon - 40-80x faster than MCP. Use when user needs video info, search YouTube, get channel data, manage playlists, or fetch transcripts. Triggers on "youtube search", "get video", "channel info", "list playlists", "video stats", "youtube transcript", "trending videos".
license: MIT
compatibility: Requires fgp CLI and YouTube API Key (YOUTUBE_API_KEY env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP YouTube Daemon

Ultra-fast YouTube Data API operations. **40-80x faster** than browser automation.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| Search | 15-30ms | ~1200ms | **40-80x** |
| Video info | 10-20ms | ~800ms | **40-80x** |
| Channel data | 12-25ms | ~900ms | **35-75x** |
| Playlist | 15-30ms | ~1000ms | **35-65x** |

Direct YouTube Data API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-youtube

# Or
bash ~/.claude/skills/fgp-youtube/scripts/install.sh
```

## Setup

```bash
# Set API key (for public data)
export YOUTUBE_API_KEY="..."

# Or OAuth for private data
fgp youtube auth
```

Get API key from https://console.cloud.google.com/apis/credentials

## Usage

### Search

```bash
# Search videos
fgp youtube search "rust programming tutorial"

# Search with filters
fgp youtube search "cooking" --type video --duration medium --order viewCount

# Search channels
fgp youtube search "tech reviews" --type channel

# Search playlists
fgp youtube search "workout" --type playlist
```

### Videos

```bash
# Get video info
fgp youtube video dQw4w9WgXcQ

# Get multiple videos
fgp youtube videos "id1,id2,id3"

# Video statistics
fgp youtube video stats dQw4w9WgXcQ

# Video comments
fgp youtube comments dQw4w9WgXcQ --limit 50

# Related videos
fgp youtube related dQw4w9WgXcQ
```

### Channels

```bash
# Channel info
fgp youtube channel UCxxxxxxxx

# Channel by username
fgp youtube channel --username PewDiePie

# Channel videos
fgp youtube channel videos UCxxxxxxxx --limit 20

# Channel playlists
fgp youtube channel playlists UCxxxxxxxx

# Channel stats
fgp youtube channel stats UCxxxxxxxx
```

### Playlists

```bash
# Playlist info
fgp youtube playlist PLxxxxxxxx

# Playlist items
fgp youtube playlist items PLxxxxxxxx

# Create playlist (requires OAuth)
fgp youtube playlist create "My Favorites" --privacy private

# Add to playlist
fgp youtube playlist add PLxxxxxxxx dQw4w9WgXcQ

# Remove from playlist
fgp youtube playlist remove PLxxxxxxxx <item-id>
```

### Captions

```bash
# List captions
fgp youtube captions dQw4w9WgXcQ

# Download caption
fgp youtube caption download dQw4w9WgXcQ --lang en > captions.srt

# Auto-generated transcript
fgp youtube transcript dQw4w9WgXcQ
```

### Trending & Categories

```bash
# Trending videos
fgp youtube trending

# Trending by region
fgp youtube trending --region US

# Video categories
fgp youtube categories

# Videos by category
fgp youtube category 10  # Music
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `search` | Search YouTube | `fgp youtube search "query"` |
| `video` | Video info | `fgp youtube video <id>` |
| `channel` | Channel info | `fgp youtube channel <id>` |
| `playlist` | Playlist info | `fgp youtube playlist <id>` |
| `comments` | Video comments | `fgp youtube comments <id>` |
| `trending` | Trending videos | `fgp youtube trending` |
| `transcript` | Get transcript | `fgp youtube transcript <id>` |

## Search Filters

| Filter | Options |
|--------|---------|
| `--type` | video, channel, playlist |
| `--duration` | short (<4min), medium (4-20min), long (>20min) |
| `--order` | relevance, date, viewCount, rating |
| `--published-after` | ISO 8601 date |
| `--region` | Country code (US, UK, etc.) |
| `--safe-search` | none, moderate, strict |

## Example Workflows

### Research a topic
```bash
# Find popular videos
fgp youtube search "machine learning" --order viewCount --limit 10

# Get details on top result
fgp youtube video <video-id>

# Get transcript for study
fgp youtube transcript <video-id> > ml_tutorial.txt
```

### Analyze a channel
```bash
# Get channel info
fgp youtube channel UCxxxxxxxx

# See recent videos
fgp youtube channel videos UCxxxxxxxx --limit 20

# Get stats over time (recent videos)
fgp youtube channel videos UCxxxxxxxx --limit 50 | jq '.[] | {title, views, published}'
```

### Build a playlist
```bash
# Create playlist
fgp youtube playlist create "Study Music" --privacy unlisted

# Search and add
fgp youtube search "lofi study beats" --limit 10 | jq -r '.[].id' | xargs -I {} fgp youtube playlist add PLxxxxxxxx {}
```

## Troubleshooting

### Quota exceeded
```
Error: quotaExceeded
```
YouTube API has daily quotas. Check usage at Cloud Console.

### Video unavailable
```
Error: videoNotFound
```
Video may be private, deleted, or region-locked.

### Forbidden
```
Error: forbidden
```
Need OAuth for private resources. Run `fgp youtube auth`.

## Architecture

- **YouTube Data API v3**
- **API key** for public data
- **OAuth 2.0** for private operations
- **UNIX socket** at `~/.fgp/services/youtube/daemon.sock`
- **Response caching** for repeated queries
