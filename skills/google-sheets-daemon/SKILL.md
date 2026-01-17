---
name: google-sheets-daemon
description: Fast Google Sheets operations via FGP daemon - 35-70x faster than MCP. Use when user needs to read spreadsheets, write data, create sheets, manage formulas, or export data. Triggers on "read spreadsheet", "write cells", "sheets data", "google sheets", "update spreadsheet", "append rows", "sheets formula".
license: MIT
compatibility: Requires fgp CLI and Google OAuth credentials (run fgp sheets auth)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Google Sheets Daemon

Ultra-fast Google Sheets operations using direct API access. **35-70x faster** than browser automation.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| Read range | 10-20ms | ~700ms | **35-70x** |
| Write cells | 15-30ms | ~800ms | **25-55x** |
| Append rows | 12-25ms | ~750ms | **30-60x** |
| Create sheet | 20-40ms | ~900ms | **22-45x** |

Direct Google Sheets API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-google-sheets

# Or
bash ~/.claude/skills/fgp-google-sheets/scripts/install.sh
```

## Setup

```bash
# Authenticate
fgp sheets auth

# Browser opens for OAuth consent
```

## Usage

### Reading Data

```bash
# Read entire sheet
fgp sheets read <spreadsheet-id>

# Read specific range
fgp sheets read <spreadsheet-id> --range "A1:D100"

# Read named range
fgp sheets read <spreadsheet-id> --range "SalesData"

# Read specific sheet tab
fgp sheets read <spreadsheet-id> --sheet "Sheet2" --range "A:C"

# Output formats
fgp sheets read <id> --format json    # Default
fgp sheets read <id> --format csv
fgp sheets read <id> --format table
```

### Writing Data

```bash
# Write to range
fgp sheets write <spreadsheet-id> --range "A1" --data '[["Name", "Value"], ["Test", 123]]'

# Write from JSON file
fgp sheets write <spreadsheet-id> --range "A1" --file data.json

# Append rows
fgp sheets append <spreadsheet-id> --data '[["New", "Row"]]'

# Append to specific sheet
fgp sheets append <spreadsheet-id> --sheet "Log" --data '[["2024-01-15", "Event"]]'

# Update specific cells
fgp sheets update <spreadsheet-id> --range "B2" --value "Updated"
```

### Sheet Management

```bash
# List all sheets (tabs) in spreadsheet
fgp sheets list <spreadsheet-id>

# Create new spreadsheet
fgp sheets create "My Spreadsheet"

# Add new sheet tab
fgp sheets add-sheet <spreadsheet-id> "New Tab"

# Delete sheet tab
fgp sheets delete-sheet <spreadsheet-id> --sheet "Old Tab"

# Rename sheet
fgp sheets rename-sheet <spreadsheet-id> --from "Sheet1" --to "Data"

# Duplicate sheet
fgp sheets duplicate-sheet <spreadsheet-id> --sheet "Template"
```

### Formatting

```bash
# Bold header row
fgp sheets format <spreadsheet-id> --range "1:1" --bold

# Set background color
fgp sheets format <spreadsheet-id> --range "A1:D1" --background "#4285f4"

# Freeze rows/columns
fgp sheets freeze <spreadsheet-id> --rows 1 --cols 1

# Auto-resize columns
fgp sheets resize <spreadsheet-id> --columns "A:D" --auto

# Add borders
fgp sheets format <spreadsheet-id> --range "A1:D10" --border solid
```

### Formulas

```bash
# Set formula
fgp sheets formula <spreadsheet-id> --cell "E1" --formula "=SUM(A1:D1)"

# Batch formulas
fgp sheets formula <spreadsheet-id> --range "E1:E100" --formula "=SUM(A:D)"

# Get formulas (not values)
fgp sheets read <spreadsheet-id> --range "E:E" --formulas
```

### Find & Replace

```bash
# Find in spreadsheet
fgp sheets find <spreadsheet-id> "search term"

# Find and replace
fgp sheets replace <spreadsheet-id> --find "old" --replace "new"

# Replace in specific range
fgp sheets replace <spreadsheet-id> --find "old" --replace "new" --range "A:A"
```

### Charts

```bash
# Create chart
fgp sheets chart <spreadsheet-id> --type bar --range "A1:B10" --title "Sales"

# Chart types: bar, line, pie, area, scatter, column

# List charts
fgp sheets charts <spreadsheet-id>

# Delete chart
fgp sheets delete-chart <spreadsheet-id> --chart-id <id>
```

### Filters & Sorting

```bash
# Sort by column
fgp sheets sort <spreadsheet-id> --range "A1:D100" --by "B" --order desc

# Create filter
fgp sheets filter <spreadsheet-id> --range "A1:D100"

# Clear filter
fgp sheets clear-filter <spreadsheet-id>
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `read` | Read cell range | `fgp sheets read <id> --range "A1:B10"` |
| `write` | Write data to range | `fgp sheets write <id> --range "A1" --data '[[...]]'` |
| `append` | Append rows | `fgp sheets append <id> --data '[[...]]'` |
| `create` | Create spreadsheet | `fgp sheets create "Name"` |
| `list` | List sheet tabs | `fgp sheets list <id>` |
| `format` | Format cells | `fgp sheets format <id> --range "A1" --bold` |
| `formula` | Set formula | `fgp sheets formula <id> --cell "A1" --formula "=SUM()"` |
| `sort` | Sort range | `fgp sheets sort <id> --by "A"` |
| `chart` | Create chart | `fgp sheets chart <id> --type bar` |

## Example Workflows

### Daily data append
```bash
# Append today's metrics
fgp sheets append $SHEET_ID --data "[[\"$(date +%Y-%m-%d)\", $REVENUE, $USERS]]"
```

### Export to CSV
```bash
# Read and save as CSV
fgp sheets read $SHEET_ID --format csv > data.csv
```

### Sync from JSON
```bash
# Clear and write fresh data
fgp sheets write $SHEET_ID --range "A2:Z" --clear
fgp sheets write $SHEET_ID --range "A2" --file data.json
```

### Create report template
```bash
# Create new spreadsheet with headers
SHEET=$(fgp sheets create "Monthly Report" --json | jq -r '.id')
fgp sheets write $SHEET --range "A1" --data '[["Date", "Revenue", "Users", "Churn"]]'
fgp sheets format $SHEET --range "1:1" --bold --background "#4285f4" --color white
fgp sheets freeze $SHEET --rows 1
```

## Troubleshooting

### Not authenticated
```
Error: No credentials found
```
Run: `fgp sheets auth`

### Spreadsheet not found
```
Error: Spreadsheet not found
```
Check spreadsheet ID is correct and you have access.

### Rate limit exceeded
```
Error: Rate Limit Exceeded
```
Google Sheets API has quotas. Wait and retry, or use batch operations.

### Permission denied
```
Error: The caller does not have permission
```
Check you have edit access to the spreadsheet.

## Architecture

- **Google Sheets API v4**
- **OAuth 2.0** with offline refresh
- **UNIX socket** at `~/.fgp/services/google-sheets/daemon.sock`
- **Batch operations** for efficiency
- **Value render options** (formatted, unformatted, formula)
