#!/bin/bash

# Allow direnv
direnv allow

# Load environment
source ./scripts/env.sh

# Check if Bitcoin is downloaded
if [ ! -d "bitcoin-28.0" ]; then
    echo "Bitcoin 28.0 not found. Downloading..."
    ./scripts/download-core.sh
    if [ $? -ne 0 ]; then
        echo "Failed to download Bitcoin. Exiting."
        exit 1
    fi
fi

# Check if bitcoind is already running
if ! pgrep -x "bitcoind" > /dev/null; then
    # Run Bitcoin
    echo "Starting Bitcoin..."
    exec /home/runner/workspace/bitcoin-28.0/bin/bitcoind -regtest
else
    echo "bitcoind is already running."
fi
