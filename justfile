download-bitcoin:
  scripts/download-core.sh
clear-bitcoin-data:
  scripts/clear-bitcoin-data.sh
bitcoind:
  /home/runner/workspace/bitcoin-28.0/bin/bitcoind -regtest
bitcoind-28:
  /home/runner/workspace/bitcoin-28.0/bin/bitcoind -regtest
bitcoind-27:
  /home/runner/workspace/bitcoin-27.0/bin/bitcoind -regtest
