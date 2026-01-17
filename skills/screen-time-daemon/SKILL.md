---
name: screen-time-daemon
description: Fast Screen Time queries via FGP daemon (macOS only) - 50x faster than alternatives. Use when user needs app usage stats, screen time reports, productivity insights, or daily usage breakdown. Triggers on "how much time on", "app usage", "screen time", "most used apps", "productivity report", "time spent on", "screen time today".
license: MIT
compatibility: Requires macOS, fgp CLI, and Full Disk Access permission for terminal
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Screen Time Daemon

Ultra-fast Screen Time queries on macOS using direct SQLite access to knowledgeC.db. **50x faster** than any alternative.

## Why FGP?

| Operation | FGP Daemon | Python script | Speedup |
|-----------|------------|---------------|---------|
| Today's usage | 1-5ms | ~60ms | **12-50x** |
| App breakdown | 2-8ms | ~80ms | **10-40x** |
| Weekly report | 5-15ms | ~150ms | **10-30x** |
| Search history | 3-10ms | ~100ms | **10-30x** |

Direct SQLite queries on Apple's knowledge database.

## Requirements

- **macOS only** (reads `/private/var/db/CoreDuet/Knowledge/knowledgeC.db`)
- **Full Disk Access** permission required
- Works best on macOS Ventura or later

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-screen-time

# Or
bash ~/.claude/skills/fgp-screen-time/scripts/install.sh
```

## Setup

Grant Full Disk Access to your terminal:

1. System Preferences > Security & Privacy > Privacy
2. Select "Full Disk Access"
3. Add your terminal (Terminal, iTerm2, Warp, etc.)
4. Restart terminal

## Usage

### Daily Usage

```bash
# Today's total screen time
fgp screen-time today

# Yesterday
fgp screen-time yesterday

# Specific date
fgp screen-time day 2024-01-15

# With app breakdown
fgp screen-time today --breakdown
```

### App Usage

```bash
# Top apps today
fgp screen-time apps

# Top apps this week
fgp screen-time apps --period week

# Specific app
fgp screen-time app "Safari"
fgp screen-time app "com.apple.Safari"  # Bundle ID works too

# App usage over time
fgp screen-time app "Slack" --history 7d
```

### Reports

```bash
# Weekly summary
fgp screen-time week

# Monthly summary
fgp screen-time month

# Custom range
fgp screen-time range --from "2024-01-01" --to "2024-01-31"

# Compare weeks
fgp screen-time compare --this-week --last-week
```

### Categories

```bash
# Usage by category
fgp screen-time categories

# Productivity vs entertainment
fgp screen-time productivity

# Social media time
fgp screen-time category "Social Networking"
```

### Pickups & Notifications

```bash
# Device pickups today
fgp screen-time pickups

# Notifications received
fgp screen-time notifications

# By app
fgp screen-time notifications --app "Messages"
```

### Focus / Do Not Disturb

```bash
# Focus mode history
fgp screen-time focus

# Time in focus modes
fgp screen-time focus --summary
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `today` | Today's usage | `fgp screen-time today` |
| `apps` | Top apps | `fgp screen-time apps` |
| `app` | Specific app | `fgp screen-time app "Safari"` |
| `week` | Weekly summary | `fgp screen-time week` |
| `month` | Monthly summary | `fgp screen-time month` |
| `categories` | By category | `fgp screen-time categories` |
| `pickups` | Device pickups | `fgp screen-time pickups` |
| `notifications` | Notifications | `fgp screen-time notifications` |

## Output Formats

```bash
# Human readable (default)
fgp screen-time today

# JSON
fgp screen-time today --json

# CSV (for export)
fgp screen-time apps --csv > apps.csv
```

## Example Workflows

### Morning productivity check
```bash
# How did yesterday go?
fgp screen-time yesterday --breakdown
```

### Weekly review
```bash
# Get weekly summary
fgp screen-time week

# Compare to last week
fgp screen-time compare --this-week --last-week
```

### Find time wasters
```bash
# Social media usage
fgp screen-time category "Social Networking" --period week

# Most used entertainment apps
fgp screen-time apps --period week --category Entertainment
```

### Track focus
```bash
# How much focus time?
fgp screen-time focus --summary --period week
```

## Data Available

The daemon can access:
- App usage duration
- App open/close events
- Device pickups
- Notifications received
- Focus/DND status
- Device lock/unlock

**Not available** (requires Screen Time API):
- App limits
- Downtime schedules
- Communication limits

## Troubleshooting

### Permission denied
```
Error: Unable to read knowledgeC.db
```
Grant Full Disk Access to your terminal app.

### No data found
```
Error: No usage data for this period
```
Screen Time must be enabled in System Preferences.

### Database locked
```
Error: Database is locked
```
Close System Preferences > Screen Time if open.

## Privacy

- **Local only** - all data stays on your machine
- **Read-only** - daemon cannot modify Screen Time data
- **No network** - no data sent anywhere
- Data is the same as what you see in System Preferences > Screen Time

## Architecture

- **SQLite queries** on `/private/var/db/CoreDuet/Knowledge/knowledgeC.db`
- **Read-only access** - no modifications
- **UNIX socket** at `~/.fgp/services/screen-time/daemon.sock`
- **Efficient queries** with proper indexing
