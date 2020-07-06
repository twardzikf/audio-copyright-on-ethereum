pragma solidity 0.5.16;

import  './Property.sol';

contract Auction{
    
    Property public property;
    uint public startPrice;
    uint public highestOffer;
    address payable public highestBidder;
    address payable public owner;
    
    enum State{Default, Running, Finished}
    State public auctionState;
    
    uint public index;
    
    constructor() public {
        highestOffer = 0;
        highestBidder = address(0x0);
        auctionState = State.Default;
    }
    
    function start(Property _property, address payable _owner, uint _startPrice, uint _index) public {
        property = _property;
        owner = _owner;
        startPrice = _startPrice;
        auctionState = State.Running;
        index = _index;
    }
    
    function bid(uint _price, address payable _highestBidder) public {
        highestOffer = _price;
        highestBidder = _highestBidder;
    }
    
    function stop() public {
        auctionState = State.Finished;
    }
    
    function running() public view returns (bool){
        if(auctionState == State.Running){
            return true;
        } else {
            return false;
        }
    }
}