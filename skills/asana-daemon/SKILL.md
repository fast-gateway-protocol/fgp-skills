---
name: asana-daemon
description: Fast Asana task and project management via FGP daemon. Use when user needs to manage tasks, list projects, search workspaces, or track work in Asana. Triggers on "asana task", "create asana", "asana project", "list tasks", "asana search".
license: MIT
compatibility: Requires fgp CLI and Asana Personal Access Token (ASANA_ACCESS_TOKEN env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Asana Daemon

Fast Asana task and project management using a persistent daemon architecture. Eliminates cold-start latency from spawning Python/Node API clients on every request.

## Why FGP?

FGP daemons maintain persistent connections and avoid cold-start overhead. Instead of spawning a new API client for each request, the daemon stays warm and ready.

Benefits:
- No cold-start latency
- Connection pooling
- Persistent authentication

## Installation

```bash
# Via Homebrew (recommended)
brew tap fast-gateway-protocol/fgp
brew install fgp-asana

# Via npx
npx add-skill fgp-asana
```

## Quick Start

```bash
# Set your Asana personal access token
export ASANA_ACCESS_TOKEN="1/12345..."

# Start the daemon
fgp start asana

# List tasks in a project
fgp call asana.list_tasks --project_gid "12345"

# Create a task
fgp call asana.create_task --workspace_gid "ws123" --name "Review PR" --due_on "2026-01-20"
```

## Authentication

Get a Personal Access Token from Asana:

1. Go to https://app.asana.com/0/my-apps
2. Click "Create new token"
3. Copy the token and set `ASANA_ACCESS_TOKEN`

For OAuth2 apps, set `ASANA_CLIENT_ID` and `ASANA_CLIENT_SECRET` instead.

## Methods

### Tasks

- `asana.get_task` - Retrieve a task by GID
  - `task_gid` (string, required): The task GID
  - `opt_fields` (array, optional): Fields to return

- `asana.create_task` - Create a new task
  - `workspace_gid` (string, required): Workspace GID
  - `name` (string, required): Task name
  - `projects` (array, optional): Project GIDs to add task to
  - `assignee` (string, optional): Assignee user GID or email
  - `due_on` (string, optional): Due date (YYYY-MM-DD)
  - `notes` (string, optional): Task description

- `asana.update_task` - Update task fields
  - `task_gid` (string, required): The task GID
  - `name` (string, optional): New task name
  - `completed` (boolean, optional): Mark complete/incomplete
  - `due_on` (string, optional): New due date
  - `assignee` (string, optional): New assignee

- `asana.delete_task` - Delete a task
  - `task_gid` (string, required): The task GID

- `asana.list_tasks` - List tasks in a project or assigned to user
  - `project_gid` (string, optional): Project to list tasks from
  - `assignee` (string, optional): User GID or "me"
  - `workspace_gid` (string, required if using assignee): Workspace GID
  - `completed_since` (string, optional): ISO datetime filter

### Projects

- `asana.get_project` - Retrieve project details
  - `project_gid` (string, required): The project GID

- `asana.list_projects` - List projects in a workspace
  - `workspace_gid` (string, required): Workspace GID
  - `archived` (boolean, optional): Include archived projects

- `asana.create_project` - Create a new project
  - `workspace_gid` (string, required): Workspace GID
  - `name` (string, required): Project name
  - `team_gid` (string, optional): Team GID for team projects

### Comments & Stories

- `asana.add_comment` - Add a comment to a task
  - `task_gid` (string, required): The task GID
  - `text` (string, required): Comment text (supports @mentions)

- `asana.get_stories` - Get task activity/comments
  - `task_gid` (string, required): The task GID

### Search

- `asana.search_tasks` - Search tasks in a workspace
  - `workspace_gid` (string, required): Workspace GID
  - `text` (string, optional): Text to search for
  - `assignee` (string, optional): Filter by assignee
  - `projects` (array, optional): Filter by project GIDs
  - `completed` (boolean, optional): Filter by completion status

### Workspaces

- `asana.list_workspaces` - List all accessible workspaces
  - No parameters required

## Examples

### Get my tasks due this week

```bash
fgp call asana.search_tasks \
  --workspace_gid "12345" \
  --assignee "me" \
  --due_on.before "2026-01-24" \
  --completed false
```

### Create a task with subtasks

```bash
# Create parent task
TASK=$(fgp call asana.create_task --workspace_gid "12345" --name "Ship feature X" --projects '["proj-123"]')
TASK_GID=$(echo $TASK | jq -r '.result.gid')

# Add subtasks
fgp call asana.create_task --workspace_gid "12345" --name "Write tests" --parent "$TASK_GID"
fgp call asana.create_task --workspace_gid "12345" --name "Update docs" --parent "$TASK_GID"
```

### Mark task complete with comment

```bash
fgp call asana.update_task --task_gid "task-123" --completed true
fgp call asana.add_comment --task_gid "task-123" --text "Completed! PR merged: https://github.com/..."
```

## Error Handling

The daemon returns structured errors:

```json
{
  "ok": false,
  "error": {
    "code": "not_found",
    "message": "task: Unknown object: 12345"
  }
}
```

Common error codes:
- `not_authorized` - Invalid token or insufficient permissions
- `not_found` - Task/project not found
- `invalid_request` - Malformed request parameters
- `rate_limited` - Too many requests (daemon handles backoff)
