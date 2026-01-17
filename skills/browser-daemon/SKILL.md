---
name: browser-daemon
description: Fast browser automation via FGP daemon - 3-12x faster than Playwright MCP. Use when user needs to navigate web pages, take screenshots, click elements, fill forms, scrape content, or get ARIA accessibility snapshots. Triggers on "open URL", "take screenshot", "click button", "fill form", "get page content", "scrape website", "automate browser".
license: MIT
compatibility: Requires fgp CLI and Chrome/Chromium browser installed
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Browser Daemon

Ultra-fast browser automation using Chrome DevTools Protocol directly. **3-12x faster** than Playwright MCP for navigation, **50x faster** for ARIA snapshots.

## Why FGP?

| Operation | FGP Daemon | Playwright MCP | Speedup |
|-----------|------------|----------------|---------|
| Navigate | 2-8ms | 27ms | **3-12x** |
| ARIA Snapshot | 0.7-9ms | 2-3ms | **3x** |
| Screenshot | 25-30ms | 50-80ms | **2x** |

FGP daemons are persistent UNIX socket servers - no cold start, no process spawn overhead.

## Installation

```bash
# Install via Homebrew (macOS/Linux)
brew install fast-gateway-protocol/tap/fgp-browser

# Or build from source
git clone https://github.com/fast-gateway-protocol/browser
cd browser && cargo build --release
```

The install script handles daemon setup:

```bash
bash ~/.claude/skills/fgp-browser/scripts/install.sh
```

## Usage

Once installed, the daemon runs in the background. Call it via the `fgp` CLI:

```bash
# Navigate to URL
fgp browser open "https://example.com"

# Get ARIA accessibility tree (for understanding page structure)
fgp browser snapshot

# Take screenshot
fgp browser screenshot /tmp/page.png

# Click element
fgp browser click "button[type=submit]"

# Fill input field
fgp browser fill "input#email" "user@example.com"

# Press key
fgp browser press Enter

# Select dropdown option
fgp browser select "select#country" "United States"
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `open <url>` | Navigate to URL | `fgp browser open "https://google.com"` |
| `snapshot` | Get ARIA tree | `fgp browser snapshot` |
| `screenshot <path>` | Capture PNG | `fgp browser screenshot /tmp/shot.png` |
| `click <selector>` | Click element | `fgp browser click "#submit"` |
| `fill <selector> <text>` | Fill input | `fgp browser fill "input" "hello"` |
| `press <key>` | Press key | `fgp browser press Enter` |
| `select <selector> <value>` | Select option | `fgp browser select "select" "opt1"` |
| `hover <selector>` | Hover element | `fgp browser hover ".menu"` |
| `scroll [direction]` | Scroll page | `fgp browser scroll down` |

## Multi-Session Support

Create isolated browser sessions for parallel work:

```bash
# Create new session
fgp browser session new --name "shopping"

# Use specific session
fgp browser --session shopping open "https://amazon.com"

# List sessions
fgp browser session list

# Close session
fgp browser session close shopping
```

## Daemon Management

```bash
# Check daemon status
fgp browser health

# View available methods
fgp browser methods

# Stop daemon
fgp browser stop

# Restart daemon
fgp browser start
```

## Example Workflow

```bash
# 1. Open a page
fgp browser open "https://github.com/login"

# 2. Get page structure
fgp browser snapshot

# 3. Fill login form
fgp browser fill "input#login_field" "username"
fgp browser fill "input#password" "password"

# 4. Submit
fgp browser click "input[type=submit]"

# 5. Screenshot result
fgp browser screenshot /tmp/github-logged-in.png
```

## Troubleshooting

### Chrome not found
```
Error: Chrome executable not found
```
Install Chrome or set `CHROME_PATH` environment variable.

### Daemon not running
```
Error: Connection refused
```
Start the daemon: `fgp browser start`

### Permission denied on socket
```
Error: Permission denied
```
Check socket permissions: `ls -la ~/.fgp/services/browser/daemon.sock`

## Architecture

FGP Browser uses:
- **Chrome DevTools Protocol** for browser control (not Playwright)
- **UNIX sockets** for IPC (sub-millisecond latency)
- **Persistent daemon** (no cold start)
- **NDJSON protocol** (simple, debuggable)

Socket location: `~/.fgp/services/browser/daemon.sock`
