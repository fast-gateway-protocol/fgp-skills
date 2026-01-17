---
name: ollama-daemon
description: Fast local Ollama model inference via FGP daemon. Use when user needs local LLM chat, text generation, embeddings, or model management. Triggers on "ollama chat", "local llm", "ollama generate", "ollama embed", "pull model", "run llama locally".
license: MIT
compatibility: Requires fgp CLI and Ollama installed and running (ollama serve)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Ollama Daemon

Fast, persistent gateway to local Ollama models. Run LLMs locally with minimal latency overhead between requests.

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
brew install fgp-ollama

# Via npx
npx add-skill fgp-ollama
```

**Prerequisites:** Ollama must be installed and running.
```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Start Ollama server
ollama serve
```

## Quick Start

```bash
# Start the daemon
fgp start ollama

# Pull a model
fgp call ollama.pull --model "llama3.2"

# Chat
fgp call ollama.chat \
  --model "llama3.2" \
  --messages '[{"role": "user", "content": "Hello!"}]'

# Generate embeddings
fgp call ollama.embed --model "nomic-embed-text" --input "Hello world"
```

## Methods

### Chat & Generation

- `ollama.chat` - Chat completion
  - `model` (string, required): Model name
  - `messages` (array, required): Chat messages
  - `options` (object, optional): Generation options
    - `temperature` (float): Sampling temperature
    - `num_predict` (int): Max tokens to generate
    - `top_p` (float): Nucleus sampling
    - `top_k` (int): Top-k sampling
  - `stream` (bool, optional): Enable streaming

- `ollama.generate` - Raw text generation
  - `model` (string, required): Model name
  - `prompt` (string, required): Input prompt
  - `system` (string, optional): System prompt
  - `options` (object, optional): Generation options

### Embeddings

- `ollama.embed` - Generate embeddings
  - `model` (string, required): Embedding model name
  - `input` (string|array, required): Text(s) to embed

### Model Management

- `ollama.list` - List available models
  - No parameters required

- `ollama.pull` - Download a model
  - `model` (string, required): Model name to pull
  - `insecure` (bool, optional): Allow insecure connections

- `ollama.delete` - Remove a model
  - `model` (string, required): Model name to delete

- `ollama.show` - Get model details
  - `model` (string, required): Model name

- `ollama.copy` - Duplicate a model
  - `source` (string, required): Source model name
  - `destination` (string, required): New model name

## Popular Models

### Chat Models
- `llama3.2` - Llama 3.2 (3B) - Fast, good quality
- `llama3.2:70b` - Llama 3.2 (70B) - Best quality
- `mistral` - Mistral 7B
- `mixtral` - Mixtral 8x7B
- `phi3` - Microsoft Phi-3
- `gemma2` - Google Gemma 2
- `qwen2.5` - Alibaba Qwen 2.5

### Code Models
- `codellama` - Code Llama
- `deepseek-coder` - DeepSeek Coder
- `starcoder2` - StarCoder 2

### Embedding Models
- `nomic-embed-text` - Fast, high quality
- `mxbai-embed-large` - Large embeddings
- `all-minilm` - Compact, efficient

### Vision Models
- `llava` - LLaVA (vision + language)
- `bakllava` - BakLLaVA

## Configuration

Environment variables:
- `OLLAMA_HOST` (optional): Ollama server URL (default: http://localhost:11434)

## Examples

### Multi-turn conversation

```bash
fgp call ollama.chat \
  --model "llama3.2" \
  --messages '[
    {"role": "system", "content": "You are a helpful coding assistant."},
    {"role": "user", "content": "Write a Python function to reverse a string"},
    {"role": "assistant", "content": "def reverse_string(s): return s[::-1]"},
    {"role": "user", "content": "Now add type hints"}
  ]'
```

### Generate with custom parameters

```bash
fgp call ollama.generate \
  --model "mistral" \
  --prompt "Write a haiku about programming:" \
  --system "You are a creative poet." \
  --options '{
    "temperature": 0.9,
    "num_predict": 50,
    "top_p": 0.95
  }'
```

### Batch embeddings

```bash
fgp call ollama.embed \
  --model "nomic-embed-text" \
  --input '["First document", "Second document", "Third document"]'
```

### Pull and use a new model

```bash
# Pull the model
fgp call ollama.pull --model "deepseek-coder:6.7b"

# Use it for code generation
fgp call ollama.generate \
  --model "deepseek-coder:6.7b" \
  --prompt "Write a Rust function to calculate fibonacci numbers"
```

### Check available models

```bash
fgp call ollama.list
```

### Get model information

```bash
fgp call ollama.show --model "llama3.2"
```

### Use with vision model

```bash
fgp call ollama.chat \
  --model "llava" \
  --messages '[{
    "role": "user",
    "content": "What is in this image?",
    "images": ["/path/to/image.jpg"]
  }]'
```

## Performance Tips

1. **Keep models loaded:** Ollama keeps recently used models in memory. Reuse the same model to avoid load times.

2. **Use smaller models for simple tasks:** `llama3.2` (3B) is often sufficient and much faster than 70B.

3. **Batch embeddings:** Send multiple texts in one call to `ollama.embed` for better throughput.

4. **Adjust num_predict:** Set a reasonable `num_predict` limit to avoid unnecessarily long generations.
