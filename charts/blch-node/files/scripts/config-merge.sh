#!/bin/sh
# Configuration merge script
# Merges chain config files with overlay configurations

set -eux

# Construct paths from HOME and CHAIN_HOME
CHAIN_HOME="/home/operator/$homeDir"
CONFIG_DIR="$CHAIN_HOME/config"
TMP_DIR="$HOME/.tmp/config"
OVERLAY_DIR="$HOME/.config"

echo "Merging config..."

if [ -f "$TMP_DIR/config.toml" ]; then
    config-merge -f toml "$TMP_DIR/config.toml" "$OVERLAY_DIR/config-overlay.toml" > "$CONFIG_DIR/config.toml"
fi
if [ -f "$TMP_DIR/app.toml" ]; then
    config-merge -f toml "$TMP_DIR/app.toml" "$OVERLAY_DIR/app-overlay.toml" > "$CONFIG_DIR/app.toml"
fi

echo "Config merge complete."
