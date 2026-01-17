---
name: fgp-trello
description: Fast Trello board and card operations via FGP daemon.
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
  categories: ["productivity"]
---

# FGP Trello Daemon

Fast Trello board and card operations using a persistent daemon architecture. Eliminates cold-start latency from spawning API clients on every request.

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
brew install fgp-trello

# Via npx
npx add-skill fgp-trello
```

## Quick Start

```bash
# Set your Trello API credentials
export TRELLO_API_KEY="your-api-key"
export TRELLO_TOKEN="your-token"

# Start the daemon
fgp start trello

# List cards on a board
fgp call trello.list_cards --board_id "abc123"

# Create a card
fgp call trello.create_card --list_id "list123" --name "New feature" --desc "Description here"
```

## Authentication

Get API credentials from Trello:

1. Get API Key: https://trello.com/app-key
2. Generate Token: Click "Token" link on the API key page
3. Set environment variables:
   - `TRELLO_API_KEY` - Your API key
   - `TRELLO_TOKEN` - Your generated token

## Methods

### Cards

- `trello.get_card` - Retrieve a card by ID
  - `card_id` (string, required): The card ID or shortLink
  - `fields` (array, optional): Fields to return

- `trello.create_card` - Create a new card
  - `list_id` (string, required): List ID to create card in
  - `name` (string, required): Card name
  - `desc` (string, optional): Card description
  - `pos` (string, optional): Position ("top", "bottom", or number)
  - `due` (string, optional): Due date (ISO format)
  - `labels` (array, optional): Label IDs to add

- `trello.update_card` - Update card fields
  - `card_id` (string, required): The card ID
  - `name` (string, optional): New name
  - `desc` (string, optional): New description
  - `closed` (boolean, optional): Archive the card
  - `list_id` (string, optional): Move to different list
  - `due` (string, optional): New due date

- `trello.delete_card` - Delete a card permanently
  - `card_id` (string, required): The card ID

- `trello.move_card` - Move card to another list
  - `card_id` (string, required): The card ID
  - `list_id` (string, required): Target list ID
  - `pos` (string, optional): Position in new list

### Lists

- `trello.get_list` - Retrieve a list by ID
  - `list_id` (string, required): The list ID

- `trello.create_list` - Create a new list on a board
  - `board_id` (string, required): Board ID
  - `name` (string, required): List name
  - `pos` (string, optional): Position

- `trello.list_cards` - Get all cards in a list
  - `list_id` (string, required): The list ID
  - `filter` (string, optional): "all", "open", "closed"

- `trello.archive_list` - Archive a list
  - `list_id` (string, required): The list ID

### Boards

- `trello.get_board` - Retrieve board details
  - `board_id` (string, required): The board ID

- `trello.list_boards` - List all boards for current user
  - `filter` (string, optional): "all", "open", "closed", "starred"

- `trello.get_board_lists` - Get all lists on a board
  - `board_id` (string, required): The board ID
  - `filter` (string, optional): "all", "open", "closed"

### Comments & Activity

- `trello.add_comment` - Add a comment to a card
  - `card_id` (string, required): The card ID
  - `text` (string, required): Comment text

- `trello.get_card_actions` - Get card activity history
  - `card_id` (string, required): The card ID
  - `filter` (string, optional): Action types to include

### Labels & Members

- `trello.add_label` - Add a label to a card
  - `card_id` (string, required): The card ID
  - `label_id` (string, required): Label ID to add

- `trello.add_member` - Add a member to a card
  - `card_id` (string, required): The card ID
  - `member_id` (string, required): Member ID to add

### Search

- `trello.search` - Search across boards, cards, and members
  - `query` (string, required): Search query
  - `model_types` (array, optional): ["cards", "boards", "members"]
  - `board_ids` (array, optional): Limit to specific boards

## Examples

### Kanban workflow - move card through stages

```bash
# Move card from "To Do" to "In Progress"
fgp call trello.move_card --card_id "card123" --list_id "in-progress-list"

# Add a comment about starting work
fgp call trello.add_comment --card_id "card123" --text "Started working on this"

# Later, move to "Done"
fgp call trello.move_card --card_id "card123" --list_id "done-list"
```

### Create a card with all details

```bash
fgp call trello.create_card \
  --list_id "backlog-list" \
  --name "Implement user authentication" \
  --desc "Add OAuth2 login flow with Google and GitHub providers" \
  --due "2026-01-25T17:00:00Z" \
  --labels '["label-urgent", "label-backend"]'
```

### Search for cards assigned to me

```bash
fgp call trello.search --query "@me is:open" --model_types '["cards"]'
```

## Error Handling

The daemon returns structured errors:

```json
{
  "ok": false,
  "error": {
    "code": "invalid_id",
    "message": "invalid id"
  }
}
```

Common error codes:
- `unauthorized` - Invalid API key or token
- `invalid_id` - Card/board/list ID not found
- `invalid_value` - Invalid parameter value
- `rate_limited` - Too many requests (daemon handles backoff)
