---
name: supabase-daemon
description: Fast Supabase operations via FGP daemon - 40-120x faster than MCP. Use when user needs database queries, auth operations, storage uploads, edge functions, or realtime subscriptions. Triggers on "supabase query", "list tables", "upload file", "create user", "run sql", "supabase storage", "supabase auth".
license: MIT
compatibility: Requires fgp CLI and Supabase credentials (SUPABASE_URL and SUPABASE_KEY env vars)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Supabase Daemon

Ultra-fast Supabase operations using direct API access. **40-120x faster** than browser or MCP alternatives.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| SQL query | 5-15ms | ~600ms | **40-120x** |
| List tables | 8-20ms | ~700ms | **35-85x** |
| Storage upload | 20-50ms | ~1000ms | **20-50x** |
| Auth ops | 10-25ms | ~800ms | **30-80x** |

Direct Supabase APIs via persistent daemon with connection pooling.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-supabase

# Or
bash ~/.claude/skills/fgp-supabase/scripts/install.sh
```

## Setup

```bash
# Set credentials
export SUPABASE_URL="https://xxx.supabase.co"
export SUPABASE_KEY="eyJ..."  # service_role key for admin ops

# Or use project reference
fgp supabase link --project-ref xxx
```

## Usage

### SQL Queries

```bash
# Run SQL
fgp supabase sql "SELECT * FROM users LIMIT 10"

# With parameters
fgp supabase sql "SELECT * FROM users WHERE id = $1" --params '["uuid-here"]'

# From file
fgp supabase sql --file query.sql

# Transaction
fgp supabase sql --transaction "
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
"
```

### Database

```bash
# List tables
fgp supabase tables

# Describe table
fgp supabase table users

# List columns
fgp supabase columns users

# List indexes
fgp supabase indexes users

# Database size
fgp supabase db size
```

### Data Operations (PostgREST)

```bash
# Select
fgp supabase select users --columns "id,name,email" --limit 10

# Filter
fgp supabase select users --filter "status=eq.active" --order "created_at.desc"

# Insert
fgp supabase insert users --data '{"name": "John", "email": "john@example.com"}'

# Update
fgp supabase update users --filter "id=eq.123" --data '{"status": "inactive"}'

# Delete
fgp supabase delete users --filter "status=eq.deleted"

# Upsert
fgp supabase upsert users --data '{"id": 123, "name": "Updated"}' --on-conflict id
```

### Auth

```bash
# List users
fgp supabase auth users

# Get user
fgp supabase auth user <user-id>

# Create user
fgp supabase auth create --email "user@example.com" --password "secret"

# Delete user
fgp supabase auth delete <user-id>

# Update user
fgp supabase auth update <user-id> --data '{"user_metadata": {"role": "admin"}}'

# Invite user
fgp supabase auth invite "new@example.com"
```

### Storage

```bash
# List buckets
fgp supabase storage buckets

# List files
fgp supabase storage list my-bucket

# Upload file
fgp supabase storage upload my-bucket/path/file.png ./local-file.png

# Download file
fgp supabase storage download my-bucket/path/file.png ./local-file.png

# Delete file
fgp supabase storage delete my-bucket/path/file.png

# Get public URL
fgp supabase storage url my-bucket/path/file.png

# Create signed URL
fgp supabase storage signed-url my-bucket/path/file.png --expires 3600
```

### Edge Functions

```bash
# List functions
fgp supabase functions

# Deploy function
fgp supabase function deploy my-function

# Invoke function
fgp supabase function invoke my-function --body '{"key": "value"}'

# Get function logs
fgp supabase function logs my-function
```

### Realtime

```bash
# Subscribe to changes (for testing)
fgp supabase realtime users --event INSERT

# List channels
fgp supabase realtime channels
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `sql` | Run SQL query | `fgp supabase sql "SELECT..."` |
| `tables` | List tables | `fgp supabase tables` |
| `select` | Query via PostgREST | `fgp supabase select users` |
| `insert` | Insert data | `fgp supabase insert users --data '{}'` |
| `auth users` | List users | `fgp supabase auth users` |
| `storage` | Storage ops | `fgp supabase storage list bucket` |
| `functions` | Edge functions | `fgp supabase functions` |

## Filter Syntax

PostgREST filter operators:

| Operator | Example | Description |
|----------|---------|-------------|
| `eq` | `status=eq.active` | Equals |
| `neq` | `status=neq.deleted` | Not equals |
| `gt` | `age=gt.18` | Greater than |
| `gte` | `age=gte.18` | Greater or equal |
| `lt` | `price=lt.100` | Less than |
| `like` | `name=like.*john*` | Pattern match |
| `in` | `id=in.(1,2,3)` | In list |
| `is` | `deleted_at=is.null` | Is null |

## Example Workflows

### Quick data check
```bash
# See recent records
fgp supabase select orders --order "created_at.desc" --limit 5
```

### Debug auth issue
```bash
# Find user
fgp supabase sql "SELECT * FROM auth.users WHERE email = 'user@example.com'"

# Check sessions
fgp supabase sql "SELECT * FROM auth.sessions WHERE user_id = 'uuid'"
```

### Backup table
```bash
fgp supabase sql "COPY users TO STDOUT WITH CSV HEADER" > users_backup.csv
```

## Troubleshooting

### Connection failed
```
Error: Unable to connect
```
Check `SUPABASE_URL` and `SUPABASE_KEY`.

### Permission denied
```
Error: permission denied for table
```
Use service_role key for admin operations.

### RLS blocking query
```
Error: new row violates row-level security
```
Query as service role or check RLS policies.

## Architecture

- **Supabase REST API** (PostgREST)
- **Supabase Auth API**
- **Supabase Storage API**
- **Direct Postgres** for SQL
- **UNIX socket** at `~/.fgp/services/supabase/daemon.sock`
