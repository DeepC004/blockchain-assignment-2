// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Transact{
    uint public value;
    address payable public buyer;
    address payable public seller;
    enum State{ Make, Acquire, Release, Inactive}
    State public state;

    event Aborted(address buyer);
    event PurchaseConfirmed(address buyer, uint amount);
    event ItemReceived(address buyer, uint amount);
    event SellerRefunded(address seller, uint amount);

    constructor() payable{
        seller = payable(msg.sender);
        value = msg.value / 2;
        require(msg.value == (2 * value), "The value has to be even.");
        //the balance shown would be twice the cost of the item(consists security deposit)
    }

    function about() public {
        require(msg.sender == buyer, "Only the buyer can call this functionality.");
        require(state == State.Make, "Invalid state.");
        emit Aborted(buyer);
        state = State.Inactive;
        seller.transfer(address(this).balance);
        //This function allows the buyer to abort the transaction
    }

    function confirmPurchase() public payable{
        require(msg.value == (2 * value));
        require(state == State.Make, "Invalid state.");
        emit PurchaseConfirmed(buyer, 2*value);
        buyer = payable(msg.sender);
        state = State.Acquire;
        //In order to initiate the transaction, the buyer also has to deposit twice the cost of the item
    }

    function confirmItemReceived() public{
        require(msg.sender == buyer, "Only the buyer can call this functionality.");
        require(state == State.Acquire, "Invalid state.");
        emit ItemReceived(buyer, value);
        state = State.Release;
        buyer.transfer(value);
        emit SellerRefunded(seller, 3*value);
        seller.transfer(value * 3);
        //Once buyer confirms that they received the order using this, they will be receive half of what they deposited(half is credited to seller and half is returned)
        //Seller receives his entire deposit plus the cost of item(half of buyer's deposit)
    }
}
