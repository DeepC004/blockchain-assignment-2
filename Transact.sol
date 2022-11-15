// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Transact{
    uint public value; //stores the value of the item 
    address payable public buyer; //stores address of buyer
    address payable public seller; //stores address of seller
    enum State{ Make, Acquire, Release, Inactive} //an enumeration of states to capture the state changes at various stages of transaction
    State public state;

    event Aborted(address buyer); //event emitted when a transaction is aborted
    event PurchaseConfirmed(address buyer, uint amount); //event emitted when purchase of item is confirmed
    event ItemReceived(address buyer, uint amount); //event emitted when item is received by the buyer
    event SellerRefunded(address seller, uint amount); //event emitted when seller gets refunded as soon as item receival confirmation takes place

    constructor() payable{
        seller = payable(msg.sender);
        value = msg.value / 2;
        require(msg.value == (2 * value), "The value has to be even."); //both buyer and seller sending 2x the value of the item as a security deposit
    }

    //aborts the transaction if the buyer does not want to purchase the item; only executable by buyer
    //refunds seller his money and buyer money forfeited 
    function abortTransaction() public {
        require(msg.sender == buyer, "Only the buyer can call this functionality.");
        require(state == State.Make || state == State.Acquire, "Invalid state.");
        emit Aborted(buyer);
        state = State.Inactive;
        seller.transfer(address(this).balance);
    }

    //confirms item purchase; only executable by buyer
    function confirmPurchase() public payable{
        require(msg.value == (2 * value));
        require(state == State.Make, "Invalid state.");
        emit PurchaseConfirmed(buyer, 2*value);
        buyer = payable(msg.sender);
        state = State.Acquire;
    }
    
    //confirms item received; only executable by buyer
    //seller gets refunded as soon as the item receival is confirmed
    function confirmItemReceived() public{
        require(msg.sender == buyer, "Only the buyer can call this functionality.");
        require(state == State.Acquire, "Invalid state.");
        emit ItemReceived(buyer, value);
        state = State.Release;
        buyer.transfer(value);
        emit SellerRefunded(seller, 3*value);
        seller.transfer(value * 3);
    }
}
