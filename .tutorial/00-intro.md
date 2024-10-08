# Bitcoin Core 0.28 New Features Guide

Welcome to this guide on the new features introduced in Bitcoin Core 0.28. Each section details a feature and provides instructions on how to use the feature using the bitcoin-cli.

To take the maximal advantage of this upgrade, wallets and backends should integrate with the submitpackage Bitcoin Core RPC command:

bitcoin-cli submitpackage ‘[“<commitment_tx_hex>”, “<anchor_spend_hex>”]’

This guide will go through some use cases of package relay and explain how they work.

## Guide Structure

1. [Introduction](00-intro.md) (You are here)
2. [Setting up the environment](00a-setup.md)
3. [One Parent One Child (1P1C) Relay](01-1p1c.md)
4. [1P1C-topology Package RBF](02-package_rbf.md)
5. [Pay To Anchor (P2A)](03-p2a.md)
6. [User Stories](04-user_stories.md)
7. [Appendix: Topology Restricted Until Confirmed (TRUC, formerly v3 transactions)](10-truc.md)

Each section explains a feature with examples and use cases you can try out in the regtest environment of this repl.

We'll start with [One Parent One Child (1P1C) Relay](01-1p1c.md)
