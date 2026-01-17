---
name: elasticsearch-daemon
description: Fast Elasticsearch operations via FGP daemon - 20-40x faster than spawning curl per request. Use when user needs to search documents, index data, run aggregations, or manage indices. Triggers on "elasticsearch search", "es query", "index document", "elastic aggregation", "search index".
license: MIT
compatibility: Requires fgp CLI and Elasticsearch connection (ELASTICSEARCH_URL env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Elasticsearch Daemon

Fast Elasticsearch search and indexing operations.

## Why FGP?

| Operation | FGP Daemon | curl/REST | Speedup |
|-----------|------------|-----------|---------|
| Search | 5ms | 150ms | **30x** |
| Index doc | 8ms | 180ms | **22x** |
| Bulk index | 20ms | 400ms | **20x** |
| Aggregation | 15ms | 200ms | **13x** |

## Installation

```bash
brew install fast-gateway-protocol/fgp/fgp-elasticsearch
```

## Setup

```bash
export ELASTICSEARCH_URL="http://localhost:9200"
# Or Elastic Cloud
export ELASTICSEARCH_URL="https://my-cluster.es.us-east-1.aws.found.io"
export ELASTICSEARCH_API_KEY="..."

fgp start elasticsearch
```

## Available Commands

| Command | Description |
|---------|-------------|
| `es.search` | Search documents |
| `es.get` | Get document by ID |
| `es.index` | Index document |
| `es.bulk` | Bulk operations |
| `es.delete` | Delete document |
| `es.count` | Count documents |
| `es.indices` | List indices |
| `es.mapping` | Get index mapping |
| `es.aggregate` | Run aggregations |

## Example Workflows

```bash
# Search
fgp call es.search --index products --query '{"match": {"name": "laptop"}}'

# Index document
fgp call es.index --index logs --document '{"message": "User logged in", "@timestamp": "2026-01-17T12:00:00Z"}'

# Aggregation
fgp call es.aggregate --index sales --aggs '{"by_category": {"terms": {"field": "category"}}}'
```
