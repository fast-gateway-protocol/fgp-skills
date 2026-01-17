---
name: fgp-replicate
description: Fast Replicate model inference via FGP daemon.
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
  categories: ["devtools", "automation", "ai"]
---

# FGP Replicate Daemon

Fast, persistent gateway to Replicate's model inference API. Run thousands of open-source ML models with minimal latency overhead.

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
brew install fgp-replicate

# Via npx
npx add-skill fgp-replicate
```

## Quick Start

```bash
# Set your API token
export REPLICATE_API_TOKEN="r8_..."

# Start the daemon
fgp start replicate

# Run a model
fgp call replicate.run \
  --model "stability-ai/sdxl" \
  --input '{"prompt": "A photo of an astronaut riding a horse"}'

# Run Llama
fgp call replicate.run \
  --model "meta/llama-2-70b-chat" \
  --input '{"prompt": "Explain quantum computing in simple terms"}'
```

## Methods

### Predictions

- `replicate.run` - Run a model and wait for results
  - `model` (string, required): Model identifier (owner/name or version)
  - `input` (object, required): Model-specific input parameters
  - `timeout` (int, optional): Max wait time in seconds (default: 300)

- `replicate.create` - Create prediction without waiting
  - `model` (string, required): Model identifier
  - `input` (object, required): Model-specific input
  - `webhook` (string, optional): URL for completion callback

- `replicate.get` - Get prediction status/results
  - `id` (string, required): Prediction ID

- `replicate.cancel` - Cancel a running prediction
  - `id` (string, required): Prediction ID

- `replicate.list` - List recent predictions
  - `cursor` (string, optional): Pagination cursor

### Models

- `replicate.models` - Search/list available models
  - `query` (string, optional): Search query
  - `owner` (string, optional): Filter by owner

## Popular Models

### Image Generation
- `stability-ai/sdxl` - Stable Diffusion XL
- `black-forest-labs/flux-schnell` - FLUX.1 Schnell (fast)
- `black-forest-labs/flux-dev` - FLUX.1 Dev (high quality)

### Language Models
- `meta/llama-2-70b-chat` - Llama 2 70B Chat
- `meta/llama-3-70b-instruct` - Llama 3 70B
- `mistralai/mixtral-8x7b-instruct` - Mixtral 8x7B

### Audio
- `openai/whisper` - Speech-to-text
- `suno-ai/bark` - Text-to-speech

### Video
- `stability-ai/stable-video-diffusion` - Image-to-video

## Configuration

Environment variables:
- `REPLICATE_API_TOKEN` (required): Your Replicate API token

## Examples

### Generate an image with SDXL

```bash
fgp call replicate.run \
  --model "stability-ai/sdxl" \
  --input '{
    "prompt": "A cyberpunk cityscape at night, neon lights, rain",
    "negative_prompt": "blurry, low quality",
    "width": 1024,
    "height": 1024,
    "num_inference_steps": 30
  }'
```

### Chat with Llama 3

```bash
fgp call replicate.run \
  --model "meta/llama-3-70b-instruct" \
  --input '{
    "prompt": "What are the key differences between Python and Rust?",
    "max_tokens": 500,
    "temperature": 0.7
  }'
```

### Transcribe audio

```bash
fgp call replicate.run \
  --model "openai/whisper" \
  --input '{
    "audio": "https://example.com/audio.mp3",
    "model": "large-v3",
    "language": "en"
  }'
```

### Async prediction with webhook

```bash
# Create prediction
fgp call replicate.create \
  --model "stability-ai/sdxl" \
  --input '{"prompt": "A sunset over mountains"}' \
  --webhook "https://your-server.com/webhook"

# Check status later
fgp call replicate.get --id "prediction_id_here"
```
