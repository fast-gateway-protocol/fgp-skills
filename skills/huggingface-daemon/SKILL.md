---
name: huggingface-daemon
description: Fast Hugging Face Inference API via FGP daemon. Use when user needs text generation, embeddings, classification, image captioning, or model inference. Triggers on "huggingface inference", "generate text", "get embeddings", "classify text", "hugging face", "HF model", "zero-shot".
license: MIT
compatibility: Requires fgp CLI and optional HF_API_TOKEN for private models
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Hugging Face Daemon

Fast, persistent gateway to Hugging Face's Inference API. Access 400,000+ models with minimal latency overhead.

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
brew install fgp-huggingface

# Via npx
npx add-skill fgp-huggingface
```

## Quick Start

```bash
# Set your API token (optional for public models)
export HF_API_TOKEN="hf_..."

# Start the daemon
fgp start huggingface

# Text generation
fgp call huggingface.generate \
  --model "mistralai/Mistral-7B-Instruct-v0.2" \
  --inputs "Explain machine learning in simple terms:"

# Embeddings
fgp call huggingface.embed \
  --model "sentence-transformers/all-MiniLM-L6-v2" \
  --inputs "Hello world"
```

## Methods

### Text Generation

- `huggingface.generate` - Generate text with language models
  - `model` (string, required): Model ID on Hugging Face Hub
  - `inputs` (string, required): Input text/prompt
  - `parameters` (object, optional): Generation parameters
    - `max_new_tokens` (int): Maximum tokens to generate
    - `temperature` (float): Sampling temperature
    - `top_p` (float): Nucleus sampling threshold
    - `do_sample` (bool): Enable sampling

- `huggingface.chat` - Chat completion (for chat models)
  - `model` (string, required): Chat model ID
  - `messages` (array, required): Chat messages
  - `parameters` (object, optional): Generation parameters

### Embeddings

- `huggingface.embed` - Generate embeddings
  - `model` (string, required): Embedding model ID
  - `inputs` (string|array, required): Text(s) to embed

### Classification

- `huggingface.classify` - Text classification
  - `model` (string, required): Classification model ID
  - `inputs` (string, required): Text to classify

- `huggingface.zero_shot` - Zero-shot classification
  - `model` (string, required): Zero-shot model ID
  - `inputs` (string, required): Text to classify
  - `candidate_labels` (array, required): Possible labels

### Vision

- `huggingface.image_classify` - Image classification
  - `model` (string, required): Vision model ID
  - `image` (string, required): Image URL or base64

- `huggingface.image_to_text` - Image captioning
  - `model` (string, required): Captioning model ID
  - `image` (string, required): Image URL or base64

## Popular Models

### Text Generation
- `mistralai/Mistral-7B-Instruct-v0.2` - Mistral 7B Instruct
- `meta-llama/Llama-2-7b-chat-hf` - Llama 2 7B Chat
- `HuggingFaceH4/zephyr-7b-beta` - Zephyr 7B

### Embeddings
- `sentence-transformers/all-MiniLM-L6-v2` - Fast, general-purpose
- `BAAI/bge-large-en-v1.5` - High quality English
- `intfloat/multilingual-e5-large` - Multilingual

### Classification
- `facebook/bart-large-mnli` - Zero-shot classification
- `cardiffnlp/twitter-roberta-base-sentiment` - Sentiment analysis
- `MoritzLaworker/topic-classification` - Topic detection

### Vision
- `Salesforce/blip-image-captioning-large` - Image captioning
- `google/vit-base-patch16-224` - Image classification
- `facebook/detr-resnet-50` - Object detection

## Configuration

Environment variables:
- `HF_API_TOKEN` (optional): Your Hugging Face API token
- `HF_INFERENCE_ENDPOINT` (optional): Custom inference endpoint URL

## Examples

### Text generation with parameters

```bash
fgp call huggingface.generate \
  --model "mistralai/Mistral-7B-Instruct-v0.2" \
  --inputs "[INST] Write a haiku about programming [/INST]" \
  --parameters '{
    "max_new_tokens": 100,
    "temperature": 0.8,
    "do_sample": true
  }'
```

### Zero-shot classification

```bash
fgp call huggingface.zero_shot \
  --model "facebook/bart-large-mnli" \
  --inputs "I just bought a new iPhone and it's amazing!" \
  --candidate_labels '["technology", "sports", "politics", "entertainment"]'
```

### Batch embeddings

```bash
fgp call huggingface.embed \
  --model "sentence-transformers/all-MiniLM-L6-v2" \
  --inputs '["First sentence", "Second sentence", "Third sentence"]'
```

### Image captioning

```bash
fgp call huggingface.image_to_text \
  --model "Salesforce/blip-image-captioning-large" \
  --image "https://example.com/photo.jpg"
```

### Sentiment analysis

```bash
fgp call huggingface.classify \
  --model "cardiffnlp/twitter-roberta-base-sentiment" \
  --inputs "I love using FGP! It makes everything so fast."
```
