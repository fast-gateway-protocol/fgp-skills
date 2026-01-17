---
name: ffmpeg-daemon
description: Fast video/audio processing via FGP daemon - 5-20x faster than spawning ffmpeg per operation. Use when user needs to convert videos, extract audio, trim clips, resize, add watermarks, or transcode. Triggers on "convert video", "extract audio", "trim video", "compress video", "ffmpeg", "video editing", "transcode".
license: MIT
compatibility: Requires fgp CLI and FFmpeg installed (brew install ffmpeg)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP FFmpeg Daemon

Ultra-fast video/audio processing with persistent FFmpeg instance. **5-20x faster** than spawning ffmpeg per command.

## Why FGP?

| Operation | FGP Daemon | Direct ffmpeg | Speedup |
|-----------|------------|---------------|---------|
| Probe metadata | 2-5ms | ~50ms | **10-25x** |
| Extract frame | 10-30ms | ~100ms | **3-10x** |
| Trim clip | 15-50ms | ~150ms | **3-10x** |
| Convert format | 20-100ms overhead | ~200ms overhead | **2-10x** |

Persistent daemon eliminates process spawn overhead. Actual encoding time depends on content.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-ffmpeg

# Or
bash ~/.claude/skills/fgp-ffmpeg/scripts/install.sh
```

### Prerequisites

FFmpeg must be installed:
```bash
# macOS
brew install ffmpeg

# Ubuntu/Debian
sudo apt install ffmpeg

# Verify
ffmpeg -version
```

## Usage

### Probe / Info

```bash
# Get video info (duration, resolution, codec, etc.)
fgp ffmpeg info video.mp4

# Get detailed probe data (JSON)
fgp ffmpeg probe video.mp4

# Get duration only
fgp ffmpeg duration video.mp4

# Get resolution
fgp ffmpeg resolution video.mp4

# List streams (video, audio, subtitle tracks)
fgp ffmpeg streams video.mp4
```

### Format Conversion

```bash
# Convert to MP4
fgp ffmpeg convert video.avi --to mp4

# Convert to WebM
fgp ffmpeg convert video.mp4 --to webm

# Convert to GIF
fgp ffmpeg convert video.mp4 --to gif

# Convert with specific codec
fgp ffmpeg convert video.mp4 --to webm --codec vp9

# Convert audio only
fgp ffmpeg convert audio.wav --to mp3
fgp ffmpeg convert audio.flac --to aac
```

### Trim / Cut

```bash
# Trim from start to end time
fgp ffmpeg trim video.mp4 --start 00:01:30 --end 00:02:45

# Trim with duration
fgp ffmpeg trim video.mp4 --start 00:01:30 --duration 30

# Trim last 60 seconds
fgp ffmpeg trim video.mp4 --last 60

# Trim first 30 seconds
fgp ffmpeg trim video.mp4 --first 30

# Output to specific file
fgp ffmpeg trim video.mp4 --start 10 --end 20 --output clip.mp4
```

### Extract Audio

```bash
# Extract audio as MP3
fgp ffmpeg extract-audio video.mp4

# Extract as specific format
fgp ffmpeg extract-audio video.mp4 --format wav
fgp ffmpeg extract-audio video.mp4 --format aac
fgp ffmpeg extract-audio video.mp4 --format flac

# Extract specific audio track
fgp ffmpeg extract-audio video.mp4 --track 1
```

### Extract Frames

```bash
# Extract single frame at timestamp
fgp ffmpeg frame video.mp4 --at 00:01:30

# Extract frame as PNG
fgp ffmpeg frame video.mp4 --at 30 --format png

# Extract multiple frames (every N seconds)
fgp ffmpeg frames video.mp4 --every 10

# Extract N frames evenly distributed
fgp ffmpeg frames video.mp4 --count 20

# Extract all frames (warning: large output)
fgp ffmpeg frames video.mp4 --all --output frames/
```

### Resize / Scale

```bash
# Resize to specific dimensions
fgp ffmpeg resize video.mp4 --size 1280x720

# Resize by width (maintain aspect)
fgp ffmpeg resize video.mp4 --width 1280

# Resize by height (maintain aspect)
fgp ffmpeg resize video.mp4 --height 720

# Scale by percentage
fgp ffmpeg resize video.mp4 --scale 50%

# Common presets
fgp ffmpeg resize video.mp4 --preset 1080p
fgp ffmpeg resize video.mp4 --preset 720p
fgp ffmpeg resize video.mp4 --preset 480p
```

### Compress

```bash
# Compress with default settings
fgp ffmpeg compress video.mp4

# Compress to target size
fgp ffmpeg compress video.mp4 --target-size 50MB

# Compress with quality preset
fgp ffmpeg compress video.mp4 --quality medium  # low, medium, high
fgp ffmpeg compress video.mp4 --crf 28  # 0-51, higher = more compression

# Compress for web
fgp ffmpeg compress video.mp4 --preset web

# Two-pass encoding for better quality
fgp ffmpeg compress video.mp4 --two-pass --target-size 100MB
```

### Merge / Concat

```bash
# Concatenate videos
fgp ffmpeg concat video1.mp4 video2.mp4 video3.mp4 --output merged.mp4

# Concat from file list
fgp ffmpeg concat --list files.txt --output merged.mp4

# Merge video and audio
fgp ffmpeg merge video.mp4 audio.mp3 --output combined.mp4

# Replace audio track
fgp ffmpeg merge video.mp4 newtrack.mp3 --replace-audio
```

### Watermark / Overlay

```bash
# Add image watermark
fgp ffmpeg watermark video.mp4 --image logo.png

# Position watermark
fgp ffmpeg watermark video.mp4 --image logo.png --position top-right
fgp ffmpeg watermark video.mp4 --image logo.png --position bottom-left
fgp ffmpeg watermark video.mp4 --image logo.png --x 10 --y 10

# Watermark with opacity
fgp ffmpeg watermark video.mp4 --image logo.png --opacity 0.5

# Text watermark
fgp ffmpeg watermark video.mp4 --text "© 2024" --position bottom-right
```

### Speed / Slow-mo

```bash
# Speed up 2x
fgp ffmpeg speed video.mp4 --factor 2

# Slow motion 0.5x
fgp ffmpeg speed video.mp4 --factor 0.5

# Speed up with frame interpolation (smoother)
fgp ffmpeg speed video.mp4 --factor 2 --interpolate
```

### Audio Operations

```bash
# Adjust volume
fgp ffmpeg volume video.mp4 --level 1.5  # 150%
fgp ffmpeg volume video.mp4 --db +6      # +6dB

# Normalize audio
fgp ffmpeg normalize video.mp4

# Remove audio
fgp ffmpeg mute video.mp4

# Fade audio
fgp ffmpeg fade video.mp4 --audio-in 2 --audio-out 2
```

### Effects

```bash
# Rotate video
fgp ffmpeg rotate video.mp4 --degrees 90
fgp ffmpeg rotate video.mp4 --degrees 180

# Flip video
fgp ffmpeg flip video.mp4 --horizontal
fgp ffmpeg flip video.mp4 --vertical

# Crop video
fgp ffmpeg crop video.mp4 --width 1280 --height 720 --x 100 --y 50

# Add fade in/out
fgp ffmpeg fade video.mp4 --in 2 --out 2

# Convert to black & white
fgp ffmpeg filter video.mp4 --grayscale

# Blur video
fgp ffmpeg filter video.mp4 --blur 5

# Stabilize shaky video
fgp ffmpeg stabilize video.mp4
```

### Thumbnails

```bash
# Generate thumbnail grid
fgp ffmpeg thumbnails video.mp4 --grid 4x4

# Generate thumbnail at specific time
fgp ffmpeg thumbnail video.mp4 --at 00:01:00

# Generate thumbnail from best frame
fgp ffmpeg thumbnail video.mp4 --auto
```

### Subtitles

```bash
# Burn subtitles into video
fgp ffmpeg subtitles video.mp4 --file subs.srt

# Extract subtitles
fgp ffmpeg extract-subs video.mp4

# Add subtitle track (soft subs)
fgp ffmpeg add-subs video.mp4 --file subs.srt --output video_with_subs.mkv
```

### Batch Processing

```bash
# Convert all videos in folder
fgp ffmpeg batch convert ./videos --to mp4

# Compress all videos
fgp ffmpeg batch compress ./videos --quality medium

# Resize all videos
fgp ffmpeg batch resize ./videos --preset 720p

# Custom batch with pattern
fgp ffmpeg batch convert ./videos/*.avi --to mp4
```

### Streaming / HLS

```bash
# Create HLS stream
fgp ffmpeg hls video.mp4 --output stream/

# Create HLS with multiple qualities
fgp ffmpeg hls video.mp4 --qualities 1080p,720p,480p --output stream/

# Create DASH stream
fgp ffmpeg dash video.mp4 --output stream/
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `info` | Get video info | `fgp ffmpeg info video.mp4` |
| `probe` | Detailed probe | `fgp ffmpeg probe video.mp4` |
| `convert` | Format conversion | `fgp ffmpeg convert video.avi --to mp4` |
| `trim` | Cut video segment | `fgp ffmpeg trim video.mp4 --start 10 --end 30` |
| `extract-audio` | Extract audio | `fgp ffmpeg extract-audio video.mp4` |
| `frame` | Extract frame | `fgp ffmpeg frame video.mp4 --at 30` |
| `resize` | Scale video | `fgp ffmpeg resize video.mp4 --width 1280` |
| `compress` | Reduce file size | `fgp ffmpeg compress video.mp4 --quality medium` |
| `concat` | Join videos | `fgp ffmpeg concat a.mp4 b.mp4` |
| `watermark` | Add overlay | `fgp ffmpeg watermark video.mp4 --image logo.png` |
| `speed` | Change speed | `fgp ffmpeg speed video.mp4 --factor 2` |
| `thumbnails` | Generate thumbnails | `fgp ffmpeg thumbnails video.mp4 --grid 4x4` |

## Output Formats

### Video
- MP4 (H.264/H.265)
- WebM (VP8/VP9/AV1)
- MOV
- AVI
- MKV
- GIF
- WEBP (animated)

### Audio
- MP3
- AAC
- WAV
- FLAC
- OGG
- OPUS

### Images
- PNG
- JPEG
- WEBP
- BMP

## Example Workflows

### Prepare video for web
```bash
# Compress and resize for web
fgp ffmpeg compress video.mp4 --preset web --output web.mp4
```

### Create social media clip
```bash
# Trim, resize for Instagram, add watermark
fgp ffmpeg trim video.mp4 --start 0 --duration 60 | \
fgp ffmpeg resize --preset 1080x1080 | \
fgp ffmpeg watermark --text "@myhandle" --position bottom-right
```

### Extract podcast audio
```bash
# Extract audio from video podcast
fgp ffmpeg extract-audio recording.mp4 --format mp3 --output podcast.mp3
fgp ffmpeg normalize podcast.mp3
```

### Create video thumbnails for gallery
```bash
# Generate thumbnail grid for all videos
for f in *.mp4; do
  fgp ffmpeg thumbnails "$f" --grid 3x3 --output "thumbs/${f%.mp4}.jpg"
done
```

### Batch convert legacy formats
```bash
fgp ffmpeg batch convert ./archive --pattern "*.avi" --to mp4 --quality high
```

## Troubleshooting

### FFmpeg not found
```
Error: ffmpeg not found in PATH
```
Install FFmpeg: `brew install ffmpeg` or `apt install ffmpeg`

### Unsupported codec
```
Error: Encoder libx265 not found
```
Your FFmpeg build may not include all codecs. Try: `brew reinstall ffmpeg --with-all-codecs`

### Out of memory
```
Error: Cannot allocate memory
```
For large files, use streaming mode: `fgp ffmpeg convert large.mp4 --to webm --stream`

### Permission denied
```
Error: Permission denied
```
Check file permissions and output directory access.

## Architecture

- **FFmpeg subprocess** with persistent pipe
- **UNIX socket** at `~/.fgp/services/ffmpeg/daemon.sock`
- **Job queue** for batch operations
- **Progress streaming** via socket
- **Hardware acceleration** (VideoToolbox on macOS, NVENC on Linux)
