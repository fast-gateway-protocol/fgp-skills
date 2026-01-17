---
name: fgp-openai
description: Fast OpenAI operations via FGP daemon - 20-40x faster connection overhead. Use when user needs embeddings, completions, image generation, or OpenAI API calls. Triggers on "generate embedding", "openai completion", "dalle image", "whisper transcribe".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP OpenAI Daemon

Ultra-fast OpenAI API access with connection pooling. **20-40x faster** connection overhead (API latency depends on model).

## Why FGP?

| Operation | FGP Daemon | Direct API | Speedup |
|-----------|------------|------------|---------|
| Connection overhead | 2-5ms | ~100ms | **20-50x** |
| Embeddings (batch) | 15-30ms + API | ~150ms + API | **5-10x** |
| Image generation | 10-20ms + API | ~120ms + API | **6-12x** |

Persistent connection pooling eliminates per-request overhead.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-openai

# Or
bash ~/.claude/skills/fgp-openai/scripts/install.sh
```

## Setup

```bash
export OPENAI_API_KEY="sk-..."
```

## Usage

### Chat Completions

```bash
# Simple completion
fgp openai chat "What is the capital of France?"

# With model
fgp openai chat "Explain quantum computing" --model gpt-4o

# System message
fgp openai chat "Write a poem" --system "You are a creative poet"

# With temperature
fgp openai chat "Generate a story" --temperature 0.9

# Streaming
fgp openai chat "Tell me a story" --stream

# JSON mode
fgp openai chat "List 3 colors" --json

# From file
fgp openai chat --file prompt.txt
```

### Embeddings

```bash
# Single text
fgp openai embed "Hello world"

# Multiple texts
fgp openai embed "Text 1" "Text 2" "Text 3"

# From file
fgp openai embed --file texts.txt

# With model
fgp openai embed "Hello" --model text-embedding-3-large

# Output to file
fgp openai embed "Hello" --output embedding.json
```

### Image Generation (DALL-E)

```bash
# Generate image
fgp openai image "A cat wearing a hat"

# With size
fgp openai image "Mountain landscape" --size 1792x1024

# With quality
fgp openai image "Portrait" --quality hd

# With style
fgp openai image "Abstract art" --style vivid

# Multiple images
fgp openai image "Sunset" --n 4

# Save to file
fgp openai image "Robot" --output robot.png
```

### Image Analysis (Vision)

```bash
# Analyze image
fgp openai vision ./image.png "What's in this image?"

# From URL
fgp openai vision "https://example.com/image.jpg" "Describe this"

# Detailed analysis
fgp openai vision ./chart.png "Explain this chart in detail"
```

### Audio (Whisper)

```bash
# Transcribe audio
fgp openai transcribe ./audio.mp3

# With language hint
fgp openai transcribe ./audio.mp3 --language en

# Translate to English
fgp openai translate ./spanish-audio.mp3

# With timestamps
fgp openai transcribe ./audio.mp3 --timestamps

# Output formats
fgp openai transcribe ./audio.mp3 --format srt
fgp openai transcribe ./audio.mp3 --format vtt
```

### Text-to-Speech

```bash
# Generate speech
fgp openai speak "Hello, welcome to our service" --output welcome.mp3

# With voice
fgp openai speak "Breaking news" --voice nova

# Available voices: alloy, echo, fable, onyx, nova, shimmer

# With speed
fgp openai speak "Slow speech" --speed 0.8
```

### Assistants

```bash
# List assistants
fgp openai assistants

# Create assistant
fgp openai assistant create --name "Helper" --model gpt-4o --instructions "You are a helpful assistant"

# Run assistant
fgp openai assistant run <assistant-id> "Help me with this task"

# With file
fgp openai assistant run <assistant-id> "Analyze this" --file data.csv
```

### Files

```bash
# List files
fgp openai files

# Upload file
fgp openai file upload ./data.jsonl --purpose fine-tune

# Get file info
fgp openai file <file-id>

# Download file
fgp openai file download <file-id> --output data.jsonl

# Delete file
fgp openai file delete <file-id>
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `chat` | Chat completion | `fgp openai chat "Hello"` |
| `embed` | Get embeddings | `fgp openai embed "text"` |
| `image` | Generate image | `fgp openai image "prompt"` |
| `vision` | Analyze image | `fgp openai vision img.png "?"` |
| `transcribe` | Audio to text | `fgp openai transcribe audio.mp3` |
| `speak` | Text to speech | `fgp openai speak "text"` |
| `assistants` | List assistants | `fgp openai assistants` |
| `files` | List files | `fgp openai files` |

## Models

| Type | Models |
|------|--------|
| Chat | gpt-4o, gpt-4o-mini, gpt-4-turbo, gpt-3.5-turbo |
| Embeddings | text-embedding-3-small, text-embedding-3-large |
| Image | dall-e-3, dall-e-2 |
| Audio | whisper-1 |
| TTS | tts-1, tts-1-hd |

## Example Workflows

### Generate embeddings for RAG
```bash
# Embed documents
cat docs/*.txt | fgp openai embed --model text-embedding-3-small --output embeddings.json
```

### Transcribe meeting
```bash
fgp openai transcribe meeting.mp3 --format srt > meeting.srt
```

### Create image asset
```bash
fgp openai image "Professional logo for tech startup, minimal, blue" --size 1024x1024 --output logo.png
```

## Troubleshooting

### Invalid API key
```
Error: Invalid API key
```
Check `OPENAI_API_KEY` is correct.

### Rate limited
```
Error: Rate limit reached
```
Wait or upgrade your tier.

### Context too long
```
Error: Maximum context length exceeded
```
Reduce input length or use a model with larger context.

## Architecture

- **OpenAI REST API**
- **Connection pooling** for reduced latency
- **UNIX socket** at `~/.fgp/services/openai/daemon.sock`
- **Streaming support** for chat completions
