download-bitcoin:
  scripts/download-core.sh
clear-bitcoin-data:
  scripts/clear-bitcoin-data.sh
bitcoind:
  /home/runner/$REPL_SLUG/bitcoin-28.0/bin/bitcoind -regtest
bitcoind-28:
  /home/runner/$REPL_SLUG/bitcoin-28.0/bin/bitcoind -regtest
bitcoind-27:
  /home/runner/$REPL_SLUG/bitcoin-27.0/bin/bitcoind -regtest
