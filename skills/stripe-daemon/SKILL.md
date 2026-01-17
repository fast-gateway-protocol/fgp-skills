---
name: fgp-stripe
description: Fast Stripe operations via FGP daemon - 30-60x faster than MCP. Use when user needs to manage payments, customers, subscriptions, or invoices. Triggers on "list customers", "create payment", "stripe subscription", "refund", "invoice".
license: MIT
metadata:
  author: fast-gateway-protocol
  version: "1.0.0"
  platforms: ["darwin", "linux"]
---

# FGP Stripe Daemon

Ultra-fast Stripe operations using direct API access. **30-60x faster** than browser or MCP alternatives.

## Why FGP?

| Operation | FGP Daemon | Browser/MCP | Speedup |
|-----------|------------|-------------|---------|
| List customers | 10-20ms | ~600ms | **30-60x** |
| Create payment | 15-30ms | ~800ms | **25-55x** |
| Get subscription | 12-25ms | ~700ms | **30-55x** |
| Create invoice | 15-35ms | ~900ms | **25-60x** |

Direct Stripe API via persistent daemon.

## Installation

```bash
brew install fast-gateway-protocol/tap/fgp-stripe

# Or
bash ~/.claude/skills/fgp-stripe/scripts/install.sh
```

## Setup

```bash
# Set API key
export STRIPE_SECRET_KEY="sk_live_..."

# Or for testing
export STRIPE_SECRET_KEY="sk_test_..."
```

Get keys from https://dashboard.stripe.com/apikeys

## Usage

### Customers

```bash
# List customers
fgp stripe customers

# Search customers
fgp stripe customers --email "user@example.com"

# Get customer
fgp stripe customer cus_xxxxx

# Create customer
fgp stripe customer create --email "new@example.com" --name "John Doe"

# Update customer
fgp stripe customer update cus_xxxxx --name "Jane Doe"

# Delete customer
fgp stripe customer delete cus_xxxxx
```

### Payments

```bash
# List payments
fgp stripe payments

# Get payment
fgp stripe payment pi_xxxxx

# Create payment intent
fgp stripe payment create --amount 2000 --currency usd --customer cus_xxxxx

# Confirm payment
fgp stripe payment confirm pi_xxxxx

# Cancel payment
fgp stripe payment cancel pi_xxxxx

# Capture payment
fgp stripe payment capture pi_xxxxx
```

### Subscriptions

```bash
# List subscriptions
fgp stripe subscriptions

# Get subscription
fgp stripe subscription sub_xxxxx

# Create subscription
fgp stripe subscription create --customer cus_xxxxx --price price_xxxxx

# Update subscription
fgp stripe subscription update sub_xxxxx --price price_yyyyy

# Cancel subscription
fgp stripe subscription cancel sub_xxxxx

# Resume subscription
fgp stripe subscription resume sub_xxxxx
```

### Invoices

```bash
# List invoices
fgp stripe invoices

# Get invoice
fgp stripe invoice in_xxxxx

# Create invoice
fgp stripe invoice create --customer cus_xxxxx

# Add line item
fgp stripe invoice add-item in_xxxxx --amount 1000 --description "Service fee"

# Finalize invoice
fgp stripe invoice finalize in_xxxxx

# Send invoice
fgp stripe invoice send in_xxxxx

# Pay invoice
fgp stripe invoice pay in_xxxxx
```

### Products & Prices

```bash
# List products
fgp stripe products

# Create product
fgp stripe product create --name "Pro Plan" --description "Full access"

# List prices
fgp stripe prices --product prod_xxxxx

# Create price
fgp stripe price create --product prod_xxxxx --unit-amount 2999 --currency usd --recurring monthly
```

### Refunds

```bash
# Create refund
fgp stripe refund pi_xxxxx

# Partial refund
fgp stripe refund pi_xxxxx --amount 500

# List refunds
fgp stripe refunds
```

### Balance & Payouts

```bash
# Get balance
fgp stripe balance

# List transactions
fgp stripe transactions

# List payouts
fgp stripe payouts

# Create payout
fgp stripe payout create --amount 10000
```

### Webhooks

```bash
# List webhooks
fgp stripe webhooks

# Create webhook
fgp stripe webhook create --url "https://example.com/webhook" --events "payment_intent.succeeded,customer.created"

# Get webhook secret
fgp stripe webhook secret we_xxxxx
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `customers` | List customers | `fgp stripe customers` |
| `customer` | Get customer | `fgp stripe customer cus_xxx` |
| `payments` | List payments | `fgp stripe payments` |
| `payment create` | Create payment | `fgp stripe payment create` |
| `subscriptions` | List subs | `fgp stripe subscriptions` |
| `invoices` | List invoices | `fgp stripe invoices` |
| `refund` | Create refund | `fgp stripe refund pi_xxx` |
| `balance` | Get balance | `fgp stripe balance` |

## Example Workflows

### Onboard new customer
```bash
# Create customer
CUSTOMER=$(fgp stripe customer create --email "new@example.com" --json | jq -r '.id')

# Create subscription
fgp stripe subscription create --customer $CUSTOMER --price price_xxxxx
```

### Handle refund
```bash
# Find the payment
fgp stripe payments --customer cus_xxxxx --limit 5

# Issue refund
fgp stripe refund pi_xxxxx --reason requested_by_customer
```

### Monthly billing review
```bash
# Check MRR
fgp stripe subscriptions --status active --json | jq '[.[].items.data[].price.unit_amount] | add'

# Recent invoices
fgp stripe invoices --status paid --created-after "1 month ago"
```

## Test Mode

Use test keys for development:

```bash
export STRIPE_SECRET_KEY="sk_test_..."

# Test card numbers
# 4242424242424242 - Success
# 4000000000000002 - Decline
```

## Troubleshooting

### Invalid API key
```
Error: Invalid API key
```
Check `STRIPE_SECRET_KEY` is correct.

### Resource not found
```
Error: No such customer: cus_xxx
```
Verify the ID is correct and matches your account (live vs test).

### Card declined
```
Error: Your card was declined
```
Use a different card or check test mode cards.

## Architecture

- **Stripe API v2023-10-16**
- **Secret key authentication**
- **UNIX socket** at `~/.fgp/services/stripe/daemon.sock`
- **Idempotency** for safe retries
