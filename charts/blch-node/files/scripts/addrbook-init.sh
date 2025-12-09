#!/bin/sh
# Address book initialization script
# Downloads and processes the address book file

set -eux

ADDRBOOK_FILE=$CONFIG_DIR/addrbook.json

# Check if address book already exists
if [ -f "$ADDRBOOK_FILE" ]; then
    echo "Address book already exists"
    exit 0
fi

# Source download utilities if available
if [ -f "./download-utils.sh" ]; then
    source "./download-utils.sh"
else
    echo "Warning: download-utils.sh not found, download functions may not work"
fi

# ADDRBOOK_URL should be provided as environment variable or argument
ADDRBOOK_URL="${1:-${ADDRBOOK_URL}}"

if [ -z "$ADDRBOOK_URL" ]; then
    echo "Error: ADDRBOOK_URL must be provided as argument or environment variable"
    exit 1
fi

echo "Downloading address book file $ADDRBOOK_URL to $ADDRBOOK_FILE..."

rm -f "$ADDRBOOK_FILE"

case "$ADDRBOOK_URL" in
    *.json.gz)
        download_jsongz "$ADDRBOOK_URL" "$ADDRBOOK_FILE"
        ;;
    *.json)
        download_json "$ADDRBOOK_URL" "$ADDRBOOK_FILE"
        ;;
    *.tar.gz)
        download_targz "$ADDRBOOK_URL" "$ADDRBOOK_FILE"
        ;;
    *.tar.gzip)
        download_targz "$ADDRBOOK_URL" "$ADDRBOOK_FILE"
        ;;
    *.tar)
        download_tar "$ADDRBOOK_URL" "$ADDRBOOK_FILE"
        ;;
    *.zip)
        download_zip "$ADDRBOOK_URL" "$ADDRBOOK_FILE"
        ;;
    *)
        echo "Unable to handle file extension for $ADDRBOOK_URL"
        exit 1
        ;;
esac

echo "Saved address book file to $ADDRBOOK_FILE."
echo "Download address book file complete."

echo "Address book $ADDRBOOK_FILE downloaded"
