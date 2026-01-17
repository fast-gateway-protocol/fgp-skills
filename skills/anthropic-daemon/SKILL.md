---
name: anthropic-daemon
description: Fast Anthropic Claude API operations via FGP daemon - 15-30x faster than spawning API clients per request. Use when user needs Claude chat completions, streaming responses, token counting, or batch requests. Triggers on "claude chat", "anthropic api", "claude completion", "claude stream".
license: MIT
compatibility: Requires fgp CLI and Anthropic API Key (ANTHROPIC_API_KEY env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Anthropic Daemon

Fast Anthropic Claude API operations with persistent connection pooling.

## Why FGP?

| Operation | FGP Daemon | Direct API Client | Speedup |
|-----------|------------|-------------------|---------|
| Chat completion | 15ms overhead | 200-400ms cold | **15-25x** |
| Streaming | 5ms setup | 150ms setup | **30x** |
| Embeddings | 10ms | 180ms cold | **18x** |

## Installation

```bash
# Via Homebrew
brew install fast-gateway-protocol/fgp/fgp-anthropic

# Via npx
npx add-skill fast-gateway-protocol/fgp-skills --skill fgp-anthropic
```

## Setup

```bash
# Set your API key
export ANTHROPIC_API_KEY="sk-ant-..."

# Start the daemon
fgp start anthropic
```

## Usage

```bash
# Chat completion
fgp call anthropic.chat --model claude-sonnet-4-20250514 --message "Hello!"

# Streaming chat
fgp call anthropic.stream --model claude-sonnet-4-20250514 --message "Write a poem"

# List models
fgp call anthropic.models
```

## Available Commands

| Command | Description |
|---------|-------------|
| `anthropic.chat` | Send chat completion request |
| `anthropic.stream` | Streaming chat completion |
| `anthropic.models` | List available models |
| `anthropic.count_tokens` | Count tokens in text |
| `anthropic.batch` | Batch multiple requests |

## Example Workflows

### Code Review
```bash
fgp call anthropic.chat \
  --model claude-sonnet-4-20250514 \
  --system "You are a code reviewer" \
  --message "Review this code: $(cat main.py)"
```

### Document Analysis
```bash
fgp call anthropic.chat \
  --model claude-sonnet-4-20250514 \
  --message "Summarize this document" \
  --file report.pdf
```

## Architecture

- Persistent HTTPS connection pool
- Response caching for identical requests
- Automatic retry with exponential backoff
- Token counting without API calls
