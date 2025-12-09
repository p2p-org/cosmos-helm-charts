#!/bin/sh
# RPC Health Check Script for RPC Nodes
# Designed for Kubernetes readiness/startup probes
# This script checks the health of a node by verifying:
# 1. RPC endpoint is responding
# 2. Node is synced (not catching up)
#
# Environment variables:
#   RPC_URL - RPC endpoint URL (default: http://localhost)
#   RPC_PORT - RPC port (default: 26657)
#
# Exit codes:
#   0 - Node is healthy and synced
#   1 - Node is unhealthy or not synced (including when catching up or stuck)
#
# Usage:
#   - Use as readinessProbe: Pod marked as not ready when catching up (no traffic routed)
#   - Use as startupProbe: Allows grace period during initial sync
#   - Do NOT use as livenessProbe: Would restart pod during catch-up, preventing sync
#

set -u

# Default configuration
RPC_URL="${RPC_URL:-http://localhost}"
RPC_PORT="${RPC_PORT:-26657}"

# Construct full RPC endpoint
RPC_ENDPOINT="${RPC_URL}:${RPC_PORT}"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log_error() {
    echo "[WARNING] $*"
}

log_success() {
    echo "[OK] $*"
}

# Check node status and sync state
status_url="${RPC_ENDPOINT}/status"
log "Checking node status: $status_url"

response=$(curl -sSf "$status_url" 2>&1)
exit_code=$?

if [ $exit_code -ne 0 ]; then
    log_error "Failed to connect to status endpoint: $response"
    exit 1
fi

# Check if node is catching up (not synced)
if echo "$response" | grep -q '"catching_up":\s*true'; then
    log_error "Node is still catching up (not synced)"
    exit 1
fi

# Verify we got a valid status response
if ! echo "$response" | grep -q '"result"'; then
    log_error "Unexpected status response: $response"
    exit 1
fi

log_success "Node is up and synced"
exit 0
