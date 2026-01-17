---
name: stability-daemon
description: Fast Stability AI image generation via FGP daemon. Use when user needs to generate images, transform images, inpaint, upscale, or remove backgrounds with Stable Diffusion. Triggers on "stability generate", "stable diffusion", "generate image", "upscale image", "remove background", "inpaint image", "SD3".
license: MIT
compatibility: Requires fgp CLI and Stability AI API Key (STABILITY_API_KEY env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Stability AI Daemon

Fast, persistent gateway to Stability AI's image generation APIs. Generate, edit, and upscale images with Stable Diffusion models.

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
brew install fgp-stability

# Via npx
npx add-skill fgp-stability
```

## Quick Start

```bash
# Set your API key
export STABILITY_API_KEY="sk-..."

# Start the daemon
fgp start stability

# Generate an image
fgp call stability.generate \
  --prompt "A majestic mountain landscape at sunset" \
  --output "/tmp/mountain.png"

# Upscale an image
fgp call stability.upscale \
  --image "/tmp/mountain.png" \
  --output "/tmp/mountain_4x.png"
```

## Methods

### Text-to-Image

- `stability.generate` - Generate images from text prompts
  - `prompt` (string, required): Text description of the image
  - `negative_prompt` (string, optional): What to avoid in the image
  - `model` (string, optional): Model ID (default: stable-diffusion-xl-1024-v1-0)
  - `width` (int, optional): Image width (512-2048)
  - `height` (int, optional): Image height (512-2048)
  - `steps` (int, optional): Inference steps (10-50)
  - `cfg_scale` (float, optional): Prompt adherence (0-35)
  - `seed` (int, optional): Random seed for reproducibility
  - `samples` (int, optional): Number of images (1-10)
  - `output` (string, optional): Output file path

- `stability.generate_3` - Use Stable Diffusion 3
  - `prompt` (string, required): Text description
  - `model` (string, optional): sd3, sd3-turbo (default: sd3)
  - `aspect_ratio` (string, optional): 16:9, 1:1, 9:16, etc.
  - `output` (string, optional): Output file path

### Image-to-Image

- `stability.img2img` - Transform existing images
  - `image` (string, required): Input image path or URL
  - `prompt` (string, required): Transformation description
  - `strength` (float, optional): Transformation strength (0-1)
  - `cfg_scale` (float, optional): Prompt adherence
  - `output` (string, optional): Output file path

- `stability.inpaint` - Edit specific regions
  - `image` (string, required): Input image path
  - `mask` (string, required): Mask image (white = edit region)
  - `prompt` (string, required): What to generate in masked area
  - `output` (string, optional): Output file path

### Upscaling

- `stability.upscale` - Enhance image resolution
  - `image` (string, required): Input image path
  - `scale` (int, optional): Upscale factor (2 or 4, default: 4)
  - `output` (string, optional): Output file path

- `stability.upscale_creative` - Creative upscaling with enhancement
  - `image` (string, required): Input image path
  - `prompt` (string, optional): Guide the enhancement
  - `output` (string, optional): Output file path

### Utilities

- `stability.remove_background` - Remove image background
  - `image` (string, required): Input image path
  - `output` (string, optional): Output PNG with transparency

## Models

### Stable Diffusion XL
- `stable-diffusion-xl-1024-v1-0` - SDXL 1.0 (default)
- `stable-diffusion-xl-1024-v0-9` - SDXL 0.9

### Stable Diffusion 3
- `sd3` - Stable Diffusion 3 (best quality)
- `sd3-turbo` - SD3 Turbo (faster)

### Legacy
- `stable-diffusion-v1-6` - SD 1.6

## Configuration

Environment variables:
- `STABILITY_API_KEY` (required): Your Stability AI API key

## Examples

### High-quality landscape

```bash
fgp call stability.generate \
  --prompt "A serene Japanese garden with cherry blossoms, koi pond, traditional bridge, morning mist, photorealistic, 8k" \
  --negative_prompt "blurry, low quality, distorted" \
  --model "stable-diffusion-xl-1024-v1-0" \
  --width 1536 \
  --height 1024 \
  --steps 40 \
  --cfg_scale 7.5 \
  --output "/tmp/garden.png"
```

### SD3 with aspect ratio

```bash
fgp call stability.generate_3 \
  --prompt "A futuristic cityscape with flying cars, neon lights, cyberpunk aesthetic" \
  --model "sd3" \
  --aspect_ratio "21:9" \
  --output "/tmp/cyberpunk.png"
```

### Style transfer with img2img

```bash
fgp call stability.img2img \
  --image "/tmp/photo.jpg" \
  --prompt "Transform into Studio Ghibli anime style, vibrant colors" \
  --strength 0.7 \
  --output "/tmp/anime_style.png"
```

### Inpainting to replace object

```bash
fgp call stability.inpaint \
  --image "/tmp/room.jpg" \
  --mask "/tmp/room_mask.png" \
  --prompt "A modern minimalist sofa, Scandinavian design" \
  --output "/tmp/room_new_sofa.png"
```

### 4x upscale

```bash
fgp call stability.upscale \
  --image "/tmp/small.png" \
  --scale 4 \
  --output "/tmp/large.png"
```

### Remove background

```bash
fgp call stability.remove_background \
  --image "/tmp/product.jpg" \
  --output "/tmp/product_transparent.png"
```
