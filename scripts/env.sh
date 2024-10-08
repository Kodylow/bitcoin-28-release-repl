

# direnv hook
eval "$(direnv hook bash)"

# Check if Bitcoin is downloaded
if [ ! -d "bitcoin-28.0" ]; then
    echo "Bitcoin 28.0 not found. Downloading..."
    ./scripts/download-core.sh
    if [ $? -ne 0 ]; then
        echo "Failed to download Bitcoin. Exiting."
        exit 1
    fi
fi

# Set aliases
alias bitcoind='/home/runner/$REPL_SLUG/bitcoin-28.0/bin/bitcoind'
alias bitcoin-cli='/home/runner/$REPL_SLUG/bitcoin-28.0/bin/bitcoin-cli'
alias bitcoin-cli-28='/home/runner/$REPL_SLUG/bitcoin-28.0/bin/bitcoin-cli'
alias bitcoind-28='/home/runner/$REPL_SLUG/bitcoin-28.0/bin/bitcoind -regtest'
alias bitcoind-27='/home/runner/$REPL_SLUG/bitcoin-27.0/bin/bitcoind -regtest'
alias bitcoin-cli-27='/home/runner/$REPL_SLUG/bitcoin-27.0/bin/bitcoin-cli'

echo "Bitcoin development environment loaded"
