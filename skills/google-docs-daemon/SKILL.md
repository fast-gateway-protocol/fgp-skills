---
name: google-docs-daemon
description: Fast Google Docs operations via FGP daemon - 30-60x faster than MCP. Use when user needs to read documents, create docs, insert text, format content, or export to PDF. Triggers on "read document", "create doc", "google docs", "insert text", "document content", "export doc", "format document".
license: MIT
compatibility: Requires fgp CLI and Google OAuth credentials (run fgp docs auth)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Google Docs Daemon

Ultra-fast Google Docs operations using direct API access. **30-60x faster** than browser automation.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| Read document | 12-25ms | ~750ms | **30-60x** |
| Insert text | 15-30ms | ~800ms | **25-55x** |
| Create doc | 20-40ms | ~850ms | **20-45x** |
| Export PDF | 25-50ms | ~900ms | **18-35x** |

Direct Google Docs API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-google-docs

# Or
bash ~/.claude/skills/fgp-google-docs/scripts/install.sh
```

## Setup

```bash
# Authenticate
fgp docs auth

# Browser opens for OAuth consent
```

## Usage

### Reading Documents

```bash
# Read entire document
fgp docs read <document-id>

# Read as plain text
fgp docs read <document-id> --format text

# Read as markdown
fgp docs read <document-id> --format markdown

# Read as HTML
fgp docs read <document-id> --format html

# Get document structure (headings, sections)
fgp docs structure <document-id>

# Get document metadata
fgp docs info <document-id>
```

### Creating Documents

```bash
# Create empty document
fgp docs create "My Document"

# Create with initial content
fgp docs create "My Document" --content "Initial text here"

# Create from markdown file
fgp docs create "My Document" --from-file notes.md

# Create in specific folder
fgp docs create "My Document" --folder <folder-id>
```

### Inserting Content

```bash
# Insert text at end
fgp docs insert <document-id> "New paragraph text"

# Insert at specific index
fgp docs insert <document-id> "Text" --at 100

# Insert at start
fgp docs insert <document-id> "Title" --at start

# Insert heading
fgp docs insert <document-id> "Section Title" --style heading1

# Insert from file
fgp docs insert <document-id> --from-file content.md

# Insert page break
fgp docs insert <document-id> --page-break

# Insert horizontal rule
fgp docs insert <document-id> --horizontal-rule
```

### Text Formatting

```bash
# Bold text range
fgp docs format <document-id> --range "10:50" --bold

# Italic
fgp docs format <document-id> --range "10:50" --italic

# Underline
fgp docs format <document-id> --range "10:50" --underline

# Font size
fgp docs format <document-id> --range "10:50" --size 14

# Font color
fgp docs format <document-id> --range "10:50" --color "#ff0000"

# Background highlight
fgp docs format <document-id> --range "10:50" --highlight yellow

# Font family
fgp docs format <document-id> --range "10:50" --font "Roboto"

# Multiple styles
fgp docs format <document-id> --range "10:50" --bold --italic --size 16
```

### Paragraph Styling

```bash
# Set as heading
fgp docs style <document-id> --range "10:50" --heading 1

# Set alignment
fgp docs style <document-id> --range "10:50" --align center

# Line spacing
fgp docs style <document-id> --range "10:50" --spacing 1.5

# Indent
fgp docs style <document-id> --range "10:50" --indent 36
```

### Lists

```bash
# Create bullet list
fgp docs list <document-id> --range "100:200" --type bullet

# Create numbered list
fgp docs list <document-id> --range "100:200" --type number

# Remove list formatting
fgp docs list <document-id> --range "100:200" --remove
```

### Tables

```bash
# Insert table
fgp docs table <document-id> --rows 3 --cols 4 --at 100

# Insert table with data
fgp docs table <document-id> --data '[["A", "B"], ["1", "2"]]' --at 100

# Update table cell
fgp docs table-cell <document-id> --table 1 --row 0 --col 0 --text "Header"
```

### Images

```bash
# Insert image from URL
fgp docs image <document-id> --url "https://example.com/image.png" --at 100

# Insert image from file
fgp docs image <document-id> --file ./diagram.png --at 100

# Set image size
fgp docs image <document-id> --url "..." --width 300 --height 200
```

### Find & Replace

```bash
# Find text
fgp docs find <document-id> "search term"

# Replace all occurrences
fgp docs replace <document-id> --find "old text" --replace "new text"

# Replace with formatting
fgp docs replace <document-id> --find "important" --replace "IMPORTANT" --bold
```

### Exporting

```bash
# Export as PDF
fgp docs export <document-id> --format pdf > document.pdf

# Export as DOCX
fgp docs export <document-id> --format docx > document.docx

# Export as plain text
fgp docs export <document-id> --format txt > document.txt

# Export as HTML
fgp docs export <document-id> --format html > document.html

# Export as Markdown
fgp docs export <document-id> --format md > document.md
```

### Document Management

```bash
# Copy document
fgp docs copy <document-id> --name "Copy of Document"

# Move to folder
fgp docs move <document-id> --folder <folder-id>

# Rename document
fgp docs rename <document-id> "New Title"

# Delete document
fgp docs delete <document-id>

# Get revision history
fgp docs revisions <document-id>
```

### Comments & Suggestions

```bash
# List comments
fgp docs comments <document-id>

# Add comment
fgp docs comment <document-id> --range "100:150" --text "Please review this section"

# Reply to comment
fgp docs reply <document-id> --comment-id <id> --text "Done"

# Resolve comment
fgp docs resolve <document-id> --comment-id <id>
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `read` | Read document content | `fgp docs read <id>` |
| `create` | Create new document | `fgp docs create "Title"` |
| `insert` | Insert text/content | `fgp docs insert <id> "text"` |
| `format` | Format text | `fgp docs format <id> --bold` |
| `style` | Paragraph styles | `fgp docs style <id> --heading 1` |
| `export` | Export document | `fgp docs export <id> --format pdf` |
| `replace` | Find and replace | `fgp docs replace <id> --find "x"` |
| `table` | Insert table | `fgp docs table <id> --rows 3` |
| `image` | Insert image | `fgp docs image <id> --url "..."` |

## Example Workflows

### Create meeting notes template
```bash
# Create doc with structure
DOC=$(fgp docs create "Meeting Notes - $(date +%Y-%m-%d)" --json | jq -r '.id')
fgp docs insert $DOC "Meeting Notes" --style heading1
fgp docs insert $DOC "Date: $(date +%Y-%m-%d)"
fgp docs insert $DOC "Attendees" --style heading2
fgp docs insert $DOC "Action Items" --style heading2
fgp docs insert $DOC "Notes" --style heading2
echo "Created: https://docs.google.com/document/d/$DOC"
```

### Convert markdown to Google Doc
```bash
fgp docs create "Imported Document" --from-file README.md
```

### Batch export documents
```bash
# Export all docs in folder as PDF
fgp drive list $FOLDER_ID --type document --json | jq -r '.[].id' | while read id; do
  fgp docs export $id --format pdf > "${id}.pdf"
done
```

### Generate report
```bash
# Create report with data
DOC=$(fgp docs create "Weekly Report" --json | jq -r '.id')
fgp docs insert $DOC "Weekly Metrics Report" --style heading1
fgp docs insert $DOC "Generated: $(date)" --italic
fgp docs table $DOC --data "$(generate_metrics_json)"
fgp docs export $DOC --format pdf > report.pdf
```

## Troubleshooting

### Not authenticated
```
Error: No credentials found
```
Run: `fgp docs auth`

### Document not found
```
Error: Document not found
```
Check document ID is correct and you have access.

### Rate limit exceeded
```
Error: Rate Limit Exceeded
```
Google Docs API has quotas. Wait and retry, or use batch operations.

### Permission denied
```
Error: The caller does not have permission
```
Check you have edit access to the document.

### Invalid range
```
Error: Invalid range
```
Range indices are 1-based and must be within document length. Use `fgp docs info <id>` to check document length.

## Architecture

- **Google Docs API v1**
- **OAuth 2.0** with offline refresh
- **UNIX socket** at `~/.fgp/services/google-docs/daemon.sock`
- **Batch updates** for multiple operations
- **Structural elements** aware (paragraphs, tables, lists)
