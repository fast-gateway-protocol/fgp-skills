---
name: github-daemon
description: Fast GitHub operations via FGP daemon - 75x faster than MCP. Use when user needs to work with issues, pull requests, repositories, CI/CD status, or GitHub API. Triggers on "list issues", "create PR", "check CI status", "list repos", "review PR", "github issues", "merge pull request", "github search".
license: MIT
compatibility: Requires fgp CLI and GitHub token (GITHUB_TOKEN env var or gh CLI auth)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP GitHub Daemon

Ultra-fast GitHub operations using GraphQL and REST APIs. **75x faster** than MCP alternatives.

## Why FGP?

| Operation | FGP Daemon | GitHub MCP | Speedup |
|-----------|------------|------------|---------|
| List issues | 8-15ms | ~600ms | **40-75x** |
| Get PR | 10-20ms | ~700ms | **35-70x** |
| List repos | 12-25ms | ~800ms | **30-65x** |
| Create issue | 15-30ms | ~900ms | **30-60x** |

Direct API calls via persistent daemon - no subprocess spawn overhead.

## Installation

```bash
# Install via Homebrew
brew install fast-gateway-protocol/tap/fgp-github

# Or run install script
bash ~/.claude/skills/fgp-github/scripts/install.sh
```

## Setup (One-Time)

Set your GitHub token:

```bash
# Option 1: Environment variable
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"

# Option 2: Store in keychain (macOS)
fgp github auth --token ghp_xxxxxxxxxxxx

# Option 3: Use gh CLI token
fgp github auth --from-gh-cli
```

Create a token at: https://github.com/settings/tokens

Required scopes: `repo`, `read:org`, `read:user`

## Usage

### Issues

```bash
# List issues in current repo
fgp github issues

# List issues in specific repo
fgp github issues --repo owner/repo

# Filter by state
fgp github issues --state open --label bug

# Create issue
fgp github issues create --title "Bug report" --body "Description here"

# Close issue
fgp github issues close 123
```

### Pull Requests

```bash
# List PRs
fgp github prs

# Get specific PR
fgp github pr 456

# Create PR
fgp github pr create --title "Feature X" --body "Description" --base main --head feature-branch

# List PR reviews
fgp github pr reviews 456

# Check CI status
fgp github pr checks 456
```

### Repositories

```bash
# List your repos
fgp github repos

# List org repos
fgp github repos --org my-org

# Get repo info
fgp github repo owner/repo

# Clone repo
fgp github clone owner/repo
```

### Users & Orgs

```bash
# Get user info
fgp github user octocat

# List org members
fgp github org members my-org

# List teams
fgp github org teams my-org
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `issues` | List issues | `fgp github issues --state open` |
| `issues create` | Create issue | `fgp github issues create --title "X"` |
| `issues close` | Close issue | `fgp github issues close 123` |
| `prs` | List PRs | `fgp github prs --state open` |
| `pr <num>` | Get PR details | `fgp github pr 456` |
| `pr create` | Create PR | `fgp github pr create --title "X"` |
| `pr merge` | Merge PR | `fgp github pr merge 456` |
| `pr checks` | Get CI status | `fgp github pr checks 456` |
| `repos` | List repos | `fgp github repos --org myorg` |
| `repo` | Get repo info | `fgp github repo owner/repo` |
| `search` | Search GitHub | `fgp github search "language:rust"` |

## GraphQL Queries

For complex queries, use raw GraphQL:

```bash
fgp github graphql '
  query {
    repository(owner: "facebook", name: "react") {
      stargazerCount
      forkCount
    }
  }
'
```

## Example Workflows

### Triage issues
```bash
# List open bugs
fgp github issues --state open --label bug

# Add label
fgp github issues label 123 --add priority:high
```

### Review PRs
```bash
# List PRs needing review
fgp github prs --state open --review-requested @me

# Check PR details and CI
fgp github pr 456
fgp github pr checks 456
```

### Create feature PR
```bash
# Create PR from current branch
fgp github pr create \
  --title "Add feature X" \
  --body "## Summary\nAdds feature X\n\n## Test Plan\n- [x] Unit tests" \
  --base main
```

## Daemon Management

```bash
# Check status
fgp github health

# View methods
fgp github methods

# Stop/start daemon
fgp github stop
fgp github start
```

## Troubleshooting

### Not authenticated
```
Error: No GitHub token found
```
Set `GITHUB_TOKEN` or run `fgp github auth`

### Rate limited
```
Error: API rate limit exceeded
```
GitHub allows 5000 requests/hour. Check limit: `fgp github rate-limit`

### Repo not found
```
Error: Repository not found
```
Check permissions and repo name spelling.

## Architecture

- **GitHub GraphQL API** (primary) + REST API (fallback)
- **Token auth** via env var or keychain
- **UNIX socket** at `~/.fgp/services/github/daemon.sock`
- **Response caching** for repeated queries
