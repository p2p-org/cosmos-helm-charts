#!/bin/sh

set -eu

# Construct full chain home path
CHAIN_HOME="/home/operator/$homeDir"

# CHAIN_ID_FLAG: flag used to pass the chain/network id (default: --chain-id).
# Override to --network for chains like Story that use a different convention.
CHAIN_ID_FLAG=${CHAIN_ID_FLAG:---chain-id}

# MONIKER_FLAG: flag used to pass the node moniker.
# Default is empty (positional arg). Set to --moniker for chains like Story.
MONIKER_FLAG=${MONIKER_FLAG:-}

if [ ! -d "$CHAIN_HOME/data" ]; then
  echo "Initializing chain..."
  $CHAIN_BINARY init ${CHAIN_ID_FLAG} $CHAIN_ID ${MONIKER_FLAG} $NODE_NAME --home "$CHAIN_HOME"
else
  echo "Skipping chain init; already initialized."
fi

echo "Initializing into tmp dir for downstream processing..."
# cleanup old tmp in case it had leftovers
rm -rf "$HOME/.tmp/*"
$CHAIN_BINARY init ${CHAIN_ID_FLAG} $CHAIN_ID ${MONIKER_FLAG} $NODE_NAME --home "$HOME/.tmp"
