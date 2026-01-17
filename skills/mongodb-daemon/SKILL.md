---
name: mongodb-daemon
description: Fast MongoDB operations via FGP daemon - 25-60x faster than spawning mongosh per query. Use when user needs to query documents, insert data, run aggregations, or manage collections. Triggers on "mongodb query", "find documents", "insert document", "mongo aggregate", "mongodb collection".
license: MIT
compatibility: Requires fgp CLI and MongoDB connection string (MONGODB_URI env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP MongoDB Daemon

Fast MongoDB operations with persistent connection pooling.

## Why FGP?

| Operation | FGP Daemon | mongosh | Speedup |
|-----------|------------|---------|---------|
| Find one | 3ms | 150ms | **50x** |
| Find many | 8ms | 200ms | **25x** |
| Insert | 5ms | 180ms | **36x** |
| Aggregate | 15ms | 250ms | **17x** |

## Installation

```bash
brew install fast-gateway-protocol/fgp/fgp-mongodb
```

## Setup

```bash
export MONGODB_URI="mongodb://localhost:27017/mydb"
# Or MongoDB Atlas
export MONGODB_URI="mongodb+srv://user:pass@cluster.mongodb.net/mydb"

fgp start mongodb
```

## Available Commands

| Command | Description |
|---------|-------------|
| `mongodb.find` | Find documents |
| `mongodb.findOne` | Find single document |
| `mongodb.insert` | Insert document(s) |
| `mongodb.update` | Update document(s) |
| `mongodb.delete` | Delete document(s) |
| `mongodb.aggregate` | Run aggregation pipeline |
| `mongodb.count` | Count documents |
| `mongodb.collections` | List collections |
| `mongodb.indexes` | List indexes |

## Example Workflows

```bash
# Find documents
fgp call mongodb.find --collection users --filter '{"active": true}' --limit 10

# Insert document
fgp call mongodb.insert --collection logs --document '{"event": "login", "ts": "2026-01-17"}'

# Aggregation
fgp call mongodb.aggregate --collection orders --pipeline '[{"$group": {"_id": "$status", "count": {"$sum": 1}}}]'
```

## Architecture

- Connection pool with configurable size
- Automatic reconnection on failure
- Query result caching (optional)
- Support for replica sets and sharding
