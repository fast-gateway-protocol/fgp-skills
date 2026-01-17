---
name: clickup-daemon
description: Fast ClickUp task and time tracking via FGP daemon. Use when user needs to manage tasks, track time, update status, or work with ClickUp lists. Triggers on "clickup task", "create clickup", "clickup list", "time tracking", "clickup status".
license: MIT
compatibility: Requires fgp CLI and ClickUp API Token (CLICKUP_API_TOKEN env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP ClickUp Daemon

Fast ClickUp task management using a persistent daemon architecture. Eliminates cold-start latency from spawning API clients on every request.

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
brew install fgp-clickup

# Via npx
npx add-skill fgp-clickup
```

## Quick Start

```bash
# Set your ClickUp API token
export CLICKUP_API_TOKEN="pk_..."

# Start the daemon
fgp start clickup

# List tasks in a list
fgp call clickup.list_tasks --list_id "12345"

# Create a task
fgp call clickup.create_task --list_id "12345" --name "Review code" --priority 2
```

## Authentication

Get your API token from ClickUp:

1. Go to Settings > Apps
2. Click "Generate" under API Token
3. Copy the token (starts with `pk_`)
4. Set `CLICKUP_API_TOKEN` environment variable

For OAuth2 apps, configure `CLICKUP_CLIENT_ID` and `CLICKUP_CLIENT_SECRET`.

## Methods

### Tasks

- `clickup.get_task` - Retrieve a task by ID
  - `task_id` (string, required): The task ID
  - `include_subtasks` (boolean, optional): Include subtasks

- `clickup.create_task` - Create a new task
  - `list_id` (string, required): List ID to create task in
  - `name` (string, required): Task name
  - `description` (string, optional): Task description (markdown supported)
  - `assignees` (array, optional): User IDs to assign
  - `priority` (number, optional): 1=urgent, 2=high, 3=normal, 4=low
  - `due_date` (number, optional): Unix timestamp in milliseconds
  - `status` (string, optional): Status name
  - `tags` (array, optional): Tag names to add

- `clickup.update_task` - Update task fields
  - `task_id` (string, required): The task ID
  - `name` (string, optional): New name
  - `description` (string, optional): New description
  - `status` (string, optional): New status
  - `priority` (number, optional): New priority
  - `assignees` (object, optional): `{add: [...], rem: [...]}`

- `clickup.delete_task` - Delete a task
  - `task_id` (string, required): The task ID

- `clickup.list_tasks` - List tasks in a list
  - `list_id` (string, required): The list ID
  - `archived` (boolean, optional): Include archived tasks
  - `page` (number, optional): Page number
  - `statuses` (array, optional): Filter by status names
  - `assignees` (array, optional): Filter by assignee IDs

### Subtasks

- `clickup.create_subtask` - Create a subtask
  - `parent_id` (string, required): Parent task ID
  - `name` (string, required): Subtask name
  - `assignees` (array, optional): User IDs

- `clickup.get_subtasks` - Get subtasks of a task
  - `task_id` (string, required): Parent task ID

### Comments

- `clickup.add_comment` - Add a comment to a task
  - `task_id` (string, required): The task ID
  - `comment_text` (string, required): Comment content
  - `assignee` (number, optional): Assign comment to user
  - `notify_all` (boolean, optional): Notify all assignees

- `clickup.get_comments` - Get task comments
  - `task_id` (string, required): The task ID

### Time Tracking

- `clickup.start_timer` - Start time tracking on a task
  - `task_id` (string, required): The task ID

- `clickup.stop_timer` - Stop the running timer
  - No parameters required

- `clickup.add_time_entry` - Add manual time entry
  - `task_id` (string, required): The task ID
  - `duration` (number, required): Duration in milliseconds
  - `start` (number, optional): Start time (Unix ms)
  - `description` (string, optional): Time entry description

- `clickup.get_time_entries` - Get time entries for a task
  - `task_id` (string, required): The task ID

### Workspaces & Lists

- `clickup.list_workspaces` - List all accessible workspaces
  - No parameters required

- `clickup.list_spaces` - List spaces in a workspace
  - `team_id` (string, required): Workspace/team ID

- `clickup.list_folders` - List folders in a space
  - `space_id` (string, required): Space ID

- `clickup.list_lists` - List lists in a folder or space
  - `folder_id` (string, optional): Folder ID
  - `space_id` (string, optional): Space ID (for folderless lists)

### Custom Fields

- `clickup.set_custom_field` - Set a custom field value
  - `task_id` (string, required): The task ID
  - `field_id` (string, required): Custom field ID
  - `value` (any, required): Field value

## Examples

### Create a task with full details

```bash
fgp call clickup.create_task \
  --list_id "12345" \
  --name "Implement OAuth login" \
  --description "Add Google and GitHub OAuth providers\n\n## Acceptance Criteria\n- Users can sign in with Google\n- Users can sign in with GitHub" \
  --priority 2 \
  --assignees '[123456]' \
  --due_date 1737417600000 \
  --tags '["backend", "auth"]'
```

### Track time on a task

```bash
# Start working
fgp call clickup.start_timer --task_id "abc123"

# ... do work ...

# Stop timer
fgp call clickup.stop_timer

# Or add manual entry
fgp call clickup.add_time_entry \
  --task_id "abc123" \
  --duration 3600000 \
  --description "Code review and testing"
```

### Move task through workflow

```bash
# Update status to "In Progress"
fgp call clickup.update_task --task_id "abc123" --status "in progress"

# Add a comment
fgp call clickup.add_comment --task_id "abc123" --comment_text "Started implementation"

# Mark complete
fgp call clickup.update_task --task_id "abc123" --status "complete"
```

### Get all tasks assigned to me

```bash
# First get your user ID from workspace members
TEAMS=$(fgp call clickup.list_workspaces)

# Then filter tasks
fgp call clickup.list_tasks \
  --list_id "12345" \
  --assignees '[YOUR_USER_ID]' \
  --statuses '["open", "in progress"]'
```

## Error Handling

The daemon returns structured errors:

```json
{
  "ok": false,
  "error": {
    "code": "ITEM_013",
    "message": "Task not found"
  }
}
```

Common error codes:
- `OAUTH_017` - Invalid or expired token
- `ITEM_013` - Task/list not found
- `TEAM_025` - Insufficient permissions
- `RATE_LIMIT` - Too many requests (daemon handles backoff)
