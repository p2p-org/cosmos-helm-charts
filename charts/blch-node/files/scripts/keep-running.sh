#!/bin/sh
# Keep Running Script
# Keeps a container running and handles termination signals gracefully
# Use this as the entrypoint for sidecar containers that need to stay alive
# but don't perform any active work (e.g., health check sidecars)

set -eu

cleanup() {
    log "Received termination signal, shutting down gracefully..."
    exit 0
}

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

# Handle termination signals
trap cleanup TERM INT

log "Sidecar container started, waiting for termination signal..."

# Keep container running using a loop with short sleeps for fast termination
while true; do
    sleep 1 || true
done
