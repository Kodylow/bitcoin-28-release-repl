#!/bin/bash

# Define the directories to clear
DIRS=(
    "/home/runner/workspace/bitcoin-28.0-data"
    "/home/runner/workspace/bitcoin-27.0-data"
)

# Function to clear a directory
clear_directory() {
    local dir="$1"
    if [ -d "$dir" ]; then
        echo "Clearing $dir..."
        rm -rf "$dir"/*
        echo "Done clearing $dir"
    else
        echo "Warning: $dir does not exist or is not a directory"
    fi
}

# Main script
echo "Starting to clear Bitcoin data directories..."

for dir in "${DIRS[@]}"; do
    clear_directory "$dir"
done

echo "Finished clearing Bitcoin data directories"
