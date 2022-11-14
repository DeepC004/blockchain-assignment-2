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
    }

    function about() public {
        require(msg.sender == buyer, "Only the buyer can call this functionality.");
        require(state == State.Make, "Invalid state.");
        emit Aborted(buyer);
        state = State.Inactive;
        seller.transfer(address(this).balance);
    }

    function confirmPurchase() public payable{
        require(msg.value == (2 * value));
        require(state == State.Make, "Invalid state.");
        emit PurchaseConfirmed(buyer, 2*value);
        buyer = payable(msg.sender);
        state = State.Acquire;
    }

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
