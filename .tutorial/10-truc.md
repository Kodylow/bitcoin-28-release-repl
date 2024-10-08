# Topology Restricted Until Confirmed (TRUC) Transactions

Topology Restricted Until Confirmed(TRUC) transactions, previously known as v3 transactions, is a new opt-in mempool policy aimed at allowing robust replace-by-fee (RBF) of transactions, mitigating both fee-related transaction pinning as well as package limit pinning. Its central philosophy is: while many features are infeasible for all transactions, we can implement them for packages with a limited topology, so we create a way to opt-in to this more robust set of policies in addition to the topological restrictions.

In short, a TRUC transaction is a transaction with an nVersion of 3, which restricts the transaction to either a singleton of up to 10kvB, or the child of another TRUC transaction capped at 1kvB. Non-TRUC and TRUC transactions can not be spent together unconfirmed in the mempool. All TRUC transactions are considered opt-in RBF regardless of BIP125 signaling.
If another un-conflicting TRUC child is added to the parent TRUC transaction, it will be treated as a conflict with the original child, and normal RBF resolution rules apply including feerate and total fee checks.

TRUC transactions are also allowed to have any transaction fee, including 0-fee, provided a child transaction bumps the overall package feerate sufficiently.

This topology also neatly falls within the 1P1C relay paradigm regardless of what transaction counterparties do, assuming all versions of signed transactions are TRUC.

TRUC payments are replaceable, so any transactions with inputs not owned at least in part by the transactor can be double-spent. In other words, receiving zero-conf TRUC payments is not safer than non-TRUC ones.
