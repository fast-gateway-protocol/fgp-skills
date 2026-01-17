---
name: fgp-contacts
description: Fast Contacts operations via FGP daemon (macOS only) - 30-60x faster than alternatives. Use when user needs to search contacts, get phone numbers, or manage address book. Triggers on "find contact", "get phone number", "search contacts", "who is", "contact info".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin"]
---

# FGP Contacts Daemon

Ultra-fast macOS Contacts access using native frameworks. **30-60x faster** than AppleScript alternatives.

## Why FGP?

| Operation | FGP Daemon | AppleScript | Speedup |
|-----------|------------|-------------|---------|
| Search | 2-5ms | ~100ms | **20-50x** |
| Get contact | 1-3ms | ~80ms | **25-80x** |
| List all | 5-15ms | ~300ms | **20-60x** |
| By phone | 2-4ms | ~90ms | **20-45x** |

Native Contacts.framework access via persistent daemon.

## Requirements

- **macOS only**
- **Contacts access** permission required
- Works with iCloud-synced contacts

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-contacts

# Or
bash ~/.claude/skills/fgp-contacts/scripts/install.sh
```

## Setup

On first run, macOS will prompt for Contacts access. Grant permission to continue.

## Usage

### Search Contacts

```bash
# Search by name
fgp contacts search "John"

# Search any field
fgp contacts search "Apple"  # Finds company matches too

# Exact match
fgp contacts search "John Smith" --exact
```

### Get Contact Details

```bash
# By name
fgp contacts get "Mom"

# Get specific fields
fgp contacts get "John Smith" --fields phone,email

# JSON output
fgp contacts get "Boss" --json
```

### Phone Numbers

```bash
# Get phone number
fgp contacts phone "Alice"

# All phone numbers
fgp contacts phones "John"  # If multiple

# Search by phone
fgp contacts find-by-phone "+1234567890"
```

### Email Addresses

```bash
# Get email
fgp contacts email "Bob"

# All emails
fgp contacts emails "Company Inc"
```

### Groups

```bash
# List groups
fgp contacts groups

# Contacts in group
fgp contacts group "Family"

# Add to group
fgp contacts group add "Friends" "New Contact"
```

### List & Export

```bash
# List all contacts
fgp contacts list

# With specific fields
fgp contacts list --fields name,phone,email

# Export to CSV
fgp contacts list --csv > contacts.csv

# Export to JSON
fgp contacts list --json > contacts.json

# Export to vCard
fgp contacts export "John Smith" > john.vcf
```

### Create & Update (if enabled)

```bash
# Create contact
fgp contacts create "New Person" \
  --phone "+1234567890" \
  --email "person@example.com" \
  --company "Acme Inc"

# Update contact
fgp contacts update "John Smith" --phone "+1987654321"

# Add note
fgp contacts note "Client Name" "Met at conference 2024"
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `search` | Search contacts | `fgp contacts search "John"` |
| `get` | Get contact | `fgp contacts get "Mom"` |
| `phone` | Get phone | `fgp contacts phone "Boss"` |
| `email` | Get email | `fgp contacts email "Alice"` |
| `find-by-phone` | Reverse lookup | `fgp contacts find-by-phone "+1..."` |
| `list` | List all | `fgp contacts list` |
| `groups` | List groups | `fgp contacts groups` |
| `group` | Group members | `fgp contacts group "Family"` |

## Output Fields

```bash
# Available fields for --fields option:
name        # Full name
firstName   # First name
lastName    # Last name
phone       # Primary phone
phones      # All phone numbers
email       # Primary email
emails      # All emails
company     # Company/organization
jobTitle    # Job title
address     # Primary address
addresses   # All addresses
birthday    # Birthday
note        # Notes
```

## Example Workflows

### Quick lookup
```bash
# Get someone's number fast
fgp contacts phone "Pizza Place"
```

### Find who called
```bash
# Reverse phone lookup
fgp contacts find-by-phone "+1234567890"
```

### Export for backup
```bash
fgp contacts list --json > ~/Desktop/contacts-backup.json
```

### Find work contacts
```bash
fgp contacts search "Acme Inc" --field company
```

## Integration with iMessage

Works great with `fgp-imessage`:

```bash
# Find contact, then message them
PHONE=$(fgp contacts phone "Mom")
fgp imessage send "$PHONE" "On my way!"
```

## Troubleshooting

### Permission denied
```
Error: Contacts access denied
```
Grant Contacts permission in System Preferences > Security & Privacy > Privacy > Contacts.

### Contact not found
```
Error: No contact found for "Name"
```
Try partial name or different spelling.

### Multiple matches
```
Multiple contacts found for "John"
```
Be more specific: "John Smith" or use `--exact`.

## Privacy

- **Local only** - accesses local Contacts database
- **Read-mostly** - create/update requires explicit enable
- **No network** - doesn't sync or upload
- **Standard permissions** - uses macOS Contacts access

## Architecture

- **Contacts.framework** (native macOS)
- **ABAddressBook APIs**
- **UNIX socket** at `~/.fgp/services/contacts/daemon.sock`
- **Index caching** for fast lookups
