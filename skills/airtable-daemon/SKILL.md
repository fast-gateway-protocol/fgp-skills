---
name: fgp-airtable
description: Fast Airtable operations via FGP daemon - 20-40x faster than MCP. Bases, tables, records, and views.
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
  categories: ["database", "productivity"]
---

# FGP Airtable Daemon

Fast Airtable database operations.

## Why FGP?

| Operation | FGP Daemon | REST API | Speedup |
|-----------|------------|----------|---------|
| List records | 15ms | 400ms | **27x** |
| Get record | 8ms | 250ms | **31x** |
| Create | 12ms | 350ms | **29x** |
| Update | 10ms | 300ms | **30x** |

## Installation

```bash
brew install fast-gateway-protocol/fgp/fgp-airtable
```

## Setup

```bash
export AIRTABLE_API_KEY="pat..."
# Or personal access token
export AIRTABLE_PAT="pat..."

fgp start airtable
```

## Available Commands

| Command | Description |
|---------|-------------|
| `airtable.bases` | List bases |
| `airtable.tables` | List tables in base |
| `airtable.records` | List records |
| `airtable.record` | Get single record |
| `airtable.create` | Create record(s) |
| `airtable.update` | Update record(s) |
| `airtable.delete` | Delete record(s) |
| `airtable.views` | List views |

## Example Workflows

```bash
# List records with filter
fgp call airtable.records \
  --base appXXX \
  --table "Tasks" \
  --filter "{Status} = 'Active'" \
  --view "Grid view"

# Create record
fgp call airtable.create \
  --base appXXX \
  --table "Tasks" \
  --fields '{"Name": "New task", "Status": "Todo"}'

# Batch update
fgp call airtable.update \
  --base appXXX \
  --table "Tasks" \
  --records '[{"id": "recXXX", "fields": {"Status": "Done"}}]'
```
