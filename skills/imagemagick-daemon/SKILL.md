---
name: imagemagick-daemon
description: Fast image processing via FGP daemon - 5-25x faster than spawning convert per operation. Use when user needs to resize images, convert formats, add watermarks, crop, compress, or batch process images. Triggers on "resize image", "convert image", "compress image", "imagemagick", "image processing", "thumbnail", "crop image".
license: MIT
compatibility: Requires fgp CLI and ImageMagick installed (brew install imagemagick)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP ImageMagick Daemon

Ultra-fast image processing with persistent ImageMagick instance. **5-25x faster** than spawning convert per command.

## Why FGP?

| Operation | FGP Daemon | Direct convert | Speedup |
|-----------|------------|----------------|---------|
| Identify/info | 1-3ms | ~40ms | **15-40x** |
| Resize | 5-15ms | ~60ms | **4-12x** |
| Convert format | 3-10ms | ~50ms | **5-17x** |
| Thumbnail | 4-12ms | ~55ms | **5-14x** |

Persistent daemon eliminates process spawn overhead.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-imagemagick

# Or
bash ~/.claude/skills/fgp-imagemagick/scripts/install.sh
```

### Prerequisites

ImageMagick must be installed:
```bash
# macOS
brew install imagemagick

# Ubuntu/Debian
sudo apt install imagemagick

# Verify
magick --version  # or convert --version
```

## Usage

### Info / Identify

```bash
# Get image info
fgp im info image.jpg

# Get dimensions only
fgp im size image.jpg

# Get format
fgp im format image.jpg

# Detailed metadata (EXIF, etc.)
fgp im identify image.jpg --verbose

# Get specific property
fgp im identify image.jpg --property width
fgp im identify image.jpg --property colorspace
```

### Format Conversion

```bash
# Convert to PNG
fgp im convert image.jpg --to png

# Convert to WebP
fgp im convert image.png --to webp

# Convert to JPEG with quality
fgp im convert image.png --to jpg --quality 85

# Convert to AVIF (modern format)
fgp im convert image.jpg --to avif

# Convert to ICO (favicon)
fgp im convert logo.png --to ico --sizes 16,32,48

# Convert to PDF
fgp im convert image.jpg --to pdf
```

### Resize / Scale

```bash
# Resize to specific dimensions
fgp im resize image.jpg --size 800x600

# Resize by width (maintain aspect)
fgp im resize image.jpg --width 1200

# Resize by height (maintain aspect)
fgp im resize image.jpg --height 800

# Scale by percentage
fgp im resize image.jpg --scale 50%

# Resize to fit within bounds (contain)
fgp im resize image.jpg --fit 1920x1080

# Resize to fill bounds (cover)
fgp im resize image.jpg --fill 1920x1080

# Resize with specific algorithm
fgp im resize image.jpg --width 800 --filter lanczos
```

### Thumbnails

```bash
# Create thumbnail
fgp im thumbnail image.jpg --size 150x150

# Thumbnail with crop (exact size)
fgp im thumbnail image.jpg --size 150x150 --crop

# Multiple thumbnail sizes
fgp im thumbnail image.jpg --sizes "150x150,300x300,600x600"

# Thumbnail strip (multiple images in one)
fgp im thumbnail-strip *.jpg --size 100x100 --output strip.jpg
```

### Crop

```bash
# Crop to size from center
fgp im crop image.jpg --size 800x600

# Crop with offset
fgp im crop image.jpg --size 800x600 --x 100 --y 50

# Crop with gravity
fgp im crop image.jpg --size 800x600 --gravity center
fgp im crop image.jpg --size 800x600 --gravity northwest

# Smart crop (content-aware)
fgp im crop image.jpg --size 800x600 --smart

# Trim whitespace/borders
fgp im trim image.jpg

# Trim with fuzz tolerance
fgp im trim image.jpg --fuzz 10%
```

### Compress / Optimize

```bash
# Optimize JPEG
fgp im compress image.jpg --quality 80

# Optimize PNG (lossless)
fgp im compress image.png

# Aggressive compression
fgp im compress image.jpg --quality 60

# Strip metadata (reduce size)
fgp im compress image.jpg --strip

# Target file size
fgp im compress image.jpg --target-size 100KB

# Web optimization preset
fgp im compress image.jpg --preset web
```

### Watermark / Overlay

```bash
# Add image watermark
fgp im watermark image.jpg --image logo.png

# Position watermark
fgp im watermark image.jpg --image logo.png --position bottom-right
fgp im watermark image.jpg --image logo.png --gravity southeast --offset 10x10

# Watermark with opacity
fgp im watermark image.jpg --image logo.png --opacity 50%

# Text watermark
fgp im watermark image.jpg --text "© 2024 Company"

# Text with styling
fgp im watermark image.jpg --text "© 2024" --font "Arial" --size 24 --color white
```

### Effects & Filters

```bash
# Blur
fgp im blur image.jpg --radius 5

# Gaussian blur
fgp im blur image.jpg --gaussian 0x3

# Sharpen
fgp im sharpen image.jpg

# Grayscale
fgp im grayscale image.jpg

# Sepia
fgp im sepia image.jpg

# Negate/Invert
fgp im negate image.jpg

# Adjust brightness/contrast
fgp im adjust image.jpg --brightness 10 --contrast 20

# Adjust saturation
fgp im adjust image.jpg --saturation 120%

# Auto-enhance
fgp im enhance image.jpg

# Normalize/stretch histogram
fgp im normalize image.jpg
```

### Rotate / Flip

```bash
# Rotate by degrees
fgp im rotate image.jpg --degrees 90
fgp im rotate image.jpg --degrees -45

# Auto-rotate based on EXIF
fgp im rotate image.jpg --auto

# Flip horizontal
fgp im flip image.jpg --horizontal

# Flip vertical
fgp im flip image.jpg --vertical

# Transpose
fgp im transpose image.jpg
```

### Color Operations

```bash
# Convert colorspace
fgp im colorspace image.jpg --to srgb
fgp im colorspace image.jpg --to cmyk

# Reduce colors (quantize)
fgp im colors image.png --count 256

# Make transparent
fgp im transparent image.png --color white --fuzz 10%

# Replace color
fgp im replace-color image.png --from red --to blue

# Extract channel
fgp im channel image.jpg --extract red
```

### Borders & Padding

```bash
# Add border
fgp im border image.jpg --size 10 --color black

# Add padding
fgp im pad image.jpg --size 20 --color white

# Extend canvas
fgp im extend image.jpg --size 1920x1080 --gravity center --color "#f0f0f0"

# Round corners
fgp im round image.jpg --radius 20
```

### Composite / Merge

```bash
# Overlay images
fgp im composite base.jpg overlay.png --position 100x100

# Blend images
fgp im blend image1.jpg image2.jpg --amount 50%

# Montage (grid of images)
fgp im montage *.jpg --tile 3x3 --geometry 200x200+5+5

# Append images
fgp im append image1.jpg image2.jpg --horizontal
fgp im append image1.jpg image2.jpg --vertical

# Stack with labels
fgp im montage *.jpg --tile 2x --label "%f"
```

### Text & Annotation

```bash
# Add text
fgp im text image.jpg --text "Hello World" --position 10x30

# Styled text
fgp im text image.jpg --text "Title" --font "Helvetica-Bold" --size 48 --color white --position center

# Text with background
fgp im text image.jpg --text "Caption" --background black --color white --position bottom

# Draw rectangle
fgp im draw image.jpg --rectangle 100x100+50+50 --color red

# Draw line
fgp im draw image.jpg --line "10,10 100,100" --color blue
```

### Batch Processing

```bash
# Convert all images in folder
fgp im batch convert ./images --to webp

# Resize all images
fgp im batch resize ./images --width 800

# Compress all images
fgp im batch compress ./images --quality 80

# Thumbnail all images
fgp im batch thumbnail ./images --size 150x150 --output ./thumbs

# Custom batch with pattern
fgp im batch convert ./photos/*.png --to jpg --quality 90
```

### Sprite Sheets

```bash
# Create sprite sheet
fgp im sprite icons/*.png --output sprite.png --css sprite.css

# Sprite with padding
fgp im sprite icons/*.png --output sprite.png --padding 2
```

### Compare / Diff

```bash
# Compare images
fgp im compare image1.jpg image2.jpg

# Get difference percentage
fgp im diff image1.jpg image2.jpg

# Visual diff output
fgp im diff image1.jpg image2.jpg --output diff.png
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `info` | Get image info | `fgp im info image.jpg` |
| `convert` | Format conversion | `fgp im convert image.jpg --to png` |
| `resize` | Scale image | `fgp im resize image.jpg --width 800` |
| `thumbnail` | Create thumbnail | `fgp im thumbnail image.jpg --size 150x150` |
| `crop` | Crop image | `fgp im crop image.jpg --size 800x600` |
| `compress` | Optimize/compress | `fgp im compress image.jpg --quality 80` |
| `watermark` | Add overlay | `fgp im watermark image.jpg --image logo.png` |
| `blur` | Blur image | `fgp im blur image.jpg --radius 5` |
| `grayscale` | Convert to B&W | `fgp im grayscale image.jpg` |
| `rotate` | Rotate image | `fgp im rotate image.jpg --degrees 90` |
| `batch` | Batch process | `fgp im batch resize ./images --width 800` |

## Output Formats

- **Raster**: JPEG, PNG, WebP, AVIF, GIF, BMP, TIFF, ICO
- **Vector**: SVG, PDF, EPS
- **Raw**: DNG, CR2, NEF (read only)
- **Special**: HDR, EXR

## Example Workflows

### Prepare images for web
```bash
# Resize, compress, convert to WebP
fgp im resize photo.jpg --width 1200 | \
fgp im compress --quality 80 | \
fgp im convert --to webp
```

### Create responsive image set
```bash
# Generate multiple sizes
for size in 320 640 1024 1920; do
  fgp im resize image.jpg --width $size --output "image-${size}w.webp"
done
```

### Process product photos
```bash
# Standardize product images
fgp im batch resize ./products --fill 1000x1000 --background white
fgp im batch watermark ./products --image logo.png --position bottom-right --opacity 30%
```

### Create favicon set
```bash
# Generate all favicon sizes
fgp im convert logo.png --to ico --sizes 16,32,48,64,128,256 --output favicon.ico
fgp im resize logo.png --size 180x180 --output apple-touch-icon.png
fgp im resize logo.png --size 192x192 --output icon-192.png
fgp im resize logo.png --size 512x512 --output icon-512.png
```

### Batch optimize uploads
```bash
# Compress all uploaded images
fgp im batch compress ./uploads --quality 85 --strip --preset web
```

## Troubleshooting

### ImageMagick not found
```
Error: magick/convert not found in PATH
```
Install ImageMagick: `brew install imagemagick` or `apt install imagemagick`

### Unsupported format
```
Error: no decode delegate for this image format
```
Your ImageMagick may need additional delegates. Try: `brew reinstall imagemagick --with-all`

### Memory limit exceeded
```
Error: cache resources exhausted
```
For large images, increase limits: `fgp im config --memory 2GB`

### Permission denied
```
Error: Permission denied
```
Check file permissions and output directory access.

## Architecture

- **ImageMagick** subprocess with persistent connection
- **UNIX socket** at `~/.fgp/services/imagemagick/daemon.sock`
- **Job queue** for batch operations
- **Memory-mapped** for large images
- **GPU acceleration** when available (OpenCL)
