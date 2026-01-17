---
name: whisper-daemon
description: Fast audio transcription via FGP daemon - 3-10x faster than spawning whisper per file. Use when user needs to transcribe audio, convert speech to text, generate subtitles, or translate audio. Triggers on "transcribe audio", "speech to text", "whisper", "generate subtitles", "transcription", "audio to text".
license: MIT
compatibility: Requires fgp CLI and whisper.cpp or openai-whisper installed; optional OPENAI_API_KEY for cloud API
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Whisper Daemon

Ultra-fast audio transcription with persistent Whisper model. **3-10x faster** than spawning whisper per file.

## Why FGP?

| Operation | FGP Daemon | whisper CLI | Speedup |
|-----------|------------|-------------|---------|
| Model load | 0ms (cached) | ~5-30s | **∞** |
| Short audio (<30s) | 1-5s | 10-35s | **3-10x** |
| Long audio (5min) | 15-45s | 60-180s | **3-4x** |
| Batch (10 files) | 30-90s | 300-600s | **5-10x** |

Persistent daemon keeps model loaded in memory (GPU or CPU).

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-whisper

# Or
bash ~/.claude/skills/fgp-whisper/scripts/install.sh
```

### Prerequisites

For local inference, install whisper.cpp or openai-whisper:

```bash
# whisper.cpp (recommended - faster, less memory)
brew install whisper-cpp

# Or Python whisper
pip install openai-whisper

# For GPU acceleration (NVIDIA)
pip install openai-whisper[cuda]

# For Apple Silicon (uses Metal)
# whisper.cpp automatically uses Metal
```

For API-based transcription:
```bash
export OPENAI_API_KEY="sk-..."
```

## Usage

### Basic Transcription

```bash
# Transcribe audio file
fgp whisper transcribe audio.mp3

# Transcribe video file (extracts audio)
fgp whisper transcribe video.mp4

# Output to file
fgp whisper transcribe audio.mp3 --output transcript.txt

# With timestamps
fgp whisper transcribe audio.mp3 --timestamps

# Specific language
fgp whisper transcribe audio.mp3 --language en
fgp whisper transcribe audio.mp3 --language es
fgp whisper transcribe audio.mp3 --language ja
```

### Output Formats

```bash
# Plain text (default)
fgp whisper transcribe audio.mp3 --format txt

# JSON with segments
fgp whisper transcribe audio.mp3 --format json

# SRT subtitles
fgp whisper transcribe audio.mp3 --format srt

# VTT subtitles
fgp whisper transcribe audio.mp3 --format vtt

# TSV (tab-separated)
fgp whisper transcribe audio.mp3 --format tsv

# All formats
fgp whisper transcribe audio.mp3 --format all
```

### Models

```bash
# List available models
fgp whisper models

# Use specific model
fgp whisper transcribe audio.mp3 --model tiny      # Fastest, least accurate
fgp whisper transcribe audio.mp3 --model base      # Fast, good accuracy
fgp whisper transcribe audio.mp3 --model small     # Balanced (default)
fgp whisper transcribe audio.mp3 --model medium    # Better accuracy
fgp whisper transcribe audio.mp3 --model large     # Best accuracy, slowest
fgp whisper transcribe audio.mp3 --model large-v3  # Latest large model

# English-only models (faster)
fgp whisper transcribe audio.mp3 --model tiny.en
fgp whisper transcribe audio.mp3 --model base.en
fgp whisper transcribe audio.mp3 --model small.en
fgp whisper transcribe audio.mp3 --model medium.en

# Download model
fgp whisper download large-v3

# Check loaded model
fgp whisper status
```

### Translation

```bash
# Translate to English
fgp whisper translate audio.mp3

# Translate from specific language
fgp whisper translate audio.mp3 --from es

# Translate with subtitles
fgp whisper translate video.mp4 --format srt
```

### Language Detection

```bash
# Detect language
fgp whisper detect audio.mp3

# Get confidence scores
fgp whisper detect audio.mp3 --verbose
```

### Batch Processing

```bash
# Transcribe multiple files
fgp whisper batch *.mp3

# Transcribe folder
fgp whisper batch ./audio --output ./transcripts

# With specific format
fgp whisper batch ./audio --format srt --output ./subtitles

# Parallel processing
fgp whisper batch ./audio --parallel 4
```

### Real-time / Streaming

```bash
# Transcribe from microphone
fgp whisper stream

# Stream to file
fgp whisper stream --output live.txt

# Stream with translation
fgp whisper stream --translate

# Set audio device
fgp whisper stream --device 1
```

### Timestamps & Segments

```bash
# Word-level timestamps
fgp whisper transcribe audio.mp3 --word-timestamps

# Segment by sentence
fgp whisper transcribe audio.mp3 --segment sentence

# Custom segment length
fgp whisper transcribe audio.mp3 --segment-length 30

# Get specific time range
fgp whisper transcribe audio.mp3 --start 00:01:30 --end 00:05:00
```

### Speaker Diarization

```bash
# Identify speakers
fgp whisper transcribe audio.mp3 --diarize

# Set number of speakers
fgp whisper transcribe audio.mp3 --diarize --speakers 2

# With speaker labels
fgp whisper transcribe audio.mp3 --diarize --speaker-labels "Alice,Bob"
```

### Audio Processing

```bash
# Normalize audio before transcription
fgp whisper transcribe audio.mp3 --normalize

# Reduce noise
fgp whisper transcribe audio.mp3 --denoise

# Specific sample rate
fgp whisper transcribe audio.mp3 --sample-rate 16000

# Mono conversion
fgp whisper transcribe audio.mp3 --mono
```

### OpenAI API

```bash
# Use OpenAI API instead of local model
fgp whisper transcribe audio.mp3 --api openai

# With specific model
fgp whisper transcribe audio.mp3 --api openai --model whisper-1

# Set API key
export OPENAI_API_KEY="sk-..."
```

### Prompting

```bash
# Initial prompt for context
fgp whisper transcribe audio.mp3 --prompt "This is a podcast about technology."

# Technical vocabulary
fgp whisper transcribe audio.mp3 --prompt "Kubernetes, Docker, PostgreSQL, GraphQL"

# Prompt from file
fgp whisper transcribe audio.mp3 --prompt-file context.txt
```

### Performance Tuning

```bash
# CPU threads
fgp whisper transcribe audio.mp3 --threads 8

# GPU acceleration
fgp whisper transcribe audio.mp3 --device cuda

# Apple Metal (default on macOS)
fgp whisper transcribe audio.mp3 --device metal

# Beam size (accuracy vs speed)
fgp whisper transcribe audio.mp3 --beam-size 5

# Temperature (randomness)
fgp whisper transcribe audio.mp3 --temperature 0
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `transcribe` | Transcribe audio | `fgp whisper transcribe audio.mp3` |
| `translate` | Translate to English | `fgp whisper translate audio.mp3` |
| `detect` | Detect language | `fgp whisper detect audio.mp3` |
| `batch` | Batch transcribe | `fgp whisper batch *.mp3` |
| `stream` | Real-time from mic | `fgp whisper stream` |
| `models` | List models | `fgp whisper models` |
| `download` | Download model | `fgp whisper download large-v3` |
| `status` | Daemon status | `fgp whisper status` |

## Supported Formats

**Audio:**
- MP3, WAV, FLAC, OGG, M4A, AAC, WMA, AIFF

**Video (audio extracted):**
- MP4, MKV, AVI, MOV, WebM, FLV

**Output:**
- TXT, JSON, SRT, VTT, TSV

## Supported Languages

Whisper supports 99 languages including:

| Code | Language | Code | Language |
|------|----------|------|----------|
| en | English | es | Spanish |
| fr | French | de | German |
| it | Italian | pt | Portuguese |
| ru | Russian | ja | Japanese |
| ko | Korean | zh | Chinese |
| ar | Arabic | hi | Hindi |

Full list: `fgp whisper languages`

## Example Workflows

### Podcast transcription
```bash
# Transcribe podcast with speaker diarization
fgp whisper transcribe podcast.mp3 \
  --model medium \
  --diarize \
  --format json \
  --output podcast_transcript.json
```

### Video subtitles
```bash
# Generate SRT subtitles for video
fgp whisper transcribe video.mp4 \
  --format srt \
  --output video.srt

# For non-English video, translate subtitles
fgp whisper translate video.mp4 \
  --format srt \
  --output video_en.srt
```

### Meeting notes
```bash
# Transcribe meeting with timestamps
fgp whisper transcribe meeting.m4a \
  --model small \
  --timestamps \
  --diarize \
  --output meeting_notes.txt
```

### Batch process interviews
```bash
# Transcribe all interviews
fgp whisper batch ./interviews \
  --model medium \
  --format json \
  --diarize \
  --parallel 2 \
  --output ./transcripts
```

### Live captioning
```bash
# Real-time captions from microphone
fgp whisper stream --model base.en
```

## Troubleshooting

### Model not found
```
Error: Model 'large-v3' not found
```
Download model: `fgp whisper download large-v3`

### Out of memory
```
Error: CUDA out of memory
```
Use smaller model: `--model small` or use CPU: `--device cpu`

### Audio format error
```
Error: Unsupported audio format
```
Install ffmpeg: `brew install ffmpeg`

### Slow transcription
```
Tip: Transcription is slow
```
- Use GPU acceleration: `--device cuda` or `--device metal`
- Use smaller model: `--model base` or `--model tiny`
- Use English-only model: `--model small.en`

### Inaccurate results
```
Tip: Improve accuracy
```
- Use larger model: `--model large-v3`
- Add context prompt: `--prompt "Technical terms..."`
- Check audio quality

## Architecture

- **whisper.cpp** or **openai-whisper** backend
- **Model caching** in memory (GPU or CPU)
- **UNIX socket** at `~/.fgp/services/whisper/daemon.sock`
- **Metal acceleration** on Apple Silicon
- **CUDA acceleration** on NVIDIA GPUs
- **Streaming support** for real-time transcription
