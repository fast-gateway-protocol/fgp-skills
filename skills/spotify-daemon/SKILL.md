---
name: spotify-daemon
description: Fast Spotify operations via FGP daemon - 20-50x faster than MCP. Use when user needs to control playback, search tracks, manage playlists, or check what's playing. Triggers on "spotify play", "what's playing", "spotify search", "add to playlist", "spotify pause", "now playing".
license: MIT
compatibility: Requires fgp CLI and Spotify OAuth (run fgp spotify auth)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Spotify Daemon

Fast Spotify API operations with OAuth token management.

## Why FGP?

| Operation | FGP Daemon | MCP/REST | Speedup |
|-----------|------------|----------|---------|
| Now playing | 10ms | 250ms | **25x** |
| Search | 15ms | 300ms | **20x** |
| Play/pause | 8ms | 200ms | **25x** |
| Playlist ops | 20ms | 400ms | **20x** |

## Installation

```bash
brew install fast-gateway-protocol/fgp/fgp-spotify
```

## Setup

```bash
# OAuth setup (opens browser for auth)
fgp-spotify auth

# Start daemon
fgp start spotify
```

## Available Commands

| Command | Description |
|---------|-------------|
| `spotify.now_playing` | Get current track |
| `spotify.play` | Start playback |
| `spotify.pause` | Pause playback |
| `spotify.next` | Skip to next track |
| `spotify.previous` | Previous track |
| `spotify.search` | Search tracks/albums/artists |
| `spotify.playlists` | List playlists |
| `spotify.playlist` | Get playlist tracks |
| `spotify.add_to_playlist` | Add track to playlist |
| `spotify.queue` | Add to queue |
| `spotify.devices` | List devices |
| `spotify.transfer` | Transfer playback |

## Example Workflows

```bash
# What's playing?
fgp call spotify.now_playing

# Search and play
fgp call spotify.search --query "bohemian rhapsody" --type track
fgp call spotify.play --uri "spotify:track:..."

# Add to playlist
fgp call spotify.add_to_playlist --playlist "My Playlist" --track "spotify:track:..."
```
