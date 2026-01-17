---
name: fgp-cloudflare
description: Fast Cloudflare operations via FGP daemon - 50-100x faster than MCP. Use when user needs to manage DNS, Workers, KV, or Cloudflare settings. Triggers on "add DNS record", "deploy worker", "cloudflare settings", "purge cache", "list domains".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP Cloudflare Daemon

Ultra-fast Cloudflare operations using direct API access. **50-100x faster** than browser automation.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| List DNS records | 10-20ms | ~1000ms | **50-100x** |
| Create DNS record | 15-30ms | ~1200ms | **40-80x** |
| Deploy Worker | 30-60ms | ~2000ms | **30-65x** |
| KV operations | 8-15ms | ~800ms | **50-100x** |

Direct Cloudflare API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-cloudflare

# Or
bash ~/.claude/skills/fgp-cloudflare/scripts/install.sh
```

## Setup

```bash
# Set API token
export CLOUDFLARE_API_TOKEN="..."

# Or use global API key
export CLOUDFLARE_API_KEY="..."
export CLOUDFLARE_EMAIL="..."
```

Create token at https://dash.cloudflare.com/profile/api-tokens

## Usage

### DNS Records

```bash
# List zones (domains)
fgp cf zones

# List DNS records
fgp cf dns list example.com

# Add A record
fgp cf dns add example.com A @ 192.168.1.1

# Add CNAME
fgp cf dns add example.com CNAME www target.example.com

# Add with proxy
fgp cf dns add example.com A api 192.168.1.2 --proxied

# Update record
fgp cf dns update example.com <record-id> --content 192.168.1.3

# Delete record
fgp cf dns delete example.com <record-id>

# Export zone file
fgp cf dns export example.com > zone.txt
```

### Workers

```bash
# List workers
fgp cf workers

# Deploy worker
fgp cf worker deploy my-worker --script worker.js

# Deploy from directory
fgp cf worker deploy my-api --dir ./worker

# Get worker
fgp cf worker get my-worker

# Delete worker
fgp cf worker delete my-worker

# View logs (tail)
fgp cf worker logs my-worker
```

### KV (Key-Value Store)

```bash
# List namespaces
fgp cf kv namespaces

# Create namespace
fgp cf kv namespace create MY_KV

# List keys
fgp cf kv keys MY_KV

# Get value
fgp cf kv get MY_KV my-key

# Set value
fgp cf kv set MY_KV my-key "my value"

# Set with expiration
fgp cf kv set MY_KV temp-key "expires soon" --ttl 3600

# Delete key
fgp cf kv delete MY_KV my-key

# Bulk write
fgp cf kv bulk MY_KV --file data.json
```

### Cache

```bash
# Purge everything
fgp cf cache purge example.com --all

# Purge specific URLs
fgp cf cache purge example.com --urls "https://example.com/page1,https://example.com/page2"

# Purge by tag
fgp cf cache purge example.com --tags "blog,static"

# Purge by prefix
fgp cf cache purge example.com --prefixes "https://example.com/api/"
```

### Page Rules & Settings

```bash
# List page rules
fgp cf rules example.com

# Zone settings
fgp cf settings example.com

# Enable/disable features
fgp cf settings example.com --ssl full
fgp cf settings example.com --minify on
fgp cf settings example.com --always-https on
```

### Analytics

```bash
# Zone analytics
fgp cf analytics example.com --since "24 hours ago"

# Worker analytics
fgp cf worker analytics my-worker
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `zones` | List domains | `fgp cf zones` |
| `dns list` | List DNS records | `fgp cf dns list example.com` |
| `dns add` | Add DNS record | `fgp cf dns add example.com A @ 1.2.3.4` |
| `workers` | List workers | `fgp cf workers` |
| `worker deploy` | Deploy worker | `fgp cf worker deploy name` |
| `kv` | KV operations | `fgp cf kv get NS key` |
| `cache purge` | Purge cache | `fgp cf cache purge example.com` |
| `settings` | Zone settings | `fgp cf settings example.com` |

## DNS Record Types

| Type | Example |
|------|---------|
| A | `fgp cf dns add example.com A @ 1.2.3.4` |
| AAAA | `fgp cf dns add example.com AAAA @ 2001:db8::1` |
| CNAME | `fgp cf dns add example.com CNAME www target.com` |
| MX | `fgp cf dns add example.com MX @ mail.example.com --priority 10` |
| TXT | `fgp cf dns add example.com TXT @ "v=spf1 ..."` |

## Example Workflows

### Deploy website
```bash
# Add DNS pointing to Vercel
fgp cf dns add mysite.com CNAME @ cname.vercel-dns.com --proxied

# Enable HTTPS
fgp cf settings mysite.com --ssl full --always-https on
```

### Deploy Worker
```bash
# Write worker
cat > worker.js << 'EOF'
export default {
  fetch(request) {
    return new Response("Hello from FGP!");
  }
}
EOF

# Deploy
fgp cf worker deploy hello-world --script worker.js

# Add route
fgp cf worker route add example.com/api/* hello-world
```

### Cache management
```bash
# After deploy, purge old cache
fgp cf cache purge example.com --all
```

## Troubleshooting

### Zone not found
```
Error: Zone example.com not found
```
Check domain is added to Cloudflare account.

### Permission denied
```
Error: Token missing required permissions
```
Add required permissions to API token.

### Invalid token
```
Error: Invalid API token
```
Check `CLOUDFLARE_API_TOKEN` is correct.

## Architecture

- **Cloudflare API v4**
- **API token authentication**
- **UNIX socket** at `~/.fgp/services/cloudflare/daemon.sock`
- **Zone caching** for faster lookups
