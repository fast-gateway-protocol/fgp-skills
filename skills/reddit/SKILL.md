---
name: reddit
description: Token-efficient Reddit access via public JSON API. No auth required. Use when user wants to browse subreddits, read posts/comments, search Reddit, or check user activity. Triggers on "show me r/", "reddit posts", "search reddit", "what's on reddit", "check subreddit", "reddit comments".
license: MIT
compatibility: Python 3.8+ (stdlib only, no dependencies)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# Reddit CLI

Token-efficient Reddit access via the public JSON API. **No authentication required.**

## Why This Approach?

Appending `.json` to any Reddit URL returns pure JSON - a little-known trick that bypasses the need for API keys or OAuth.

| Metric | Value |
|--------|-------|
| Token reduction | **94% average** (10-40x compression) |
| Latency | ~400-600ms (network-bound) |
| Auth required | None |
| Rate limit | ~10 req/min |

## Commands

### List Subreddit Posts
```bash
reddit posts <subreddit> [--limit N] [--sort hot|new|top|rising]
```

Examples:
```bash
reddit posts programming --limit 10
reddit posts MachineLearning --sort top --limit 5
reddit posts LocalLLaMA --sort new
```

### Get Post with Comments
```bash
reddit post <url> [--limit N]
```

Examples:
```bash
reddit post "https://reddit.com/r/programming/comments/abc123/title"
reddit post /r/python/comments/xyz789/post_title --limit 50
```

### Search Reddit
```bash
reddit search <query> [--subreddit NAME] [--limit N]
```

Examples:
```bash
reddit search "rust vs go"
reddit search "MCP model context protocol" --limit 10
reddit search "async" --subreddit python --limit 20
```

### Get User Activity
```bash
reddit user <username> [--limit N]
```

Examples:
```bash
reddit user spez --limit 10
```

## Output Format

All commands return **minimal JSON** with only essential fields:

**Posts:**
```json
[
  {
    "title": "Post title",
    "author": "username",
    "subreddit": "programming",
    "score": 1234,
    "comments": 56,
    "url": "https://example.com/article",
    "permalink": "https://reddit.com/r/..."
  }
]
```

**Post with Comments:**
```json
{
  "post": {
    "title": "...",
    "author": "...",
    "score": 1234,
    "text": "Self post content (truncated)..."
  },
  "comments": [
    {"author": "user1", "score": 100, "body": "Comment...", "depth": 0},
    {"author": "user2", "score": 50, "body": "Reply...", "depth": 1}
  ]
}
```

## Token Efficiency

| Operation | Raw JSON | Minimal JSON | Reduction |
|-----------|----------|--------------|-----------|
| 10 posts | ~11,600 tokens | ~1,200 tokens | 90% |
| Post + 30 comments | ~60,000 tokens | ~1,500 tokens | 97% |
| Search 10 results | ~18,000 tokens | ~1,200 tokens | 93% |

## Limitations

- Public subreddits only (no private/quarantined)
- Rate limited to ~10 req/min without auth
- Read-only (no posting/voting)

## Codex Integration

For Codex CLI, use the same commands:
```bash
reddit posts programming --limit 5
reddit search "topic" --limit 10
```

Output is JSON, easily parseable by any LLM.
