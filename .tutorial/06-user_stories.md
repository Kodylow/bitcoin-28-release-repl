# User Stories:

Moving on from the more general release notes level feature description, we will describe a few common wallet patterns and how these can benefit from these updates, with or without the wallets making active changes.

## Simple Payments:

If users wish to have more predictable RBF behavior, one way would be to opt-in to TRUC transactions. If adapted, wallets should only use confirmed outputs for TRUC transactions and construct them to stay within 10kvB (as opposed to the 100kvB non-TRUC limit). This restricted limit still supports larger batch payments as well. If a wallet has no choice but to spend an unconfirmed input, if that input comes from a TRUC transaction, this new transaction would need to be below 1kvB.

This would allow an RBFing wallet confidence that receivers of bitcoin would not be able to create arbitrary chains of transactions off of the payment, pinning the user. Incoming payments could also be robustly bumped via an up to 1kvB spend of the incoming deposit output.

## Coinjoins:

In the coinjoin scenario where privacy is the focus but the coinjoin is not attempting to be covert, TRUC transactions for the coinjoin itself may be worthwhile. The coinjoin may have insufficient feerate for inclusion in the blockchain requiring a small bump of a participants’ coins.

Along with TRUC transactions, a P2A output could be added allowing for a segregated wallet like a watchtower to pay for the transaction fees alone.

If other participants spend their unconfirmed outputs, TRUC sibling eviction will ensure that the other spends can be replaced even if not directly conflicting, preserving TRUC topology limits.

Pinning caveat: Participants in the coinjoin may still economically grief the transaction by double-spending their own input to the coinjoin, requiring the coinjoin to RBF the griefer’s first transaction.

## Lightning Network:

Transactions generated in the Lightning Network protocol consist of a few main types:
Funding transactions: Single-party funded or “dual”-party funded transactions to set up the contract. Less time sensitivity to confirm.
Commitment transactions: The transaction that commits to the latest state of the payment channel. These transactions are asymmetrical, and currently require a “update_fee” message bi-directionally to update how much of the funding output value is given to fees. The fees must be enough to propagate the latest version of the commitment transaction into miners’ mempools. 
HTLC presigned transactions

With 1P1C relay and package RBF, upgrading Bitcoin Core nodes significantly increases the security of the Lightning network. Lightning unilateral closes can be accomplished with commitment transactions with below mempool minfee feerates, or conflicting with another low-fee commitment transaction package that wouldn’t be promptly included in a block.

To take the maximal advantage of this upgrade, wallets and backends should integrate with the submitpackage Bitcoin Core RPC command:

bitcoin-cli submitpackage ‘[“<commitment_tx_hex>”, “<anchor_spend_hex>”]’

Wallet implementations should integrate their software with the command using the commitment transaction as well as an anchor child spend to ensure inclusion into miners’ mempools with the appropriate feerate.

Note: The RPC endpoint supports many-child, single-parent packages, but these will not propagate under the 1P1C relay update.

After a sufficient number of nodes upgrade on the network, the LN protocol may be updated to drop the “update_fee” message, which has been a source of unnecessary force closes during fee spikes for years now. With removal of this protocol message, commitment transactions could be set to a static 1 sat/vbyte feerate. 
With TRUC transactions, we can ensure that competing commitment transactions with anchor spends are allowed to RBF each other over the network, and if there are competing output spends from the same commitment transaction, that RBF can occur no matter which output is being spent. TRUC transactions are also allowed to be 0-fee, allowing reduction in spec complexity. With TRUC’s sibling eviction, we can also drop the 1 block CSV locktimes, since we are no longer overly concerned with what unconfirmed outputs are being spent, as long as each party can spend a single output themselves.

With TRUC + P2A Anchors, we can reduce the blockspace usage of the current two anchors down to a single keyless anchor. This anchor requires no commitment to a public key or  signatures, saving additional blockspace. The fee bumping can also be outsourced to other agents that have no privileged key material. Anchors could also consist of a single output with shared key material between the counterparties rather than P2A, at the cost of additional vbytes in the benign unilateral close case.

Similar strategies can be pursued when implementing advanced features such as splicing, to reduce the risk of RBF pinning. For example, a TRUC channel splice that is less than 1kvB in size could CPFP another channel's unilateral close, without exposing the bumper to RBF pins. Subsequent bumps can be done in series by replacing just the channel splice transaction. This comes at the cost of revealing the TRUC transaction type during splices.

As you can see, significant complexity can be avoided and savings achieved with the updated features, provided each transaction can fit into the 1P1C paradigm.

## Ark:

Not all transaction patterns fit into the 1P1C paradigm. A prime example of this is Ark outputs, which commit to a tree of presigned(or covenant committed) transactions to unroll a shared UTXO.

Ideally the initial unilateral close of an Ark tree would be:
The publication of an entire merkle branch to the underlying virtual UTXO(vUTXO)
Each of these transactions are 0-fee, to avoid fee prediction or the requirement to decide who pays fees a priori
The ultimate leaf transaction has a 0-value anchor spend where the CPFP pays for the entire merkle tree’s publication to a miner’s mempool and inclusion in a block
