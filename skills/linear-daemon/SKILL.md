---
name: linear-daemon
description: Fast Linear operations via FGP daemon - 45-90x faster than MCP. Use when user needs to manage issues, check sprints/cycles, update tickets, or work with Linear projects. Triggers on "create linear issue", "check linear", "list issues", "update ticket", "linear sprint", "linear cycle", "linear project".
license: MIT
compatibility: Requires fgp CLI and Linear API Key (LINEAR_API_KEY env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Linear Daemon

Ultra-fast Linear operations using GraphQL API. **45-90x faster** than browser automation.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| List issues | 10-20ms | ~900ms | **45-90x** |
| Create issue | 15-30ms | ~1100ms | **35-70x** |
| Update issue | 12-25ms | ~1000ms | **40-80x** |
| Search | 20-40ms | ~1200ms | **30-60x** |

Direct Linear GraphQL API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-linear

# Or
bash ~/.claude/skills/fgp-linear/scripts/install.sh
```

## Setup

```bash
# Set API key
export LINEAR_API_KEY="lin_api_..."

# Or authenticate
fgp linear auth
```

Get API key from Linear Settings > API > Personal API keys.

## Usage

### Issues

```bash
# List my issues
fgp linear issues

# List by state
fgp linear issues --state "In Progress"

# List by team
fgp linear issues --team "Engineering"

# Get specific issue
fgp linear issue ENG-123

# Create issue
fgp linear issue create "Fix login bug" --team "Engineering" --priority high

# Create with details
fgp linear issue create "Add dark mode" \
  --team "Frontend" \
  --description "Implement dark mode toggle" \
  --labels "feature,ui" \
  --estimate 3 \
  --assignee "@me"

# Update issue
fgp linear issue update ENG-123 --state "Done"

# Assign issue
fgp linear issue assign ENG-123 "@alice"

# Add comment
fgp linear issue comment ENG-123 "Fixed in commit abc123"
```

### Cycles (Sprints)

```bash
# Current cycle
fgp linear cycle

# Cycle issues
fgp linear cycle issues

# Past cycles
fgp linear cycles --past 3

# Cycle progress
fgp linear cycle progress
```

### Projects

```bash
# List projects
fgp linear projects

# Project details
fgp linear project "Q1 Launch"

# Project issues
fgp linear project issues "Q1 Launch"

# Project progress
fgp linear project progress "Q1 Launch"
```

### Teams

```bash
# List teams
fgp linear teams

# Team issues
fgp linear team issues "Engineering"

# Team members
fgp linear team members "Engineering"
```

### Search

```bash
# Search issues
fgp linear search "authentication bug"

# Advanced search
fgp linear search "priority:high state:backlog"
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `issues` | List issues | `fgp linear issues --state Todo` |
| `issue` | Get issue | `fgp linear issue ENG-123` |
| `issue create` | Create issue | `fgp linear issue create "Title"` |
| `issue update` | Update issue | `fgp linear issue update ENG-123` |
| `cycle` | Current cycle | `fgp linear cycle` |
| `projects` | List projects | `fgp linear projects` |
| `teams` | List teams | `fgp linear teams` |
| `search` | Search issues | `fgp linear search "query"` |

## States

Linear states vary by team. Common ones:
- `Backlog`, `Todo`, `In Progress`, `In Review`, `Done`, `Canceled`

```bash
# List available states
fgp linear states --team "Engineering"
```

## Priority Levels

| Priority | Flag |
|----------|------|
| Urgent | `--priority urgent` |
| High | `--priority high` |
| Medium | `--priority medium` |
| Low | `--priority low` |
| None | `--priority none` |

## Example Workflows

### Daily standup
```bash
# What I'm working on
fgp linear issues --assignee "@me" --state "In Progress"

# What's blocked
fgp linear issues --assignee "@me" --label "blocked"
```

### Triage new issues
```bash
# Unassigned issues
fgp linear issues --team "Engineering" --state "Backlog" --no-assignee

# Assign and prioritize
fgp linear issue update ENG-456 --assignee "@bob" --priority high
```

### Sprint planning
```bash
# Current cycle status
fgp linear cycle progress

# Move issue to cycle
fgp linear issue update ENG-789 --cycle current
```

### Quick bug report
```bash
fgp linear issue create "API returns 500 on /users" \
  --team "Backend" \
  --priority urgent \
  --labels "bug" \
  --description "Steps to reproduce:\n1. Call GET /users\n2. See 500 error"
```

## Troubleshooting

### Issue not found
```
Error: Issue ENG-123 not found
```
Check issue identifier is correct.

### Invalid API key
```
Error: Authentication failed
```
Check `LINEAR_API_KEY` is valid.

### Team not found
```
Error: Team "Eng" not found
```
Use exact team name: `fgp linear teams`

## Architecture

- **Linear GraphQL API**
- **API key authentication**
- **UNIX socket** at `~/.fgp/services/linear/daemon.sock`
- **Query batching** for efficiency
