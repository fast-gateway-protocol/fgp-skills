---
name: kubernetes-daemon
description: Fast Kubernetes operations via FGP daemon - 15-40x faster than spawning kubectl per command. Use when user needs to manage pods, deployments, services, get logs, or apply manifests. Triggers on "kubectl", "k8s pods", "get pods", "kubernetes logs", "apply manifest", "describe pod".
license: MIT
compatibility: Requires fgp CLI and kubeconfig (~/.kube/config or KUBECONFIG env var)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP Kubernetes Daemon

Fast Kubernetes cluster operations via direct API access.

## Why FGP?

| Operation | FGP Daemon | kubectl | Speedup |
|-----------|------------|---------|---------|
| Get pods | 8ms | 200ms | **25x** |
| Get logs | 12ms | 300ms | **25x** |
| Describe | 10ms | 250ms | **25x** |
| Apply | 20ms | 400ms | **20x** |

## Installation

```bash
brew install fast-gateway-protocol/fgp/fgp-kubernetes
```

## Setup

```bash
# Uses ~/.kube/config by default
# Or specify kubeconfig
export KUBECONFIG="/path/to/kubeconfig"

fgp start kubernetes
```

## Available Commands

| Command | Description |
|---------|-------------|
| `k8s.pods` | List pods |
| `k8s.deployments` | List deployments |
| `k8s.services` | List services |
| `k8s.logs` | Get pod logs |
| `k8s.describe` | Describe resource |
| `k8s.apply` | Apply manifest |
| `k8s.delete` | Delete resource |
| `k8s.exec` | Exec into pod |
| `k8s.events` | Get events |
| `k8s.contexts` | List contexts |

## Example Workflows

```bash
# List pods
fgp call k8s.pods --namespace default --selector "app=my-app"

# Get logs
fgp call k8s.logs --pod my-app-xyz --container main --tail 100

# Apply manifest
fgp call k8s.apply --file deployment.yaml

# Exec into pod
fgp call k8s.exec --pod my-app-xyz --cmd "cat /etc/config"
```
