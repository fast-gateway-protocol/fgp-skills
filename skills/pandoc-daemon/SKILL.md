---
name: pandoc-daemon
description: Fast document conversion via FGP daemon - 10-30x faster than spawning pandoc per operation. Use when user needs to convert markdown, docx, pdf, html, latex, epub, or other document formats. Triggers on "convert markdown", "markdown to pdf", "docx to markdown", "pandoc", "document conversion", "export to pdf".
license: MIT
compatibility: Requires fgp CLI and Pandoc installed (brew install pandoc); for PDF output also requires LaTeX
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Pandoc Daemon

Ultra-fast document conversion with persistent Pandoc instance. **10-30x faster** than spawning pandoc per command.

## Why FGP?

| Operation | FGP Daemon | Direct pandoc | Speedup |
|-----------|------------|---------------|---------|
| Markdown → HTML | 2-5ms | ~50ms | **10-25x** |
| Markdown → PDF | 20-50ms | ~300ms | **6-15x** |
| DOCX → Markdown | 10-25ms | ~150ms | **6-15x** |
| HTML → EPUB | 15-40ms | ~200ms | **5-13x** |

Persistent daemon eliminates Haskell runtime startup overhead.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-pandoc

# Or
bash ~/.claude/skills/fgp-pandoc/scripts/install.sh
```

### Prerequisites

Pandoc must be installed:
```bash
# macOS
brew install pandoc

# For PDF output, also install:
brew install basictex  # or mactex for full install

# Ubuntu/Debian
sudo apt install pandoc texlive-xetex

# Verify
pandoc --version
```

## Usage

### Basic Conversion

```bash
# Markdown to HTML
fgp pandoc convert doc.md --to html

# Markdown to PDF
fgp pandoc convert doc.md --to pdf

# Markdown to DOCX
fgp pandoc convert doc.md --to docx

# DOCX to Markdown
fgp pandoc convert doc.docx --to markdown

# HTML to Markdown
fgp pandoc convert page.html --to markdown

# With output file
fgp pandoc convert doc.md --to pdf --output document.pdf
```

### Supported Formats

**Input formats:**
- Markdown (md, markdown, gfm, commonmark)
- HTML (html, html5)
- Word (docx)
- OpenDocument (odt)
- LaTeX (tex, latex)
- reStructuredText (rst)
- Org-mode (org)
- Textile, MediaWiki, Jira, and more

**Output formats:**
- HTML (html, html5)
- PDF (via LaTeX or wkhtmltopdf)
- Word (docx)
- EPUB (epub, epub3)
- LaTeX (tex, latex)
- Presentation (pptx, revealjs, beamer)
- Plain text (plain)
- And 40+ more

### Markdown Flavors

```bash
# GitHub Flavored Markdown
fgp pandoc convert doc.md --from gfm --to html

# CommonMark
fgp pandoc convert doc.md --from commonmark --to html

# Pandoc Markdown (default)
fgp pandoc convert doc.md --from markdown --to html

# With extensions
fgp pandoc convert doc.md --from markdown+emoji+footnotes --to html
```

### PDF Generation

```bash
# Basic PDF
fgp pandoc convert doc.md --to pdf

# With custom template
fgp pandoc convert doc.md --to pdf --template report.tex

# With table of contents
fgp pandoc convert doc.md --to pdf --toc

# With numbered sections
fgp pandoc convert doc.md --to pdf --number-sections

# Custom margins
fgp pandoc convert doc.md --to pdf --margin 1in

# Custom font
fgp pandoc convert doc.md --to pdf --font "Helvetica"

# A4 paper
fgp pandoc convert doc.md --to pdf --paper a4

# Via HTML (faster, different styling)
fgp pandoc convert doc.md --to pdf --engine wkhtmltopdf
```

### DOCX Generation

```bash
# Basic DOCX
fgp pandoc convert doc.md --to docx

# With reference doc (for styling)
fgp pandoc convert doc.md --to docx --reference-doc template.docx

# With table of contents
fgp pandoc convert doc.md --to docx --toc

# Preserve formatting from source
fgp pandoc convert source.html --to docx --track-changes
```

### EPUB Generation

```bash
# Basic EPUB
fgp pandoc convert book.md --to epub

# EPUB3
fgp pandoc convert book.md --to epub3

# With cover image
fgp pandoc convert book.md --to epub --cover cover.jpg

# With metadata
fgp pandoc convert book.md --to epub --metadata title="My Book" --metadata author="Name"

# With CSS styling
fgp pandoc convert book.md --to epub --css style.css

# With table of contents
fgp pandoc convert book.md --to epub --toc --toc-depth 2
```

### Presentations

```bash
# PowerPoint
fgp pandoc convert slides.md --to pptx

# With template
fgp pandoc convert slides.md --to pptx --reference-doc template.pptx

# Reveal.js (HTML slides)
fgp pandoc convert slides.md --to revealjs --output slides.html

# Reveal.js with theme
fgp pandoc convert slides.md --to revealjs --variable theme=moon

# Beamer (LaTeX PDF slides)
fgp pandoc convert slides.md --to beamer --output slides.pdf
```

### LaTeX

```bash
# Markdown to LaTeX
fgp pandoc convert doc.md --to latex

# With document class
fgp pandoc convert doc.md --to latex --documentclass article

# With custom preamble
fgp pandoc convert doc.md --to latex --include-in-header preamble.tex

# LaTeX to PDF
fgp pandoc convert doc.tex --to pdf
```

### HTML Options

```bash
# Standalone HTML (with head/body)
fgp pandoc convert doc.md --to html --standalone

# With custom CSS
fgp pandoc convert doc.md --to html --css style.css

# With syntax highlighting
fgp pandoc convert doc.md --to html --highlight-style pygments

# Self-contained (embedded images/CSS)
fgp pandoc convert doc.md --to html --self-contained

# With MathJax for equations
fgp pandoc convert doc.md --to html --mathjax

# HTML5 semantic elements
fgp pandoc convert doc.md --to html5
```

### Metadata & Variables

```bash
# Set title
fgp pandoc convert doc.md --to pdf --metadata title="Report"

# Set multiple metadata
fgp pandoc convert doc.md --to pdf \
  --metadata title="Report" \
  --metadata author="John Doe" \
  --metadata date="2024-01-15"

# From YAML file
fgp pandoc convert doc.md --to pdf --metadata-file metadata.yaml

# Template variables
fgp pandoc convert doc.md --to html --variable fontsize=12pt
```

### Filters & Processing

```bash
# With Lua filter
fgp pandoc convert doc.md --to html --lua-filter filter.lua

# With multiple filters
fgp pandoc convert doc.md --to pdf --filter pandoc-crossref --filter pandoc-citeproc

# Bibliography/citations
fgp pandoc convert doc.md --to pdf --citeproc --bibliography refs.bib

# Citation style
fgp pandoc convert doc.md --to pdf --citeproc --csl ieee.csl
```

### Templates

```bash
# List available templates
fgp pandoc templates --format html

# Use custom template
fgp pandoc convert doc.md --to html --template custom.html

# Get default template (for customization)
fgp pandoc template html > my-template.html
```

### Batch Conversion

```bash
# Convert all markdown files
fgp pandoc batch convert ./docs --to html

# Convert to PDF
fgp pandoc batch convert ./chapters --to pdf --output ./pdfs

# With options
fgp pandoc batch convert ./posts --to html --css blog.css --standalone

# Pattern matching
fgp pandoc batch convert ./docs/*.md --to docx
```

### Extract & Transform

```bash
# Extract text from DOCX
fgp pandoc convert doc.docx --to plain

# Extract to Markdown (clean)
fgp pandoc convert doc.docx --to gfm

# Strip formatting
fgp pandoc convert doc.html --to plain --wrap none

# JSON AST (for processing)
fgp pandoc convert doc.md --to json

# From JSON AST
fgp pandoc convert doc.json --from json --to html
```

### Combine Documents

```bash
# Merge multiple files
fgp pandoc merge chapter1.md chapter2.md chapter3.md --to pdf --output book.pdf

# With metadata file
fgp pandoc merge --metadata-file book.yaml *.md --to epub --output book.epub

# From file list
fgp pandoc merge --files chapters.txt --to pdf
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `convert` | Convert document | `fgp pandoc convert doc.md --to pdf` |
| `batch` | Batch convert | `fgp pandoc batch convert ./docs --to html` |
| `merge` | Combine documents | `fgp pandoc merge *.md --to pdf` |
| `template` | Get template | `fgp pandoc template html` |
| `templates` | List templates | `fgp pandoc templates --format pdf` |
| `formats` | List formats | `fgp pandoc formats` |
| `extensions` | List extensions | `fgp pandoc extensions markdown` |

## Common Workflows

### Blog post publishing
```bash
# Markdown to SEO-friendly HTML
fgp pandoc convert post.md --to html5 \
  --standalone \
  --metadata-file post.yaml \
  --css blog.css \
  --output post.html
```

### Academic paper
```bash
# With citations and cross-references
fgp pandoc convert paper.md --to pdf \
  --citeproc \
  --bibliography refs.bib \
  --csl ieee.csl \
  --filter pandoc-crossref \
  --number-sections \
  --toc
```

### Technical documentation
```bash
# Markdown to DOCX for clients
fgp pandoc convert docs/*.md --to docx \
  --reference-doc company-template.docx \
  --toc \
  --output documentation.docx
```

### Ebook from chapters
```bash
# Combine chapters into EPUB
fgp pandoc merge \
  --metadata title="My Book" \
  --metadata author="Author Name" \
  chapters/*.md \
  --to epub3 \
  --cover cover.jpg \
  --toc \
  --output book.epub
```

### Presentation from notes
```bash
# Markdown to reveal.js slides
fgp pandoc convert notes.md --to revealjs \
  --variable theme=black \
  --variable transition=slide \
  --standalone \
  --output presentation.html
```

### Convert legacy docs
```bash
# DOCX to clean Markdown
fgp pandoc batch convert ./legacy/*.docx \
  --to gfm \
  --extract-media ./images \
  --output ./markdown
```

## Troubleshooting

### Pandoc not found
```
Error: pandoc not found in PATH
```
Install Pandoc: `brew install pandoc` or `apt install pandoc`

### PDF generation failed
```
Error: pdflatex not found
```
Install LaTeX: `brew install basictex` or `apt install texlive-xetex`

### Missing fonts
```
Error: Font not found
```
Install required fonts or use: `--pdf-engine xelatex --variable mainfont="DejaVu Sans"`

### Unicode issues
```
Error: Unicode character not supported
```
Use XeLaTeX engine: `--pdf-engine xelatex`

### Citation errors
```
Error: bibliography not found
```
Check path to .bib file and install pandoc-citeproc if needed.

## Architecture

- **Pandoc** subprocess with persistent connection
- **UNIX socket** at `~/.fgp/services/pandoc/daemon.sock`
- **Template caching** for faster repeated conversions
- **Parallel batch processing** for multiple files
- **AST caching** for incremental builds
