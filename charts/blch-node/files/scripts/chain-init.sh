#!/bin/sh

set -eu

# Construct full chain home path
CHAIN_HOME="/home/operator/$homeDir"

if [ ! -d "$CHAIN_HOME/data" ]; then
  echo "Initializing chain..."
  $CHAIN_BINARY init --chain-id $CHAIN_ID $NODE_NAME --home "$CHAIN_HOME"
else
  echo "Skipping chain init; already initialized."
fi

echo "Initializing into tmp dir for downstream processing..."
$CHAIN_BINARY init --chain-id $CHAIN_ID $NODE_NAME --home "$HOME/.tmp"