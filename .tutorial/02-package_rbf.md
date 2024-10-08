# 1P1C-topology Package RBF

## Checklist
1. Understand the concept of 1P1C-topology Package RBF
2. Create a new parent transaction that conflicts with the existing package: higher parent fees but lower package fees
3. Create a child transaction for the new parent with lower child fees but higher package feerate
4. Submit the new package to replace the existing one by higher overall package feerate

## Understanding 1P1C-topology Package RBF

Sometimes the 1P1C package’s parent conflicts with the in-mempool parent. This can happen when there are multiple versions of the parent transaction presigned. Previously the new parent would be considered for RBF alone, and discarded if the fee was too low. With 1P1C topology package RBF, the new child will also be included for consideration in the RBF checks.

This allows a wallet developer to get robust transmission of 1P1C packages through the p2p network, regardless of what versions of transactions have hit their local mempool.

Note that currently the conflicted transactions all must be singletons themselves or 1P1C transaction packages with no other dependencies, also known as clusters. Otherwise the replacement will be rejected. Any number of such clusters can be conflicted. This will be relaxed in a future release as a result of cluster mempool.

Continuing our running 1P1C example (see [01-1p1c.md](./01-1p1c.md)), we are going to execute a package RBF against the existing 1P1C package, this time with a non-TRUC transaction package (both parent and child will have fees).

## The Current State of the Mempool

At this point, you should have a 1P1C package in the mempool.

```bash
bitcoin-cli -regtest getrawmempool
# there should be two txids in the mempool
# the first one is the parent, the second one is the child
```

## Create a new parent transaction that conflicts with the existing one

First, we're going to create a new parent transaction using that same UTXO as the previous parent transaction. The previous parent TX had no fees, for this one we'll have a couple hundred sats in fees, but still less than original package's child's fees.

Since you've broadcast the previous parent transaction, the utxos won't show up as unspent. To get the txid and vout you used rom earlier run these command to parse the input from the previous parent transaction:

```bash
bitcoin-cli -regtest gettransaction "PREVIOUS_PARENT_TXID"
```

Decode the raw transaction to get the input's txid, vout, scriptPubKey, and amount:

```bash
bitcoin-cli -regtest decoderawtransaction PREVIOUS_PARENT_TX_HEX
```

Then create the new parent transaction, this time with 1000 sats in fees:

```bash
bitcoin-cli -regtest createrawtransaction '[{"txid": "PREVIOUS_PARENT_INPUT_TXID", "vout": 0}]' '[{"YOUR_ADDRESS": "49.99999"}]'
# this will output a raw transaction hex like this
# 020000000155afb3506b83b429c54cce4cae851aa81684f9d4e5d7f2ce7c612f9c3a2b76d10000000000fdffffff0118ee052a01000000160014f0941d2107006b6ee0ab28c5403ec70026469f1700000000
```

Don't switch to v3 transaction here, just keep the 02. This has fees on its own so we don't need TRUC.

3.  Sign the new parent transaction:

```bash
bitcoin-cli -regtest -rpcwallet=test signrawtransactionwithwallet YOUR_NEW_PARENT_RAW_TX_HEX
```

4. Attempt to send the new parent transaction:

```bash
bitcoin-cli -regtest sendrawtransaction YOUR_SIGNED_TX_HEX
```

This will fail! Even though the parent has higher fees, the package in the mempool has a higher feerate because of the child's fees.

```bash
error code: -26
error message:
insufficient fee, rejecting replacement NEW_PARENT_TXID, less fees than conflicting txs; 0.00001 < 0.0001
```

# Creating a new child transaction to bring additional fees to the new package
Create a child transaction to bring additional fees to the new package. We'll use the same fees we did for the previous child, and this time with the higher feerate of the new parent we'll have an overall higher feerate package and be able to replace the previous package.

5. Decode the new parent transaction to get the input's txid, vout, scriptPubKey, and amount:

```bash
bitcoin-cli -regtest decoderawtransaction NEW_PARENT_TX_HEX
```

6. Create the child transaction

```bash
bitcoin-cli -regtest createrawtransaction '[{"txid": "NEW_PARENT_TXID", "vout": 0}]' '[{"YOUR_ADDRESS": "49.999"}]'
```

6. Sign the child transaction (providing the parent's txid, vout, scriptPubKey, and amount as additional info for the wallet since it's signing for the parent's output it hasn't received yet):

```bash
bitcoin-cli -regtest -rpcwallet=test signrawtransactionwithwallet YOUR_CHILD_TX_HEX '[{"txid": "NEW_PARENT_TXID", "vout": 0, "scriptPubKey": "PARENT_SCRIPTPUBKEY", "amount": PARENT_AMOUNT}]'
```

7. Submit the new package to replace the existing one:

```bash
bitcoin-cli -regtest -rpcwallet=test submitpackage '["NEW_PARENT_TX_HEX", "NEW_CHILD_TX_HEX"]'
```

And we'll see that this time, the new package is accepted and the old one is replaced:

```bash
# {
#   "package_msg": "success",
#   "tx-results": {
#     "895842b4e783ddbba4fec1c04627cc9700621462e39962b90362a86e60e09d9f": {
#       "txid": "819ab7c6b81ee8643faf907a5273a410e94ca1991bc31e88567ae4ea36d0f4c1",
#       "vsize": 110,
#       "fees": {
#         "base": 0.00001000,
#         "effective-feerate": 0.00454545,
#         "effective-includes": [
#           "895842b4e783ddbba4fec1c04627cc9700621462e39962b90362a86e60e09d9f",
#           "d5c4cea05682e19cdd08e0c47acb0df958d5eee32d432804eb817619eb460005"
#         ]
#       }
#     },
#     "d5c4cea05682e19cdd08e0c47acb0df958d5eee32d432804eb817619eb460005": {
#       "txid": "23bd3a2f97ed8798d325b4512a2ace9b5785d53357ad1d9091791fb8f89578e0",
#       "vsize": 110,
#       "fees": {
#         "base": 0.00099000,
#         "effective-feerate": 0.00454545,
#         "effective-includes": [
#           "895842b4e783ddbba4fec1c04627cc9700621462e39962b90362a86e60e09d9f",
#           "d5c4cea05682e19cdd08e0c47acb0df958d5eee32d432804eb817619eb460005"
#         ]
#       }
#     }
#   },
#   "replaced-transactions": [
#     "dcdf8b56c476774c2dca90d2bce42d5b88222386922bb4bfd398693329bb1686",
#     "f702f1ea070cce7f94911a26237b32b22bc34e8a98e2dbbf198c2335ee173ee6"
#   ]
# }
```

8. Verify that the new package has replaced the old one:

```bash
bitcoin-cli -regtest getrawmempool
```

Remember to replace placeholders like YOUR_TXID, YOUR_ADDRESS, NEW_PARENT_TXID, etc., with actual values from your regtest environment.

## Use Cases

1P1C-topology Package RBF is particularly useful in scenarios where:

- Multiple versions of a transaction are pre-signed
- Fee bumping is needed for a transaction that's already in the mempool
- Complex transaction structures need to be updated or replaced

This feature enhances the flexibility and reliability of transaction propagation in the Bitcoin network, especially for advanced wallet implementations and Layer 2 protocols.
