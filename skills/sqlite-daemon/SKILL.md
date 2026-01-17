---
name: fgp-sqlite
description: Fast SQLite operations via FGP daemon - 20-100x faster than spawning sqlite3 per query. Use when user needs to query SQLite databases, run SQL, explore schema, or manage local databases. Triggers on "query sqlite", "sqlite database", "run sql", "local database", "db query", ".db file".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP SQLite Daemon

Ultra-fast SQLite operations with persistent database connections. **20-100x faster** than spawning sqlite3 per query.

## Why FGP?

| Operation | FGP Daemon | sqlite3 CLI | Speedup |
|-----------|------------|-------------|---------|
| Simple query | 0.1-0.5ms | ~20ms | **40-200x** |
| Complex query | 1-5ms | ~25ms | **5-25x** |
| Schema info | 0.2-1ms | ~20ms | **20-100x** |
| Insert row | 0.3-1ms | ~22ms | **20-70x** |

Persistent connections eliminate process spawn and database open overhead.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-sqlite

# Or
bash ~/.claude/skills/fgp-sqlite/scripts/install.sh
```

## Usage

### Connect to Database

```bash
# Open database
fgp sqlite open mydb.db

# Open with read-only mode
fgp sqlite open mydb.db --readonly

# Open in-memory database
fgp sqlite open :memory:

# List open connections
fgp sqlite connections

# Close connection
fgp sqlite close mydb.db
```

### Run Queries

```bash
# Simple query
fgp sqlite query mydb.db "SELECT * FROM users"

# With parameters
fgp sqlite query mydb.db "SELECT * FROM users WHERE id = ?" --params '[1]'

# Named parameters
fgp sqlite query mydb.db "SELECT * FROM users WHERE name = :name" --params '{"name": "John"}'

# From file
fgp sqlite query mydb.db --file query.sql

# Multiple statements
fgp sqlite exec mydb.db "
  INSERT INTO users (name) VALUES ('John');
  INSERT INTO users (name) VALUES ('Jane');
"
```

### Output Formats

```bash
# JSON (default)
fgp sqlite query mydb.db "SELECT * FROM users"

# Table format
fgp sqlite query mydb.db "SELECT * FROM users" --format table

# CSV
fgp sqlite query mydb.db "SELECT * FROM users" --format csv

# TSV
fgp sqlite query mydb.db "SELECT * FROM users" --format tsv

# Vertical (one column per line)
fgp sqlite query mydb.db "SELECT * FROM users" --format vertical

# Single value
fgp sqlite query mydb.db "SELECT COUNT(*) FROM users" --format value

# Column headers only
fgp sqlite query mydb.db "SELECT * FROM users" --format headers
```

### Schema Exploration

```bash
# List all tables
fgp sqlite tables mydb.db

# Describe table
fgp sqlite describe mydb.db users

# Get CREATE statement
fgp sqlite schema mydb.db users

# List all indexes
fgp sqlite indexes mydb.db

# List indexes for table
fgp sqlite indexes mydb.db users

# List views
fgp sqlite views mydb.db

# List triggers
fgp sqlite triggers mydb.db

# Full schema dump
fgp sqlite schema mydb.db --all
```

### Data Operations

```bash
# Insert
fgp sqlite insert mydb.db users --data '{"name": "John", "email": "john@example.com"}'

# Insert multiple rows
fgp sqlite insert mydb.db users --data '[{"name": "John"}, {"name": "Jane"}]'

# Update
fgp sqlite update mydb.db users --where "id = 1" --set '{"name": "Johnny"}'

# Delete
fgp sqlite delete mydb.db users --where "id = 1"

# Upsert (insert or replace)
fgp sqlite upsert mydb.db users --data '{"id": 1, "name": "John"}' --conflict id

# Truncate table
fgp sqlite truncate mydb.db users
```

### Transactions

```bash
# Begin transaction
fgp sqlite begin mydb.db

# Commit
fgp sqlite commit mydb.db

# Rollback
fgp sqlite rollback mydb.db

# Transaction block
fgp sqlite transaction mydb.db "
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
"

# Transaction from file
fgp sqlite transaction mydb.db --file migration.sql
```

### Import / Export

```bash
# Import CSV
fgp sqlite import mydb.db users data.csv

# Import with options
fgp sqlite import mydb.db users data.csv --header --separator ","

# Import JSON
fgp sqlite import mydb.db users data.json

# Export to CSV
fgp sqlite export mydb.db users --format csv > users.csv

# Export query results
fgp sqlite query mydb.db "SELECT * FROM users WHERE active = 1" --format csv > active_users.csv

# Export to JSON
fgp sqlite export mydb.db users --format json > users.json

# Dump entire database
fgp sqlite dump mydb.db > backup.sql

# Dump specific tables
fgp sqlite dump mydb.db users orders > partial_backup.sql
```

### Database Management

```bash
# Create new database
fgp sqlite create newdb.db

# Create with schema file
fgp sqlite create newdb.db --schema schema.sql

# Copy database
fgp sqlite copy mydb.db copy.db

# Vacuum (optimize)
fgp sqlite vacuum mydb.db

# Analyze (update statistics)
fgp sqlite analyze mydb.db

# Check integrity
fgp sqlite check mydb.db

# Get database info
fgp sqlite info mydb.db

# Database size
fgp sqlite size mydb.db
```

### Query Analysis

```bash
# Explain query
fgp sqlite explain mydb.db "SELECT * FROM users WHERE email = 'test@example.com'"

# Explain query plan
fgp sqlite explain mydb.db "SELECT * FROM users JOIN orders ON users.id = orders.user_id" --plan

# Query timing
fgp sqlite query mydb.db "SELECT * FROM large_table" --timing

# Profile query
fgp sqlite profile mydb.db "SELECT * FROM users" --iterations 100
```

### Full-Text Search

```bash
# Create FTS table
fgp sqlite exec mydb.db "CREATE VIRTUAL TABLE docs_fts USING fts5(title, content)"

# Search
fgp sqlite query mydb.db "SELECT * FROM docs_fts WHERE docs_fts MATCH 'search term'"

# Search with ranking
fgp sqlite query mydb.db "SELECT *, rank FROM docs_fts WHERE docs_fts MATCH 'term' ORDER BY rank"
```

### JSON Support

```bash
# Query JSON column
fgp sqlite query mydb.db "SELECT json_extract(data, '$.name') FROM users"

# Insert JSON
fgp sqlite exec mydb.db "INSERT INTO users (data) VALUES (json('{\"name\": \"John\"}'))"

# JSON aggregation
fgp sqlite query mydb.db "SELECT json_group_array(name) FROM users"
```

### Backup & Restore

```bash
# Online backup
fgp sqlite backup mydb.db backup.db

# Restore from backup
fgp sqlite restore backup.db mydb.db

# Dump to SQL
fgp sqlite dump mydb.db > backup.sql

# Restore from SQL
fgp sqlite exec newdb.db --file backup.sql
```

### Pragmas & Settings

```bash
# Get pragma
fgp sqlite pragma mydb.db journal_mode

# Set pragma
fgp sqlite pragma mydb.db journal_mode=WAL

# Enable foreign keys
fgp sqlite pragma mydb.db foreign_keys=ON

# Set cache size
fgp sqlite pragma mydb.db cache_size=-64000

# Get all pragmas
fgp sqlite pragmas mydb.db
```

### Common Databases

```bash
# Query browser history (macOS Chrome)
fgp sqlite query ~/Library/Application\ Support/Google/Chrome/Default/History \
  "SELECT title, url, datetime(last_visit_time/1000000-11644473600,'unixepoch') FROM urls ORDER BY last_visit_time DESC LIMIT 20"

# Query Firefox history
fgp sqlite query ~/Library/Application\ Support/Firefox/Profiles/*.default/places.sqlite \
  "SELECT title, url FROM moz_places ORDER BY last_visit_date DESC LIMIT 20"

# Query iOS backup
fgp sqlite query ~/Library/Application\ Support/MobileSync/Backup/*/Manifest.db \
  "SELECT * FROM Files LIMIT 10"
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `query` | Run SELECT query | `fgp sqlite query db.db "SELECT..."` |
| `exec` | Run any SQL | `fgp sqlite exec db.db "INSERT..."` |
| `tables` | List tables | `fgp sqlite tables db.db` |
| `describe` | Describe table | `fgp sqlite describe db.db users` |
| `schema` | Get schema | `fgp sqlite schema db.db` |
| `insert` | Insert data | `fgp sqlite insert db.db users --data '{...}'` |
| `update` | Update data | `fgp sqlite update db.db users --where "..."` |
| `delete` | Delete data | `fgp sqlite delete db.db users --where "..."` |
| `import` | Import CSV/JSON | `fgp sqlite import db.db users data.csv` |
| `export` | Export data | `fgp sqlite export db.db users` |
| `dump` | Dump database | `fgp sqlite dump db.db` |
| `backup` | Online backup | `fgp sqlite backup db.db copy.db` |
| `vacuum` | Optimize | `fgp sqlite vacuum db.db` |

## Example Workflows

### Quick data exploration
```bash
# Open and explore
fgp sqlite tables mydb.db
fgp sqlite describe mydb.db users
fgp sqlite query mydb.db "SELECT * FROM users LIMIT 10"
```

### Migration script
```bash
# Run migration in transaction
fgp sqlite transaction mydb.db --file migrations/001_add_columns.sql
```

### Data export for analysis
```bash
# Export to CSV for spreadsheet
fgp sqlite query mydb.db "
  SELECT
    u.name,
    COUNT(o.id) as order_count,
    SUM(o.total) as total_spent
  FROM users u
  LEFT JOIN orders o ON u.id = o.user_id
  GROUP BY u.id
" --format csv > user_analysis.csv
```

### Backup before changes
```bash
# Create backup
fgp sqlite backup production.db "production_$(date +%Y%m%d).db"

# Make changes
fgp sqlite exec production.db --file updates.sql

# Verify
fgp sqlite query production.db "SELECT COUNT(*) FROM affected_table"
```

### Query local app databases
```bash
# Query Slack local data
fgp sqlite query ~/Library/Application\ Support/Slack/storage/slack-workspaces \
  "SELECT * FROM workspaces"

# Query Safari bookmarks
fgp sqlite query ~/Library/Safari/Bookmarks.db \
  "SELECT title, url FROM bookmarks"
```

## Troubleshooting

### Database locked
```
Error: database is locked
```
Another process has the database open. Use `--timeout 5000` to wait.

### Read-only database
```
Error: attempt to write a readonly database
```
Check file permissions or open with write access.

### Malformed database
```
Error: database disk image is malformed
```
Database may be corrupted. Try: `fgp sqlite check db.db`

### No such table
```
Error: no such table: users
```
Table doesn't exist. Check with: `fgp sqlite tables db.db`

### Disk full
```
Error: database or disk is full
```
Free up disk space or use smaller transaction batches.

## Architecture

- **rusqlite** for native SQLite bindings
- **Connection pooling** for multiple databases
- **UNIX socket** at `~/.fgp/services/sqlite/daemon.sock`
- **WAL mode** by default for better concurrency
- **Prepared statement caching** for repeated queries
- **Memory-mapped I/O** for large databases
