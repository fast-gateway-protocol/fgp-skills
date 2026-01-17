---
name: google-drive-daemon
description: Fast Google Drive operations via FGP daemon - 40-80x faster than MCP. Use when user needs to list files, upload files, download files, search Drive, or share documents. Triggers on "list drive files", "upload to drive", "download from drive", "search drive", "share file", "google drive", "drive folder".
license: MIT
compatibility: Requires fgp CLI and Google OAuth credentials (run fgp drive auth)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Google Drive Daemon

Ultra-fast Google Drive operations using direct API access. **40-80x faster** than browser automation.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| List files | 12-25ms | ~1000ms | **40-80x** |
| Upload file | 30-100ms | ~1500ms | **15-50x** |
| Download | 25-80ms | ~1200ms | **15-50x** |
| Search | 15-30ms | ~1100ms | **35-75x** |

Direct Google Drive API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-google-drive

# Or
bash ~/.claude/skills/fgp-google-drive/scripts/install.sh
```

## Setup

```bash
# Authenticate
fgp drive auth

# Browser opens for OAuth consent
```

## Usage

### List Files

```bash
# List root folder
fgp drive list

# List specific folder
fgp drive list <folder-id>

# List with details
fgp drive list --fields "name,size,modifiedTime,mimeType"

# List by type
fgp drive list --type folder
fgp drive list --type document
fgp drive list --type spreadsheet
```

### Search

```bash
# Search by name
fgp drive search "quarterly report"

# Search by type
fgp drive search "budget" --type spreadsheet

# Search in folder
fgp drive search "notes" --in <folder-id>

# Full-text search
fgp drive search --fulltext "action items from meeting"

# Recent files
fgp drive recent --limit 20
```

### Upload

```bash
# Upload file
fgp drive upload ./report.pdf

# Upload to specific folder
fgp drive upload ./report.pdf --folder <folder-id>

# Upload with custom name
fgp drive upload ./local.txt --name "Remote Name.txt"

# Upload folder (recursive)
fgp drive upload ./project --recursive

# Convert to Google format
fgp drive upload ./document.docx --convert
```

### Download

```bash
# Download file
fgp drive download <file-id>

# Download to specific path
fgp drive download <file-id> --output ./local-copy.pdf

# Export Google Doc as PDF
fgp drive export <doc-id> --format pdf > document.pdf

# Export formats: pdf, docx, xlsx, pptx, txt, html
```

### Folders

```bash
# Create folder
fgp drive mkdir "New Folder"

# Create nested folder
fgp drive mkdir "Projects/2024/Q1"

# Move file to folder
fgp drive move <file-id> <folder-id>

# Copy file
fgp drive copy <file-id> --name "Copy of File"
```

### Sharing

```bash
# Share with user
fgp drive share <file-id> --email user@example.com --role writer

# Share with anyone (link)
fgp drive share <file-id> --anyone --role reader

# List permissions
fgp drive permissions <file-id>

# Remove permission
fgp drive unshare <file-id> --email user@example.com

# Get shareable link
fgp drive link <file-id>
```

### Info & Management

```bash
# File info
fgp drive info <file-id>

# Rename file
fgp drive rename <file-id> "New Name"

# Delete file (trash)
fgp drive trash <file-id>

# Permanently delete
fgp drive delete <file-id> --permanent

# Restore from trash
fgp drive restore <file-id>

# Empty trash
fgp drive trash empty
```

### Storage

```bash
# Storage quota
fgp drive quota

# Large files
fgp drive list --order "size desc" --limit 20
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `list` | List files | `fgp drive list` |
| `search` | Search files | `fgp drive search "query"` |
| `upload` | Upload file | `fgp drive upload ./file.pdf` |
| `download` | Download file | `fgp drive download <id>` |
| `export` | Export Google doc | `fgp drive export <id> --format pdf` |
| `mkdir` | Create folder | `fgp drive mkdir "Folder"` |
| `share` | Share file | `fgp drive share <id> --email ...` |
| `info` | File info | `fgp drive info <id>` |

## File Types

| Type | MIME Type |
|------|-----------|
| `folder` | application/vnd.google-apps.folder |
| `document` | application/vnd.google-apps.document |
| `spreadsheet` | application/vnd.google-apps.spreadsheet |
| `presentation` | application/vnd.google-apps.presentation |
| `form` | application/vnd.google-apps.form |
| `pdf` | application/pdf |

## Example Workflows

### Backup local folder
```bash
# Create backup folder
FOLDER=$(fgp drive mkdir "Backups/$(date +%Y-%m-%d)" --json | jq -r '.id')

# Upload files
fgp drive upload ./important-docs --folder $FOLDER --recursive
```

### Share project folder
```bash
# Create project folder
fgp drive mkdir "Project X"

# Share with team
fgp drive share <folder-id> --email team@company.com --role writer

# Get link for external
fgp drive link <folder-id>
```

### Export all docs as PDF
```bash
# Find all docs in folder
fgp drive list <folder-id> --type document --json | jq -r '.[].id' | while read id; do
  fgp drive export $id --format pdf > "${id}.pdf"
done
```

## Troubleshooting

### Not authenticated
```
Error: No credentials found
```
Run: `fgp drive auth`

### File not found
```
Error: File not found
```
Check file ID is correct and you have access.

### Quota exceeded
```
Error: User rate limit exceeded
```
Google Drive API has quotas. Wait and retry.

### Permission denied
```
Error: The user does not have sufficient permissions
```
Check you have edit access for the operation.

## Architecture

- **Google Drive API v3**
- **OAuth 2.0** with offline refresh
- **UNIX socket** at `~/.fgp/services/google-drive/daemon.sock`
- **Resumable uploads** for large files
- **Chunked downloads** for efficiency
