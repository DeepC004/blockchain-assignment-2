# BITS-F452-Assignment-2
Implementation of smart contract to ease the purchase of products online.
## Team Members (Group 26)
1. Deep Chordia (2020A7PS2073H) 
2. Neeraj Gunda (2020A7PS0169H) 
3. Sravika Linga (2020A7PS1310H)

## Objective 
Implement a smart contract to confirm the receival of product by the buyer as well as the receival of equivalent product value by the seller.</br>

## Implementation
- Smart contract written using solidity in Transact.sol file. Remix IDE used for testing.
- abortTransaction() - aborts the transaction upon execution. It is only executable by the buyer. Refunds the seller the 3 times the value of the item and value equivalent to the value of the item to the buyer. 
- confirmPurchase() - confirms the purchase of item by the buyer. It is only executable by the buyer. 
- confirmItemReceived() - confirms the receival of item by the buyer. It is only executable by the buyer. Both the seller and the buyer are refunded their appropriate deposit amount on execution of the function.

## Tech Stack
- Solidity: https://docs.soliditylang.org/en/v0.8.17/
- Remix IDE: https://remix-ide.readthedocs.io/en/latest/
