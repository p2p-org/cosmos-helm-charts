#!/bin/sh
# Configuration merge script
# Merges chain config files with overlay configurations

set -eux

# Construct paths from HOME and CHAIN_HOME
CHAIN_HOME="/home/operator/$homeDir"
CONFIG_DIR="$CHAIN_HOME/config"
TMP_DIR="$HOME/.tmp/config"
OVERLAY_DIR="$HOME/.config"

merge_config_if_exists() {
    local base_file="$1"
    local config_name="$2"
    local output_file="$3"

    [ ! -f "$base_file" ] && return 0

    local args="$base_file"

    # Add overlays in order only if they exist
    for overlay_type in defaults defaults-$NODE_NAME overrides overrides-$NODE_NAME; do
        local overlay_file="$OVERLAY_DIR/${config_name}-overlay-${overlay_type}.toml"
        [ -f "$overlay_file" ] && args="$args $overlay_file"
    done
    echo "Args: $args"
    config-merge -f toml $args > "$output_file"
}

echo "Merging config..."

echo "Merging config.toml..."
merge_config_if_exists "$TMP_DIR/config.toml" "config" "$CONFIG_DIR/config.toml"

echo "Merging app.toml..."
merge_config_if_exists "$TMP_DIR/app.toml" "app" "$CONFIG_DIR/app.toml"

echo "Config merge complete."
