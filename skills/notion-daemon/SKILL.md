---
name: fgp-notion
description: Fast Notion operations via FGP daemon - 40-80x faster than MCP. Use when user needs to search Notion, create pages, update databases, or manage workspace. Triggers on "search notion", "create notion page", "update notion", "list notion databases".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP Notion Daemon

Ultra-fast Notion operations using direct API access. **40-80x faster** than browser automation.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| Search | 20-40ms | ~1500ms | **35-75x** |
| Get page | 15-30ms | ~1200ms | **40-80x** |
| Create page | 25-50ms | ~1400ms | **30-55x** |
| Query database | 20-45ms | ~1300ms | **30-65x** |

Direct Notion API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-notion

# Or
bash ~/.claude/skills/fgp-notion/scripts/install.sh
```

## Setup

```bash
# Set integration token
export NOTION_TOKEN="secret_..."

# Start daemon
fgp notion start
```

Create integration at https://www.notion.so/my-integrations

## Usage

### Search

```bash
# Search everything
fgp notion search "project roadmap"

# Search pages only
fgp notion search "meeting notes" --type page

# Search databases only
fgp notion search "tasks" --type database
```

### Pages

```bash
# Get page
fgp notion page <page-id>

# Create page
fgp notion page create "New Document" --parent <parent-id>

# Create with content
fgp notion page create "Meeting Notes" --parent <parent-id> --content "## Attendees\n- Alice\n- Bob"

# Update page
fgp notion page update <page-id> --title "Updated Title"

# Append content
fgp notion page append <page-id> "## New Section\nMore content here"

# Archive page
fgp notion page archive <page-id>
```

### Databases

```bash
# List databases
fgp notion databases

# Query database
fgp notion query <database-id>

# Query with filter
fgp notion query <database-id> --filter "Status = Done"

# Query with sort
fgp notion query <database-id> --sort "Created" --direction desc

# Add row to database
fgp notion row create <database-id> --props '{"Name": "New Task", "Status": "Todo"}'

# Update row
fgp notion row update <row-id> --props '{"Status": "In Progress"}'
```

### Blocks

```bash
# Get block children
fgp notion blocks <block-id>

# Append blocks
fgp notion blocks append <parent-id> --type paragraph --content "New paragraph"

# Delete block
fgp notion blocks delete <block-id>
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `search` | Search workspace | `fgp notion search "query"` |
| `page` | Get page | `fgp notion page <id>` |
| `page create` | Create page | `fgp notion page create "Title"` |
| `page append` | Append content | `fgp notion page append <id> "text"` |
| `databases` | List databases | `fgp notion databases` |
| `query` | Query database | `fgp notion query <id>` |
| `row create` | Add database row | `fgp notion row create <id>` |
| `blocks` | Get blocks | `fgp notion blocks <id>` |

## Filter Syntax

```bash
# Equals
--filter "Status = Done"

# Contains
--filter "Name contains Project"

# Date filters
--filter "Due after 2024-01-01"

# Multiple filters (AND)
--filter "Status = Todo" --filter "Priority = High"
```

## Example Workflows

### Daily standup
```bash
# Find today's standup page
fgp notion search "standup $(date +%Y-%m-%d)"

# Or create one
fgp notion page create "Standup $(date +%Y-%m-%d)" \
  --parent <standup-db-id> \
  --content "## Yesterday\n\n## Today\n\n## Blockers"
```

### Task management
```bash
# Get high priority todos
fgp notion query <tasks-db> --filter "Status = Todo" --filter "Priority = High"

# Mark task done
fgp notion row update <task-id> --props '{"Status": "Done"}'
```

### Knowledge base search
```bash
fgp notion search "API authentication" --type page
```

## Troubleshooting

### Page not found
```
Error: Could not find page
```
Ensure integration has access to the page (share with integration).

### Invalid token
```
Error: Invalid token
```
Check `NOTION_TOKEN` is correct.

### Property not found
```
Error: Property "Status" not found
```
Check exact property name in database schema.

## Architecture

- **Notion API** (v2022-06-28)
- **Integration token auth**
- **UNIX socket** at `~/.fgp/services/notion/daemon.sock`
- **Block caching** for faster reads
