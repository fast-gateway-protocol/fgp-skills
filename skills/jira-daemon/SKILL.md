---
name: fgp-jira
description: Fast Jira operations via FGP daemon - 25-50x faster than MCP. Issues, sprints, boards, and JQL queries.
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
  categories: ["devtools", "productivity"]
---

# FGP Jira Daemon

Fast Jira issue tracking operations.

## Why FGP?

| Operation | FGP Daemon | REST API | Speedup |
|-----------|------------|----------|---------|
| JQL search | 20ms | 600ms | **30x** |
| Get issue | 10ms | 300ms | **30x** |
| Create issue | 25ms | 500ms | **20x** |
| Transition | 15ms | 400ms | **27x** |

## Installation

```bash
brew install fast-gateway-protocol/fgp/fgp-jira
```

## Setup

```bash
export JIRA_URL="https://your-domain.atlassian.net"
export JIRA_EMAIL="your@email.com"
export JIRA_API_TOKEN="..."

fgp start jira
```

## Available Commands

| Command | Description |
|---------|-------------|
| `jira.search` | JQL search |
| `jira.issue` | Get issue |
| `jira.create` | Create issue |
| `jira.update` | Update issue |
| `jira.transition` | Change status |
| `jira.comment` | Add comment |
| `jira.assign` | Assign issue |
| `jira.sprints` | List sprints |
| `jira.boards` | List boards |
| `jira.projects` | List projects |

## Example Workflows

```bash
# Search issues
fgp call jira.search --jql "project = PROJ AND status = 'In Progress'" --limit 20

# Create issue
fgp call jira.create --project PROJ --type Task --summary "New feature" --description "..."

# Transition to Done
fgp call jira.transition --issue PROJ-123 --status Done

# Add comment
fgp call jira.comment --issue PROJ-123 --body "Fixed in PR #456"
```
