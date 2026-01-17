---
name: neon-daemon
description: Fast Neon Postgres operations via FGP daemon - 35-70x faster than MCP. Use when user needs database queries, branch management, schema operations, or migrations on Neon. Triggers on "neon query", "create branch", "run sql", "list databases", "neon project", "postgres query", "neon migration".
license: MIT
compatibility: Requires fgp CLI and Neon API Key (NEON_API_KEY env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Neon Daemon

Ultra-fast Neon Postgres operations using direct API access. **35-70x faster** than MCP alternatives.

## Why FGP?

| Operation | FGP Daemon | MCP | Speedup |
|-----------|------------|-----|---------|
| SQL query | 8-20ms | ~500ms | **25-60x** |
| List branches | 10-25ms | ~600ms | **25-60x** |
| Create branch | 15-35ms | ~800ms | **25-50x** |
| Schema info | 12-30ms | ~700ms | **25-55x** |

Direct Neon API + Postgres connection via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-neon

# Or
bash ~/.claude/skills/fgp-neon/scripts/install.sh
```

## Setup

```bash
# Set API key
export NEON_API_KEY="..."

# Or authenticate
fgp neon auth
```

Get API key from https://console.neon.tech/app/settings/api-keys

## Usage

### Projects

```bash
# List projects
fgp neon projects

# Get project info
fgp neon project <project-id>

# Create project
fgp neon project create my-project --region aws-us-east-1

# Delete project
fgp neon project delete <project-id>
```

### Branches

```bash
# List branches
fgp neon branches <project-id>

# Create branch (instant copy)
fgp neon branch create <project-id> --name feature-x

# Create from specific point
fgp neon branch create <project-id> --name hotfix --parent main --point-in-time "2024-01-15T10:00:00Z"

# Delete branch
fgp neon branch delete <project-id> <branch-id>

# Reset branch from parent
fgp neon branch reset <project-id> <branch-id>
```

### SQL Queries

```bash
# Run SQL
fgp neon sql <project-id> "SELECT * FROM users LIMIT 10"

# On specific branch
fgp neon sql <project-id> "SELECT COUNT(*) FROM orders" --branch feature-x

# Transaction
fgp neon sql <project-id> --transaction "
  BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
  COMMIT;
"

# From file
fgp neon sql <project-id> --file migration.sql
```

### Schema

```bash
# List tables
fgp neon tables <project-id>

# Describe table
fgp neon table <project-id> users

# Compare schemas between branches
fgp neon schema compare <project-id> --from main --to feature-x

# Generate migration
fgp neon schema diff <project-id> --from main --to feature-x > migration.sql
```

### Migrations

```bash
# Prepare migration (creates temp branch)
fgp neon migration prepare <project-id> --file migration.sql

# Test migration on branch
fgp neon sql <project-id> "SELECT * FROM new_table" --branch migration-preview

# Complete migration (merge to main)
fgp neon migration complete <project-id>

# Rollback
fgp neon migration rollback <project-id>
```

### Performance

```bash
# List slow queries
fgp neon slow-queries <project-id>

# Explain query
fgp neon explain <project-id> "SELECT * FROM users WHERE email = 'test@example.com'"

# Query tuning suggestions
fgp neon tune <project-id> "SELECT * FROM orders JOIN users ON..."
```

### Compute

```bash
# List compute endpoints
fgp neon computes <project-id>

# Scale compute
fgp neon compute scale <project-id> <endpoint-id> --size 2

# Suspend compute
fgp neon compute suspend <project-id> <endpoint-id>

# Resume compute
fgp neon compute resume <project-id> <endpoint-id>
```

### Connection

```bash
# Get connection string
fgp neon connection-string <project-id>

# Get connection string for branch
fgp neon connection-string <project-id> --branch feature-x

# Get pooler connection string
fgp neon connection-string <project-id> --pooler
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `projects` | List projects | `fgp neon projects` |
| `branches` | List branches | `fgp neon branches <proj>` |
| `branch create` | Create branch | `fgp neon branch create <proj>` |
| `sql` | Run SQL | `fgp neon sql <proj> "SELECT..."` |
| `tables` | List tables | `fgp neon tables <proj>` |
| `schema compare` | Compare schemas | `fgp neon schema compare <proj>` |
| `slow-queries` | Performance | `fgp neon slow-queries <proj>` |

## Example Workflows

### Feature development
```bash
# Create feature branch
fgp neon branch create my-project --name feature-x

# Work on feature branch
fgp neon sql my-project "ALTER TABLE users ADD COLUMN role TEXT" --branch feature-x

# Test
fgp neon sql my-project "SELECT * FROM users" --branch feature-x

# Merge (reset main from feature)
fgp neon branch reset my-project main --from feature-x
```

### Safe migrations
```bash
# Prepare migration
fgp neon migration prepare my-project --file add_index.sql

# Test on preview branch
fgp neon sql my-project "EXPLAIN SELECT * FROM users WHERE email = 'x'" --branch migration-preview

# If good, complete
fgp neon migration complete my-project
```

### Debug performance
```bash
# Find slow queries
fgp neon slow-queries my-project

# Explain the slow one
fgp neon explain my-project "SELECT * FROM orders WHERE status = 'pending'"

# Get tuning suggestions
fgp neon tune my-project "SELECT * FROM orders WHERE status = 'pending'"
```

## Troubleshooting

### Connection failed
```
Error: Unable to connect to database
```
Check compute is not suspended: `fgp neon computes <project-id>`

### Branch not found
```
Error: Branch feature-x not found
```
List branches: `fgp neon branches <project-id>`

### Query timeout
```
Error: Query timed out
```
Check slow queries or increase timeout.

## Architecture

- **Neon API** for management operations
- **Direct Postgres** for queries (via pooler)
- **UNIX socket** at `~/.fgp/services/neon/daemon.sock`
- **Connection pooling** for efficiency
