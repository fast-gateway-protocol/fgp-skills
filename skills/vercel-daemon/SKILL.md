---
name: fgp-vercel
description: Fast Vercel operations via FGP daemon - 30-60x faster than MCP. Use when user needs to deploy, check deployments, manage domains, or view logs. Triggers on "deploy to vercel", "check deployment", "vercel logs", "add domain", "list projects".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP Vercel Daemon

Ultra-fast Vercel operations using direct API access. **30-60x faster** than browser automation.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| List deployments | 10-20ms | ~600ms | **30-60x** |
| Deploy | 50-100ms | ~2000ms | **20-40x** |
| Get logs | 15-30ms | ~800ms | **25-55x** |
| Domain ops | 12-25ms | ~700ms | **30-55x** |

Direct Vercel API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-vercel

# Or
bash ~/.claude/skills/fgp-vercel/scripts/install.sh
```

## Setup

```bash
# Set token
export VERCEL_TOKEN="..."

# Or authenticate
fgp vercel auth
```

Get token from https://vercel.com/account/tokens

## Usage

### Deployments

```bash
# Deploy current directory
fgp vercel deploy

# Deploy with production flag
fgp vercel deploy --prod

# Deploy specific directory
fgp vercel deploy ./dist

# List recent deployments
fgp vercel deployments

# Get deployment status
fgp vercel deployment <deployment-id>

# Cancel deployment
fgp vercel deployment cancel <deployment-id>

# Promote to production
fgp vercel promote <deployment-id>
```

### Projects

```bash
# List projects
fgp vercel projects

# Get project info
fgp vercel project my-app

# Create project
fgp vercel project create my-new-app

# Link directory to project
fgp vercel link

# Environment variables
fgp vercel env list
fgp vercel env add API_KEY "secret" --env production
fgp vercel env rm API_KEY --env production
```

### Domains

```bash
# List domains
fgp vercel domains

# Add domain
fgp vercel domain add example.com --project my-app

# Remove domain
fgp vercel domain rm example.com

# Check DNS
fgp vercel domain verify example.com

# Certificates
fgp vercel certs
```

### Logs

```bash
# Deployment logs
fgp vercel logs <deployment-id>

# Build logs
fgp vercel logs <deployment-id> --type build

# Function logs (real-time)
fgp vercel logs --follow

# Filter by function
fgp vercel logs --function api/hello
```

### Teams

```bash
# List teams
fgp vercel teams

# Switch team
fgp vercel team switch my-team

# Team members
fgp vercel team members
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `deploy` | Deploy project | `fgp vercel deploy --prod` |
| `deployments` | List deployments | `fgp vercel deployments` |
| `deployment` | Deployment info | `fgp vercel deployment <id>` |
| `projects` | List projects | `fgp vercel projects` |
| `project` | Project info | `fgp vercel project my-app` |
| `domains` | List domains | `fgp vercel domains` |
| `domain add` | Add domain | `fgp vercel domain add example.com` |
| `logs` | View logs | `fgp vercel logs <id>` |
| `env` | Manage env vars | `fgp vercel env list` |

## Example Workflows

### Deploy to production
```bash
# Deploy
fgp vercel deploy --prod

# Check status
fgp vercel deployments --limit 1
```

### Debug failed deployment
```bash
# Get recent deployments
fgp vercel deployments

# Check build logs
fgp vercel logs <deployment-id> --type build
```

### Add custom domain
```bash
# Add domain
fgp vercel domain add mysite.com --project my-app

# Verify DNS
fgp vercel domain verify mysite.com
```

## Troubleshooting

### Not authenticated
```
Error: No token found
```
Set `VERCEL_TOKEN` or run `fgp vercel auth`.

### Project not linked
```
Error: No project linked
```
Run `fgp vercel link` in project directory.

### Deployment failed
```
Error: Build failed
```
Check logs: `fgp vercel logs <id> --type build`

## Architecture

- **Vercel REST API**
- **Token authentication**
- **UNIX socket** at `~/.fgp/services/vercel/daemon.sock`
- **Deployment streaming** for real-time logs
