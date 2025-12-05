#!/bin/sh
# Genesis initialization script
# Downloads and processes the genesis file

set -eux

GENESIS_FILE=$CONFIG_DIR/genesis.json

# Check if database already exists
echo "check datadir"
if [ -d "$DATA_DIR/db" ]; then
    echo "Database already initialized, skipping genesis initialization"
    exit 0
fi

# Source download utilities if available
if [ -f "./download-utils.sh" ]; then
    source "./download-utils.sh"
else
    echo "Warning: download-utils.sh not found, download functions may not work"
fi

GENESIS_URL="${1:-${GENESIS_URL}}"

if [ -z "$GENESIS_URL" ]; then
    echo "Error: GENESIS_URL must be provided as argument or environment variable"
    exit 1
fi

echo "Downloading genesis file $GENESIS_URL to $GENESIS_FILE..."

rm -f "$GENESIS_FILE"

case "$GENESIS_URL" in
    *.json.gz)
        download_jsongz "$GENESIS_URL" "$GENESIS_FILE"
        ;;
    *.json)
        download_json "$GENESIS_URL" "$GENESIS_FILE"
        ;;
    *.tar.gz)
        download_targz "$GENESIS_URL" "$CONFIG_DIR"
        ;;
    *.tar.gzip)
        download_targz "$GENESIS_URL" "$CONFIG_DIR"
        ;;
    *.tar)
        download_tar "$GENESIS_URL" "$CONFIG_DIR"
        ;;
    *.zip)
        download_zip "$GENESIS_URL" "$GENESIS_FILE"
        ;;
    *)
        echo "Unable to handle file extension for $GENESIS_URL"
        exit 1
        ;;
esac

echo "Saved genesis file to $GENESIS_FILE."
echo "Download genesis file complete."
echo "Genesis $GENESIS_FILE initialized."
