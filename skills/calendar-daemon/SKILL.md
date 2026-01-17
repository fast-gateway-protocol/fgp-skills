---
name: calendar-daemon
description: Fast Google Calendar operations via FGP daemon - 10x faster than MCP. Use when user needs to check schedule, create events, find free time, manage calendar, or view upcoming meetings. Triggers on "check my calendar", "schedule meeting", "when am I free", "create event", "what's on my schedule", "book meeting", "calendar today".
license: MIT
compatibility: Requires fgp CLI and Google OAuth credentials (run fgp calendar auth)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Calendar Daemon

Ultra-fast Google Calendar operations using direct API access. **10x faster** than browser-based or MCP alternatives.

## Why FGP?

| Operation | FGP Daemon | MCP/Browser | Speedup |
|-----------|------------|-------------|---------|
| List events | 15-30ms | ~300ms | **10-20x** |
| Create event | 20-40ms | ~400ms | **10-20x** |
| Find free time | 25-50ms | ~500ms | **10-20x** |
| Update event | 20-35ms | ~350ms | **10-17x** |

Direct Google Calendar API via persistent daemon - no browser overhead.

## Installation

```bash
# Install via Homebrew
brew install fast-gateway-protocol/tap/fgp-calendar

# Or run install script
bash ~/.claude/skills/fgp-calendar/scripts/install.sh
```

## Setup (One-Time)

```bash
# Authenticate with Google
fgp calendar auth

# Browser opens for OAuth consent
# Credentials stored in ~/.fgp/services/calendar/
```

## Usage

### View Events

```bash
# Today's events
fgp calendar today

# This week
fgp calendar week

# Specific date range
fgp calendar list --from "2024-01-15" --to "2024-01-20"

# Next N events
fgp calendar next 5
```

### Create Events

```bash
# Quick event
fgp calendar create "Team standup" --when "tomorrow 9am" --duration 30m

# With details
fgp calendar create "Project review" \
  --when "2024-01-20 2pm" \
  --duration 1h \
  --location "Conference Room A" \
  --description "Q1 planning session" \
  --attendees "alice@company.com,bob@company.com"

# Recurring event
fgp calendar create "Weekly sync" \
  --when "monday 10am" \
  --duration 30m \
  --recurrence weekly
```

### Find Free Time

```bash
# Find free slots today
fgp calendar free-time --date today

# Find 1-hour slot this week
fgp calendar free-time --duration 1h --within "this week"

# Check availability with others
fgp calendar free-time \
  --duration 30m \
  --attendees "alice@company.com" \
  --within "next 3 days"
```

### Manage Events

```bash
# Update event
fgp calendar update <event-id> --time "3pm" --duration 45m

# Delete event
fgp calendar delete <event-id>

# RSVP to event
fgp calendar rsvp <event-id> --response yes

# Add attendee
fgp calendar add-attendee <event-id> "newperson@company.com"
```

### Multiple Calendars

```bash
# List calendars
fgp calendar calendars

# Use specific calendar
fgp calendar today --calendar "Work"
fgp calendar create "Personal errand" --calendar "Personal" --when "saturday 2pm"
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `today` | Today's events | `fgp calendar today` |
| `week` | This week's events | `fgp calendar week` |
| `next` | Next N events | `fgp calendar next 10` |
| `list` | Events in range | `fgp calendar list --from X --to Y` |
| `create` | Create event | `fgp calendar create "Title" --when "..."` |
| `update` | Update event | `fgp calendar update <id> --time "..."` |
| `delete` | Delete event | `fgp calendar delete <id>` |
| `free-time` | Find available slots | `fgp calendar free-time --duration 1h` |
| `rsvp` | Respond to invite | `fgp calendar rsvp <id> --response yes` |
| `calendars` | List calendars | `fgp calendar calendars` |

## Natural Language Time Parsing

The daemon understands natural language:

| Input | Interpretation |
|-------|----------------|
| `tomorrow 9am` | Next day at 9:00 AM |
| `next monday 2pm` | Coming Monday at 2:00 PM |
| `in 2 hours` | Current time + 2 hours |
| `this friday` | This week's Friday |
| `jan 15 3pm` | January 15 at 3:00 PM |

## Example Workflows

### Morning briefing
```bash
fgp calendar today
```

### Schedule a meeting
```bash
# Find when everyone is free
fgp calendar free-time --duration 1h --attendees "team@company.com" --within "this week"

# Book the slot
fgp calendar create "Team planning" --when "wednesday 2pm" --duration 1h --attendees "team@company.com"
```

### Reschedule
```bash
# Find the event
fgp calendar list --from today --to "next week" | grep "Team planning"

# Update it
fgp calendar update evt_abc123 --time "thursday 3pm"
```

## Daemon Management

```bash
fgp calendar health
fgp calendar methods
fgp calendar stop
fgp calendar start
```

## Troubleshooting

### Not authenticated
```
Error: No credentials found
```
Run: `fgp calendar auth`

### Calendar not found
```
Error: Calendar "Work" not found
```
List available calendars: `fgp calendar calendars`

### Event conflicts
```
Warning: Conflicts with existing event
```
Use `--force` to create anyway, or find free time first.

## Architecture

- **Google Calendar API** (REST)
- **OAuth 2.0** with offline refresh
- **UNIX socket** at `~/.fgp/services/calendar/daemon.sock`
- **Smart caching** for repeated queries
