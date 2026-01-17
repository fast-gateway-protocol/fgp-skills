---
name: redis-daemon
description: Fast Redis operations via FGP daemon - 15-50x faster than spawning redis-cli per command. Use when user needs to get/set cache values, manage keys, pub/sub, or work with Redis data structures. Triggers on "redis get", "redis set", "cache", "redis-cli", "get key", "set key".
license: MIT
compatibility: Requires fgp CLI and Redis connection (REDIS_URL env var or localhost:6379)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Redis Daemon

Ultra-fast Redis operations with persistent connection pooling. **15-50x faster** than spawning redis-cli per command.

## Why FGP?

| Operation | FGP Daemon | redis-cli | Speedup |
|-----------|------------|-----------|---------|
| GET | 0.1-0.3ms | ~15ms | **50-150x** |
| SET | 0.1-0.4ms | ~15ms | **40-150x** |
| HGETALL | 0.2-0.5ms | ~16ms | **30-80x** |
| Pipeline 100 | 1-3ms | ~50ms | **15-50x** |

Persistent connections eliminate process spawn and connection overhead.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-redis

# Or
bash ~/.claude/skills/fgp-redis/scripts/install.sh
```

## Setup

```bash
# Default connection (localhost:6379)
fgp redis ping

# With URL
export REDIS_URL="redis://localhost:6379"

# With password
export REDIS_URL="redis://:password@localhost:6379"

# With TLS
export REDIS_URL="rediss://user:pass@host:6379"

# Select database
export REDIS_URL="redis://localhost:6379/1"
```

## Usage

### Basic Operations

```bash
# Get value
fgp redis get mykey

# Set value
fgp redis set mykey "myvalue"

# Set with expiry (seconds)
fgp redis set mykey "value" --ex 3600

# Set with expiry (milliseconds)
fgp redis set mykey "value" --px 60000

# Set if not exists
fgp redis set mykey "value" --nx

# Set if exists
fgp redis set mykey "value" --xx

# Get and set
fgp redis getset mykey "newvalue"

# Delete
fgp redis del mykey

# Delete multiple
fgp redis del key1 key2 key3

# Check exists
fgp redis exists mykey

# Get type
fgp redis type mykey
```

### Key Management

```bash
# List keys (pattern)
fgp redis keys "user:*"

# Scan keys (safe for production)
fgp redis scan "user:*"

# Rename key
fgp redis rename oldkey newkey

# Expire key
fgp redis expire mykey 3600

# Get TTL
fgp redis ttl mykey

# Persist (remove expiry)
fgp redis persist mykey

# Random key
fgp redis randomkey
```

### Strings

```bash
# Increment
fgp redis incr counter

# Increment by
fgp redis incrby counter 10

# Increment float
fgp redis incrbyfloat price 0.50

# Decrement
fgp redis decr counter

# Append
fgp redis append mykey " more text"

# Get length
fgp redis strlen mykey

# Get range
fgp redis getrange mykey 0 10

# Set range
fgp redis setrange mykey 6 "Redis"

# Multiple get
fgp redis mget key1 key2 key3

# Multiple set
fgp redis mset key1 "val1" key2 "val2"
```

### Hashes

```bash
# Set field
fgp redis hset user:1 name "John"

# Set multiple fields
fgp redis hset user:1 name "John" email "john@example.com" age 30

# Get field
fgp redis hget user:1 name

# Get all fields
fgp redis hgetall user:1

# Get multiple fields
fgp redis hmget user:1 name email

# Check field exists
fgp redis hexists user:1 name

# Delete field
fgp redis hdel user:1 age

# Get all keys
fgp redis hkeys user:1

# Get all values
fgp redis hvals user:1

# Get field count
fgp redis hlen user:1

# Increment field
fgp redis hincrby user:1 visits 1
```

### Lists

```bash
# Push left
fgp redis lpush mylist "item1"

# Push right
fgp redis rpush mylist "item2"

# Pop left
fgp redis lpop mylist

# Pop right
fgp redis rpop mylist

# Get range
fgp redis lrange mylist 0 -1

# Get by index
fgp redis lindex mylist 0

# Get length
fgp redis llen mylist

# Set by index
fgp redis lset mylist 0 "newvalue"

# Trim list
fgp redis ltrim mylist 0 99

# Remove elements
fgp redis lrem mylist 0 "value"

# Blocking pop
fgp redis blpop mylist 5
fgp redis brpop mylist 5

# Move between lists
fgp redis lmove source dest LEFT RIGHT
```

### Sets

```bash
# Add member
fgp redis sadd myset "member1"

# Add multiple
fgp redis sadd myset "a" "b" "c"

# Get all members
fgp redis smembers myset

# Check membership
fgp redis sismember myset "member1"

# Remove member
fgp redis srem myset "member1"

# Get random member
fgp redis srandmember myset

# Pop random
fgp redis spop myset

# Get size
fgp redis scard myset

# Union
fgp redis sunion set1 set2

# Intersection
fgp redis sinter set1 set2

# Difference
fgp redis sdiff set1 set2

# Store union
fgp redis sunionstore destset set1 set2
```

### Sorted Sets

```bash
# Add with score
fgp redis zadd leaderboard 100 "player1"

# Add multiple
fgp redis zadd leaderboard 100 "p1" 95 "p2" 90 "p3"

# Get range by rank
fgp redis zrange leaderboard 0 9

# Get range with scores
fgp redis zrange leaderboard 0 9 WITHSCORES

# Get range by score
fgp redis zrangebyscore leaderboard 90 100

# Get reverse range
fgp redis zrevrange leaderboard 0 9

# Get rank
fgp redis zrank leaderboard "player1"

# Get score
fgp redis zscore leaderboard "player1"

# Increment score
fgp redis zincrby leaderboard 10 "player1"

# Remove member
fgp redis zrem leaderboard "player1"

# Remove by rank
fgp redis zremrangebyrank leaderboard 0 2

# Get size
fgp redis zcard leaderboard
```

### JSON (RedisJSON)

```bash
# Set JSON
fgp redis json.set user:1 $ '{"name": "John", "age": 30}'

# Get JSON
fgp redis json.get user:1

# Get path
fgp redis json.get user:1 $.name

# Set path
fgp redis json.set user:1 $.age 31

# Increment
fgp redis json.numincrby user:1 $.age 1

# Array append
fgp redis json.arrappend user:1 $.tags '"new"'

# Delete path
fgp redis json.del user:1 $.temp
```

### Pub/Sub

```bash
# Publish
fgp redis publish channel "message"

# Subscribe (streaming)
fgp redis subscribe channel

# Pattern subscribe
fgp redis psubscribe "news:*"

# List channels
fgp redis pubsub channels
```

### Streams

```bash
# Add to stream
fgp redis xadd mystream "*" field1 value1 field2 value2

# Read from stream
fgp redis xread STREAMS mystream 0

# Read new entries
fgp redis xread BLOCK 5000 STREAMS mystream $

# Range
fgp redis xrange mystream - +

# Length
fgp redis xlen mystream

# Create consumer group
fgp redis xgroup CREATE mystream mygroup $ MKSTREAM

# Read as consumer
fgp redis xreadgroup GROUP mygroup consumer STREAMS mystream >

# Acknowledge
fgp redis xack mystream mygroup message-id
```

### Transactions

```bash
# Multi/Exec
fgp redis multi
fgp redis set key1 value1
fgp redis set key2 value2
fgp redis exec

# Transaction block
fgp redis transaction "
SET key1 value1
SET key2 value2
INCR counter
"

# Watch (optimistic locking)
fgp redis watch mykey
fgp redis multi
fgp redis set mykey newvalue
fgp redis exec
```

### Lua Scripts

```bash
# Eval script
fgp redis eval "return redis.call('GET', KEYS[1])" 1 mykey

# Load script
fgp redis script load "return redis.call('GET', KEYS[1])"

# Run loaded script
fgp redis evalsha <sha> 1 mykey
```

### Server Commands

```bash
# Ping
fgp redis ping

# Info
fgp redis info

# Info section
fgp redis info memory

# Database size
fgp redis dbsize

# Flush database
fgp redis flushdb

# Flush all
fgp redis flushall

# Last save time
fgp redis lastsave

# Background save
fgp redis bgsave

# Config get
fgp redis config get maxmemory

# Config set
fgp redis config set maxmemory 100mb

# Slowlog
fgp redis slowlog get 10

# Client list
fgp redis client list
```

### Cluster

```bash
# Cluster info
fgp redis cluster info

# Cluster nodes
fgp redis cluster nodes

# Cluster slots
fgp redis cluster slots

# Key slot
fgp redis cluster keyslot mykey
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `get` | Get value | `fgp redis get mykey` |
| `set` | Set value | `fgp redis set mykey "value"` |
| `del` | Delete key | `fgp redis del mykey` |
| `keys` | List keys | `fgp redis keys "user:*"` |
| `hset` | Set hash field | `fgp redis hset user:1 name "John"` |
| `hgetall` | Get all hash | `fgp redis hgetall user:1` |
| `lpush` | Push to list | `fgp redis lpush mylist "item"` |
| `lrange` | Get list range | `fgp redis lrange mylist 0 -1` |
| `sadd` | Add to set | `fgp redis sadd myset "member"` |
| `zadd` | Add to sorted set | `fgp redis zadd lb 100 "player"` |
| `publish` | Publish message | `fgp redis publish channel "msg"` |
| `info` | Server info | `fgp redis info` |

## Example Workflows

### Session cache
```bash
# Store session
fgp redis set "session:abc123" '{"user_id": 1, "role": "admin"}' --ex 3600

# Get session
fgp redis get "session:abc123"

# Extend session
fgp redis expire "session:abc123" 3600
```

### Rate limiting
```bash
# Increment and check
COUNT=$(fgp redis incr "rate:user:1:$(date +%Y%m%d%H%M)")
fgp redis expire "rate:user:1:$(date +%Y%m%d%H%M)" 60

if [ "$COUNT" -gt 100 ]; then
  echo "Rate limit exceeded"
fi
```

### Leaderboard
```bash
# Add scores
fgp redis zadd leaderboard 1500 "alice" 1200 "bob" 1800 "charlie"

# Get top 10
fgp redis zrevrange leaderboard 0 9 WITHSCORES

# Get player rank
fgp redis zrevrank leaderboard "alice"
```

### Job queue
```bash
# Add job
fgp redis lpush jobs '{"type": "email", "to": "user@example.com"}'

# Process job (blocking)
JOB=$(fgp redis brpop jobs 30)
```

### Real-time analytics
```bash
# Increment page views
fgp redis hincrby "stats:2024-01-15" "/home" 1

# Get daily stats
fgp redis hgetall "stats:2024-01-15"
```

## Troubleshooting

### Connection refused
```
Error: Connection refused
```
Check Redis is running: `redis-server` or `brew services start redis`

### Authentication failed
```
Error: NOAUTH Authentication required
```
Set password in URL: `REDIS_URL="redis://:password@localhost:6379"`

### Wrong type
```
Error: WRONGTYPE Operation against a key holding the wrong kind of value
```
Check key type with: `fgp redis type mykey`

### Memory limit
```
Error: OOM command not allowed
```
Redis is out of memory. Check with: `fgp redis info memory`

## Architecture

- **redis-rs** for native Redis protocol
- **Connection pooling** with configurable size
- **UNIX socket** at `~/.fgp/services/redis/daemon.sock`
- **Pipeline support** for batch operations
- **Cluster support** for distributed Redis
- **TLS support** for secure connections
