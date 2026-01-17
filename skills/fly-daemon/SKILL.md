---
name: fgp-fly
description: Fast Fly.io operations via FGP daemon - 25-50x faster than CLI. Use when user needs to deploy, scale, check status, or manage Fly apps. Triggers on "deploy to fly", "fly status", "scale app", "fly logs", "list machines".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP Fly Daemon

Ultra-fast Fly.io operations using direct API access. **25-50x faster** than the fly CLI for most operations.

## Why FGP?

| Operation | FGP Daemon | fly CLI | Speedup |
|-----------|------------|---------|---------|
| App status | 8-15ms | ~400ms | **25-50x** |
| List machines | 10-20ms | ~500ms | **25-50x** |
| Scale | 15-30ms | ~600ms | **20-40x** |
| Logs | 12-25ms | ~450ms | **20-35x** |

Direct Fly.io GraphQL/REST API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-fly

# Or
bash ~/.claude/skills/fgp-fly/scripts/install.sh
```

## Setup

```bash
# Use existing flyctl auth
fgp fly auth --from-flyctl

# Or set token directly
export FLY_API_TOKEN="..."
```

## Usage

### Apps

```bash
# List apps
fgp fly apps

# App status
fgp fly status my-app

# App info
fgp fly app my-app

# Create app
fgp fly app create my-new-app --region ord

# Delete app
fgp fly app delete my-old-app
```

### Deployments

```bash
# Deploy current directory
fgp fly deploy

# Deploy with specific image
fgp fly deploy --image my-registry/app:latest

# Deploy to specific region
fgp fly deploy --region lax

# Deployment status
fgp fly releases my-app
```

### Machines

```bash
# List machines
fgp fly machines my-app

# Machine status
fgp fly machine <machine-id>

# Start/stop machine
fgp fly machine start <machine-id>
fgp fly machine stop <machine-id>

# Restart machine
fgp fly machine restart <machine-id>

# Clone machine to new region
fgp fly machine clone <machine-id> --region lhr
```

### Scaling

```bash
# Scale count
fgp fly scale count my-app 3

# Scale count per region
fgp fly scale count my-app 2 --region ord
fgp fly scale count my-app 1 --region lhr

# Scale VM size
fgp fly scale vm my-app shared-cpu-2x

# Autoscaling
fgp fly autoscale my-app --min 1 --max 10
```

### Logs

```bash
# Recent logs
fgp fly logs my-app

# Follow logs
fgp fly logs my-app --follow

# Filter by region
fgp fly logs my-app --region ord

# Filter by instance
fgp fly logs my-app --instance <instance-id>
```

### Secrets

```bash
# List secrets
fgp fly secrets my-app

# Set secret
fgp fly secrets set my-app DATABASE_URL="postgres://..."

# Unset secret
fgp fly secrets unset my-app OLD_SECRET

# Import from .env
fgp fly secrets import my-app < .env
```

### Volumes

```bash
# List volumes
fgp fly volumes my-app

# Create volume
fgp fly volume create my-app my-data --size 10 --region ord

# Extend volume
fgp fly volume extend <volume-id> --size 20

# Snapshots
fgp fly volume snapshots <volume-id>
```

### Networking

```bash
# List IPs
fgp fly ips my-app

# Allocate IP
fgp fly ip allocate my-app --type v4

# Release IP
fgp fly ip release my-app <ip-address>

# Certificates
fgp fly certs my-app
fgp fly cert add my-app example.com
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `apps` | List apps | `fgp fly apps` |
| `status` | App status | `fgp fly status my-app` |
| `deploy` | Deploy app | `fgp fly deploy` |
| `machines` | List machines | `fgp fly machines my-app` |
| `scale` | Scale app | `fgp fly scale count my-app 3` |
| `logs` | View logs | `fgp fly logs my-app` |
| `secrets` | Manage secrets | `fgp fly secrets my-app` |
| `volumes` | Manage volumes | `fgp fly volumes my-app` |

## Example Workflows

### Quick deploy
```bash
fgp fly deploy --strategy immediate
```

### Scale for traffic
```bash
# Add machines in multiple regions
fgp fly scale count my-app 3 --region ord
fgp fly scale count my-app 2 --region lhr
fgp fly scale count my-app 2 --region syd
```

### Debug issue
```bash
# Check status
fgp fly status my-app

# Check logs
fgp fly logs my-app --limit 100

# SSH into machine
fgp fly ssh my-app
```

## Troubleshooting

### Not authenticated
```
Error: No token found
```
Run `fgp fly auth --from-flyctl` or set `FLY_API_TOKEN`.

### App not found
```
Error: App my-app not found
```
Check app name or organization.

### Deploy failed
```
Error: Deployment failed
```
Check logs: `fgp fly logs my-app --type deploy`

## Architecture

- **Fly.io GraphQL + Machines API**
- **Token authentication**
- **UNIX socket** at `~/.fgp/services/fly/daemon.sock`
- **Log streaming** via NATS
