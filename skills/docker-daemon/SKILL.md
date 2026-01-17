---
name: fgp-docker
description: Fast Docker operations via FGP daemon - 10-30x faster than spawning docker CLI per command. Direct Docker API access.
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
  categories: ["devtools", "cloud"]
---

# FGP Docker Daemon

Fast Docker container management via direct API access.

## Why FGP?

| Operation | FGP Daemon | docker CLI | Speedup |
|-----------|------------|------------|---------|
| List containers | 5ms | 80ms | **16x** |
| Container logs | 8ms | 120ms | **15x** |
| Exec command | 15ms | 200ms | **13x** |
| Image list | 3ms | 60ms | **20x** |

## Installation

```bash
brew install fast-gateway-protocol/fgp/fgp-docker
```

## Setup

```bash
# Uses Docker socket by default
# Or specify remote Docker host
export DOCKER_HOST="tcp://localhost:2375"

fgp start docker
```

## Available Commands

| Command | Description |
|---------|-------------|
| `docker.containers` | List containers |
| `docker.images` | List images |
| `docker.logs` | Get container logs |
| `docker.exec` | Execute command in container |
| `docker.start` | Start container |
| `docker.stop` | Stop container |
| `docker.rm` | Remove container |
| `docker.pull` | Pull image |
| `docker.build` | Build image |
| `docker.stats` | Container resource stats |

## Example Workflows

```bash
# List running containers
fgp call docker.containers --filter '{"status": ["running"]}'

# Get logs
fgp call docker.logs --container my-app --tail 100

# Execute command
fgp call docker.exec --container my-app --cmd "ls -la /app"

# Container stats
fgp call docker.stats --container my-app
```
