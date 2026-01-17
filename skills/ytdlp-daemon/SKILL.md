---
name: fgp-ytdlp
description: Fast video/audio downloading via FGP daemon - 5-15x faster than spawning yt-dlp per operation. Use when user needs to download videos, extract audio, get metadata, or download playlists from YouTube and other sites. Triggers on "download video", "download youtube", "extract audio", "yt-dlp", "get video", "download playlist".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP yt-dlp Daemon

Ultra-fast video/audio downloading with persistent yt-dlp instance. **5-15x faster** than spawning yt-dlp per command.

## Why FGP?

| Operation | FGP Daemon | Direct yt-dlp | Speedup |
|-----------|------------|---------------|---------|
| Get metadata | 5-15ms | ~80ms | **5-16x** |
| List formats | 8-20ms | ~100ms | **5-12x** |
| Download start | 10-30ms | ~120ms | **4-12x** |
| Playlist info | 15-40ms | ~150ms | **4-10x** |

Persistent daemon eliminates Python interpreter startup overhead.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-ytdlp

# Or
bash ~/.claude/skills/fgp-ytdlp/scripts/install.sh
```

### Prerequisites

yt-dlp must be installed:
```bash
# macOS
brew install yt-dlp

# pip (any platform)
pip install yt-dlp

# Verify
yt-dlp --version
```

For best quality, also install ffmpeg:
```bash
brew install ffmpeg
```

## Usage

### Download Video

```bash
# Download best quality
fgp ytdlp download "https://youtube.com/watch?v=VIDEO_ID"

# Download to specific folder
fgp ytdlp download "URL" --output ~/Videos

# Download with custom filename
fgp ytdlp download "URL" --output "%(title)s.%(ext)s"

# Download specific format
fgp ytdlp download "URL" --format "bestvideo[height<=1080]+bestaudio"

# Download 720p
fgp ytdlp download "URL" --format 720p

# Download as MP4
fgp ytdlp download "URL" --format mp4
```

### Extract Audio

```bash
# Extract audio as MP3
fgp ytdlp audio "URL"

# Extract as specific format
fgp ytdlp audio "URL" --format mp3
fgp ytdlp audio "URL" --format m4a
fgp ytdlp audio "URL" --format opus
fgp ytdlp audio "URL" --format wav

# With quality setting
fgp ytdlp audio "URL" --format mp3 --quality 320k

# Extract from local video
fgp ytdlp audio video.mp4 --format mp3
```

### Get Metadata

```bash
# Get video info
fgp ytdlp info "URL"

# Get specific fields
fgp ytdlp info "URL" --fields title,duration,view_count

# Get as JSON
fgp ytdlp info "URL" --json

# Get thumbnail URL
fgp ytdlp info "URL" --fields thumbnail

# Get description
fgp ytdlp info "URL" --fields description
```

### List Formats

```bash
# List available formats
fgp ytdlp formats "URL"

# Show video-only formats
fgp ytdlp formats "URL" --video-only

# Show audio-only formats
fgp ytdlp formats "URL" --audio-only

# Get best format info
fgp ytdlp formats "URL" --best
```

### Download Thumbnail

```bash
# Download thumbnail
fgp ytdlp thumbnail "URL"

# Specific size
fgp ytdlp thumbnail "URL" --size maxres

# As specific format
fgp ytdlp thumbnail "URL" --format png

# All thumbnails
fgp ytdlp thumbnail "URL" --all
```

### Playlists

```bash
# Download entire playlist
fgp ytdlp playlist "PLAYLIST_URL"

# Download specific range
fgp ytdlp playlist "URL" --start 1 --end 10

# Download specific items
fgp ytdlp playlist "URL" --items "1,3,5-7"

# Get playlist info only
fgp ytdlp playlist "URL" --info-only

# Extract audio from playlist
fgp ytdlp playlist "URL" --audio --format mp3

# With numbering
fgp ytdlp playlist "URL" --output "%(playlist_index)02d - %(title)s.%(ext)s"
```

### Channels

```bash
# Download from channel
fgp ytdlp channel "CHANNEL_URL"

# Last N videos
fgp ytdlp channel "URL" --last 10

# Since date
fgp ytdlp channel "URL" --since 2024-01-01

# Specific tab
fgp ytdlp channel "URL" --tab videos
fgp ytdlp channel "URL" --tab shorts
fgp ytdlp channel "URL" --tab streams
```

### Subtitles

```bash
# Download with subtitles
fgp ytdlp download "URL" --subtitles

# Specific language
fgp ytdlp download "URL" --subtitles en

# Multiple languages
fgp ytdlp download "URL" --subtitles "en,es,fr"

# Auto-generated subtitles
fgp ytdlp download "URL" --auto-subtitles

# Embed subtitles in video
fgp ytdlp download "URL" --subtitles --embed-subs

# Download subtitles only
fgp ytdlp subtitles "URL" --language en
```

### Search

```bash
# Search YouTube
fgp ytdlp search "search query"

# Limit results
fgp ytdlp search "query" --limit 5

# Download first result
fgp ytdlp search "query" --download

# Search and get audio
fgp ytdlp search "query" --audio
```

### Batch Download

```bash
# Download from file of URLs
fgp ytdlp batch urls.txt

# With options
fgp ytdlp batch urls.txt --format 720p --output ~/Videos

# Download as audio
fgp ytdlp batch urls.txt --audio --format mp3

# Parallel downloads
fgp ytdlp batch urls.txt --parallel 3
```

### Supported Sites

yt-dlp supports 1000+ sites including:

```bash
# YouTube
fgp ytdlp download "https://youtube.com/watch?v=..."

# Vimeo
fgp ytdlp download "https://vimeo.com/..."

# Twitter/X
fgp ytdlp download "https://twitter.com/.../status/..."

# Reddit
fgp ytdlp download "https://reddit.com/r/.../comments/..."

# TikTok
fgp ytdlp download "https://tiktok.com/@.../video/..."

# Instagram
fgp ytdlp download "https://instagram.com/p/..."

# Twitch
fgp ytdlp download "https://twitch.tv/videos/..."

# SoundCloud
fgp ytdlp audio "https://soundcloud.com/..."

# List all supported sites
fgp ytdlp sites
```

### Format Selection

```bash
# Best video + best audio
fgp ytdlp download "URL" --format "bestvideo+bestaudio"

# Best MP4
fgp ytdlp download "URL" --format "bestvideo[ext=mp4]+bestaudio[ext=m4a]"

# Max 1080p
fgp ytdlp download "URL" --format "bestvideo[height<=1080]+bestaudio"

# Max 720p MP4
fgp ytdlp download "URL" --format "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]"

# Worst quality (smallest file)
fgp ytdlp download "URL" --format worst

# Specific format ID
fgp ytdlp download "URL" --format 137+140
```

### Output Templates

```bash
# Default template
fgp ytdlp download "URL" --output "%(title)s.%(ext)s"

# With uploader
fgp ytdlp download "URL" --output "%(uploader)s - %(title)s.%(ext)s"

# Organized by channel
fgp ytdlp download "URL" --output "%(uploader)s/%(title)s.%(ext)s"

# With date
fgp ytdlp download "URL" --output "%(upload_date)s - %(title)s.%(ext)s"

# Playlist numbering
fgp ytdlp playlist "URL" --output "%(playlist)s/%(playlist_index)02d - %(title)s.%(ext)s"
```

### Authentication

```bash
# With cookies
fgp ytdlp download "URL" --cookies cookies.txt

# Extract cookies from browser
fgp ytdlp download "URL" --cookies-from-browser chrome

# With username/password
fgp ytdlp download "URL" --username USER --password PASS
```

### Rate Limiting

```bash
# Limit download speed
fgp ytdlp download "URL" --limit-rate 1M

# Sleep between downloads
fgp ytdlp batch urls.txt --sleep 5

# Random sleep range
fgp ytdlp batch urls.txt --sleep-range 3-10
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `download` | Download video | `fgp ytdlp download "URL"` |
| `audio` | Extract audio | `fgp ytdlp audio "URL"` |
| `info` | Get metadata | `fgp ytdlp info "URL"` |
| `formats` | List formats | `fgp ytdlp formats "URL"` |
| `playlist` | Download playlist | `fgp ytdlp playlist "URL"` |
| `channel` | Download channel | `fgp ytdlp channel "URL"` |
| `search` | Search YouTube | `fgp ytdlp search "query"` |
| `thumbnail` | Get thumbnail | `fgp ytdlp thumbnail "URL"` |
| `subtitles` | Get subtitles | `fgp ytdlp subtitles "URL"` |
| `batch` | Batch download | `fgp ytdlp batch urls.txt` |
| `sites` | List supported sites | `fgp ytdlp sites` |

## Example Workflows

### Download podcast episode
```bash
fgp ytdlp audio "PODCAST_URL" --format mp3 --quality 192k --output "podcasts/%(title)s.%(ext)s"
```

### Archive channel
```bash
fgp ytdlp channel "CHANNEL_URL" \
  --format "bestvideo[height<=1080]+bestaudio" \
  --subtitles en \
  --output "archive/%(uploader)s/%(upload_date)s - %(title)s.%(ext)s"
```

### Download music playlist
```bash
fgp ytdlp playlist "PLAYLIST_URL" \
  --audio \
  --format mp3 \
  --quality 320k \
  --output "music/%(playlist)s/%(title)s.%(ext)s"
```

### Get video for editing
```bash
# Get highest quality for editing
fgp ytdlp download "URL" \
  --format "bestvideo[ext=mp4]+bestaudio[ext=m4a]" \
  --output "editing/%(title)s.%(ext)s"
```

### Research: save video info
```bash
# Get metadata as JSON
fgp ytdlp info "URL" --json > video_info.json
```

## Troubleshooting

### yt-dlp not found
```
Error: yt-dlp not found in PATH
```
Install yt-dlp: `brew install yt-dlp` or `pip install yt-dlp`

### Age-restricted video
```
Error: Sign in to confirm your age
```
Use cookies: `fgp ytdlp download "URL" --cookies-from-browser chrome`

### Format not available
```
Error: Requested format not available
```
Check available formats: `fgp ytdlp formats "URL"`

### Geo-restricted
```
Error: Video not available in your country
```
May require VPN or proxy: `fgp ytdlp download "URL" --proxy socks5://...`

### Rate limited
```
Error: HTTP 429
```
Add sleep between requests: `fgp ytdlp batch urls.txt --sleep 10`

## Architecture

- **yt-dlp** subprocess with persistent connection
- **UNIX socket** at `~/.fgp/services/ytdlp/daemon.sock`
- **Progress streaming** via socket
- **Download queue** for batch operations
- **Metadata caching** for repeated queries
