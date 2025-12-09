#!/bin/sh
# RPC Health Check Script for RPC Nodes
# Designed for Kubernetes readiness/startup probes
# This script checks the health of a node by verifying:
# 1. RPC endpoint is responding
# 2. Node is synced (not catching up)
# 3. Node is processing new blocks (not stuck)
#
# Environment variables:
#   RPC_URL - RPC endpoint URL (default: http://localhost)
#   RPC_PORT - RPC port (default: 26657)
#   MAX_BLOCK_AGE - Maximum age of latest block in seconds (default: 180 = 3 minutes)
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

set -eu

# Default configuration
RPC_URL="${RPC_URL:-http://localhost}"
RPC_PORT="${RPC_PORT:-26657}"
MAX_BLOCK_AGE="${MAX_BLOCK_AGE:-180}"  # 3 minutes default

# Construct full RPC endpoint
RPC_ENDPOINT="${RPC_URL}:${RPC_PORT}"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
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

# Check if node is processing new blocks (not stuck)
# Extract latest_block_time from JSON response
# Format is typically: "latest_block_time": "2024-01-01T12:00:00Z"
block_time=$(echo "$response" | grep -o '"latest_block_time":"[^"]*"' | cut -d'"' -f4)

if [ -z "$block_time" ]; then
    log_error "Could not extract latest_block_time from response"
    exit 1
fi

# Convert block time to Unix timestamp
# Try Linux format first (GNU date), then macOS format (BSD date)
block_timestamp=$(date -d "$block_time" +%s 2>/dev/null || date -u -j -f "%Y-%m-%dT%H:%M:%S" "${block_time%Z}" +%s 2>/dev/null || echo "")

if [ -z "$block_timestamp" ]; then
    # Try without timezone suffix
    block_time_clean=$(echo "$block_time" | sed 's/Z$//; s/+[0-9][0-9]:[0-9][0-9]$//')
    block_timestamp=$(date -d "$block_time_clean" +%s 2>/dev/null || date -u -j -f "%Y-%m-%dT%H:%M:%S" "$block_time_clean" +%s 2>/dev/null || echo "")
fi

if [ -z "$block_timestamp" ]; then
    log_error "Could not parse latest_block_time: $block_time"
    exit 1
fi

current_timestamp=$(date +%s)
block_age=$((current_timestamp - block_timestamp))

if [ $block_age -gt "$MAX_BLOCK_AGE" ]; then
    log_error "Node appears stuck: latest block is ${block_age}s old (max: ${MAX_BLOCK_AGE}s)"
    exit 1
fi

log_success "Node is up, synced, and processing blocks (latest block: ${block_age}s ago)"
exit 0
