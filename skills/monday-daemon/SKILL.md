---
name: monday-daemon
description: Fast Monday.com board and item management via FGP daemon. Use when user needs to manage boards, create/update items, change columns, or track work in Monday.com. Triggers on "monday board", "create monday item", "monday task", "update monday", "monday column".
license: MIT
compatibility: Requires fgp CLI and Monday.com API Token (MONDAY_API_TOKEN env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Monday.com Daemon

Fast Monday.com board operations using a persistent daemon architecture. Eliminates cold-start latency from spawning API clients on every request.

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
brew install fgp-monday

# Via npx
npx add-skill fgp-monday
```

## Quick Start

```bash
# Set your Monday.com API token
export MONDAY_API_TOKEN="your-api-token"

# Start the daemon
fgp start monday

# Get board items
fgp call monday.get_board --board_id 12345

# Create an item
fgp call monday.create_item --board_id 12345 --item_name "New task" --column_values '{"status": "Working on it"}'
```

## Authentication

Get your API token from Monday.com:

1. Click your profile picture > Developers
2. Go to "My Access Tokens" tab
3. Click "Show" to reveal your token
4. Set `MONDAY_API_TOKEN` environment variable

For OAuth2 apps, configure `MONDAY_CLIENT_ID` and `MONDAY_CLIENT_SECRET`.

## Methods

### Items

- `monday.get_item` - Retrieve an item by ID
  - `item_id` (number, required): The item ID
  - `column_ids` (array, optional): Specific columns to return

- `monday.create_item` - Create a new item
  - `board_id` (number, required): Board ID
  - `item_name` (string, required): Item name
  - `group_id` (string, optional): Group to add item to
  - `column_values` (object, optional): Column values as JSON

- `monday.update_item` - Update item name
  - `item_id` (number, required): The item ID
  - `item_name` (string, required): New item name

- `monday.delete_item` - Delete an item
  - `item_id` (number, required): The item ID

- `monday.move_item` - Move item to another group
  - `item_id` (number, required): The item ID
  - `group_id` (string, required): Target group ID

- `monday.duplicate_item` - Duplicate an item
  - `item_id` (number, required): The item ID
  - `board_id` (number, required): Target board ID
  - `with_updates` (boolean, optional): Include updates/comments

### Columns

- `monday.change_column_value` - Update a single column
  - `item_id` (number, required): The item ID
  - `board_id` (number, required): Board ID
  - `column_id` (string, required): Column ID
  - `value` (any, required): New value (format depends on column type)

- `monday.change_multiple_columns` - Update multiple columns
  - `item_id` (number, required): The item ID
  - `board_id` (number, required): Board ID
  - `column_values` (object, required): Map of column_id to value

### Boards

- `monday.get_board` - Retrieve board with items
  - `board_id` (number, required): The board ID
  - `limit` (number, optional): Max items to return
  - `page` (number, optional): Page number

- `monday.list_boards` - List all accessible boards
  - `limit` (number, optional): Max boards to return
  - `board_kind` (string, optional): "public", "private", "share"

- `monday.get_board_columns` - Get board column definitions
  - `board_id` (number, required): The board ID

- `monday.get_board_groups` - Get board groups
  - `board_id` (number, required): The board ID

### Updates (Comments)

- `monday.add_update` - Add an update/comment to an item
  - `item_id` (number, required): The item ID
  - `body` (string, required): Update content (HTML supported)

- `monday.get_updates` - Get item updates
  - `item_id` (number, required): The item ID
  - `limit` (number, optional): Max updates to return

- `monday.reply_to_update` - Reply to an update
  - `update_id` (number, required): The update ID
  - `body` (string, required): Reply content

### Subitems

- `monday.create_subitem` - Create a subitem
  - `parent_item_id` (number, required): Parent item ID
  - `item_name` (string, required): Subitem name
  - `column_values` (object, optional): Column values

- `monday.get_subitems` - Get subitems of an item
  - `item_id` (number, required): Parent item ID

### Workspaces

- `monday.list_workspaces` - List all workspaces
  - No parameters required

- `monday.get_workspace` - Get workspace details
  - `workspace_id` (number, required): Workspace ID

## Column Value Formats

Monday.com uses specific JSON formats for column values:

```javascript
// Status column
{"status": {"label": "Done"}}
// or use index
{"status": {"index": 1}}

// Date column
{"date": {"date": "2026-01-20"}}

// Person column
{"person": {"personsAndTeams": [{"id": 12345, "kind": "person"}]}}

// Numbers column
{"numbers": 42}

// Text column
{"text": "Hello world"}

// Timeline column
{"timeline": {"from": "2026-01-15", "to": "2026-01-20"}}

// Dropdown column
{"dropdown": {"labels": ["Option 1", "Option 2"]}}
```

## Examples

### Create a task with columns

```bash
fgp call monday.create_item \
  --board_id 12345 \
  --item_name "Implement feature X" \
  --group_id "new_group" \
  --column_values '{
    "status": {"label": "Working on it"},
    "person": {"personsAndTeams": [{"id": 67890, "kind": "person"}]},
    "date4": {"date": "2026-01-25"},
    "numbers": 5
  }'
```

### Update task status with comment

```bash
# Change status to Done
fgp call monday.change_column_value \
  --item_id 123456 \
  --board_id 12345 \
  --column_id "status" \
  --value '{"label": "Done"}'

# Add completion update
fgp call monday.add_update \
  --item_id 123456 \
  --body "<p>Completed! <a href='https://github.com/...'>PR merged</a></p>"
```

### Query board items by group

```bash
# Get board structure
BOARD=$(fgp call monday.get_board --board_id 12345)

# Parse and work with items in specific group
echo $BOARD | jq '.result.groups[] | select(.title == "This Week") | .items'
```

### Bulk update multiple items

```bash
# Update multiple columns at once
fgp call monday.change_multiple_columns \
  --item_id 123456 \
  --board_id 12345 \
  --column_values '{
    "status": {"label": "Stuck"},
    "text0": "Blocked by API issue",
    "date4": {"date": "2026-01-22"}
  }'
```

## Error Handling

The daemon returns structured errors:

```json
{
  "ok": false,
  "error": {
    "code": "ItemNotFoundException",
    "message": "Item not found"
  }
}
```

Common error codes:
- `InvalidTokenException` - Invalid or expired token
- `ItemNotFoundException` - Item not found
- `BoardNotFoundException` - Board not found or no access
- `ColumnValueException` - Invalid column value format
- `RateLimitExceeded` - Too many requests (daemon handles backoff)
- `ComplexityException` - Query too complex, reduce scope
