---
name: github-actions-daemon
description: Fast GitHub Actions operations via FGP daemon - 30-60x faster than gh CLI. Use when user needs to trigger workflows, check run status, download artifacts, or view logs. Triggers on "github actions", "trigger workflow", "workflow run", "check CI", "download artifact", "actions logs".
license: MIT
compatibility: Requires fgp CLI and GitHub token (GITHUB_TOKEN env var or gh CLI auth)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP GitHub Actions Daemon

Fast GitHub Actions management via GraphQL and REST APIs.

## Why FGP?

| Operation | FGP Daemon | gh CLI | Speedup |
|-----------|------------|--------|---------|
| List runs | 15ms | 500ms | **33x** |
| Trigger workflow | 20ms | 600ms | **30x** |
| Get logs | 25ms | 800ms | **32x** |
| Cancel run | 10ms | 400ms | **40x** |

## Installation

```bash
brew install fast-gateway-protocol/fgp/fgp-github-actions
```

## Setup

```bash
# Uses gh auth or GITHUB_TOKEN
export GITHUB_TOKEN="ghp_..."

fgp start github-actions
```

## Available Commands

| Command | Description |
|---------|-------------|
| `actions.workflows` | List workflows |
| `actions.runs` | List workflow runs |
| `actions.run` | Get run details |
| `actions.trigger` | Trigger workflow |
| `actions.cancel` | Cancel run |
| `actions.rerun` | Re-run workflow |
| `actions.logs` | Get run logs |
| `actions.artifacts` | List artifacts |
| `actions.download` | Download artifact |
| `actions.secrets` | List secrets |

## Example Workflows

```bash
# List recent runs
fgp call actions.runs --repo owner/repo --workflow deploy.yml --limit 10

# Trigger workflow
fgp call actions.trigger --repo owner/repo --workflow deploy.yml --ref main --inputs '{"env": "prod"}'

# Get logs for failed run
fgp call actions.logs --repo owner/repo --run-id 12345

# Download artifacts
fgp call actions.download --repo owner/repo --run-id 12345 --name build-output
```
