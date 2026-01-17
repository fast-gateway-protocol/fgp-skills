---
name: aws-daemon
description: Fast AWS operations via FGP daemon - S3, Lambda, DynamoDB, SQS and more. 20-50x faster than spawning AWS CLI per command. Use when user needs to interact with AWS services. Triggers on "s3 upload", "lambda invoke", "dynamodb query", "aws s3", "sqs message".
license: MIT
compatibility: Requires fgp CLI and AWS credentials (AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY env vars or aws configure)
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
---

# FGP AWS Daemon

Fast AWS operations with persistent SDK connections and credential caching.

## Why FGP?

| Operation | FGP Daemon | AWS CLI | Speedup |
|-----------|------------|---------|---------|
| S3 list | 15ms | 400ms | **25x** |
| S3 get object | 20ms | 500ms | **25x** |
| Lambda invoke | 25ms | 600ms | **24x** |
| DynamoDB query | 10ms | 350ms | **35x** |

## Installation

```bash
# Via Homebrew
brew install fast-gateway-protocol/fgp/fgp-aws

# Via npx
npx add-skill fast-gateway-protocol/fgp-skills --skill fgp-aws
```

## Setup

```bash
# Configure AWS credentials (uses standard AWS config)
aws configure

# Or set environment variables
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_REGION="us-east-1"

# Start the daemon
fgp start aws
```

## Available Commands

### S3
| Command | Description |
|---------|-------------|
| `aws.s3.list` | List buckets or objects |
| `aws.s3.get` | Download object |
| `aws.s3.put` | Upload object |
| `aws.s3.delete` | Delete object |
| `aws.s3.presign` | Generate presigned URL |

### Lambda
| Command | Description |
|---------|-------------|
| `aws.lambda.list` | List functions |
| `aws.lambda.invoke` | Invoke function |
| `aws.lambda.logs` | Get function logs |

### DynamoDB
| Command | Description |
|---------|-------------|
| `aws.dynamodb.tables` | List tables |
| `aws.dynamodb.query` | Query table |
| `aws.dynamodb.get` | Get item |
| `aws.dynamodb.put` | Put item |
| `aws.dynamodb.delete` | Delete item |

### SQS
| Command | Description |
|---------|-------------|
| `aws.sqs.queues` | List queues |
| `aws.sqs.send` | Send message |
| `aws.sqs.receive` | Receive messages |

## Example Workflows

### S3 Operations
```bash
# List buckets
fgp call aws.s3.list

# Upload file
fgp call aws.s3.put --bucket my-bucket --key data.json --file ./data.json

# Generate presigned URL
fgp call aws.s3.presign --bucket my-bucket --key data.json --expires 3600
```

### Lambda Invocation
```bash
fgp call aws.lambda.invoke \
  --function my-function \
  --payload '{"action": "process"}'
```

## Architecture

- Persistent AWS SDK clients per service
- Credential caching and auto-refresh
- Connection pooling for HTTP/2
- Regional endpoint optimization
